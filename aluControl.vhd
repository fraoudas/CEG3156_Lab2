LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY aluControl IS
	PORT (
		i_func 		: IN 	STD_LOGIC_VECTOR(5 downto 0);
		i_ALUOp 	: IN 	STD_LOGIC_VECTOR(1 downto 0);
		o_control 	: OUT 	STD_LOGIC_VECTOR(2 downto 0)
		);
END aluControl;

ARCHITECTURE struct OF aluControl IS

SIGNAL int_control : STD_LOGIC_VECTOR(2 downto 0);

BEGIN

int_control(2) <= i_ALUOp(0) OR (i_ALUOp(1) AND i_func(1));
int_control(1) <= NOT(i_ALUOp(1)) OR NOT(i_func(2));
int_control(0) <= i_ALUOp(1) AND (i_func(3) OR i_func(0));

	--Output driver
	o_control <= int_control;

END struct;