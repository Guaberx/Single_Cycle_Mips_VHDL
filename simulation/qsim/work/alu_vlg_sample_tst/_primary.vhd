library verilog;
use verilog.vl_types.all;
entity alu_vlg_sample_tst is
    port(
        inputA          : in     vl_logic_vector(31 downto 0);
        inputB          : in     vl_logic_vector(31 downto 0);
        inputControl    : in     vl_logic_vector(1 downto 0);
        sampler_tx      : out    vl_logic
    );
end alu_vlg_sample_tst;
