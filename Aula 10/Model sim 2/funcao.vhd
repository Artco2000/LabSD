LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity funcao is
	generic(r : integer := 2);
   port ( x   : in  std_logic_vector(3 downto 0);
         fx   : out std_logic_vector(9 downto 0)
        );
end funcao;

architecture RTL OF funcao is
	signal aux : unsigned(9 downto 0);
begin
	aux <= to_unsigned(r,2) * unsigned(x) * unsigned(not(x));
	fx <= std_logic_vector(aux);
end RTL ;