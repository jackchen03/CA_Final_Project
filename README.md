# Computer_Architecture_Final_Project
Implementation of a RISC-V CPU

## Instructions Supported
- Arithmetic and Logical: ADD, SUB, MUL, AND, OR
- Shifts: SLTI, SRAI, SLLI
- Control: AUIPC, JAL, JALR

## Modules
- PC_CAL -> Generate the value of PC (Program Counter)
- Control -> Handle control signals
- ALU -> Arithmetic and Logic Unit
- ALU_Control -> Control signals of ALU
- Imm_Gen -> Generate immediates
- RegWrite_mux -> Decide which data source to write to rd
