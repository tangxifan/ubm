.. _datasheet_fsm_fsm_three_code:

FSM_top
-------

Introduction
~~~~~~~~~~~~

This benchmark evaluates three-process finite state machine (FSM) coding styles in FPGAs, separating state storage, next-state transition logic, and output decoding into distinct blocks.
It implements a structured controller to test synthesis optimization and register mapping across decoupled FSM architectures.

Source codes
~~~~~~~~~~~~

See details in ``fsm/FSM_three_code``

Block Diagram
~~~~~~~~~~~~~

.. figure:: ./figures/fsm_three_code.svg
  :width: 100%
  :alt: FSM_top schematic

  FSM_top schematic


Performance
~~~~~~~~~~~

Expect to consume combinational LUTs for next-state and output combinational blocks along with state register flip-flops.
It analyzes how synthesis tools optimize multi-process state machine descriptions and combinatorial boundary paths.

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
    - 2
    - 1
    - 3
    - 2
    - 0
    - 0
    - 0
