LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY aluControl IS
	PORT (
		i_func 		: IN 	STD_LOGIC_VECTOR(5 downto 0);
		i_aluOp 	: IN 	STD_LOGIC_VECTOR(1 downto 0);
		o_control 	: OUT 	STD_LOGIC_VECTOR(2 downto 0)
		);
END aluControl;

ARCHITECTURE struct OF aluControl IS

BEGIN

PROCESS(i_aluOp)
BEGIN
	

  if i_aluOp = "00" then   -- add function lw
     o_control <= "010";
	 
  elsif i_aluOp = "01" then -- subtract function sw
     o_control <= "110";
	 
  elsif i_aluOp = "10" then -- r-type insturction 
     if i_func(3 downto 0) = "0000"  then -- add function
	 o_control <= "010";
	 
	 elsif i_func(3 downto 0) = "0010" then -- subtract function 
	 o_control <= "110";
	 
	 elsif i_func(3 downto 0) = "0100" then  -- and function
	 o_control <= "000";
	 
	 elsif i_func(3 downto 0) = "0101" then -- or function
	 o_control <= "001";
	 
	 elsif i_func(3 downto 0) = "1010" then -- slt function
	 o_control <= "111";
	 
	end if;
   end if;
   
end process;

END struct;