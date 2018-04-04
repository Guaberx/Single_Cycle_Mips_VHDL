library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RF is
	generic
	(
		dataWidth : integer := 31;
		addrWidth : integer := 4
	);


	port
	(
		-- Input portsz
		rs	: in  std_logic_vector(addrWidth downto 0);
		rt	: in  std_logic_vector(addrWidth downto 0);
		rd : in std_logic_vector(addrWidth downto 0);
		
		writeData : in signed(dataWidth downto 0);
		regWrite : in std_logic;
		
		-- Output ports
		readData1	: out signed(dataWidth downto 0);
		readData2	: out signed(dataWidth downto 0)
	);
end RF;


architecture RFARCHITECTURE of RF is

	signal r1,r2,r3,r4,r5,r6,r7,r8,r9,r10 : signed(dataWidth downto 0);

begin
	
	process(rs,rt)
	begin
		case rs is
			when "00001" => readData1 <= r1;
			when "00010" => readData1 <= r2;
			when "00011" => readData1 <= r3;
			when "00100" => readData1 <= r4;
			when "00101" => readData1 <= r5;
			when "00110" => readData1 <= r6;
			when "00111" => readData1 <= r7;
			when "01000" => readData1 <= r8;
			when "01001" => readData1 <= r9;
			when "01010" => readData1 <= r10;
			when others =>
			end case;
		case rs is
			when "00001" => readData2 <= r1;
			when "00010" => readData2 <= r2;
			when "00011" => readData2 <= r3;
			when "00100" => readData2 <= r4;
			when "00101" => readData2 <= r5;
			when "00110" => readData2 <= r6;
			when "00111" => readData2 <= r7;
			when "01000" => readData2 <= r8;
			when "01001" => readData2 <= r9;
			when "01010" => readData2 <= r10;
			when others =>
			end case;
		end process;
		
	process(regWrite)
	begin
		if regWrite='1' then
			case rd is
				when "00001" => r1 <= writeData;
				when "00010" => r2 <= writeData;
				when "00011" => r3 <= writeData;
				when "00100" => r4 <= writeData;
				when "00101" => r5 <= writeData;
				when "00110" => r6 <= writeData;
				when "00111" => r7 <= writeData;
				when "01000" => r8 <= writeData;
				when "01001" => r9 <= writeData;
				when "01010" => r10 <= writeData;
				when others =>
			end case;
		end if;
	end process;
	

end RFARCHITECTURE;
