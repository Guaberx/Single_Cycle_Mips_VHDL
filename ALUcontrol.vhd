library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALUControl is
	generic
	(
		dataWidth	: integer  :=	32;
		ADDR_WIDTH : natural := 8;
		registerWidth : natural := 5
	);
	port
	(
		InALUOp	:in std_logic_vector(1 downto 0);
		InInstruction	:in std_logic_vector(5 downto 0);

		Output : out std_logic_vector(1 downto 0)
	);
	
end entity;

architecture ALUControlArchitecture of ALUControl is
	signal tipoR : std_logic_vector(1 downto 0);
begin
	process(InALUOp,InInstruction)
	begin
		case InALUOp is
			when "00" => --R-Type
				case InInstruction is
					when "100000" => --Add
						Output <= "00";
					when "100010" => --Sub
						Output <= "01";
					when "011000" => --Mult
						Output <= "10";
					when "011010" => --Div
						Output <= "11";
					when others =>
						output <= "00";
				end case;
			when "01" => --addi
					output <= "00";
			when others =>
				Output <= "00";
		end case;
		
	end process;

end ALUControlArchitecture;