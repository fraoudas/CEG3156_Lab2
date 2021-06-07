LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY singleCycleProc IS
	PORT (
		GReset, GClock 					: IN STD_LOGIC;
		ValueSelect 					: IN STD_LOGIC_VECTOR(2 downto 0);
		MuxOut 						: OUT STD_LOGIC_VECTOR(7 downto 0);
		InstructionOut 					: OUT STD_LOGIC_VECTOR(31 downto 0);
		BranchOut, ZeroOut, MemWriteOut, RegWriteOut 	: OUT STD_LOGIC);
END singleCycleProc;

ARCHITECTURE rtl OF singleCycleProc IS

	
END rtl;
		
