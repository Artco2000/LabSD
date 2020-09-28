LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity fullAdder4 is
    port ( Cin_in  : in  std_logic;
           x_in, y_in : in  std_logic_vector(3 downto 0);
           s_out    : out std_logic_vector(3 downto 0);
           Cout_out : out std_logic
        );
end fullAdder4;

architecture RTL OF fullAdder4 is
	component fulladder is
	port 
		(
			x, y, Cin  : in std_logic;
			s, Cout : out std_logic
		);
	end component;
	
	signal C1, C2, C3 : std_logic;
	
begin
	
	--primeiro somador recebe Cin externo
	instancia_fulladder0: fulladder port map(x => x_in(0), y => y_in(0), Cin => Cin_in, Cout => C1, s => S_out(0));
	--segundo somador recebe carry-out do primeiro
	instancia_fulladder1: fulladder port map(x => x_in(1), y => y_in(1), Cin => C1, Cout => C2, s => S_out(1));
	--terceiro somador recebe carry-out do segundo
	instancia_fulladder2: fulladder port map(x => x_in(2), y => y_in(2), Cin => C2, Cout => C3, s => S_out(2));
	--primeiro somador recebe carry-out do terceiro
	instancia_fulladder3: fulladder port map(x => x_in(3), y => y_in(3), Cin => C3, Cout => Cout_out, s => S_out(3));

	
end RTL ;