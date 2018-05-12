library verilog;
use verilog.vl_types.all;
entity RF_vlg_check_tst is
    port(
        readData1       : in     vl_logic_vector(31 downto 0);
        readData2       : in     vl_logic_vector(31 downto 0);
        sampler_rx      : in     vl_logic
    );
end RF_vlg_check_tst;
