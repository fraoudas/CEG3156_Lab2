LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY controlUnit IS

      PORT (
		i_Opcode								  : IN	STD_LOGIC_VECTOR(5 downto 0);
		o_ALUOp									  : OUT	STD_LOGIC_VECTOR(1 downto 0);
		o_RegDst, o_Jump, o_Branch, o_MemRead, o_MemToReg, o_MemWrite, o_RegWrite, o_ALUSrc : OUT STD_LOGIC); 

END controlUnit;

ARCHITECTURE struct OF controlUnit IS

SIGNAL int_ALUOp : STD_LOGIC_VECTOR(1 downto 0);
SIGNAL int_RegDst, int_Jump, int_Branch, int_MemRead, int_MemToReg, int_MemWrite, int_RegWrite, int_ALUSrc : STD_LOGIC;
SIGNAL int_rformat, int_lw, int_sw, int_beq, int_j : STD_LOGIC;

BEGIN
int_rformat <= NOT(i_Opcode(5)) AND NOT(i_Opcode(4)) AND NOT(i_Opcode(3)) AND NOT(i_Opcode(2)) AND NOT(i_Opcode(1)) AND NOT(i_Opcode(0));	--r-format instruction
int_lw <= i_Opcode(5) AND NOT(i_Opcode(4)) AND NOT(i_Opcode(3)) AND NOT(i_Opcode(2)) AND i_Opcode(1) AND i_Opcode(0);	--load word instruction
int_sw <= i_Opcode(5) AND NOT(i_Opcode(4)) AND i_Opcode(3) AND NOT(i_Opcode(2)) AND i_Opcode(1) AND i_Opcode(0);	--store word instruction
int_beq <= NOT(i_Opcode(5)) AND NOT(i_Opcode(4)) AND NOT(i_Opcode(3)) AND i_Opcode(2) AND NOT(i_Opcode(1)) AND NOT(i_Opcode(0));	--branch equal instruction
int_j <= NOT(i_Opcode(5)) AND NOT(i_Opcode(4)) AND NOT(i_Opcode(3)) AND NOT(i_Opcode(2)) AND i_Opcode(1) AND NOT(i_Opcode(0));	--jump instruction

int_RegDst <= int_rformat;
int_AluSrc <= int_lw OR int_sw;
int_MemToReg <= int_lw;
int_RegWrite <= int_rformat OR int_lw;
int_MemRead <= int_lw;
int_MemWrite <= int_sw;
int_Branch <= int_beq;
int_Jump <= int_j;
int_ALUOp(1) <= int_rformat;
int_ALUOp(0) <= int_beq;

	--Output drivers
	o_ALUOp <= int_ALUOp(1) & int_ALUOp(0);
	o_RegDst <= int_RegDst;
	o_Jump <= int_Jump;
	o_Branch <= int_Branch;
	o_MemRead <= int_MemRead;
	o_MemToReg <= int_MemToReg;
	o_MemWrite <= int_MemWrite;
	o_RegWrite <= int_RegWrite;
	o_ALUSrc <= int_ALUSrc;

END struct;
	