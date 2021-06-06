LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY eightBit2x1MUX IS
	PORT (
		i_sel		: IN	STD_LOGIC;
		i_A		: IN	STD_LOGIC_VECTOR(7 downto 0);
		i_B		: IN	STD_LOGIC_VECTOR(7 downto 0);
		o_q		: OUT	STD_LOGIC_VECTOR(7 downto 0));
END eightBit2x1MUX;

ARCHITECTURE struct OF eightBit2x1MUX IS
	
BEGIN

WITH i_sel SELECT
	o_q <= i_A WHEN '0',
	       i_B WHEN '1',
	       "00000000" WHEN OTHERS;
END struct; 
