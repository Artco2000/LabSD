library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparador4bits is
	port
		(
		a, b : in std_logic_vector(3 downto 0);
		igual, maior, menor : out std_logic
		);
end comparador4bits;

architecture arch of comparador4bits is

	begin 
	
	igual <= '1' when (a = b) else '0';
	
	menor <= '1' when (a < b) else '0';
	
	maior <= '1' when (a > b) else '0';
	
	
	
end arch;