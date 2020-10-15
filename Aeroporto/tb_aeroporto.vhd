library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_aeroporto is
end entity tb_aeroporto;

architecture teste of tb_aeroporto is

component aeroporto is
	generic (
		clkFrequence : natural := 50;
		tempoP : natural := 4;
		tempoD : natural := 3
	);
	port(
		clk         : in std_logic;
		checkM      : in std_logic;
		reset       : in std_logic;
		tempoEstado : in natural;
		problema    : in std_logic;
		tProblema   : in natural;
		alarme      : out std_logic;
		s           : out std_logic_vector(2 downto 0)
	);
end component aeroporto;

signal checkM, reset, problema, alarme : std_logic;
signal tempoEstado, tProblema : natural;

constant period : time := 20 ns;
signal clk : std_logic := '0';
signal clk_enable: std_logic := '1';

signal 		s          : std_logic_vector(2 downto 0);
begin
UUT: aeroporto port map(clk, checkM, reset, tempoEstado, problema, tProblema, alarme, s);

clk <= clk_enable and not clk after period/2;

stimulus : process 
	begin
		tempoEstado <= 10;
		tProblema <= 5;
		checkM <= '1';
		
		wait until alarme = '1';
			
		--wait for 200ns;
end process stimulus;

end architecture teste;