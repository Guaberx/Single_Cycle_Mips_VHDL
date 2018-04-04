-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity monociclo is
	generic
	(
		dataWidth	: integer  :=	32;
		ADDR_WIDTH : natural := 8;
		registerWidth : natural := 5
	);
	port
	(
		-- Input ports
		clk	: in  std_logic
		
	);
end monociclo;

architecture arquiMonociclo of monociclo is
	
	--2**8=256 it means our programm can only have 256 instructions
	signal PC: natural range 0 to 2**ADDR_WIDTH - 1;
	
	signal PCAdder: natural range 0 to 2**ADDR_WIDTH - 1;
	signal branchAdder: natural range 0 to 2**ADDR_WIDTH - 1;
	
	signal rData2: signed((dataWidth-1) downto 0);
	
	signal ALUInA: signed((dataWidth-1) downto 0);
	signal ALUInB: signed((dataWidth-1) downto 0);
	signal ALUresult: signed((dataWidth-1) downto 0);
	signal ALUflag: std_logic_vector(1 downto 0);--ZERO
	signal inputControlM: std_logic_vector(1 downto 0);
	
	signal instruction : std_logic_vector((dataWidth-1) downto 0);
	signal inm_extended : std_logic_vector((dataWidth-1) downto 0);
	signal inm_shifted : std_logic_vector((dataWidth-1) downto 0);
	signal rW : std_logic;
	
	signal rdIN : std_logic_vector((registerWidth-1) downto 0);
	
	signal regDST : natural;
	signal aluSrc : natural;
	signal MemRead : std_logic;
	signal MemWrite : std_logic;
	signal MemtoReg : natural;
	signal PCMuxSelect : natural;
	
	signal dataMemOut : signed((dataWidth-1) downto 0);
	signal resultMux : signed((dataWidth-1) downto 0);
	
	signal pcSrcMuxResult : natural range 0 to 2**ADDR_WIDTH - 1;
	

begin
	process(clk, PC)
	begin
		if(falling_edge(clk)) then
			PC <= pcSrcMuxResult;
		end if;
	end process;
	
	PCAdder <= PC + 4;
	branchAdder <= PCAdder + to_integer(shift_left(unsigned(inm_extended), 2));
	
	-- Multiplexor BranchAdder -> PC
	MUX_PCSrc: work.myMux 
	generic map
	(
		W => dataWidth,
		N => 2
	)
	port map 
	(
		Selector => regDST,
		Values(0) => std_logic_vector(to_unsigned(PCAdder,dataWidth)),
		Values(1) => std_logic_vector(to_unsigned(branchAdder,dataWidth)),
		to_integer(unsigned(DataOut)) => pcSrcMuxResult
	);
	
	
	
	pmInstructionMem: work.instructionMemory
	port map 
	(
		clkI => clk,
		addr => PC,
		q => instruction
	);
		
	-- Multiplexor InstructionMemory -> RF
	MUX_RD_RT_to_RF_writeregister: work.myMux 
	generic map
	(
		W => 5,
		N => 2
	)
	port map 
	(
		Selector => regDST,
		Values(0) => instruction(20 downto 16),
		Values(1) => instruction(15 downto 11),
		DataOut => rdIN
	);
	
	pmRF: work.RF
	port map 
	(
		rs => instruction(25 downto 21),
		rt => instruction(20 downto 16),
		rd => rdIN,
		
		writeData => resultMux,
		regWrite => rW,
		
		readData1 => ALUInA,
		readData2 => rData2
	);
	
	-- Multiplexor RF -> ALU
	MUX_rd_instruction_15_0_to_ALUInB: work.myMux 
	generic map
	(
		W => dataWidth,
		N => 2
	)
	port map 
	(
		Selector => aluSrc,
		Values(0) => std_logic_vector(rData2),
		Values(1) => std_logic_vector(inm_extended),
		signed(DataOut) => ALUInB
	);
	
	pmSignExtendI: work.sign_extend
	port map 
	(
		a => instruction(15 downto 0),
		b => inm_extended
	);

	pmALU: work.alu
	port map 
	(
		inputA => ALUInA,
		inputB => ALUInB,
		output => ALUresult,
		flag => ALUflag, -- "Zero"
		inputControl => inputControlM
	);
	
	pmDataMemory: work.dataMemory
	port map 
	(
		clk2 => clk,
		addr => ALUresult,
		writeData => rData2,
		re => MemRead,
		we => MemWrite,
		readData => dataMemOut
	);
	
	-- Multiplexor DataMemory -> RF
	MUX_readData_ALUresult_to_writeData: work.myMux 
	generic map
	(
		W => dataWidth,
		N => 2
	)
	port map 
	(
		Selector => memtoReg,
		Values(0) => std_logic_vector(dataMemOut),
		Values(1) => std_logic_vector(ALUresult),
		signed(DataOut) => resultMux -- REVISAR: Si cambias este por "open" se visualiza mejor en el rtl view
	);

end arquiMonociclo;











