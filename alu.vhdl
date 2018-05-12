library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
	generic(dataWidth : integer := 32);
	port
	(
		inputControl	:in std_logic_vector(1 downto 0);
		inputA			:in std_logic_vector((dataWidth) -1 downto 0);
		inputB			:in std_logic_vector((dataWidth) -1 downto 0);
		output			:out std_logic_vector((dataWidth -1) downto 0);
		flag				:out std_logic
	);
	
end entity;

architecture ALUARCHITECTURE of alu is

begin
	process (inputControl, inputA, inputB)
	begin
		case inputControl is
			when "00" => output <= std_logic_vector(signed(inputA) + signed(inputB));
			when "01" => output <= std_logic_vector(signed(inputA) - signed(inputB));
			when "10" => output <= std_logic_vector(RESIZE(signed(inputA) * signed(inputB),dataWidth));
			when "11" => output <= std_logic_vector(signed(inputA) / signed(inputB));
			when others => output <= inputA;
			end case;
		end process;
end ALUARCHITECTURE;
		