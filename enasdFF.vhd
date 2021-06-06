LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY enasdFF is 
	PORT(
		i_resetBar : IN STD_LOGIC;
		i_d	: IN STD_LOGIC;
		i_clock : IN STD_LOGIC;
		i_enable : IN STD_LOGIC; 
		o_q, o_qBar : OUT STD_LOGIC); 
	END enasdFF;

ARCHITECTURE rtl OF enasdFF IS 
	SIGNAL int_q : STD_LOGIC; 
BEGIN 

oneBitRegister:
PROCESS(i_clock, i_resetBar)

BEGIN 
	IF (i_resetBar = '0') THEN
		int_q <= '1'; 
	ELSIF (i_clock'Event and i_clock = '1') THEN
		IF (i_enable = '1') THEN
			int_q <= i_d;
		END IF;
	END IF;
END PROCESS oneBitRegister;

	-- output driver 
	
	o_q  <= int_q;
	o_qBar <= not(int_q);

END rtl;
