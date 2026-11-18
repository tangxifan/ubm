.. _datasheet_fsm_fsm_seq_detector:

fsm_seq_detector
----------------

Introduction
~~~~~~~~~~~~

This benchmark is designed to evaluate finite state machine (FSM) synthesis, state encoding optimization, and sequential transition logic mapping in FPGAs.
It implements a sequence detector FSM that monitors an input serial bitstream to identify a specific target bit pattern.

Source codes
~~~~~~~~~~~~

See details in ``fsm/fsm_seq_detector``

Block Diagram
~~~~~~~~~~~~~

.. figure:: ./figures/fsm_seq_detector.svg
  :width: 100%
  :alt: fsm_seq_detector schematic

  fsm_seq_detector schematic


Performance
~~~~~~~~~~~

Expect to consume combinational LUT resources for next-state logic and sequential flip-flops (FFs) for state register storage.
It evaluates how synthesis tools handle multi-state sequential transitions, state register minimization, and control logic path optimization.

.. warning:: The following resource utilization is just an estimation! Different tools in different versions may result differently.

.. list-table:: Estimated resource Utilization
  :header-rows: 1
  :class: longtable

  * - Tool/Resource
    - Inputs
    - Outputs
    - LUT4
    - FF
    - Carry
    - DSP
    - BRAM
  * - General
    - 3
    - 2
    - 4
    - 3
    - 0
    - 0
    - 0
