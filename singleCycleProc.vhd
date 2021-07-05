LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY lpm;
USE lpm.lpm_components.ALL;

ENTITY singleCycleProc IS
	PORT (  CLOCK_50, CLOCK2_50				: IN STD_LOGIC;
		GReset, GClock 					: IN STD_LOGIC;
		ValueSelect 					: IN STD_LOGIC_VECTOR(2 downto 0);
		MuxOut 						: OUT STD_LOGIC_VECTOR(7 downto 0);
		InstructionOut 					: OUT STD_LOGIC_VECTOR(31 downto 0);
		BranchOut, ZeroOut, MemWriteOut, RegWriteOut 	: OUT STD_LOGIC);
END singleCycleProc;

ARCHITECTURE rtl OF singleCycleProc IS

COMPONENT eightBitAdder
	PORT (
		i_x		: IN STD_LOGIC_VECTOR(7 downto 0);
		i_y		: IN STD_LOGIC_VECTOR(7 downto 0);
		i_cin		: IN STD_LOGIC;
		o_cout		: OUT STD_LOGIC;
		o_s		: OUT STD_LOGIC_VECTOR(7 downto 0));
END COMPONENT;

COMPONENT eightBit8x3MUX
	PORT (
		i_sel						: IN 	STD_LOGIC_VECTOR(2 downto 0);
		i_A0, i_A1, i_A2, i_A3, i_A4, i_A5, i_A6, i_A7  : IN 	STD_LOGIC_VECTOR(7 downto 0);
		o_q						: OUT	STD_LOGIC_VECTOR(7 downto 0));
END COMPONENT;

COMPONENT instructionMemory
	PORT (
		i_inclock, i_outclock 	: IN  STD_LOGIC;
		i_addr 			: IN  STD_LOGIC_VECTOR(7 downto 0);
		o_q 			: OUT STD_LOGIC_VECTOR(31 downto 0));
END COMPONENT;

COMPONENT dataMemory
	PORT (
		i_inclock, i_outclock 	: IN  STD_LOGIC;
		i_writeEnable		: IN  STD_LOGIC;
		i_addr 			: IN  STD_LOGIC_VECTOR(7 downto 0);
		i_data			: IN  STD_LOGIC_VECTOR(7 downto 0);
		o_q 			: OUT STD_LOGIC_VECTOR(7 downto 0)); 
END COMPONENT;

COMPONENT eightBit2x1MUX
	PORT (
		i_sel			: IN STD_LOGIC;
		i_A			: IN STD_LOGIC_VECTOR(7 downto 0);
		i_B			: IN STD_LOGIC_VECTOR(7 downto 0);
		o_q			: OUT STD_LOGIC_VECTOR(7 downto 0));
END COMPONENT;

COMPONENT registerFile
	PORT (	i_clock			: IN	STD_LOGIC;
		i_gReset		: IN 	STD_LOGIC;
		i_regWrite		: IN	STD_LOGIC;
		i_readRegister1 	: IN 	STD_LOGIC_VECTOR(2 downto 0);
		i_readRegister2 	: IN 	STD_LOGIC_VECTOR(2 downto 0);
		i_writeRegister 	: IN 	STD_LOGIC_VECTOR(2 downto 0);
		i_writeData 		: IN 	STD_LOGIC_VECTOR(7 downto 0);
		o_readData1 		: OUT 	STD_LOGIC_VECTOR(7 downto 0);
		o_readData2 		: OUT 	STD_LOGIC_VECTOR(7 downto 0));
END COMPONENT;

COMPONENT eightBitALU
	PORT (
		i_op		: IN	STD_LOGIC_VECTOR(2 downto 0);
		i_A, i_B	: IN	STD_LOGIC_VECTOR(7 downto 0);
		o_zero		: OUT	STD_LOGIC;
		o_q		: OUT	STD_LOGIC_VECTOR(7 downto 0));
END COMPONENT;

