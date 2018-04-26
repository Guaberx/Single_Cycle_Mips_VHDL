library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
	generic(dataWidth : integer := 32);
	port
	(
		inputControl	:in std_logic_vector(1 downto 0);
		inputA			:in signed((dataWidth) -1 downto 0);
		inputB			:in signed((dataWidth) -1 downto 0);
		output			:out signed((dataWidth -1) downto 0);
		flag				:out std_logic_vector(1 downto 0)
	);
	
end entity;

architecture ALUARCHITECTURE of alu is

begin
	process (inputControl, inputA, inputB)
	begin
		case inputControl is
			when "00" => output <= inputA + inputB;
			when "01" => output <= inputA - inputB;
			when "10" => output <= RESIZE(inputA * inputB,dataWidth);
			when "11" => output <= inputA / inputB;
			when others =>
			end case;
		end process;
end ALUARCHITECTURE;
		