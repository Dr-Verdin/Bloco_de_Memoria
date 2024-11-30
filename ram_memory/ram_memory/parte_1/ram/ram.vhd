library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ram is
    Port (
        address : IN STD_LOGIC_VECTOR (4 DOWNTO 0);  -- 5-bit address for 32 words
        clock : IN STD_LOGIC;                         -- Clock input
        data : IN STD_LOGIC_VECTOR (3 DOWNTO 0);     -- 4-bit data input
        wren : IN STD_LOGIC;                          -- Write enable
        q : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)        -- 4-bit data output
    );
end ram;

architecture Behavioral of ram is

    -- Declaration of the RAM component
    component ram32x4
        Port (
            address : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
            clock : IN STD_LOGIC;
            data : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            wren : IN STD_LOGIC;
            q : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
        );
    end component;

begin

    -- Instantiate the RAM module
    ram_instance : ram32x4
        Port Map (
            address => address,
            clock => clock,
            data => data,
            wren => wren,
            q => q
        );

end Behavioral;
