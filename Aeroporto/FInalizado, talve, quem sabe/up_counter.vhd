library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity up_counter is
	generic 
		( max_bits : natural := 8);

	port
		(
		inc, clr, clk : in  std_logic;
		output        : out std_logic_vector((max_bits - 1) downto 0)
		);
		
end up_counter;

architecture rtl of up_counter is

begin
	process(clk, clr)
		variable num :integer := 0;
	begin
		if(clr = '1') then
			num := 0;
		elsif(rising_edge(clk)) then
			if(inc = '1') then
				num := num + 1;
			end if;
		end if;
		output <= std_logic_vector(to_unsigned(num, max_bits));
	end process;

end rtl;