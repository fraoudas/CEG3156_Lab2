LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY eightBitDecoder IS
	PORT (
		i_sel	: IN	STD_LOGIC_VECTOR(2 downto 0);
		o_q	: OUT	STD_LOGIC_VECTOR(7 downto 0));
END eightBitDecoder;

ARCHITECTURE struct OF eightBitDecoder IS

SIGNAL int_q : STD_LOGIC_VECTOR(7 downto 0);

BEGIN

WITH i_sel SELECT
	int_q <= 	"00000001" WHEN "000",
			"00000010" WHEN "001",
			"00000100" WHEN "010",
			"00001000" WHEN "011",
			"00010000" WHEN "100",
			"00100000" WHEN "101",
			"01000000" WHEN "110",
			"10000000" WHEN "111",
			"00000000" WHEN OTHERS;
	--Output Driver
	o_q <= int_q;
END struct;
