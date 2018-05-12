library verilog;
use verilog.vl_types.all;
entity monociclo is
    port(
        clk             : in     vl_logic;
        SalidaALU       : out    vl_logic_vector(31 downto 0);
        SalidaROM       : out    vl_logic_vector(31 downto 0);
        SalidaRAM       : out    vl_logic_vector(31 downto 0);
        SalidaRF1       : out    vl_logic_vector(31 downto 0);
        SalidaRF2       : out    vl_logic_vector(31 downto 0);
        SalidaPC        : out    vl_logic_vector(7 downto 0);
        SalidaInmediato : out    vl_logic_vector(15 downto 0);
        SalidaInmediatoExtendido: out    vl_logic_vector(31 downto 0);
        SalidaMuxRFALU  : out    vl_logic_vector(31 downto 0);
        SalidaALUOP     : out    vl_logic_vector(1 downto 0);
        SalidaALUControl: out    vl_logic_vector(1 downto 0);
        SalidaInstruction: out    vl_logic_vector(31 downto 0)
    );
end monociclo;
