# Verilog Introduction Codes

A comprehensive collection of Verilog introductory labs demonstrating fundamental digital design concepts, from basic counters and logic operations to serial communication protocols and microprocessor architecture patterns.

## Overview

This repository contains 7 progressive Verilog laboratory exercises that build upon each other, starting with simple combinational logic and sequential circuits, and advancing to complex protocols and bus architectures. Each lab introduces new concepts while reinforcing previously learned material.

---

## Lab Descriptions

### Lab 1: Combinational & Sequential Logic Basics
**Files:** `lab1.v`

**Concepts:** Counter design, multiplexing, combinational logic operations

**Description:**
This lab combines a 3-bit binary counter with logic operations. The circuit contains three key modules:

- **`three_bit_counter`**: A 3-bit synchronous counter that increments on each clock pulse. Features:
  - Asynchronous active-low reset
  - Outputs individual bits (bit_0, bit_1, bit_2) for external use
  - Simple modulo-8 counting behavior

- **`and_or_xor_func`**: A selectable logic operation module that performs:
  - AND operation when `sel = 0`
  - XOR operation when `sel = 1`
  - Takes two inputs from counter outputs

- **`lab1` (top module)**: Instantiates both sub-modules and provides the unified interface

**Key Learning Points:**
- Module instantiation and hierarchy
- Synchronous vs. asynchronous reset
- Ternary operator for multiplexing logic
- Wire vs. register usage

---

### Lab 2: BCD Counter Cascade
**Files:** `lab2.v`

**Concepts:** Counter design, cascading modules, enable logic, multi-digit counting

**Description:**
This lab implements a 3-digit BCD (Binary-Coded Decimal) counter using cascaded modules. The design demonstrates how to build larger counters from smaller units.

- **`bcd_counter`**: A single BCD counter that:
  - Counts from 0 to 9 in binary representation
  - Has an active-low reset (`nRst`)
  - Features a count enable input (`CntEn`)
  - Outputs a next-enable signal (`NextEn`) when reaching 9
  - Wraps back to 0 after reaching 9

- **`lab2` (top module)**: Cascades three BCD counter instances:
  - Co1: 1's place counter
  - Co10: 10's place counter (enabled when Co1 reaches 9)
  - Co100: 100's place counter (enabled when Co10 reaches 9)
  - Creates a 0-999 counter

**Key Learning Points:**
- Cascading enable signals for multi-stage counting
- BCD encoding and representation
- Conditional count-up logic
- Module reusability and parameterization

---

### Lab 3: Digital Debouncing
**Files:** `lab3.v`

**Concepts:** Metastability, debouncing techniques, shift registers, state machines

**Description:**
This lab implements two different approaches to debounce a noisy switch input. Switch bounce is eliminated by filtering using digital logic.

- **`debouncer1`** - Shift Register Approach:
  - Uses a 3-bit shift register to sample the input
  - Sets output HIGH only when all three shift register bits are 1 (`&shift_reg`)
  - Sets output LOW only when all three shift register bits are 0 (`~|shift_reg`)
  - Provides hysteresis-like behavior for robust debouncing
  - Requires 3 consecutive stable samples

- **`debouncer2`** - State Machine Approach:
  - Uses a lock mechanism to prevent noise-induced transitions
  - Only allows state changes after a stable period (counter reaches 4)
  - Counter increments while locked after detecting a change
  - More sophisticated control flow with explicit state management

- **`lab3` (top module)**: Implements both debouncing methods side-by-side for comparison

**Key Learning Points:**
- Synchronization of asynchronous inputs
- Shift register design patterns
- State machines with lock/enable mechanisms
- Trade-offs between different debouncing implementations
- Timing considerations for physical inputs

---

### Lab 4: Serial Communication - Basic Shift Register
**Files:** `lab4.v`

**Concepts:** Serial communication, shift registers, UART-like transmission, data synchronization

**Description:**
This lab implements a simple serial communication system using shift registers. Data is transmitted serially and then received, demonstrating the fundamentals of serial protocols.

