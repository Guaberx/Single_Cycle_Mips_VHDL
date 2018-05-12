library verilog;
use verilog.vl_types.all;
entity RF is
    port(
        rs              : in     vl_logic_vector(4 downto 0);
        rt              : in     vl_logic_vector(4 downto 0);
        rd              : in     vl_logic_vector(4 downto 0);
        writeData       : in     vl_logic_vector(31 downto 0);
        rw              : in     vl_logic;
        readData1       : out    vl_logic_vector(31 downto 0);
        readData2       : out    vl_logic_vector(31 downto 0)
    );
end RF;
