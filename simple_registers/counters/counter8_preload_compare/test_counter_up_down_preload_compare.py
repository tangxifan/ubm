import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, ReadOnly


async def reset_dut(dut):
    """Apply active-low reset and initialize inputs."""
    dut.rst_n.value = 0
    dut.en.value = 0
    dut.up_down.value = 1
    dut.load.value = 0
    dut.load_val.value = 0
    dut.compare_val.value = 0

    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    await FallingEdge(dut.clk)
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)


@cocotb.test()
async def test_preload_and_compare(dut):
    """Test synchronous preload and compare match flag."""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await reset_dut(dut)

    # Verify reset state
    await ReadOnly()
    assert int(dut.count.value) == 0, f"Expected count 0 after reset, got {int(dut.count.value)}"
    assert int(dut.match.value) == 1, "Expected match=1 when count == compare_val (0)"

    # Set compare target to 0x2A (42) on falling edge
    await FallingEdge(dut.clk)
    dut.compare_val.value = 0x2A
    await ReadOnly()
    assert int(dut.match.value) == 0, "Expected match=0 when count != compare_val"

    # Preload 0x2A (42) while en=0 to verify load priority
    await FallingEdge(dut.clk)
    dut.load.value = 1
    dut.load_val.value = 0x2A

    await RisingEdge(dut.clk)
    await ReadOnly()
    assert int(dut.count.value) == 0x2A, f"Expected preloaded value 0x2A, got {hex(int(dut.count.value))}"
    assert int(dut.match.value) == 1, "Expected match=1 after preloading compare_val"

    await FallingEdge(dut.clk)
    dut.load.value = 0


@cocotb.test()
async def test_up_down_counting(dut):
    """Test counting up, counting down, and rollover/underflow."""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await reset_dut(dut)

    width = len(dut.count)
    max_val = (1 << width) - 1

    # Preload near max value on falling edge
    await FallingEdge(dut.clk)
    dut.load.value = 1
    dut.load_val.value = max_val - 1

    # Capture preload on rising edge
    await RisingEdge(dut.clk)
    await ReadOnly()
    assert int(dut.count.value) == max_val - 1, f"Expected {max_val - 1}, got {int(dut.count.value)}"

    # Release load and enable up-counting on falling edge
    await FallingEdge(dut.clk)
    dut.load.value = 0
    dut.en.value = 1
    dut.up_down.value = 1

    # Cycle 1: max_val - 1 -> max_val
    await RisingEdge(dut.clk)
    await ReadOnly()
    assert int(dut.count.value) == max_val, f"Expected {max_val}, got {int(dut.count.value)}"

    # Cycle 2: max_val -> 0 (rollover)
    await RisingEdge(dut.clk)
    await ReadOnly()
    assert int(dut.count.value) == 0, f"Expected rollover to 0, got {int(dut.count.value)}"

    # Switch to down-counting on falling edge
    await FallingEdge(dut.clk)
    dut.up_down.value = 0

    # Cycle 3: 0 -> max_val (underflow)
    await RisingEdge(dut.clk)
    await ReadOnly()
    assert int(dut.count.value) == max_val, f"Expected underflow to {max_val}, got {int(dut.count.value)}"

    # Cycle 4: max_val -> max_val - 1
    await RisingEdge(dut.clk)
    await ReadOnly()
    assert int(dut.count.value) == max_val - 1, f"Expected {max_val - 1}, got {int(dut.count.value)}"

