# SPI-MASTER-Slave-RAM
# Configurable SPI Communication System

## Overview
This repository contains the RTL design, implementation, and functional verification of a fully configurable Serial Peripheral Interface (SPI) communication system written in Verilog HDL. The project provides a scalable baseline for synchronous serial communication, integrating a parameterized SPI Master, an SPI Slave, and a dedicated RAM module controlled by Finite State Machine (FSM) logic.

## Key Features

*   **Parameterized SPI Master:** 
    *   Configurable data widths.
    *   Adjustable clock division logic.
    *   Selectable SPI transmission modes.
    *   Configurable MSB-first or LSB-first data shifting.
*   **Intelligent SPI Slave:** 
    *   Decodes serial commands via FSM state control.
    *   Interfaces directly with the memory module for read/write execution.
    *   Operates strictly using industry-standard SPI Mode 0.
*   **Integrated RAM Module:** 
    *   8-bit, 256-location single-port memory architecture.
    *   Seamless integration with the SPI Slave for precise data storage and retrieval.
*   **Comprehensive Verification:** 
    *   Self-checking testbenches for reliable functional verification.
    *   Robust clock domain management and packet decoding validation.

## Implementation & Performance
The design has been synthesized and evaluated for physical implementation. 

*   **Operating Frequency:** Verified post-PnR (Place and Route) timing analysis at 200 MHz.
*   **Power Consumption:** Highly efficient design with a total on-chip power consumption of 0.066 W.
*   **Target:** Synthesizable RTL suitable for FPGA and ASIC integration.

## Repository Structure
*   `src/` - Contains all Verilog RTL source files (`spi_master.v`, `spi_slave.v`, `spi_ram.v`, `top.v`).
*   `tb/` - Contains self-checking testbenches for functional simulation.
*   `sim/` - Simulation scripts and waveform configurations (e.g., `.do` files).
*   `syn/` - Synthesis scripts and generated reports (timing, power, area).
*   `docs/` - Project documentation, block diagrams, and FSM state diagrams.

## Getting Started

### Prerequisites
To simulate and synthesize this project, you will need standard digital design tools such as:
*   ModelSim / QuestaSim (for RTL simulation)
*   Standard FPGA/ASIC synthesis toolchains

### Running Simulations
1. Clone the repository:
   ```bash
   git clone [https://github.com/yourusername/spi-communication-system.git](https://github.com/yourusername/spi-communication-system.git)
