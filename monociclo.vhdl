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
		clk	: in  std_logic;
		SalidaALU : out signed((dataWidth-1) downto 0);
		SalidaROM : out std_logic_vector((dataWidth-1) downto 0);
		SalidaRAM : out signed((dataWidth-1) downto 0);
		SalidaRF1 : out signed((dataWidth-1) downto 0);
		SalidaRF2 : out signed((dataWidth-1) downto 0);
		SalidaPC : out natural range 0 to 2**ADDR_WIDTH - 1;
		SalidaInmediato : out std_logic_vector(15 downto 0);
		SalidaInmediatoExtendido : out std_logic_vector((dataWidth-1) downto 0);
		SalidaMuxRFALU : out signed((dataWidth-1) downto 0)
		
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
	signal ALUControlOutput: std_logic_vector(1 downto 0);
	
	signal instruction : std_logic_vector((dataWidth-1) downto 0);
	signal inm_extended : std_logic_vector((dataWidth-1) downto 0);
	signal inm_shifted : std_logic_vector((dataWidth-1) downto 0);
	
	signal rdIN : std_logic_vector((registerWidth-1) downto 0);
	
	signal regDST : std_logic_vector(0 downto 0);
	signal Jump : std_logic_vector(0 downto 0);
	signal Branch : std_logic_vector(0 downto 0);
	signal MemRead : std_logic;
	signal MemtoReg : std_logic_vector(0 downto 0);
	signal ALUOp : std_logic_vector(1 downto 0);--TODO REHACER ESTO BIEN!!!
	signal MemWrite : std_logic;
	signal ALUSrc : std_logic_vector(0 downto 0);
	signal RegWrite : std_logic;
		
	signal dataMemOut : signed((dataWidth-1) downto 0);
	signal resultMux : signed((dataWidth-1) downto 0);
	
	signal pcSrcMuxResult : natural range 0 to 2**ADDR_WIDTH - 1;--Maximo 256 instrucciones
	signal branchMuxResult	 : std_logic_vector((dataWidth-1) downto 0);--Maximo 256 instrucciones
	signal branchAndZero : std_logic_vector(1 downto 0);
begin


	SalidaALU <= ALUresult;
	SalidaROM <= instruction;
	SalidaRAM <= dataMemOut;
	SalidaRF1 <= ALUInA;
	SalidaRF2 <= rData2;
	SalidaPC <= PC;
	SalidaInmediato <= instruction(15 downto 0);
	SalidaInmediatoExtendido <= inm_extended;
	SalidaMuxRFALU <= ALUInB;








	process(clk, PC)
	begin
		--if(falling_edge(clk)) then
		if(rising_edge(clk)) then
			PC <= pcSrcMuxResult;
		end if;
	end process;
	
	PCAdder <= PC + 1;
	branchAdder <= PCAdder + to_integer(shift_left(unsigned(inm_extended), 2));
	branchAndZero <= Branch AND ALUflag;
	
	
	
	-- Control Unity
	pmControlUnity: work.ControlUnity
	port map 
	(
		OP => instruction(31 downto 26),
		OutregDST => regDST,
		OutJump => Jump,
		OutBranch => Branch,
		OutMemRead => MemRead,
		OutMemtoReg => MemtoReg,
		OutALUOp => ALUOp,
		OutMemWrite => MemWrite,
		OutALUSrc => ALUSrc,
		OutRegWrite => RegWrite
	);
	
	
	
	--Multiplexor BranchAdder -> PC
	MUX_Branch: work.myMux 
	generic map
	(
		W => dataWidth,
		N => 2
	)
	port map 
	(
		Selector => to_integer(unsigned(branchAndZero)),
		Values(0) => std_logic_vector(to_unsigned(PCAdder,dataWidth)),
		Values(1) => std_logic_vector(to_unsigned(branchAdder,dataWidth)),
		DataOut => branchMuxResult
	);
	
	--case branchAndZero is
	--	when "00" =>
	--		branchMuxResult <= PCAdder;
	--	when "01" =>
	--		branchMuxResult <= branchAdder;
	--	when others =>
	--		branchMuxResult <= x"00000000";
	--end case;
	
	
	-- Multiplexor BranchAdder -> PC
	MUX_PCSrc: work.myMux 
	generic map
	(
		W => dataWidth,
		N => 2
	)
	port map 
	(
		Selector => to_integer(unsigned(Jump)),
		Values(0) => branchMuxResult,
		Values(1) => std_logic_vector(to_unsigned(PCAdder,dataWidth)),
		to_integer(unsigned(DataOut)) => pcSrcMuxResult
	);
	
	
	-- Instruction Memory
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
		Selector => to_integer(unsigned(regDST)),
		Values(0) => instruction(20 downto 16),
		Values(1) => instruction(15 downto 11),
		DataOut => rdIN
	);
	
	-- Register File
	pmRF: work.RF
	port map 
	(
		rs => instruction(25 downto 21),
		rt => instruction(20 downto 16),
		rd => rdIN,
		
		writeData => resultMux,
		rw => RegWrite,
		
		readData1 => ALUInA,
		readData2 => rData2
	);
	
	-- Multiplexor RF -> ALU
	--MUX_rd_instruction_15_0_to_ALUInB: work.myMux 
	--generic map
	--(
	--	W => dataWidth,
	--	N => 2
	--)
	--port map 
	--(
	--	Selector => to_integer(unsigned(aluSrc)),
	--	Values(0) => std_logic_vector(rData2),
	--	Values(1) => std_logic_vector(inm_extended),
	--	signed(DataOut) => ALUInB
	--);
	
	with ALUSrc select ALUInB <=
		rData2 when "0",
		signed(inm_extended) when "1";
	
	--Sign Extended
	pmSignExtendI: work.sign_extend
	port map 
	(
		a => instruction(15 downto 0),
		b => inm_extended
	);
	
	
	--ALUControl
	pmALUControl: work.ALUControl
	port map 
	(
		InALUOp => ALUOp,
		InInstruction => instruction(5 downto 0),
		Output => ALUControlOutput		
	);
	
	
	
	--ALU
	pmALU: work.alu
	port map 
	(
		inputControl => ALUControlOutput,
		inputA => ALUInA,
		inputB => ALUInB,
		output => ALUresult,
		flag => ALUflag -- "Zero"
	);
	
	--Data Memory
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
		Selector => to_integer(unsigned(MemtoReg)),
		Values(0) => std_logic_vector(dataMemOut),
		Values(1) => std_logic_vector(ALUresult),
		signed(DataOut) => resultMux -- REVISAR: Si cambias este por "open" se visualiza mejor en el rtl view
	);

end arquiMonociclo;











