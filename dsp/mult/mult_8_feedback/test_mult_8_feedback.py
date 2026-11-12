#####################################################################
# Test an 8-bit multiply with a shifted feedback operand: mult_8_feedback
#####################################################################
import random
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

NUM_CYCLES = 8


def next_product(p, b):
    """Operand a is the low byte of p, shifted right by one bit with sign extension"""
    low_byte = p & 0xFF
    a = (low_byte >> 1) | (low_byte & 0x80)
    return a * b


async def check_run(dut, test_id, start_p):
    dut._log.info("======== BEGIN Test %d ========", test_id)
    # The product register has no reset: load a start value between clock edges
    dut.p.value = start_p
    await Timer(1, unit="ns")
    expected_p = start_p
    for _ in range(NUM_CYCLES):
        b = random.randint(0, 255)
        dut.b.value = b
        expected_p = next_product(expected_p, b)

        await RisingEdge(dut.clk)
        await Timer(1, unit="ns")
        actual_p = int(dut.p.value)
        dut._log.info("b is %d, expected p is %d, actual p is %d", b, expected_p, actual_p)
        assert actual_p == expected_p, f"Mismatch: expected {expected_p}, got {actual_p}"
    dut._log.info("======== END Test %d ========", test_id)


@cocotb.test()
async def test_mult_8_feedback(dut):
    # Start a 10ns clock (100 MHz)
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    dut.b.value = 0
    await RisingEdge(dut.clk)
    await Timer(1, unit="ns")

    # Random start values
    start_values = [random.randint(0, 0xFFFF) for _ in range(200)]
    # Corner cases: sign bit of the low byte set and cleared, all zeros, all ones
    start_values += [0x0080, 0x007F, 0x00FF, 0xFF00, 0x0000, 0xFFFF, 0x0001, 0x0002]
    for test_id, start_p in enumerate(start_values):
        await check_run(dut, test_id, start_p)
