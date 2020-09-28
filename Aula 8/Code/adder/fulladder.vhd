LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity fulladder is
    port ( Cin : in std_logic;
           x   : in std_logic;
           y   : in std_logic;
           s   : out std_logic;
           Cout : out std_logic
        );
end fulladder;

architecture RTL OF fulladder is
	signal input : std_logic_vector(2 downto 0);
begin
	input <= x & y & Cin;
	comportamental:process(input)
		begin
			case input is
				when "000"  => s <= '0'; Cout <= '0';
				when "001"  => s <= '1'; Cout <= '0';
				when "010"  => s <= '1'; Cout <= '0';
				when "100"  => s <= '1'; Cout <= '0';
				when "011"  => s <= '0'; Cout <= '1';
				when "110"  => s <= '0'; Cout <= '1';
				when "101"  => s <= '0'; Cout <= '1';
				when "111"  => s <= '1'; Cout <= '1';
				when others => s <= '0'; Cout <= '0';
			end case;
		end process comportamental;
end RTL ;