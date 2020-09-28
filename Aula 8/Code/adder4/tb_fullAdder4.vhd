library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_fullAdder4 is
end tb_fullAdder4;

architecture teste of tb_fullAdder4 is

component fullAdder4 is
    port ( Cin_in     : in  std_logic;
           x_in, y_in : in  std_logic_vector(3 downto 0);
           s_out      : out std_logic_vector(3 downto 0);
           Cout_out   : out std_logic
        );
end component;

signal X, Y, S   : std_logic_vector(3 downto 0);
signal CIN, COUT : std_logic;

begin
instancia_fullAdder4: fullAdder4 port map(x_in => X, y_in => Y, Cin_in => CIN, Cout_out => COUT, s_out => S);

X <= x"0", x"3" after 20 ns, x"2" after 40 ns, x"4" after 60 ns, x"8" after 70 ns;
Y <= x"0", x"4" after 10 ns, x"3" after 30 ns, x"1" after 50 ns, x"7" after 70 ns;
CIN <= '0', '1' after 10 ns, '0' after 20 ns, '1' after 30 ns, '0' after 40 ns, '1' after 50 ns, '0' after 60 ns, '1' after 70 ns;

end teste;