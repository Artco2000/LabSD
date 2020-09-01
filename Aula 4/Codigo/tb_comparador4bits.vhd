library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_comparador4bits is
end tb_comparador4bits;

architecture teste of tb_comparador4bits is

component comparador4bits is
port 
	(
		a	   : in std_logic_vector	(3 downto 0);
		b	   : in std_logic_vector	(3 downto 0);
		igual, maior, menor : out std_logic
	);
end component;

signal A, B: std_logic_vector(3 downto 0);
signal IGUAL, MAIOR, MENOR: std_logic;
begin
instancia_comparador: comparador4bits port map(a=>A,b=>B,igual=>IGUAL,maior=>MAIOR,menor=>MENOR);

simul: process
begin
	A <= x"0";
	B <= x"0";
	wait for 10 ns;
	assert((IGUAL = '1')and(MAIOR = '0')and(MENOR = '0')) report "Failed assert 1";
	A <= "1011";
	wait for 10 ns;
	assert((IGUAL = '0')and(MAIOR = '1')and(MENOR = '0')) report "Failed assert 2";
	B <= "1100";
	wait for 10 ns;
	assert((IGUAL = '0')and(MAIOR = '0')and(MENOR = '1')) report "Failed assert 3";
	A <= "1101";
	wait for 10 ns;
	assert((IGUAL = '0')and(MAIOR = '1')and(MENOR = '0')) report "Failed assert 4";
	A <= x"8";
	B <= x"3";
	wait for 10 ns;
	assert((IGUAL = '0')and(MAIOR = '1')and(MENOR = '0')) report "Failed assert 5";
	B <= x"8";
	wait for 10 ns;
	assert((IGUAL = '1')and(MAIOR = '0')and(MENOR = '0')) report "Failed assert 6";
	wait;
end process;

end teste;