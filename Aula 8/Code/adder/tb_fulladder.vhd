library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_fulladder is
end tb_fulladder;

architecture teste of tb_fulladder is

component fulladder is
port 
	(
		x, y, Cin  : in std_logic;
		s, Cout : out std_logic
	);
end component;

signal X, Y, CIN, COUT, S: std_logic;

begin
instancia_fulladder: fulladder port map(x => X, y => Y, Cin => CIN, Cout => COUT, s => S);

X <=   '0', '1' after 40 ns;
Y <=   '0', '1' after 20 ns, '0' after 40 ns, '1' after 60 ns;
CIN <= '0', '1' after 10 ns, '0' after 20 ns, '1' after 30 ns, '0' after 40 ns, '1' after 50 ns, '0' after 60 ns, '1' after 70 ns; 
end teste;