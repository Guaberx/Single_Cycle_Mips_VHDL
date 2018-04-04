library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_extend is
	port
	(
		-- Input ports
		a	: in  std_logic_vector(15 downto 0);

		-- Output ports
		b	: out std_logic_vector(31 downto 0)
	);
end sign_extend;

architecture behavior of sign_extend is

begin
	b <= std_logic_vector(resize(signed(a), b'length));
end behavior;

