-- Quartus II VHDL Template
-- Single port RAM with single read/write address 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dataMemory is

	generic 
	(
		DATA_WIDTH : natural := 32;
		ADDR_WIDTH : natural := 5
	);

	port 
	(
		clk2			: in std_logic;
		addr			: in signed((2**ADDR_WIDTH -1) downto 0);
		writeData	: in signed((DATA_WIDTH-1) downto 0);
		re				: in std_logic;
		we				: in std_logic;
		readData		: out signed((DATA_WIDTH -1) downto 0)
	);

end entity;

architecture rtl of dataMemory is

	-- Build a 2-D array type for the RAM
	subtype word_t is signed((DATA_WIDTH-1) downto 0);
	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

	-- Declare the RAM signal.	
	signal ram : memory_t;

	-- Register to hold the address 
	signal addr_reg : signed((2**ADDR_WIDTH -1) downto 0);
	
begin

	process(clk2)
	begin
	if(rising_edge(clk2)) then
		if(we = '1') then
			ram(to_integer(addr)) <= writeData;
		end if;

		-- Register the address for reading
		addr_reg <= addr;
		
		if(re = '1') then
			readData <= ram(to_integer(addr_reg));
		end if;
	end if;
	end process;
	
end rtl;
