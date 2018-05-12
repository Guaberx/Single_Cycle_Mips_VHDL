library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controlUnity is
	generic
	(
		dataWidth	: integer  :=	32;
		ADDR_WIDTH : natural := 8;
		registerWidth : natural := 5
	);
	port
	(
		OP	:in std_logic_vector(5 downto 0);

		OutregDST : out std_logic;
	   OutJump : out std_logic;
	   OutBranch : out std_logic;
		OutMemRead : out std_logic;
		OutMemtoReg : out std_logic;
		OutALUOp : out std_logic_vector(1 downto 0);
		OutMemWrite : out std_logic;
		OutALUSrc :out std_logic;
		OutRegWrite : out std_logic

	);
	
end entity;

architecture ControlUnitArchitecture of controlUnity is
begin
	process(OP)
	begin
		case OP is
			when "000000" => --R-Type
				OutregDST <= '1';
				OutJump <= '0';
				OutBranch <= '0';
				OutMemRead <= '1';
				OutMemtoReg <= '0';
				OutALUOp <= "00";
				OutMemWrite <= '0' ;
				OutALUSrc <= '0';
				OutRegWrite <= '1';
			
			when "001000" => --addi
				OutregDST <= '0';
				OutJump <= '0';
				OutBranch <= '0';
				OutMemRead <= '1';
				OutMemtoReg <= '0';
				OutALUOp <= "01";
				OutMemWrite <= '0' ;
				OutALUSrc <= '1';
				OutRegWrite <= '1';
				
			when others =>
				OutregDST <= '0';
				OutJump <= '0';
				OutBranch <= '0';
				OutMemRead <= '0';
				OutMemtoReg <= '0';
				OutALUOp <= "00";
				OutMemWrite <= '0' ;
				OutALUSrc <= '0';
				OutRegWrite <= '0';
			end case;
	end process;

end ControlUnitArchitecture;