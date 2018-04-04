library ieee;

use ieee.std_logic_1164.all;
use work.muxes.all;

entity myMux is 
	generic (
		W : natural := 32;
		N : natural := 2
	);
	port (
		Selector : in natural range 0 to N - 1;
		Values	: in mux_32(0 to N - 1)((W - 1) downto 0);
		DataOut	: out std_logic_vector((W -1) downto 0)
	);
end myMux;

architecture behavior of myMux is
begin
	DataOut <= Values(Selector);
end behavior;