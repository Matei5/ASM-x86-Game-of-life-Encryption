# Game of Life Encryption

## Contents
- Overview
- Files
- How It Works
- Usage
- Example Execution
- Notes
- License

## Overview
This project implements a variation of Conway’s Game of Life, extended with encryption and decryption functionalities using a dynamically generated key. The program is written in x86 assembly and consists of three separate implementations, each fulfilling different requirements. It combines cellular automation with a simple encryption scheme to demonstrate algorithmic evolution and security concepts.

## Files

### 1. `133_Sescu_Matei_0.s`
- Simulates Conway’s Game of Life.
- Reads matrix dimensions, number of live cells, their positions, and the number of iterations.
- Displays the resulting matrix after `k` iterations.

### 2. `133_Sescu_Matei_1.s`
- Extends the previous version by adding encryption and decryption functionality.
- Generates an encryption key from the final state of the Game of Life simulation.
- Supports both encryption (XOR-ing a plaintext message) and decryption (XOR-ing back to plaintext).
- Takes an extra parameter to determine whether to encrypt or decrypt.

### 3. `133_Sescu_Matei_2.s`
- A file-based implementation of `133_Sescu_Matei_0.s`.
- Reads input from `in.txt` instead of standard input.
- Writes the output matrix to `out.txt` instead of printing to the console.

## How It Works
1. **Game of Life Simulation**
   - The program initializes a matrix based on user input.
   - It applies Conway’s rules iteratively to determine the next state of each cell.
   - After `k` iterations, the final state is used as the encryption key.

2. **Encryption & Decryption (133_Sescu_Matei_1.s)**
   - The final matrix state is converted into a one-dimensional bit sequence.
   - This sequence is used as a key to XOR with the input message.
   - If encrypting, the output is displayed as a hexadecimal string.
   - If decrypting, the original plaintext is recovered.

## Usage
### Running the Programs
To assemble and run any of the `.s` files, use:
```bash
nasm -f elf32 file.s -o file.o
ld -m elf_i386 file.o -o file
./file
```

### Expected Input
For `133_Sescu_Matei_0.s` and `133_Sescu_Matei_1.s`, input is provided as:
```
m  # Number of rows
n  # Number of columns
p  # Number of initial live cells
row1 col1  # Position of live cells
row2 col2
...
k  # Number of iterations
[encryption mode]  # Only for 133_Sescu_Matei_1.s (0 for encryption, 1 for decryption)
[message]  # Only for 133_Sescu_Matei_1.s
```

For `133_Sescu_Matei_2.s`, input is read from `in.txt` and the output is saved in `out.txt`.

## Example Execution
### Game of Life Simulation
```
Input:
3
4
5
0 1
0 2
1 0
2 2
2 3
1

Output:
0 0 0 0
0 0 1 0
0 0 0 0
```

### Encryption Example
```
Input:
3
4
5
0 1
0 2
1 0
2 2
2 3
1
0
parola

Output:
0x70E1F26F6E63
```

### Decryption Example
```
Input:
3
4
5
0 1
0 2
1 0
2 2
2 3
1
1
0x70E1F26F6E63

Output:
parola
```

## Notes
- The programs use 32-bit assembly and may require compatibility settings on 64-bit systems.
- Input constraints are enforced (e.g., valid matrix dimensions, proper formatting for encryption keys).
- The encryption scheme relies on repeated XOR operations, making it simple yet effective for obfuscation.

## License
This project is free to use and modify for educational purposes.

