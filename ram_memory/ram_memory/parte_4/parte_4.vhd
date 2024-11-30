library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity parte_4 is
    Port (
        CLOCK_50 : in STD_LOGIC;               -- Clock de 50 MHz
        KEY0     : in STD_LOGIC;               -- Botão de reset
        SW       : in STD_LOGIC_VECTOR(8 downto 0); -- Switches para entrada
        HEX0     : out STD_LOGIC_VECTOR(6 downto 0); -- Display do dado de leitura
        HEX1     : out STD_LOGIC_VECTOR(6 downto 0); -- Display do dado de escrita
        HEX2     : out STD_LOGIC_VECTOR(6 downto 0); -- Parte baixa do endereço de leitura
        HEX3     : out STD_LOGIC_VECTOR(6 downto 0); -- Parte alta do endereço de leitura
        HEX4     : out STD_LOGIC_VECTOR(6 downto 0); -- Parte baixa do endereço de escrita
        HEX5     : out STD_LOGIC_VECTOR(6 downto 0)  -- Parte alta do endereço de escrita
    );
end parte_4;

architecture Behavioral of parte_4 is
    signal read_addr : STD_LOGIC_VECTOR(4 downto 0) := (others => '0'); -- Endereço de leitura (5 bits)
    signal write_addr : STD_LOGIC_VECTOR(4 downto 0); -- Endereço de escrita (5 bits)
    signal write_data : STD_LOGIC_VECTOR(3 downto 0); -- Dado de escrita (4 bits)
    signal read_data  : STD_LOGIC_VECTOR(3 downto 0); -- Dado de leitura (4 bits)
    signal T_1s       : STD_LOGIC;                    -- Sinal de um segundo
    signal wren       : STD_LOGIC := '0';             -- Sinal de habilitação de escrita

    -- Instanciação da memória RAM dual-port
    component ram32x4
        port (
            clock     : in  STD_LOGIC;
            data      : in  STD_LOGIC_VECTOR (3 downto 0); -- Dados de escrita
            rdaddress : in  STD_LOGIC_VECTOR (4 downto 0); -- Endereço de leitura
            wraddress : in  STD_LOGIC_VECTOR (4 downto 0); -- Endereço de escrita
            wren      : in  STD_LOGIC;                    -- Habilitação de escrita
            q         : out STD_LOGIC_VECTOR (3 downto 0)  -- Dados lidos
        );
    end component;

    -- Componente para temporizador de 1 segundo
    component contador_um_segundo
        Port (
            Clk : in  STD_LOGIC;
            T   : out STD_LOGIC
        );
    end component;

    -- Componente para display de 7 segmentos
    component display
        Port (
            binary_in : in  STD_LOGIC_VECTOR (3 downto 0);
            seg       : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component;

begin
    -- Instanciação do temporizador de 1 segundo
    U1: contador_um_segundo
        Port map (
            Clk => CLOCK_50,
            T   => T_1s
        );

    -- Contador de endereço de leitura, incrementando a cada segundo
    process(T_1s, KEY0)
    begin
        if KEY0 = '1' then
            read_addr <= (others => '0'); -- Reset do endereço de leitura
        elsif rising_edge(T_1s) then
                if read_addr = "11111" then -- Se o endereço de leitura for 31 (máximo)
                    read_addr <= (others => '0'); -- Reinicia o contador
                else
                    read_addr <= std_logic_vector(unsigned(read_addr) + 1); -- Incrementa o endereço
                end if;
        end if;
    end process;

    -- Configura os sinais de endereço e dado de escrita a partir dos switches
    write_addr <= SW(8 downto 4); -- Endereço de escrita (5 bits)
    write_data <= SW(3 downto 0); -- Dado de escrita (4 bits)
    wren       <= '1' when T_1s = '1' else '0'; -- Ativa a escrita a cada segundo
	 

    -- Instancia a RAM dual-port
    U2: ram32x4
        Port map (
            clock     => CLOCK_50,
            data      => write_data,
            rdaddress => read_addr,
            wraddress => write_addr,
            wren      => wren,
            q         => read_data
        );

    -- Exibição do dado lido e do endereço de leitura no display de 7 segmentos
    U3: display Port map (binary_in => read_data, seg => HEX0); -- Display do dado lido
    U4: display Port map (binary_in => write_data, seg => HEX1); -- Display do dado de escrita
    U5: display Port map (binary_in => read_addr(3 downto 0), seg => HEX2); -- Parte baixa do endereço de leitura
    U6: display Port map (binary_in => "000" & read_addr(4), seg => HEX3); -- Parte alta do endereço de leitura
    U7: display Port map (binary_in => write_addr(3 downto 0), seg => HEX4); -- Parte baixa do endereço de escrita
    U8: display Port map (binary_in => "000" & write_addr(4), seg => HEX5); -- Parte alta do endereço de escrita

end Behavioral;

