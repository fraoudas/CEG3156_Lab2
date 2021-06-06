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

COMPONENT LPM_ROM
	generic (LPM_WIDTH : natural;    -- MUST be greater than 0

                 LPM_WIDTHAD : natural;    -- MUST be greater than 0

                                 LPM_NUMWORDS : natural := 0;

                                 LPM_ADDRESS_CONTROL : string := "REGISTERED";

                                 LPM_OUTDATA : string := "REGISTERED";

                                 LPM_FILE : string;

                                 LPM_TYPE : string := L_ROM;

                                 INTENDED_DEVICE_FAMILY  : string := "UNUSED";

                                 LPM_HINT : string := "UNUSED");

                 port (ADDRESS : in STD_LOGIC_VECTOR(LPM_WIDTHAD-1 downto 0);

                           INCLOCK : in STD_LOGIC := '0';

                           OUTCLOCK : in STD_LOGIC := '0';

                           MEMENAB : in STD_LOGIC := '1';

                           Q : out STD_LOGIC_VECTOR(LPM_WIDTH-1 downto 0));
END COMPONENT;
	
END rtl;
		
