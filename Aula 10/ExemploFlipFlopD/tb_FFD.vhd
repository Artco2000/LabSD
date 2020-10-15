
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use ieee.numeric_std.all;

ENTITY tb_FFD IS
END tb_FFD;

ARCHITECTURE behavior OF tb_FFD IS 

    -- Component Declaration for the Unit Under Test (UUT)

component FFD 
	port( D: in std_logic;
		rst: in std_logic;
		clock: in std_logic;
		Q: out std_logic
		);
end component;
    
	signal clk              : std_logic;
	signal rst              : std_logic;
	signal data_in          : std_logic;
	signal data_output      : std_logic;
	constant max_value      : natural := 4;
	constant mim_value		: natural := 1;


	signal read_data_in    : std_logic:='0';
	signal flag_write      : std_logic:='0';   


	file   inputs_data_in  : text open read_mode  is "data_in.txt";
	file   outputs         : text open write_mode is "outputs.txt";


	-- Clock period definitions
	constant PERIOD     : time := 20 ns;
	constant DUTY_CYCLE : real := 0.5;
	constant OFFSET     : time := 5 ns;

BEGIN
	-- Instantiate the Unit Under Test (UUT) or Design Under Test (DUT)
DUT: FFD 
    port map(clock      => clk,
			rst        => rst,
			D          => data_in,
			Q          => data_output);

------------------------------------------------------------------------------------
----------------- processo para gerar o sinal de clock 
------------------------------------------------------------------------------------		
        PROCESS    -- clock process for clock
        BEGIN
            WAIT for OFFSET;
            CLOCK_LOOP : LOOP
                clk <= '0';
                WAIT FOR (PERIOD - (PERIOD * DUTY_CYCLE));
                clk <= '1';
                WAIT FOR (PERIOD * DUTY_CYCLE);
            END LOOP CLOCK_LOOP;
        END PROCESS;

------------------------------------------------------------------------------------
----------------- processo para gerar o estimulo de reset
------------------------------------------------------------------------------------		
	sreset: process
	begin
		rst <= '1';
		for i in 1 to 4 loop
			wait until rising_edge(clk);
		end loop;
		rst <= '0'; 
		wait;	
	end process sreset;
	
	
------------------------------------------------------------------------------------
----------------- processo para leer os dados do arquivo data_in.txt
------------------------------------------------------------------------------------
read_inputs_data_in:process
		variable linea : line;
		variable input : std_logic;
	begin
		wait until falling_edge(clk);
		while not endfile(inputs_data_in) loop
			if read_data_in = '1' then
				readline(inputs_data_in,linea);
				read(linea,input);
				data_in <= input;
			end if;
			wait for PERIOD;
		end loop;
		wait;
	end process read_inputs_data_in;	
	
------------------------------------------------------------------------------------
----------------- processo para gerar os estimulos de entrada
------------------------------------------------------------------------------------
	
    tb_stimulus : PROCESS
    BEGIN
        WAIT FOR (OFFSET + 3*PERIOD);
            read_data_in <= '1';		
			for i in mim_value to max_value loop
				wait for PERIOD;
			end loop;
            read_data_in <= '0';		
		WAIT;
    END PROCESS tb_stimulus;	
    
------------------------------------------------------------------------------------
------ processo para gerar os estimulos de escrita do arquivo de saida
------------------------------------------------------------------------------------   

    -- escreve_outputs : PROCESS
    -- BEGIN
        -- WAIT FOR (OFFSET + 4*PERIOD);
            -- flag_write <= '1';
			-- for i in mim_value to max_value loop
				-- wait for PERIOD;
			-- end loop;
            -- flag_write <= '0';			
		-- WAIT;
    -- END PROCESS escreve_outputs;   
    
-- ------------------------------------------------------------------------------------
-- ------ processo para escriber os dados de saida no arquivo .txt
-- ------------------------------------------------------------------------------------   

	-- write_outputs:process
		-- variable linea  : line;
		-- variable output : std_logic_vector (31 downto 0);
	-- begin
		-- wait until clk ='0';
		-- while true loop
			-- if (flag_write ='1')then
				-- output := q_ortonorma;
				-- write(linea,output);
				-- writeline(outputs,linea);
			-- end if;
			-- wait for PERIOD;
		-- end loop; 
	-- end process write_outputs;   	
END;
