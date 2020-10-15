library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use ieee.numeric_std.all;

entity tb_funcao is
end tb_funcao;

architecture teste of tb_funcao is

component funcao is
    port (  x    : in  std_logic_vector(3 downto 0);
            fx   : out std_logic_vector(9 downto 0)
        );
end component;

signal data_in          : std_logic_vector(3 downto 0);
signal data_output      : std_logic_vector(9 downto 0);
constant max_value      : natural := 5;
constant mim_value		: natural := 1;


signal read_data_in    : std_logic:='0';
signal flag_write      : std_logic:='0'; 


file   inputs_data_in  : text open read_mode  is "data_in.txt";
file   outputs         : text open write_mode is "saida1.txt";


-- Clock period definition
constant PERIOD     : time := 20 ns;


begin
instancia_funcao: funcao port map(x => data_in, fx => data_output);

------------------------------------------------------------------------------------
----------------- processo para ler os dados do arquivo data_in.txt
------------------------------------------------------------------------------------
read_inputs_data_in:process
		variable linea : line;
		variable input : std_logic_vector(3 downto 0);
	begin
        while not endfile(inputs_data_in) loop
            wait for 1 ps;
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

    escreve_outputs : PROCESS
    BEGIN
            flag_write <= '1';
			for i in mim_value to max_value loop
				wait for PERIOD;
			end loop;
            flag_write <= '0';			
		WAIT;
    END PROCESS escreve_outputs;   
    
-- ------------------------------------------------------------------------------------
-- ------ processo para escriber os dados de saida no arquivo .txt
-- ------------------------------------------------------------------------------------   

	write_outputs:process
		variable linea  : line;
		variable output : std_logic_vector (9 downto 0);
    begin
        WAIT FOR (PERIOD/2);
		while true loop
			if (flag_write ='1')then
                output := data_output;
                write(linea,output);
				writeline(outputs,linea);
			end if;
			wait for PERIOD;
		end loop; 
	end process write_outputs;   	
end teste;