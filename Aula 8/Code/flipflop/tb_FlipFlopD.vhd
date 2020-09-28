library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_FlipFlopD is
end tb_FlipFlopD;

architecture teste of tb_FlipFlopD is
	component FlipFlopD is
		port( 
			clock: in std_logic;
			D:     in std_logic;
			Q:     out std_logic
	    );
	end component;

	constant period : time := 20 ns;
	signal d, q : std_logic;
	signal clk :std_logic := '0';
	signal clk_enable: std_logic := '1';

	begin
	instancia_FlipFlopD: FlipFlopD port map(clock=>clk, D=>d, Q=>q);
	
	-- geracao do relogio com periodo PERIOD
	clk <= clk_enable and not clk after period/2;
	
	-- tests
	stimulus : process 
	begin

		d <= '0'; 
		wait for period;
		
		d <= '1';
		wait for 2*period;
		
		d <= '1';
		wait for period;
		
		d <= '0';
		wait for 2*period;
		
		clk_enable <= '0';
		wait;
	end process stimulus;
	
	

end teste;