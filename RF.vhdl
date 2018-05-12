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
		
		writeData : in std_logic_vector((dataWidth -1) downto 0);
		rw : in std_logic;
		
		-- Output ports
		readData1	: out std_logic_vector((dataWidth -1) downto 0);
		readData2	: out std_logic_vector((dataWidth -1) downto 0)
	);
end RF;


architecture RFARCHITECTURE of RF is

	subtype reg is std_logic_vector((dataWidth-1) downto 0);
	type regs is array((dataWidth - 1) downto 0) of reg;
	
	signal registers : regs;
	
	signal popo : natural;
	

begin
	
	readData1 <= registers(to_integer(signed(rs)));
	readData2 <= registers(to_integer(signed(rt)));
	
	process(rw, rd, writeData)
	begin
		if rw = '1' then
			registers(to_integer(signed(rd))) <= writeData;
		end if;
	end process;

	--registers(to_integer("00000")) <= x"00000002"; -- addi $0 $0 1
	--registers(to_integer("00001")) <= x"00000005"; -- add $0 $0 $0

	--process(rw, rs, rt, rd, writeData)
	--begin
	--	readData1 <= registers(to_integer(signed(rs)));
	--	readData2 <= registers(to_integer(signed(rt)));
	--	if rw = '1' then
	--		registers(to_integer(signed(rd))) <= writeData;
	--	end if;
	--end process;
	
end RFARCHITECTURE;
