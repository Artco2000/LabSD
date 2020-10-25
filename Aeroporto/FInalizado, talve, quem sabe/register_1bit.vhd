library ieee;
use ieee.std_logic_1164.all;

entity register_1bit is
	port
		(
		wr, data_in, clr, clk : in  std_logic;
		data_out         : out std_logic		
		);
end register_1bit;

architecture rtl of register_1bit is

begin
	process(clk, clr)
	variable memory : std_logic := '0';
	begin
		if (clr = '1') then
			memory := '0';
		elsif(rising_edge(clk)) then
			if(wr = '1') then
				memory := data_in;
			end if;
		end if;
		data_out <= memory;
	end process;

end rtl;
