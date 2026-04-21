# Computer Architecture and Assembly Language

A collection of academic projects and assignments focused on low-level programming, computer architecture principles, and algorithmic optimization. This repository includes x86 Assembly programs and a final project involving text processing and sorting.

### x86 Assembly Assignments
These programs were written in Assembly (Intel 8086 syntax, `.model small`) and demonstrate fundamental low-level concepts:

* **Low-Level Control Flow:** Implementation of loops, nested cycles, and conditional branching using hardware flags and jump instructions.
* **Memory Management & Addressing:** Working with different memory segments (Data, Code, Stack), using pointers, and managing offsets for effective data retrieval.
* **Data Manipulation:** Performing arithmetic operations and bitwise logic (AND, OR, XOR, NOT) to control program state at the bit level.
* **Interrupts & System Calls:** Interacting with the DOS environment via `INT 21h` for standard I/O operations, including character display and keyboard input handling.
* **Data Structures in Memory:** Defining and traversing one-dimensional and multi-dimensional arrays, as well as managing string buffers and pointer arrays for dynamic data processing.
* **Register Optimization:** Efficient use of general-purpose and index registers (AX, BX, CX, DX, SI, DI) to minimize memory access and improve execution speed.

### Final Project: Substring Frequency Analyzer
Located in the project directory, this utility performs efficient text analysis and sorting.

#### Functionality
* **Standard Input Processing:** Reads up to 100 lines (max 255 characters each) from `stdin` until `EOF`.
* **Cross-platform Compatibility:** Handles various line endings, including `CRLF`, `CR`, and `LF`.
* **Non-overlapping Search:** Identifies all unique, non-overlapping occurrences of a specified substring within each line.
* **Bubble Sort Implementation:** Sorts the processed lines based on the frequency of the substring.
* **Formatted Output:** Displays results in the format: `<count> <original_line_index>`.

#### Example Usage
```bash
python main_project.py [substring] < input.txt
```

## Technologies Used
* **Assembly:** x86 (8086), DOSBox/TASM environment.
* **Python:** 3.x for higher-level algorithmic implementation.
* **Architecture:** Memory segments, registers, interrupts, and pointer arithmetic.

## Academic Context
These projects were completed as part of the "Computer Architecture" course at Kyiv-Mohyla Academy (NaUKMA).