- **`transmitter`**: Shifts data out serially:
  - 9-bit shift register (1 start bit + 8 data bits)
  - `Send` signal loads parallel data into the register
  - `SR[8]` is the start bit, driven to 1 when Send is asserted
  - Shifts left on each clock cycle, outputting MSB on `SDout`
  - `SCout` is directly connected to clock (synchronous transmission)

- **`receiver`**: Receives serial data and reconstructs parallel output:
  - 9-bit shift register for receiving
  - Shifts incoming serial data (`SDin`) into LSB (`SR[0]`)
  - `SR[8]` serves as a frame boundary/completion flag
  - Once all 9 bits received, sets `PDready` high
  - Outputs received 8 data bits on `PDout`

- **`lab4` (top module)**: Connects transmitter output to receiver input, completing the loop

**Key Learning Points:**
- Shift register as fundamental communication primitive
- Frame synchronization with start bits
- Parallel-to-serial and serial-to-parallel conversion
- Clock domain management in serial protocols

---

### Lab 5: Serial Communication with Parity Check
**Files:** `lab5.v`

**Concepts:** Error detection, parity encoding, serial protocols, advanced shift registers

**Description:**
This lab extends Lab 4 by adding parity bit generation and error detection for basic data integrity checking.

- **`transmitter` (enhanced)**:
  - 10-bit shift register (start bit + 8 data bits + 1 parity bit)
  - Calculates parity as XOR of all 8 data bits (odd parity scheme)
  - `SR[9]` = start bit (1), `SR[8:1]` = data, `SR[0]` = parity
  - Uses control logic (`Cshift`/`Chold`) to manage transmission timing
  - Parity is computed in real-time during load: `(sum of all 8 bits)`

- **`receiver` (enhanced)**:
  - 10-bit shift register for receiving complete frame
  - Stores received parity bit in `SR[0]`
  - Calculates parity error by summing all received bits plus parity
  - `ParErr` output indicates if parity check failed
  - Outputs only the 8 data bits (without start/parity)

- **Parity Detection Logic**: `ParErr` signals an error if the combined sum of data + parity is non-zero

**Key Learning Points:**
- Parity-based error detection
- Extended frame format with control bits
- Trade-off between data rate and error detection capability
- Real-time parity calculation

---

### Lab 6: Rotary Encoder FSM
**Files:** `lab6.v`

**Concepts:** Finite State Machines, rotary encoder decoding, quadrature encoding, counter increment/decrement

**Description:**
This lab implements a Finite State Machine (FSM) to decode rotary encoder inputs and increment/decrement a counter based on rotation direction. Rotary encoders produce two-phase quadrature signals (D1, D2) to indicate direction.

- **FSM States**: 8 states (St0-St7) tracking the quadrature encoder sequence:
  - **St0** (idle): Both inputs low, waiting for motion
    - D1=1, D2=0 → St1 (clockwise motion detected)
    - D1=0, D2=1 → St5 (counter-clockwise motion detected)
  
  - **Clockwise Path** (St0 → St1 → St2 → St3 → St0):
    - St0: D1=1, D2=0 (first detent)
    - St1: D1=1, D2=1 (mid-step)
    - St2: D1=0, D2=1 (second detent)
    - St3: D1=0, D2=0 (return to idle) → **Counter increments**
  
  - **Counter-Clockwise Path** (St0 → St5 → St6 → St7 → St0):
    - St5: D1=0, D2=1 (first detent)
    - St6: D1=1, D2=1 (mid-step)
    - St7: D1=1, D2=0 (second detent)
    - St0: D1=0, D2=0 (return to idle) → **Counter decrements**

- **Counter Behavior**:
  - Increments by 1 when completing clockwise rotation (St3 → St0)
  - Decrements by 1 when completing counter-clockwise rotation (St7 → St0)
  - Invalid state transitions return to current state (no state change)

- **3-bit Counter Output**: Tracks rotation events with wrap-around

