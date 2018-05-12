library verilog;
use verilog.vl_types.all;
entity RF_vlg_sample_tst is
    port(
        rd              : in     vl_logic_vector(4 downto 0);
        rs              : in     vl_logic_vector(4 downto 0);
        rt              : in     vl_logic_vector(4 downto 0);
        rw              : in     vl_logic;
        writeData       : in     vl_logic_vector(31 downto 0);
        sampler_tx      : out    vl_logic
    );
end RF_vlg_sample_tst;
