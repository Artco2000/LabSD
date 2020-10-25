-- Quartus II VHDL Template with a few modifications
-- Simple Dual-Port RAM with different read/write addresses and
-- with a port read-enable
-- recieves adresses in std_logic_vector and casts it to
-- natural to use in index of memory

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity modified_dual_port_ram is

	generic 
	(
		DATA_WIDTH : natural := 8;
		ADDR_WIDTH : natural := 8
	);

	port 
	(
		clk	: in std_logic;
		raddr	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		waddr	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		wr		: in std_logic;
		rd		: in std_logic;
		rdata	: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);

end modified_dual_port_ram;

architecture rtl of modified_dual_port_ram is

	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
	type memory_t is array(2**ADDR_WIDTH -1 downto 0) of word_t;

	-- Declare the RAM signal.	
	signal ram : memory_t;

	-- Declare signals for conversion
	signal raddr_intern	: natural;
	signal waddr_intern	: natural;
begin
	raddr_intern <= to_integer(unsigned(raddr((DATA_WIDTH-1) downto 0)));
	waddr_intern <= to_integer(unsigned(waddr((DATA_WIDTH-1) downto 0)));

	process(clk)
	begin
	if(rising_edge(clk)) then 
		if(wr = '1') then
			ram(waddr_intern) <= data;
		elsif(rd = '1') then
			rdata <= ram(raddr_intern);
		else
			rdata <= (rdata'range => '0');
		end if;	
	end if;
	end process;

end rtl;