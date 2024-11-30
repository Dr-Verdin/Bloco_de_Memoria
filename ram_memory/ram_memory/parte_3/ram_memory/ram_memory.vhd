library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Definição da entidade ram_memory
entity ram_memory is
    Port ( 
        SW      : in  STD_LOGIC_VECTOR(9 downto 0);  -- Interruptores para endereço, dados e controle
        KEY     : in  STD_LOGIC_VECTOR(0 downto 0);  -- Tecla para clock
        HEX0    : out STD_LOGIC_VECTOR(6 downto 0);  -- 7 segmentos para dados lidos
        HEX2    : out STD_LOGIC_VECTOR(6 downto 0);  -- 7 segmentos para dados de entrada
        HEX4    : out STD_LOGIC_VECTOR(6 downto 0);  -- 7 segmentos para endereço (parte baixa)
        HEX5    : out STD_LOGIC_VECTOR(6 downto 0)   -- 7 segmentos para endereço (parte alta)
    );
end ram_memory;

-- Arquitetura do comportamento da ram_memory
architecture Behavioral of ram_memory is
    -- Definição de um array de memória 32 x 4
    TYPE mem IS ARRAY(0 TO 31) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL memory_array : mem := (others => (others => '0'));  -- Inicializa a memória com zero

    -- Sinais para entrada e saída
    signal data_in  : STD_LOGIC_VECTOR(3 downto 0);  -- Dados a serem escritos
    signal address  : STD_LOGIC_VECTOR(4 downto 0);  -- Endereço
    signal write_en : STD_LOGIC;                     -- Habilitação de escrita
    signal clk      : STD_LOGIC;                     -- Sinal de clock
    signal data_out : STD_LOGIC_VECTOR(3 downto 0);  -- Dados lidos da memória

    -- Função para converter binário de 4 bits para código de 7 segmentos
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
            when others => seg := "1111111";  -- Em branco
        end case;
        return seg;
    end function;

begin
    -- Conexões de entrada
    data_in  <= SW(3 downto 0);       -- SW3−0 para entrada de dados
    address  <= SW(8 downto 4);       -- SW8−4 para entrada de endereço
    write_en <= SW(9);                -- SW9 como habilitação de escrita
    clk      <= KEY(0);               -- KEY0 como entrada de clock

    -- Processo de escrita na RAM (síncrono com o clock)
    process(clk)
    begin
        if rising_edge(clk) then
            if write_en = '1' then
                memory_array(to_integer(unsigned(address))) <= data_in; -- Escreve dados na memória
            end if;
            -- Lê dados da memória
            data_out <= memory_array(to_integer(unsigned(address)));
        end if;
    end process;

    -- Exibe o bit alto do endereço em HEX5 (0 ou 1)
    HEX5 <= bin_to_7seg("000" & address(4));

    -- Exibe os 4 bits baixos do endereço em HEX4
    HEX4 <= bin_to_7seg(address(3 downto 0));

    -- Exibe os dados de entrada em HEX2
    HEX2 <= bin_to_7seg(data_in);

    -- Exibe os dados de saída da memória em HEX0
    HEX0 <= bin_to_7seg(data_out);

end Behavioral;