COMPONENT eightBitRegister
	PORT (
		i_gReset, i_clock, i_enable : IN STD_LOGIC;
		i_A : IN STD_LOGIC_VECTOR(7 downto 0);
		o_q : OUT STD_LOGIC_VECTOR(7 downto 0));
END COMPONENT;

COMPONENT controlUnit
	PORT (	
	     	i_Opcode								  : IN	STD_LOGIC_VECTOR(5 downto 0);
		o_ALUOp									  : OUT	STD_LOGIC_VECTOR(1 downto 0);
		o_RegDst, o_Jump, o_Branch, o_MemRead, o_MemToReg, o_MemWrite, o_RegWrite, o_ALUSrc : OUT STD_LOGIC); 
END COMPONENT;

COMPONENT aluControl
	PORT (
		i_func 		: IN 	STD_LOGIC_VECTOR(5 downto 0);
		i_aluOp 	: IN 	STD_LOGIC_VECTOR(1 downto 0);
		o_control 	: OUT 	STD_LOGIC_VECTOR(2 downto 0)
		);
END COMPONENT;

--PC Signals
SIGNAL int_PCin, int_PCout : STD_LOGIC_VECTOR(7 downto 0);

--Register File Signals
SIGNAL int_regDst, int_regWrite : STD_LOGIC;
SIGNAL int_readRegister1, int_readRegister2 : STD_LOGIC_VECTOR(2 downto 0);
SIGNAL int_writeRt, int_writeRd : STD_LOGIC_VECTOR(7 downto 0);
SIGNAL int_writeRegister, int_writeData : STD_LOGIC_VECTOR(7 downto 0);
SIGNAL int_readData1, int_readData2 : STD_LOGIC_VECTOR(7 downto 0);

--Branch and Jump Instruction Signals

SIGNAL int_zero : STD_LOGIC;
SIGNAL int_branch, int_jump, int_beq : STD_LOGIC;
SIGNAL int_PCnext : STD_LOGIC_VECTOR(7 downto 0);
SIGNAL int_jumpAddress, int_PCBranchAddress, int_extendedShiftedAddress, int_extendedAddress, int_nextAddress : STD_LOGIC_VECTOR(7 downto 0);

SIGNAL int_memRead, int_memToReg, int_aluSrc : STD_LOGIC;
SIGNAL int_aluControl : STD_LOGIC_VECTOR(2 downto 0);
SIGNAL int_aluOp : STD_LOGIC_VECTOR(1 downto 0);
SIGNAL int_aluRes : STD_LOGIC_VECTOR(7 downto 0);
SIGNAL int_muxOther : STD_LOGIC_VECTOR(7 downto 0);
SIGNAL int_instruction : STD_LOGIC_VECTOR(31 downto 0);

SIGNAL int_PCCout : STD_LOGIC;

SIGNAL int_memWrite : STD_LOGIC;

SIGNAL int_PCBranchCout : STD_LOGIC;

SIGNAL int_aluInputB, int_readDataMemory : STD_LOGIC_VECTOR(7 downto 0);



SIGNAL int_muxOut : STD_LOGIC_VECTOR(7 downto 0);



BEGIN
int_readRegister1 <= int_instruction(23 downto 21);
int_readRegister2 <= int_instruction(18 downto 16);
	
int_muxOther <= '0' & int_regDst & int_jump & int_memRead & int_memToReg & int_aluOp(1) & int_aluOp(0) & int_aluSrc;

ioMUX: eightBit8x3MUX
	PORT MAP (	i_sel => ValueSelect,
			i_A0 => int_PCout,
			i_A1 => int_aluRes,
			i_A2 => int_readData1,
			i_A3 => int_readData2,
			i_A4 => int_writeData,
			i_A5 => int_muxOther,
			i_A6 => int_muxOther,
			i_A7 => int_muxOther,
			o_q => int_muxOut);

PC: eightBitRegister
	PORT MAP (	i_gReset => GReset,
			i_clock => GClock,
			i_enable => '1',
			i_A => int_PCin,
			o_q => int_PCout);

