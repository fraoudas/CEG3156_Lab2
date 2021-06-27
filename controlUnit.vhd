LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity controlUnit is 

      Port (
	     opCode : in std_logic_vector(5 downto 0);
         aluOp : out std_logic_vector(1 downto 0);
	     regDst : out std_logic;
         jump : out std_logic;
	     branch : out std_logic;
      	 memRead : out std_logic;
         memToReg : out std_logic;
	     memWrite : out std_logic;
	     aluSrc : out std_logic;
	     regWrite: out std_logic
	     );

END controlUnit;

ARCHITECTURE struct OF controlUnit IS

BEGIN

PROCESS(opCode)
BEGIN
	IF (opCode = "000000") THEN -- r-type instruction
		regDst <= '1';
		jump <= '0';
		branch <= '0';
		memRead <= '0';
		memToReg <= '0';
		aluOp <= "10";
		memWrite <= '0';
		aluSrc <= '0';
		regWrite <= '1';
	ELSIF (opCode = "100011") THEN	--lw instruction
		regDst <= '0';
		jump <= '0';
		branch <= '0';
		memRead <= '1';
		memToReg <= '1';
		aluOp <= "00";
		memWrite <= '0';
		aluSrc <= '1';
		regWrite <= '1';
	ELSIF (opCode = "101011") THEN	--sw instruction
		jump <= '0';
		branch <= '0';
		memRead <= '0';
		aluOp <= "00";
		memWrite <= '1';
		aluSrc <= '1';
		regWrite <= '0';
	ELSIF (opCode = "000100") THEN -- beq instruction
		jump <= '0';
		branch <= '1';
		memRead <= '0';
		aluOp <= "01";
		memWrite <= '0';
		aluSrc <= '0';
		regWrite <= '0';
	ELSIF (opCode = "000010") THEN
		jump <= '1';
		aluSrc <= '0';
		regWrite <= '0';
		memRead <= '0';
		memWrite <= '0';
		aluOp <= "00";
	END IF;
END PROCESS;
	
END struct;
	