library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity aeroporto is
	generic (
		clkFrequence : natural := 50000000;
		tempoP : natural := 20;
		tempoD : natural := 15
	);
	port(
		clk         : in std_logic;
		checkM      : in std_logic;
		reset       : in std_logic;
		tempoEstado : in natural;
		problema    : in std_logic;
		tProblema   : in natural;
		alarme      : out std_logic;
		s           : out std_logic_vector(2 downto 0)
	);
end entity aeroporto;

architecture RTL of aeroporto is

	component counter is
		generic
		(
			MIN_COUNT : natural := 0;
			MAX_COUNT : in natural := clkFrequence
		);

		port
		(
			clk		 : in std_logic;
			reset	    : in std_logic;
			enable	 : in std_logic;
			done      : out boolean;
			q		    : out integer range MIN_COUNT to MAX_COUNT
		);
	end component;

	signal countEN  : std_logic;
	signal countRST : std_logic;
	signal countOK  : boolean;
	signal countNUM : integer range 0 to 255;
	
	type state_type is (le, analisa, espera, chama, comunica, alerta, termina);
	signal PS,NS : state_type;
	signal idAviao  : std_logic_vector(6 downto 0);
	
begin

	-------------COUNTER---------------
	counter1: counter port map(clk, countRST, countEN, countOK, countNUM); 

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
	stateProcess: process(PS, idAviao, problema, checkM)
	
	variable airplaneTime : natural := 0;
	
	begin
	alarme <= '0';

	case PS is 
	---READ INPUT STATE---
		when le => 
			countRST <= '0';
			countEN <= '1';
			
			if (checkM = '1' and countNUM >= tempoEstado) then 
				NS <= analisa;			
				countEN <= '0';
				countRST <= '1';
			elsif (checkM = '0' and countNUM >= tempoEstado) then 
				NS <= termina;
				countEN <= '0';
				countRST <= '1';
			else NS <= le;
			end if;
	---CHECK PROBLEM STATE---
		when analisa => 
			countRST <= '0';
			countEN <= '1';
			
			if (problema = '1' and countNUM >= tempoEstado) then 
				NS <= espera;
				countEN <= '0';
				countRST <= '1';
			elsif (problema = '0' and countNUM >= tempoEstado) then
				NS <= termina;
				countEN <= '0';
				countRST <= '1';
			else NS <= analisa;
			end if;
	---SOLVE PROBLEM STATE---
		when espera => 
			countRST <= '0';
			countEN <= '1';
			
			if (countNUM >= tProblema and  countNUM >= tempoEstado) then 
				NS <= analisa;
				countEN <= '0';
				countRST <= '1';
			else NS <= espera;
			end if;
	---CALL AN AIRPLANE STATE---
		when chama => 
			countRST <= '0';
			countEN <= '1';
			--- READ MEMORY ---
			if (countNUM >= tempoEstado) then 
				NS <= comunica;
				countEN <= '0';
				countRST <= '1';
			else NS <= chama;
			end if;
	---COMMUNICATION STATE---
		when comunica => 
			countRST <= '0';
			countEN <= '1';
			
			--if(idAviao(6) = '1') then airplaneTime := tempoP; --IT WILL GO DOWN
			--else airplaneTime := tempoD; -- IT WILL GO UP
			--end if;
			
			if (countNUM >= tempoEstado) then 
				NS <= alerta;
				countEN <= '0';
				countRST <= '1';
			else NS <= comunica;
			end if;
	---ALERT STATE---
		when alerta => 
			alarme <= '1';
			countRST <= '0';
			countEN <= '1';
			
			if (countNUM >= tempoEstado and countNUM >= airplaneTime) then 
				NS <= termina;
				countEN <= '0';
				countRST <= '1';
			else NS <= alerta;
			end if;
		---FINAL STATE---
		when termina => NS <= termina;
		when others => 
			alarme <= '0';
			NS <= le;
	end case;
	end process stateProcess;
	
	with PS select 
		s <= "000" when le,
			"001" when analisa,
			"010" when espera,
			"011" when chama,
			"100" when comunica,
			"101" when alerta,
			"111" when termina,
			"010" when others;
end architecture RTL;
































