library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_mean_4_clocks is
	generic (W : integer := 32);
end tb_mean_4_clocks;

architecture teste of tb_mean_4_clocks is
	component mean_4_clocks is
		port 
			(
				CLK     : in    std_logic;
				RESET   : in    std_logic;
				INPUT   : in    std_logic_vector(W - 1 downto 0);
				OUTPUT  : out   std_logic_vector(W - 1 downto 0)
			);
	end component;

	constant period : time := 20 ns;
	signal input, output : std_logic_vector(W - 1 downto 0);
	signal reset : std_logic;
	signal clk :std_logic := '0';
	signal clk_enable: std_logic := '1';

	begin
	instancia_mean_4_clocks: mean_4_clocks port map(CLK=>clk, RESET=>reset, INPUT=>input, OUTPUT=>output);
	
	-- geracao do relogio com periodo PERIOD
	clk <= clk_enable and not clk after period/2;
	
	-- tests
	stimulus : process 
	begin
		reset <= '1'; wait for period; reset <= '0';
		
		input <= std_logic_vector(to_unsigned(20, w));
		wait for period;
		
		input <= std_logic_vector(to_unsigned(30, w));
		wait for period;
		
		input <= std_logic_vector(to_unsigned(50, w));
		wait for period;
		
		input <= std_logic_vector(to_unsigned(20, w));
		wait for period;
		
		input <= std_logic_vector(to_unsigned(60, w));
		wait for period;
		
		input <= std_logic_vector(to_unsigned(70, w));
		wait for period;
		
		
		reset <= '1'; wait for period; reset <= '0';
		
		clk_enable <= '0';
		wait;
	end process stimulus;
	
	

end teste;