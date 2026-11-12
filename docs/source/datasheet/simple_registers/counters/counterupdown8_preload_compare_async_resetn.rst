.. _datasheet_counter8_preload_compare:

Counter 8-bit with Preload and Compare
--------------------------------------

Introduction
~~~~~~~~~~~~

This benchmark is designed to test flip-flops, arithmetic carry chains, and comparator logic with synchronous parallel load and asynchronous reset in FPGAs.
It generates an 8-bit bidirectional counter operating on a single clock signal (``clk``).
The counter includes an active-low asynchronous reset input (``rst_n``), a count enable (``en``), a direction control (``up_down``), a synchronous parallel load interface (``load``, ``load_val``), and a continuous equality comparator (``compare_val``, ``match``).
When ``rst_n`` is asserted low, the counter output (``count``) is immediately cleared to 0 regardless of clock transitions.
When ``load`` is asserted high, ``count`` is synchronously loaded with ``load_val`` on the rising edge of ``clk``, taking priority over counting.
When ``en`` is asserted high and ``load`` is low, ``count`` increments if ``up_down`` is high or decrements if ``up_down`` is low.
The ``match`` output is asserted high combinationally whenever ``count`` equals ``compare_val``.

Source codes
~~~~~~~~~~~~

All the counter designs are under ``simple_registers/counters``, in the naming convention of ``counter8_preload_compare``.

A list of all the designs available:

- ``counter8_preload_compare``

Block Diagram
~~~~~~~~~~~~~

The following is an example for the 8-bit up/down counter with synchronous preload, compare, and asynchronous active-low reset:

.. figure:: ./figures/counter8_preload_compare.svg
  :width: 60%
  :alt: Counter 8-bit with Preload and Compare schematic

  Counter 8-bit with Preload and Compare schematic


Performance
~~~~~~~~~~~

Expect to consume 8 flip-flops, arithmetic carry-chain logic for up/down counting, and LUT logic for parallel load multiplexing and 8-bit equality comparison.
It can evaluate the routability and performance of single-clock networks, carry chains, and wide fan-in comparator paths.

.. warning:: The following resource utilization is just an estimation! Different tools in different versions may result differently.

.. list-table:: Estimated resource Utilization
  :header-rows: 1
  :class: longtable

  * - Tool/Resource
    - Inputs
    - Outputs
    - LUT5
    - FF
    - Carry
    - DSP
    - BRAM
  * - counter8_preload_compare
    - 21
    - 9
    - 16
    - 8
    - 8
    - 0
    - 0

