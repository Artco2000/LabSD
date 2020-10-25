library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use ieee.math_real.all;
use std.textio.all;

entity tb_aeroporto is
end tb_aeroporto;

architecture teste of tb_aeroporto is

	component aeroporto is
		generic (
			clkFrequence : natural := 50;
			tempoP : natural := 3;
			tempoD : natural := 4
		);
		port(
			clk         : in std_logic;
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
	end component aeroporto;

	signal estado : string(1 to 10) := "le        ";

	signal reset, problema, alarme, insertPlane : std_logic;
	signal tempoEstado, tProblema : natural;
	signal s : std_logic_vector(2 downto 0);
	signal idAviao, radioOut, nAvioes: std_logic_vector(7 downto 0);

	constant periodAux : natural := 20;
	constant period : time := periodAux * 1 ns;
	signal clk : std_logic := '0';
	signal clk_enable: std_logic := '1';

	constant nAirplanes      : natural := 5;
	constant resetColldown   : time := 2*period;

	signal flagDisaster	 : std_logic:='0';
	signal idProblema    : std_logic_vector(2 downto 0);

	signal read_disaster        : std_logic:='0';
	signal read_state           : std_logic:='0';
	signal flag_write           : std_logic:='0'; 

	file   inputs_airplaneList  : text open read_mode  is "airplaneList.txt";
	file   inputs_stateTime 	: text open read_mode  is "stateTime.txt";
	file   inputs_disaster  	: text open read_mode  is "disaster.txt";
	file   outputs_timeTable    : text open write_mode is "timeTable.txt";
	file   outputs_comun    	: text open write_mode is "airplaneComunication.txt";
	file   outputs_problem      : text open write_mode is "relProblema.txt";

	begin
		UUT: aeroporto port map(
			clk         => clk,
			reset       => reset,
			tempoEstado => tempoEstado,
			problema    => problema,
			tProblema   => tProblema,
			idAviao     => idAviao,
			insertPlane => insertPlane,
			alarme      => alarme,
			radioOut    => radioOut,
			nAvioes     => nAvioes,
			s           => s
		);

	----------- HANDLE CLOCK ------------
	clk <= clk_enable and not clk after period/2;

	reset <= '0';

	---------- STATE DECODER ------------
	with s select 
		estado <=   
		"le        " when "000",
		"analisa   " when "001",
		"espera    " when "010",
		"chama     " when "011",
		"comunica  " when "100",
		"alerta    " when "101",
		"limpa     " when "110",
		"termina   " when "111",
		"le        " when others;

	------------------------------------------------------------------------------------
	----------------- processo para ler os dados do arquivo airplaneList.txt
	------------------------------------------------------------------------------------
	read_inputs_airplaneList:process
			variable linea : line;
			variable input : std_logic_vector(7 downto 0);
		begin
			while not endfile(inputs_airplaneList) loop
				wait for 1 ps;
				if insertPlane = '1' then
					readline(inputs_airplaneList ,linea);
					read(linea,input);
					idAviao <= input;
				end if;
				wait for 3*PERIOD;
			end loop;
			wait;
	end process read_inputs_airplaneList;	
		
	------------------------------------------------------------------------------------
	----------------- processo para gerar os estimulos de entrada dos avioes
	------------------------------------------------------------------------------------
		
	tb_stimulus_airplane : PROCESS
	BEGIN
			insertPlane <= '1';	
			for i in 1 to nAirplanes loop
				wait for 3*PERIOD;
			end loop;
			insertPlane <= '0';		
		WAIT;
	END PROCESS tb_stimulus_airplane;	

	------------------------------------------------------------------------------------
	---------- processo para leitura do tempo definido minimo para cada estado
	------------------------------------------------------------------------------------
		
	tb_stateTime : PROCESS
		variable linea : line;
		variable input : integer;
	BEGIN
		while not endfile(inputs_stateTime) loop
			readline(inputs_stateTime ,linea);
			read(linea,input);
			tempoEstado <= input/periodAux;
		end loop;
		WAIT;
	END PROCESS tb_stateTime;	
	------------------------------------------------------------------------------------
	------ processo para gerar os estimulos de escrita do arquivo de saida dos dados dos estados
	------------------------------------------------------------------------------------   

		escreve_outputs : PROCESS (estado, clk)
			variable linea  : line;
			variable lastState : string(1 to 10) := estado;
			variable delayedTime : time := 0 ns;
		BEGIN
			if (estado /= lastState and lastState /="UNDEFINED ") then
				write(linea, lastState);
				write(linea, delayedTime, right, 15);
				write(linea, now - delayedTime, right, 15);
				writeline(outputs_timeTable,linea);
				delayedTime := now;
				lastState := estado;
			elsif (lastState = "termina   ") then
				write(linea, estado);
				write(linea, delayedTime, right, 15);
				write(linea, tempoEstado*period, right, 15);
				writeline(outputs_timeTable,linea);
				lastState :="UNDEFINED ";
			end if;			
		END PROCESS escreve_outputs;   
		
	------------------------------------------------------------------------------------
	------              processo para gerar ativacoes aleatorias de problemas
	------------------------------------------------------------------------------------   

	aleatoriza : process(estado)
		variable linea : line;
		variable input : integer;
		variable seed1, seed2, aux : integer := 979;
		variable id : std_logic_vector(2 downto 0);
		variable r : real;
		variable max_val : real := 99.0;
		variable min_val : real := 0.0;
	begin
		problema <= '0';
		if estado = "analisa   " and insertPlane = '0' and not endfile(inputs_disaster) then
			uniform(seed1, seed2, r);
			aux := integer(round(r * real(max_val - min_val + 1.0) + real(min_val) - 0.5));
			--Probabilidade de acontecer disastre a cada interacao
			if (aux <= 35) then
				readline(inputs_disaster ,linea);
				read(linea,input);
				tProblema <= input/periodAux;
				read(linea, id);
				idProblema <= id;
				problema <= '1';
			end if;
		else 
			problema <= '0';
		end if;
	end process aleatoriza;
	------------------------------------------------------------------------------------
	------ processo para gerar os estimulos de escrita do arquivo de saida de problemas
	------------------------------------------------------------------------------------   

	escreve_problema : PROCESS (estado)
	variable linea  : line;
	BEGIN
		if (estado = "espera    ") then
			write(linea, idProblema);
			write(linea, now, right, 15);
			write(linea, tProblema, right, 15);
			writeline(outputs_problem,linea);
		end if;			
	END PROCESS escreve_problema;   

	------------------------------------------------------------------------------------
	------ processo para gerar os estimulos de escrita do arquivo de saida da comunicação do avião
	------------------------------------------------------------------------------------   

	escreve_comunica : PROCESS (estado, clk)
	variable linea  : line;
	variable task : string(1 to 9);
	BEGIN
		if (estado = "comunica  " and radioOut /= "00000000" and rising_edge(clk)) then
			if(radioOut(7) = '1') then 
				task := "Pouso    ";
			else 
				task := "Decolagem";
			end if;
			write(linea, task, right, 15);
			write(linea, radioOut, right, 15);
			write(linea, now, right, 15);
			writeline(outputs_comun,linea);
		end if;			
	END PROCESS escreve_comunica;   
	
end architecture teste;