**Key Learning Points:**
- FSM design for protocol decoding
- Quadrature signal interpretation
- State transition tables and conditional logic
- Directional detection from phase-encoded inputs
- Debouncing through FSM state isolation

---

### Lab 7: Tri-State Bus Architecture with Accumulator
**Files:** `lab7.v`

**Concepts:** Tri-state buses, register files, accumulator unit, bus arbitration, microprocessor datapath

**Description:**
This lab demonstrates a simplified microprocessor-style architecture with shared tri-state bus, register file, and accumulator unit. Multiple devices drive the same bus without collision through controlled tri-state logic.

**Architecture Components:**

- **Tri-State Bus (`DBus`)**: Central shared communication medium
  - 8-bit wide
  - Multiple sources can drive it (when enabled)
  - Multiple destinations can read from it (always readable)
  - High-impedance (`Z`) state when not driven

- **`Reg8bit` Modules (3 instances: R1, R2, R3)**:
  - Simple 8-bit storage registers with tri-state output
  - **Inputs**: 
    - `Clk`: Clock signal
    - `Sel`: Register select (when high, this register is selected)
    - `RnW`: Read (1) / Write (0) control
  - **On write** (Sel=1, RnW=0): Captures data from DBus on clock edge, stores in `FFstore`
  - **On read** (Sel=1, RnW=1): Drives its stored value onto DBus
  - **Idle**: Releases bus (high-Z) when not selected

- **`Accumulator` Module**:
  - Similar to register, but performs addition instead of simple storage
  - **On write** (Sel=1, RnW=0): **Adds** incoming DBus value to accumulator, stores result
  - **On read** (Sel=1, RnW=1): Drives current accumulator value onto DBus
  - **On reset** (Sel=1, RnW=1): Clears accumulator to 0
  - Implements the ALU (Arithmetic Logic Unit) element

- **Bus Arbitration Logic**:
  - Input enable: `in = ((RnW1|RnW2|RnW3) & (~En) & ~(Sel1&Sel2) & ~(Sel1&Sel3) & ~(Sel2&Sel3)) | (~(Sel1|Sel2|Sel3) & En)`
  - Ensures external data only drives bus when:
    - Any register is reading AND no other register is selected
    - OR accumulator is being accessed without simultaneous register access
  - Output enable: `out = ~in` (drives external port when not reading)
  - Prevents bus contention through mutual exclusion logic

**Signal Definitions:**
- `Sel1, Sel2, Sel3`: Register select lines
- `RnW1, RnW2, RnW3`: Individual read/write controls per register
- `En`: Accumulator enable/select
- `EnAcc`: Accumulator control (mirrors RnW logic)
- `DioExt`: External data port (bi-directional)
- `Dbus`: Internal bus (internal only, not driven externally)

**Key Learning Points:**
- Tri-state logic for bus sharing
- Register file organization
- Accumulator/ALU design
- Bus arbitration and contention prevention
- Bidirectional I/O with tri-state control
- Microprocessor datapath concepts
- Complex control logic for multi-source bus systems

---

## Key Verilog Concepts Demonstrated

### Combinational Logic
- Multiplexers using ternary operator (`?:`)
- Boolean reduction operators (`&`, `|`, `~|`, `&`)
- Continuous assignments (`assign`)

### Sequential Logic
- `always @(posedge Clk)` for synchronous logic
- `always @(posedge Clk or negedge Reset)` for async reset
- Non-blocking assignments (`<=`) for registers

### Module Design
- Module instantiation and hierarchy
- Port definitions (input, output, inout)
- Parameterized modules (using `parameter`)
- Tri-state drivers using conditional assignments (`? : Z`)

### Advanced Patterns
- Shift registers for data serialization
- State machines with enumerated states
- Bus arbitration and tri-state control
- Cascading enable signals
- Parity calculation (XOR of multiple bits)
- Quadrature signal decoding

---

## Verilog Patterns

### Shift Register Pattern
```verilog
reg [N-1:0] shift_reg;
always @(posedge Clk)
    shift_reg <= {shift_reg[N-2:0], input_bit};  // Shift left, input on right
