# Computer Organization — Course Work

106.1【電子系】ET3502701 計算機組織 (Computer Organization)

This repository contains coursework, labs, and reference material for a Computer Organization class. It includes introductory assembly exercises and progressively more complex Verilog designs: ALU, single-cycle CPU, and a pipelined CPU, along with test benches and sample inputs.

## Repository Structure

- `hw1/` — Intro assembly exercises (`.s`)
- `hw2/` — Verilog ALU and single-cycle CPU components
  - `LAB2_1_alu/` — ALU and testbench
  - `LAB2_2_singlecycle/` — Single-cycle CPU, code and tests
- `hw3/` — Advanced single-cycle CPU (Verilog), test bench and data
- `hw4/` — Pipelined CPU (Verilog), code and tests
- `README.md` — You are here

Filenames are mostly self-descriptive (e.g., `Adder.v`, `ALU_Ctrl.v`, `Reg_File.v`, `ProgramCounter.v`, `Sign_Extend.v`). Test benches are typically named `testbench.v` or `Test_Bench.v` and may reference memory initialization files in the same folder.

## Prerequisites

To simulate Verilog designs locally, install any standard simulator, for example:

- Icarus Verilog (`iverilog`, `vvp`)
- ModelSim/Questa, Verilator, or your preferred toolchain

For waveform viewing, use GTKWave or the viewer integrated with your simulator.

## Quick Start (Icarus Verilog)

Below are generic commands that work for many lab folders. Adjust paths as needed based on the specific lab/test bench.

1) Build and run an ALU test bench (example):

```bash
# From repository root
iverilog -g2012 -o build/lab2_alu.vvp hw2/LAB2_1_alu/*.v
vvp build/lab2_alu.vvp
```

2) Build and run an advanced single-cycle CPU test bench (example):

```bash
# From repository root
iverilog -g2012 -o build/lab3_cpu.vvp \
  hw3/LAB3_advanced_singlecycle/*.v \
  hw3/*.v
vvp build/lab3_cpu.vvp
```

Notes:

- Some benches expect specific working directories for data files (e.g., `*.txt`). If a test fails to find a file, run from the lab directory or pass absolute paths.
- If your simulator requires an explicit top module, point it to the test bench (e.g., `-s Test_Bench`).

## Tips

- Read each lab's test bench to see required module lists and data files.
- Keep module interfaces unchanged when swapping implementations; test benches depend on them.
- When comparing outputs, check generated logs and waveforms.

## Academic Integrity

This repository is intended for learning and reference. If you are taking a related course, follow your institution’s academic policies. Do not submit others’ work as your own.

## License

No explicit license is provided. All rights reserved by the author unless otherwise stated.

## Author

Maintained by the repository owner on GitHub.
