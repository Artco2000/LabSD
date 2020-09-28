LIBRARY IEEE;
use ieee.std_logic_1164.all;

entity FlipFlopD is
	port( 
		clock: in std_logic;
		D:     in std_logic;
	   Q:     out std_logic
	    );
end FlipFlopD;

architecture DataFlow of FlipFlopD is
	signal aux1, aux2, aux3, aux4, aux5, aux6, aux7, aux8 : std_logic;
begin
	
	--latch d - master
	aux1 <= D and not(clock);
	aux2 <= (not(D)) and not(clock);
	aux3 <= aux1 nor aux4;
	aux4 <= aux2 nor aux3;
	
	--latch d - servo
	aux5 <= aux3 and clock;
	aux6 <= (not(aux3)) and clock;
	aux7 <= aux5 nor aux8;
	aux8 <= aux6 nor aux7;
	
	Q <= aux7;
	
end DataFlow;