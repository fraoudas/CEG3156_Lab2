LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY lpm;
USE lpm.lpm_components.ALL;

ENTITY singleCycleProc IS
	PORT (
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

COMPONENT eightBitRegsiter
	PORT (
		i_gReset, i_clock 	: IN  STD_LOGIC;
		i_A 			: IN  STD_LOGIC_VECTOR(7 downto 0);
		o_q 			: OUT STD_LOGIC_VECTOR(7 downto 0));
END COMPONENT;

COMPONENT instructionMemory
	PORT (
		i_inclock, i_outclock 	: IN  STD_LOGIC;
		i_addr 			: IN  STD_LOGIC_VECTOR(7 downto 0);
		o_q 			: OUT STD_LOGIC_VECTOR(31 downto 0));
END COMPONENT;
		
SIGNAL int_PCin, int_PCout : STD_LOGIC_VECTOR(7 downto 0);
SIGNAL int_readData1, int_readData2 : STD_LOGIC_VECTOR(7 downto 0);
SIGNAL int_writeData : STD_LOGIC_VECTOR(7 downto 0);
SIGNAL int_regDst, int_jump, int_memRead, int_memToReg, int_aluSrc : STD_LOGIC;
SIGNAL int_aluOp : STD_LOGIC_VECTOR(2 downto 0);

SIGNAL int_aluRes : STD_LOGIC_VECTOR(7 downto 0);
SIGNAL int_muxOther : STD_LOGIC_VECTOR(7 downto 0);
SIGNAL int_instruction : STD_LOGIC_VECTOR(31 downto 0);

SIGNAL int_PCCout : STD_LOGIC;
SIGNAL int_PCnext : STD_LOGIC_VECTOR(7 downto 0);

BEGIN
	
int_muxOther <= '0' & int_regDst & int_jump & int_memRead & int_memToReg & int_aluOp(1) & int_aluOp(0) & int_aluSrc;

ioMUX: eightBit8x3MUX
	PORT MAP (	i_sel => ValueSelect,
			i_A0 => int_PC,
			i_A1 => int_aluRes,
			i_A2 => int_readData1,
			i_A3 => int_readData2,
			i_A4 => int_writeData,
			i_A5 => int_muxOther,
			i_A6 => int_muxOther,
			i_A7 => int_muxOther);

PC: eightBitRegister
	PORT MAP (	i_gReset => GReset,
			i_clock => GClock,
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

END rtl;