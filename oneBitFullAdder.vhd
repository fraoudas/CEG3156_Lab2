----------------------------------------------------------------------
-- Title: One Bit Full Adder
-- Description: This entity is used to add 3 bits, two input bit and a carry in bit.
--		It outputs a carry out bit and a sum bit.
--
----------------------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY oneBitFullAdder IS
	PORT ( 		i_x	: IN STD_LOGIC;
			i_y	: IN STD_LOGIC;
			i_cin	: IN STD_LOGIC;
			o_cout	: OUT STD_LOGIC;
			o_s	: OUT STD_LOGIC);
END oneBitFullAdder;

ARCHITECTURE struct OF oneBitFullAdder IS

SIGNAL int_s : STD_LOGIC;	--sum signal
SIGNAL int_cout : STD_LOGIC;	--carry out signal

BEGIN
--Formulas for calculating the sum and carry out
int_s <= (i_x xor i_y) xor i_cin;
int_cout <= (i_x and i_y) or (i_x and i_cin) or (i_y and i_cin);

		--Output Driver
		o_s <= int_s;
		o_cout <= int_cout;

END struct;
