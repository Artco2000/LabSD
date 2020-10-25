library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity aeroporto is
	generic (
		clkFrequence : natural := 50000000;
		tempoP 		 : natural := 20;
		tempoD 		 : natural := 15;
		palavras     : natural := 64;
		tam_palavra  : natural := 8
	);
	port(
		clk         : in std_logic;
		--checkM      : in std_logic;
		reset       : in std_logic;
		tempoEstado : in natural;
		problema    : in std_logic;
		tProblema   : in natural;
		idAviao  	: in std_logic_vector(7 downto 0);
		insertPlane : in std_logic;
		alarme      : out std_logic;
		radioOut    : out std_logic_vector(7 downto 0);
		nAvioes     : out std_logic_vector(7 downto 0);
		s           : out std_logic_vector(2 downto 0)
	);
end entity aeroporto;

architecture RTL of aeroporto is

	component counter is
		generic
		(
			MIN_COUNT : natural := 0;
			MAX_COUNT : natural := clkFrequence
		);

		port
		(
			clk		 : in std_logic;
			reset	    : in std_logic;
			enable	 : in std_logic;
			q		    : out integer range MIN_COUNT to MAX_COUNT
		);
	end component;
	
	component smart_fifo is
		port(
			wr, rd, reset, clk : in std_logic;
			wdata              : in std_logic_vector(7 downto 0);
			empty              : out std_logic;
			busy			   	 : out std_logic;
			rdata              : out std_logic_vector(7 downto 0);
			qnt_out            : out std_logic_vector(7 downto 0)
			--s				  		 : out std_logic_vector(2 downto 0)
			);
	end component;

	signal countEN  : std_logic;
	signal countRST : std_logic;
	signal countNUM : integer range 0 to 255;
	
	type state_type is (le, analisa, espera, chama, comunica, alerta, termina, limpa);
	signal PS,NS : state_type;
	
	signal m_rd, m_wr, m_rst, m_busy, m_empty : std_logic;
	signal m_output, m_qnt : std_logic_vector(7 downto 0);
	
begin
	nAvioes <= m_qnt;

	--------INSTANTIATE MEMORY!--------
	mem : smart_fifo port map(wr => m_wr, rd => m_rd, reset => m_rst, clk => clk, wdata => idAviao, empty => m_empty, busy => m_busy, rdata => m_output, qnt_out => m_qnt);

	-------------COUNTER---------------
	counter1: counter port map(clk, countRST, countEN, countNUM); 

	--------- CLOCK PROCESS -----------
	clkProcess: process (clk, reset, NS)
	begin
		if (reset = '1') then 
			PS <= limpa;
		elsif (rising_edge(clk)) then
			PS <= NS;
		end if;
	end process clkProcess;

	------ STATE LOGIC PROCESS -------
	stateProcess: process(PS, idAviao, problema, m_empty, countNUM, tempoEstado, insertPlane, m_busy, tProblema, m_output)
	
	variable airplaneTime : natural := 0;
	variable storedPlane  : std_logic_vector(7 downto 0);
	
	begin
	alarme <= '0';
	m_rd   <= '0';
	m_wr   <= '0';
	m_rst  <= '0';
	radioOut <= "00000000";

	case PS is 
	---READ INPUT STATE---
		when le => 
			countRST <= '0';
			countEN  <= '1';
			if (insertPlane = '1' and m_busy = '0') then
				m_wr <= '1';
				NS <= le;
			elsif (insertPlane = '1' and m_busy = '1') then
				m_wr <= '0';
				NS <= le;
			elsif (insertPlane = '0') then
				if (m_empty = '0' and countNUM >= tempoEstado-1) then 
					NS <= analisa;
					countEN  <= '0';
					countRST <= '1';
				elsif (m_empty = '1' and countNUM >= tempoEstado-1) then 
					NS <= termina;
					countEN  <= '0';
					countRST <= '1';
				else NS <= le;
				end if;
			else NS <= termina;
			end if;
			
	---CHECK PROBLEM STATE---
		when analisa => 
			countRST <= '0';
			countEN  <= '1';
			
			if (problema = '1' and countNUM >= tempoEstado-1) then 
				NS <= espera;
				countEN  <= '0';
				countRST <= '1';
			elsif (problema = '0' and countNUM >= tempoEstado-1) then
				NS <= chama;
				countEN  <= '0';
				countRST <= '1';
			else NS <= analisa;
			end if;
	---SOLVE PROBLEM STATE---
		when espera => 
			countRST <= '0';
			countEN  <= '1';
			
			if (countNUM >= tProblema and countNUM >= tempoEstado-1) then 
				NS <= analisa;
				countEN  <= '0';
				countRST <= '1';
			else NS <= espera;
			end if;
	---CALL AN AIRPLANE STATE---
		when chama => 
			countRST <= '0';
			countEN  <= '1';
			--- READ MEMORY ---
			if (countNUM >= tempoEstado-1 and m_busy = '0') then 
				NS <= comunica;
				-- As it takes 1 clock period for the awnser of the memory
				-- the awnser arrives exactly in the next state(comunica)
				m_rd <= '1';
				countEN  <= '0';
				countRST <= '1';
			else NS <= chama;
			end if;
	---COMMUNICATION STATE---
		when comunica => 
			countRST <= '0';
			countEN  <= '1';
			m_rd <= '0';
			storedPlane := m_output;
			radioOut <= storedPlane;
			
			if(storedPlane(7) = '1') then 
				airplaneTime := tempoP; -- landing
			else 
				airplaneTime := tempoD; -- take-off
			end if;
			
			if (countNUM >= tempoEstado-1) then 
				NS <= alerta;
				countEN  <= '0';
				countRST <= '1';
			else NS <= comunica;
			end if;
	---ALERT STATE---
		when alerta => 
			alarme   <= '1';
			countRST <= '0';
			countEN  <= '1';
			
			if (countNUM >= tempoEstado-1 and countNUM >= airplaneTime - 1) then 
				if (m_empty = '0') then
					NS <= analisa;
				else
					NS <= termina;
				end if;
				countEN  <= '0';
				countRST <= '1';
			else NS <= alerta;
			end if;
		---CLEAR MEM STATE---
		when limpa => 
			countRST <= '0';
			countEN  <= '1';
			m_rst <= '1';
			if (countNUM >= tempoEstado-1) then 
				NS <= le;
				countEN  <= '0';
				countRST <= '1';
			else 
				NS <= limpa;
			end if;
		---FINAL STATE---
		when termina => 
			NS <= termina;
			countRST <= '0';
			countEN  <= '0';
		when others => 
			countRST <= '1';
			countEN  <= '0';
			alarme   <= '0';
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
			"110" when limpa,
			"111" when termina,
			"010" when others;
end architecture RTL;

