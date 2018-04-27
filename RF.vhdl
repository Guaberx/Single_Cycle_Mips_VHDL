library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RF is
	generic
	(
		dataWidth : integer := 32;
		addrWidth : integer := 4
	);


	port
	(
		-- Input ports
		rs	: in  std_logic_vector(addrWidth downto 0);
		rt	: in  std_logic_vector(addrWidth downto 0);
		rd : in std_logic_vector(addrWidth downto 0);
		
		writeData : in signed((dataWidth -1) downto 0);
		rw : in std_logic;
		
		-- Output ports
		readData1	: out signed((dataWidth -1) downto 0);
		readData2	: out signed((dataWidth -1) downto 0)
	);
end RF;


architecture RFARCHITECTURE of RF is

	type registerFile is array(0 to (dataWidth -1)) of signed((dataWidth -1) downto 0);
	signal registers : registerFile;

begin
	process(rw, rs, rt, rd, writeData)
	begin
		readData1 <= registers(to_integer(signed(rs)));
		readData2 <= registers(to_integer(signed(rt)));
		if rw = '1' then
				registers(to_integer(signed(rd))) <= writeData;
			end if;
	end process;
	
end RFARCHITECTURE;
