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

		regDST : out std_logic_vector(1 downto 0);
	   Jump : out std_logic_vector(1 downto 0);
	   Branch : out std_logic_vector(1 downto 0);
		MemRead : out std_logic;
		MemtoReg : out std_logic_vector(1 downto 0);
		ALUOp : out std_logic;
		MemWrite : out std_logic;
		ALUSrc :out std_logic_vector(1 downto 0);
		RegWrite : out std_logic

	);
	
end entity;

architecture ControlUnitArchitecture of controlUnity is
type MicroMemory is array(0 to 2**ADDR_WIDTH -1) of std_logic_vector(dataWidth downto 0);

begin


end ControlUnitArchitecture;