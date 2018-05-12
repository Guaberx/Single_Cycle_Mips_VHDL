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
		
		
		
		
		
		
		SalidaALU : out std_logic_vector((dataWidth-1) downto 0);
		SalidaROM : out std_logic_vector((dataWidth-1) downto 0);
		SalidaRAM : out std_logic_vector((dataWidth-1) downto 0);
		SalidaRF1 : out std_logic_vector((dataWidth-1) downto 0);
		SalidaRF2 : out std_logic_vector((dataWidth-1) downto 0);
		SalidaPC : out natural range 0 to 2**ADDR_WIDTH - 1;
		SalidaInmediato : out std_logic_vector(15 downto 0);
		SalidaInmediatoExtendido : out std_logic_vector((dataWidth-1) downto 0);
		SalidaMuxRFALU : out std_logic_vector((dataWidth-1) downto 0);
		
		SalidaALUOP : out std_logic_vector(1 downto 0);
		SalidaALUControl : out std_logic_vector(1 downto 0);
		
		SalidaInstruction : out std_logic_vector((dataWidth-1) downto 0)
		
	);
end monociclo;

architecture arquiMonociclo of monociclo is
	
	--2**8=256 it means our programm can only have 256 instructions
	signal PC: natural range 0 to 2**ADDR_WIDTH - 1;
	
	signal PCAdder: natural range 0 to 2**ADDR_WIDTH - 1;
	signal branchAdder: natural range 0 to 2**ADDR_WIDTH - 1;
	
	signal rData2: std_logic_vector((dataWidth-1) downto 0);
	
	signal ALUInA: std_logic_vector((dataWidth-1) downto 0);
	signal ALUInB: std_logic_vector((dataWidth-1) downto 0);
	signal ALUresult: std_logic_vector((dataWidth-1) downto 0);
	signal ALUflag: std_logic;--ZERO
	signal ALUControlOutput: std_logic_vector(1 downto 0);
	
	signal instruction : std_logic_vector((dataWidth-1) downto 0);
	signal inm_extended : std_logic_vector((dataWidth-1) downto 0);
	signal inm_shifted : std_logic_vector((dataWidth-1) downto 0);
	
	signal rdIN : std_logic_vector(4 downto 0);
	
	signal regDST : std_logic;
	signal Jump : std_logic;
	signal Branch : std_logic;
	signal MemRead : std_logic;
	signal MemtoReg : std_logic;
	signal ALUOp : std_logic_vector(1 downto 0);--TODO REHACER ESTO BIEN!!!
	signal MemWrite : std_logic;
	signal ALUSrc : std_logic;
	signal RegWrite : std_logic;
		
	signal dataMemOut : std_logic_vector((dataWidth-1) downto 0);
	signal resultMux : std_logic_vector((dataWidth-1) downto 0);
	
	signal pcSrcMuxResult : natural range 0 to 2**ADDR_WIDTH - 1;--Maximo 256 instrucciones
	signal branchMuxResult	 : std_logic_vector((dataWidth-1) downto 0);--Maximo 256 instrucciones
	signal branchAndZero : std_logic;
	
	signal JumpExtended : std_logic_vector((dataWidth-1) downto 0);
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
	SalidaALUOP <= ALUOp;
	SalidaALUControl <= ALUControlOutput;
	SalidaInstruction <= instruction;








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
	
	with branchAndZero select branchMuxResult <=
		std_logic_vector(to_unsigned(PCAdder,dataWidth)) when '0',
		std_logic_vector(to_unsigned(branchAdder,dataWidth)) when '1',
		x"00000000" when others;
	
	
	
	-- Multiplexor BranchAdder -> PC
	--JumpExtended <= RESIZE( instruction(25 downto 0) ,dataWidth);---------------------- POR VER!!!!!!!
	with Jump select pcSrcMuxResult <=
		to_integer(unsigned(branchMuxResult)) when '0',
		to_integer(unsigned(JumpExtended)) when '1',
		0 when others;
	
		
	
	-- Instruction Memory
	pmInstructionMem: work.instructionMemory
	port map 
	(
		clkI => clk,
		addr => PC,
		q => instruction
	);
		
	-- Multiplexor InstructionMemory -> RF
	
	with regDST select rdIN <=
		instruction(20 downto 16) when '0',
		instruction(15 downto 11) when '1',
		"00000" when others;
	
	

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
	
	
	with ALUSrc select ALUInB <=
		rData2 when '0',
		inm_extended when '1',
		x"00000000" when others;
	
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
	
	
	with MemtoReg select resultMux <=
		ALUResult when '0',
		dataMemOut when '1',
		x"00000000" when others;

end arquiMonociclo;











