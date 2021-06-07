LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY oneBitComparator IS
	PORT ( 
		i_Ai, i_Bi 			: IN 	STD_LOGIC;
		i_GTPrevious, i_LTPrevious	: IN	STD_LOGIC;
		o_GT, o_LT, o_EQ		: OUT 	STD_LOGIC);
END oneBitComparator;

ARCHITECTURE rtl OF oneBitComparator IS
	SIGNAL int_GT, int_LT : STD_LOGIC;

BEGIN
int_GT <= (i_Ai AND NOT(i_LTPrevious) AND NOT(i_Bi)) OR i_GTPrevious;
int_LT <= (NOT(i_Ai) AND i_Bi AND NOT(i_GTPrevious)) OR i_LTPrevious;

	--Output Drivers
	o_GT <= int_GT;
	o_LT <= int_LT;
	o_EQ <= int_GT NOR int_LT;
   
END rtl;
