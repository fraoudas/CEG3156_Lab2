LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY eightBitRegister IS
	PORT ( 
		i_gReset, i_clock : IN STD_LOGIC;
		i_A : IN STD_LOGIC_VECTOR(7 downto 0);
		o_q : OUT STD_LOGIC_VECTOR(7 downto 0));
END eightBitRegister;

ARCHITECTURE rtl OF eightBitRegister IS

COMPONENT enardFF
	PORT (
		i_resetBar	: IN	STD_LOGIC;
		i_d		: IN	STD_LOGIC;
		i_enable	: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);
END COMPONENT;

SIGNAL int_q : STD_LOGIC_VECTOR(7 downto 0);

BEGIN

bit7: enardFF
	PORT MAP (	i_resetBar => i_gReset,
			i_clock => i_clock,
			i_d => i_A(7),
			i_enable => '1',
			o_q => int_q(7));

bit6: enardFF
	PORT MAP (	i_resetBar => i_gReset,
			i_clock => i_clock,
			i_d => i_A(6),
			i_enable => '1',
			o_q => int_q(6));

bit5: enardFF
	PORT MAP (	i_resetBar => i_gReset,
			i_clock => i_clock,
			i_d => i_A(5),
			i_enable => '1',
			o_q => int_q(5));

bit4: enardFF
	PORT MAP (	i_resetBar => i_gReset,
			i_clock => i_clock,
			i_d => i_A(4),
			i_enable => '1',
			o_q => int_q(4));

bit3: enardFF
	PORT MAP (	i_resetBar => i_gReset,
			i_clock => i_clock,
			i_d => i_A(3),
			i_enable => '1',
			o_q => int_q(3));

bit2: enardFF
	PORT MAP (	i_resetBar => i_gReset,
			i_clock => i_clock,
			i_d => i_A(2),
			i_enable => '1',
			o_q => int_q(2));

bit1: enardFF
	PORT MAP (	i_resetBar => i_gReset,
			i_clock => i_clock,
			i_d => i_A(1),
			i_enable => '1',
			o_q => int_q(1));

bit0: enardFF
	PORT MAP (	i_resetBar => i_gReset,
			i_clock => i_clock,
			i_d => i_A(0),
			i_enable => '1',
			o_q => int_q(0));

	--Output driver
	o_q <= int_q;

END rtl;