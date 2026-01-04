# 16-bit Half-Precision Floating Point Unit (FPU)

![Verilog](https://img.shields.io/badge/Verilog-2001-blue.svg)
![Status](https://img.shields.io/badge/Status-Add%2FSub_Verified-green.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

A synthesizable Floating Point Unit implementation in Verilog, compliant with the **IEEE 754 Half-Precision (16-bit)** standard. Currently supports Addition and Subtraction with a robust verification environment.

## Project Structure
- `addsub.v`: Core Verilog logic for Floating Point Adder/Subtractor.
- `tb_addsub.v`: File-based self-checking Testbench.
- `gen_test.py`: Python script to generate Golden Model test vectors.

## Verification Results
Verified using ModelSim/Quartus with **10,036 test cases** (including Random, Corner cases, NaN, Inf, and Subnormals).
- **Result:** 100% PASS.
- **Accuracy:** Bit-exact or within ±1 ULP (Unit in Last Place) tolerance due to rounding strategy (Truncation).

## How to Run Simulation
1. **Generate Test Vectors:**
   Run the Python script to create the golden reference data:
   ```bash
   python3 gen_test_vectors.py
