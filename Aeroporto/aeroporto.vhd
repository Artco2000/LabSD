library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity aeroporto is
	generic (
		tempoP : time := 20ns;
		tempoD : time := 15ns
	);
	port(
		clk         : in std_logic;
		checkM      : in std_logic;
		reset       : in std_logic;
		tempoEstado : in time;
		idAviao     : in std_logic_vector(5 downto 0);
		pedido      : in std_logic;
		problema    : in std_logic;
		tProblema   : in time;
		alarme      : out std_logic
	);
end entity aeroporto;

architecture RTL of aeroporto is
	type state_type is (le, analisa, espera, chama, comunica, alerta, conta, termina);
	signal PS,NS : state_type;
begin
	--------- CLOCK PROCESS -----------
	clkProcess: process (clk, reset, NS)
	begin
		if (reset = '1') then 
			PS <= le;
		elsif (rising_edge(clk)) then
			PS <= NS;
		end if;
	end process clkProcess;

	------ STATE LOGIC PROCESS -------
	stateProcess: process(PS, idAviao, pedido, problema, checkM)
	begin
	alarme <= '0';
	case PS is 
		when le => 
			alarme <= '0';
			if (checkM = '1') then NS <= analisa;
			else NS <= termina;
			end if;
		when analisa => 
			alarme <= '0';
			if (problema = '1') then NS <= espera;
			else NS <= chama;
			end if;
		when others => 
			alarme <= '0';
			NS <= le;
	end case;
	end process stateProcess;
end architecture RTL;
































