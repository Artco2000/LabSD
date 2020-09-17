library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_pseudo_mux is
end tb_pseudo_mux;

architecture teste of tb_pseudo_mux is
	component pseudo_mux is
		port (
        RESET   : in    std_logic; -- reset input
        CLK   	 : in    std_logic; -- clock input
        S       : in    std_logic; -- control input
        A,B,C,D : in    std_logic; -- data inputs
        Q       : out   std_logic  -- data output
    );
	end component;

	constant period : time := 20 ns;
	signal reset, s, a, b, c, d, q : std_logic;
	signal clk :std_logic := '0';
	signal clk_enable: std_logic := '1';

	begin
	instancia_pseudo_mux: pseudo_mux port map(CLK=>clk, RESET=>reset, S=>s, A=>a, B=>b, C=>c, D=>d, Q=>q);
	
	-- geracao do relogio com periodo PERIOD
	clk <= clk_enable and not clk after period/2;
	
	-- tests
	stimulus : process 
	begin
		reset <= '1'; wait for period; reset <= '0';
		
		s <= '0';
		a <= '1'; 
		b <= '0'; 
		c <= '1'; 
		d <= '0'; 
		wait for period;
		
		s <= '1';
		wait for period;
		s <= '0';
		b <= '1';
		wait for period;
		
		s <= '1';
		wait for period;
		s <= '0';
		wait for 2*period;
		
		s <= '1';
		wait for 2*period;
		s <= '0';
		wait for period;
		
		s <= '1';
		wait for period;
		s <= '0';
		wait for period;
		
		s <= '1';
		wait for 2 * period;
		
		reset <= '1'; wait for period; reset <= '0';
		
		clk_enable <= '0';
		wait;
	end process stimulus;
	
	

end teste;