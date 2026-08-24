# RTL Design Basics – Verilog and Verification

## Overview
This repository contains fundamental RTL designs implemented in SystemVerilog, each paired with a self-checking testbench and waveform-based verification.

---

## Design and Verification Workflow
Every module in this repository follows the same process:
1. Implement RTL in SystemVerilog
2. Develop a testbench
3. Create a reference model for expected behavior
4. Compare DUT output against the reference model (self-checking)
5. Generate a waveform dump
6. Analyze the waveform (EPWave on EDA Playground, or GTKWave for local Icarus runs)

---

## Modules

| Module | Description | Link |
|---|---|---|
| 2-FF Synchronizer | CDC synchronizer demonstrating metastability handling across clock domains | [synchronizer/](synchronizer/) |



---

## Tools & Environment
* **Language:** SystemVerilog
* **Simulation & Waveform Viewing:** EDA Playground (Synopsys VCS + EPWave)
* **Local Practice:** Icarus Verilog + GTKWave (for offline work)


---

## Learning Outcomes
* RTL design using SystemVerilog
* Writing structured, self-checking testbenches
* Building reference models for verification
* Waveform-based debugging
* Exposure to an industry-standard commercial simulator (Synopsys VCS) via EDA Playground

---
