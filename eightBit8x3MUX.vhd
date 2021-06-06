LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY eightBit8x3MUX IS
	PORT (
		i_sel						: IN 	STD_LOGIC_VECTOR(2 downto 0);
		i_A0, i_A1, i_A2, i_A3, i_A4, i_A5, i_A6, i_A7  : IN 	STD_LOGIC_VECTOR(7 downto 0);
		o_q						: OUT	STD_LOGIC_VECTOR(7 downto 0));
END eightBit8x3MUX;


ARCHITECTURE struct OF eightBit8x3MUX IS

SIGNAL int_q : STD_LOGIC_VECTOR(7 downto 0);

BEGIN

WITH i_sel SELECT
	int_q <= i_A0 WHEN "000",
		 i_A1 WHEN "001",
		 i_A2 WHEN "010",
		 i_A3 WHEN "011",
		 i_A4 WHEN "100",
		 i_A5 WHEN "101",
		 i_A6 WHEN "110",
		 i_A7 WHEN "111",
		 "00000000" WHEN OTHERS;

	--Output driver
	o_q <= int_q;

END struct;