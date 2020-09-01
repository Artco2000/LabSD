library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_alu is
generic (W : integer := 32);
end tb_alu;

architecture teste of tb_alu is
component alu is

port 
	(
		control : in    std_logic_vector(3 downto 0);
      src1    : in    std_logic_vector(W - 1 downto 0);
      src2    : in    std_logic_vector(W - 1 downto 0);
      result  : out   std_logic_vector(W - 1 downto 0);
      zero    : out   std_logic
	);
end component;

signal SRC1, SRC2, RESULT : std_logic_vector(W - 1 downto 0);
signal ZERO : std_logic;
signal CONTROl : std_logic_vector(3 downto 0);

begin
instancia_alu: alu port map(src1=>SRC1,src2=>SRC2,control=>CONTROL,result=>RESULT,zero=>ZERO);

simul: process
begin
	SRC1 <= std_logic_vector(to_unsigned(78561, SRC1'length));
	SRC2 <= std_logic_vector(to_unsigned(7561, SRC2'length));
	CONTROl <= "0000";
	wait for 10 ns;
	
	CONTROl <= "0001";
	wait for 10 ns;
	
	CONTROl <= "0010";
	wait for 10 ns;
	
	CONTROl <= "0110";
	wait for 10 ns;
	
	CONTROl <= "0111";
	wait for 10 ns;
	
	CONTROl <= "1100";
	wait for 10 ns;
	
	SRC1 <= std_logic_vector(to_unsigned(2, SRC1'length));
	wait for 10 ns;
	
	wait;
end process;

end teste;