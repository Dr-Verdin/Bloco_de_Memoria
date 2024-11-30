library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  -- Use this package for proper type conversions

entity RAM_fpga is
    Port ( 
        SW      : in  STD_LOGIC_VECTOR(9 downto 0);  -- Switches
        KEY     : in  STD_LOGIC_VECTOR(0 downto 0);  -- Key para o clock
        HEX0    : out STD_LOGIC_VECTOR(6 downto 0);  -- 7-segment para read data
        HEX2    : out STD_LOGIC_VECTOR(6 downto 0);  -- 7-segment para o input data
        HEX4    : out STD_LOGIC_VECTOR(6 downto 0);  -- 7-segment para o address (low)
        HEX5    : out STD_LOGIC_VECTOR(6 downto 0)   -- 7-segment para o address (high)
    );
end RAM_fpga;

architecture Behavioral of RAM_fpga is

    signal data_in  : STD_LOGIC_VECTOR(3 downto 0);  -- Data to be written
    signal address  : STD_LOGIC_VECTOR(4 downto 0);  -- Address
    signal write_en : STD_LOGIC;                     -- Write enable
    signal clk      : STD_LOGIC;                     -- Clock
    signal data_out : STD_LOGIC_VECTOR(3 downto 0);  -- Data read da memory

    -- Assuming ram32x4 does not use clk and we
    component ram32x4
        Port ( 
           address		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			  clock		: IN STD_LOGIC  := '1';
		     data		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		     wren		: IN STD_LOGIC ;
		     q		: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
        );
    end component;

    -- função para converter os segmentos 4 binary para 7 segmentos
    function bin_to_7seg(bin : STD_LOGIC_VECTOR(3 downto 0)) return STD_LOGIC_VECTOR is
        variable seg : STD_LOGIC_VECTOR(6 downto 0);
    begin
        case bin is
            when "0000" => seg := "1000000";  -- 0
				when "0001" => seg := "1111001";  -- 1
				when "0010" => seg := "0100100";  -- 2
				when "0011" => seg := "0110000";  -- 3
				when "0100" => seg := "0011001";  -- 4
				when "0101" => seg := "0010010";  -- 5
				when "0110" => seg := "0000010";  -- 6
				when "0111" => seg := "1111000";  -- 7
				when "1000" => seg := "0000000";  -- 8
				when "1001" => seg := "0010000";  -- 9
				when "1010" => seg := "0001000";  -- A
				when "1011" => seg := "0000011";  -- B
				when "1100" => seg := "1000110";  -- C
				when "1101" => seg := "0100001";  -- D
				when "1110" => seg := "0000110";  -- E
				when "1111" => seg := "0001110";  -- F
				when others => seg := "1111111";  -- Blank (default case)
        end case;
        return seg;
    end function;

begin

    -- Input connections
    data_in  <= SW(3 downto 0);      -- SW3−0 para data input
    address  <= SW(8 downto 4);      -- SW8−4 para address input
    write_en <= SW(9);               -- SW9 como write enable
    clk      <= KEY(0);              -- KEY0 como clock input

    -- RAM instantiation (without clk and we)
    ram_instance : ram32x4
        Port map (
            address => address,
            data    => data_in,
            q       => data_out,
				clock => clk,
				wren => write_en
        );

    -- Display the high bit of address on HEX5 (either 0 or 1)
    HEX5 <= bin_to_7seg("000" & address(4));

    -- Display the lower 4 bits of the address on HEX4
    HEX4 <= bin_to_7seg(address(3 downto 0));

    -- Display the input data on HEX2
    HEX2 <= bin_to_7seg(data_in);

    -- Display the output data from memory on HEX0
    HEX0 <= bin_to_7seg(data_out);

end Behavioral;





