LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY aluControl IS
	PORT (
		i_func 		: IN 	STD_LOGIC_VECTOR(5 downto 0);
		i_aluOp 	: IN 	STD_LOGIC_VECTOR(2 downto 0);
		o_control 	: OUT 	STD_LOGIC_VECTOR(2 downto 0));
END aluControl;

ARCHITECTURE struct OF aluControl IS
BEGIN
END struct;