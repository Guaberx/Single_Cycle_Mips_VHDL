library verilog;
use verilog.vl_types.all;
entity monociclo_vlg_check_tst is
    port(
        SalidaALU       : in     vl_logic_vector(31 downto 0);
        SalidaALUControl: in     vl_logic_vector(1 downto 0);
        SalidaALUOP     : in     vl_logic_vector(1 downto 0);
        SalidaInmediato : in     vl_logic_vector(15 downto 0);
        SalidaInmediatoExtendido: in     vl_logic_vector(31 downto 0);
        SalidaInstruction: in     vl_logic_vector(31 downto 0);
        SalidaMuxRFALU  : in     vl_logic_vector(31 downto 0);
        SalidaPC        : in     vl_logic_vector(7 downto 0);
        SalidaRAM       : in     vl_logic_vector(31 downto 0);
        SalidaRF1       : in     vl_logic_vector(31 downto 0);
        SalidaRF2       : in     vl_logic_vector(31 downto 0);
        SalidaROM       : in     vl_logic_vector(31 downto 0);
        sampler_rx      : in     vl_logic
    );
end monociclo_vlg_check_tst;
