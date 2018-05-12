library verilog;
use verilog.vl_types.all;
entity alu is
    port(
        inputControl    : in     vl_logic_vector(1 downto 0);
        inputA          : in     vl_logic_vector(31 downto 0);
        inputB          : in     vl_logic_vector(31 downto 0);
        output          : out    vl_logic_vector(31 downto 0);
        flag            : out    vl_logic_vector(1 downto 0)
    );
end alu;