PCAdder: eightBitAdder
	PORT MAP (	i_x => int_PCout,
			i_y => "00000100",
			i_cin => '0',
			o_cout => int_PCCout,
			o_s => int_PCnext);
			

instructionMem: instructionMemory
	PORT MAP (	i_inclock => CLOCK_50,
			i_outclock => CLOCK2_50,
			i_addr => int_PCout,
			o_q => int_instruction);

branchAdder: eightBitAdder
	PORT MAP (	i_x => int_PCnext,
			i_y => int_extendedShiftedAddress,
			i_cin => '0',
			o_cout => int_PCBranchCout,
			o_s => int_PCBranchAddress);

branchSelect: eightBit2x1MUX
	PORT MAP (	i_sel => int_beq,
			i_A => int_PCnext,
			i_B => int_PCBranchAddress,
			o_q => int_nextAddress);

branchOrJump: eightBit2x1MUX
	PORT MAP (	i_sel => int_jump,
			i_A => int_nextAddress,
			i_B => int_jumpAddress,
			o_q => int_PCin);

int_beq <= int_branch AND int_zero;
int_jumpAddress <= int_PCnext(7) &  int_instruction(4 downto 0) & '0' & '0';
int_extendedAddress <= int_instruction(6) & int_instruction(6 downto 0);
int_extendedShiftedAddress <= int_extendedAddress(5 downto 0) & '0' & '0';

registers: registerFile
	PORT MAP (	 i_clock => GClock,
			 i_gReset => GReset,
			 i_regWrite => int_regWrite,
			 i_readRegister1 => int_readRegister1,
			 i_readRegister2 => int_readRegister2,
			 i_writeRegister => int_writeRegister(2 downto 0),
			 i_writeData => int_writeData,
			 o_readData1 => int_readData1,
			 o_readData2 => int_readData2);

int_writeRt <= '0' & '0' & '0' & '0' & '0' & int_instruction(18 downto 16);
int_writeRd <= '0' & '0' & '0' & '0' & '0' & int_instruction(13 downto 11);

writeRegMUX: eightBit2x1MUX
	PORT MAP (	i_sel => int_regDst,
			i_A => int_writeRt,
			i_B => int_writeRd,
			o_q => int_writeRegister);

readData2MUX: eightBit2x1MUX
	PORT MAP (	i_sel => int_ALUSrc,
			i_A => int_readData2,
			i_B => int_extendedAddress,
			o_q => int_aluInputB);

control: controlUnit
	PORT MAP (	i_Opcode => int_instruction(31 downto 26),
			o_ALUOp => int_aluOp,
			o_RegDst => int_regDst,
			o_Jump => int_jump,
			o_Branch => int_branch,
			o_MemRead => int_memRead,
			o_MemToReg => int_memToReg,
			o_MemWrite => int_memWrite,
			o_ALUSrc => int_aluSrc,
			o_RegWrite => int_regWrite);

alucontrolunit: aluControl
	PORT MAP (	i_func => int_instruction(5 downto 0),
			i_aluOp => int_aluOp,
			o_control => int_aluControl);
	
alu: eightBitALU
	PORT MAP (	i_op => int_aluControl,
			i_A => int_readData1,
			i_B => int_aluInputB,
			o_zero => int_zero,
			o_q => int_aluRes);

dataMem: dataMemory
	PORT MAP (	i_inclock => CLOCK_50, --CLOCK_50
			i_outclock => CLOCK2_50,
			i_writeEnable => int_memWrite,
			i_addr => int_aluRes,
			i_data => int_readData2,
			o_q => int_readDataMemory);

dataMUX: eightBit2x1MUX
	PORT MAP (	i_sel => int_memToReg,
			i_A => int_aluRes,
			i_B => int_readDataMemory,
			o_q => int_writeData);

	--Output drivers
	MuxOut <= int_muxOut;
	InstructionOut <= int_instruction;
	BranchOut <= int_branch;
	ZeroOut <= int_zero;
	MemWriteOut <= int_memWrite;
	RegWriteOut <= int_regWrite;

END rtl;