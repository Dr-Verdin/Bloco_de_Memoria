library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
  --O propósito do sinal enable é permitir ou ativar a operação de outros módulos ou circuitos. 
  --Por exemplo, ele pode ser usado para habilitar um contador, iniciar uma operação,ou acionar um componente em um sistema.
  --Como enable está sinalizando ou controlando a operação de outros módulos, 
  --ele precisa ser uma saída para que essas outras partes do sistema possam receber o sinal de controle.
entity contador_um_segundo is 
	port(
	Clk : in std_logic;
	T : out std_logic
	);
end contador_um_segundo;

architecture behavior of contador_um_segundo is
    signal count : unsigned(30 downto 0) := (others => '0');
	   --como um ciclo dura 50MHz e cada  bit pode ter 2 valores possíveis - 0 ou 1 - é necessario ter uma
	   --quantidade de bits que possa representar pelo menos 50.000.000 de valores.
	   --2^1bit = 2 valores;
	   --2^2bits = 4 valores;
	   --...
	   --2^25 = 33.554.432 valores;
	   --2^26 = 67.108.864 valores;
begin
	process(Clk)
	begin
		if rising_edge(Clk) then
			if count = 49999999 then --como irá começar a contar a partir do 0 e estamos usando um vetor que começa na posição 0, então, se faz 5000000 - 1
				count <= (others => '0');
				T <= '1';
			else
				count <= count + 1;
				T <= '0';
			end if;
		end if;
	end process;
end behavior;
