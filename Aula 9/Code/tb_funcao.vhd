library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_funcao is
end tb_funcao;

architecture teste of tb_funcao is

component funcao is
    port ( x    : in  std_logic_vector(3 downto 0);
           fx   : out std_logic_vector(9 downto 0)
        );
end component;

signal X  : std_logic_vector(3 downto 0);
signal FX : std_logic_vector(9 downto 0);

begin
instancia_funcao: funcao port map(x => X, fx => FX);

X <= x"0", x"3" after 10 ns, x"f" after 20 ns, x"a" after 30 ns, x"9" after 40 ns;

end teste;