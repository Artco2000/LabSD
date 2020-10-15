-- Quartus II VHDL Template
-- Binary Counter

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is

	generic
	(
		MIN_COUNT : natural := 0;
		MAX_COUNT : in natural := 255
	);

	port
	(
		clk		 : in std_logic;
		reset	    : in std_logic;
		enable	 : in std_logic;
		done      : out boolean;
		q		    : out integer range MIN_COUNT to MAX_COUNT
	);

end entity;

architecture rtl of counter is
begin

	process (clk)
		variable   cnt		   : integer range MIN_COUNT to MAX_COUNT;
	begin
		if (rising_edge(clk)) then

			if reset = '1' then
				-- Reset the counter to 0
				cnt := 0;

			elsif enable = '1' then
				-- Increment the counter if counting is enabled			   
				cnt := cnt + 1;

			end if;
		end if;

		-- Output the current count
		q <= cnt;
		
		-- Output when done counting
		if (cnt = MAX_COUNT) then done <= true;
		else done <= false;
		end if;
		
	end process;

end rtl;
