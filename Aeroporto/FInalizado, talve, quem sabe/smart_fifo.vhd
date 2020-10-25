LIBRARY IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity smart_fifo is
	generic(max_bits_counter : integer := 8);

	port(
			wr, rd, reset, clk : in std_logic;
			wdata              : in std_logic_vector(7 downto 0);
			empty              : out std_logic;
			busy			   	 : out std_logic;
			rdata              : out std_logic_vector(7 downto 0);
			qnt_out            : out std_logic_vector(7 downto 0)
			--s				   	 : out std_logic_vector(2 downto 0)
			);
end smart_fifo;

architecture my_arch of smart_fifo is

	component modified_dual_port_ram is 
	port(
		clk	: in  std_logic;
		raddr	: in  std_logic_vector(7 downto 0);
		waddr	: in  std_logic_vector(7 downto 0);
		data	: in  std_logic_vector(7 downto 0);
		wr		: in  std_logic;
		rd		: in  std_logic;
		rdata	: out std_logic_vector(7 downto 0)
	);
	end component;
	
	component up_counter is
	port
		(
		inc, clr, clk   : in  std_logic;
		output          : out std_logic_vector((max_bits_counter - 1) downto 0)
		);
	end component;
	
	component register_1bit is
	port
		(
		wr, data_in, clr, clk : in  std_logic;
		data_out              : out std_logic		
		);
	end component;
	
	-- Build an enumerated type for the state machine
	type state_type is (s_wait, s_clear, s_write1, s_write2, s_read1, s_read2);

	-- Register to hold the current state
	signal state   : state_type;
	
	--------------------------------------------
	--internal signals
	--------------------------------------------
	
	signal last_op_reg_wr, last_op_reg_in, last_op_reg_out : std_logic;
	
	signal qnt : std_logic_vector(7 downto 0);
	
	signal intern_empty : std_logic;
	
	signal qnt0 : std_logic;
	
	signal clr_all : std_logic;
	
	signal full : std_logic;
	
	signal inc_begin_count, inc_end_count : std_logic;
	
	signal wr_mem, rd_mem : std_logic;
	
	signal count_begin, count_end : std_logic_vector((max_bits_counter - 1) downto 0);
	
	signal internal_clk : std_logic;
	
begin
 --signal for avoiding clock confusion
	internal_clk <= clk;
	
 --Comparator for N utilized spaces in memory = 0
	qnt0 <= '1' when qnt = (qnt'range => '0') else '0';
	
 --It has been conventioned that the write is a '1' 
 --and read is '0' as the last operation
	full  <= qnt0 and last_op_reg_out;
	intern_empty <= qnt0 and not(last_op_reg_out);
	empty <= intern_empty;
	
 --Instantiate counters
	begin_count : up_counter port map(inc => inc_begin_count, clr => clr_all, clk => internal_clk, output => count_begin);
	end_count   : up_counter port map(inc => inc_end_count  , clr => clr_all, clk => internal_clk, output => count_end  );

 --Instantiate register for last operation
	last_op_reg : register_1bit port map(wr => last_op_reg_wr, data_in => last_op_reg_in, clr => clr_all, clk => internal_clk, data_out => last_op_reg_out);
	
 --Instantiate memory element
	mem : modified_dual_port_ram port map(clk => internal_clk, raddr => count_begin, waddr => count_end, data => wdata, wr => wr_mem, rd => rd_mem, rdata => rdata);

 --calculates how many used positions based on the counters
	qnt <= std_logic_vector(unsigned(count_end) - unsigned(count_begin));
	qnt_out <= qnt;
	
 --controller for smart_fifo via MOORE-FSM:
	-- Logic to advance to the next state
	process (internal_clk)
	begin
		if (rising_edge(internal_clk)) then
			case state is
				when s_wait=>
					if reset = '1' then
						state <= s_clear;
					elsif (wr = '1' and full = '0') then
						state <= s_write1;
					elsif (rd = '1' and intern_empty = '0') then
						state <= s_read1;
					else
						state <= s_wait;
					end if;
				when s_clear=>
				 --inconditional transition
					state <= s_wait;
				when s_write1=>
				 --inconditional transition
					state <= s_write2;
				when s_write2 =>
				 --inconditional transition
					state <= s_wait;
				when s_read1=>
				 --inconditional transition
					state <= s_read2;
				when s_read2=>
				 --inconditional transition
					state <= s_wait;
				when others=>
					state <= s_wait;
			end case;
		end if;
	end process;

	-- Output depending solely on the current state
	process (state)
	begin
		case state is
			when s_wait=>
				last_op_reg_wr  <= '0';
				last_op_reg_in  <= '0';
				clr_all         <= '0';
				inc_begin_count <= '0';
				inc_end_count   <= '0';
				wr_mem          <= '0';
				rd_mem          <= '0';
				busy 				 <= '0';
			when s_clear=>
				last_op_reg_wr  <= '0';
				last_op_reg_in  <= '0';
				clr_all         <= '1';
				inc_begin_count <= '0';
				inc_end_count   <= '0';
				wr_mem          <= '0';
				rd_mem          <= '0';
				busy 				 <= '1';
			when s_write1=>
				last_op_reg_wr  <= '1';
				last_op_reg_in  <= '1';
				clr_all         <= '0';
				inc_begin_count <= '0';
				inc_end_count   <= '0';
				wr_mem          <= '1';
				rd_mem          <= '0';
				busy 				 <= '1';
			when s_write2 =>
				last_op_reg_wr  <= '0';
				last_op_reg_in  <= '0';
				clr_all         <= '0';
				inc_begin_count <= '0';
				inc_end_count   <= '1';
				wr_mem          <= '0';
				rd_mem          <= '0';
				busy 				 <= '1';
			when s_read1=>
				last_op_reg_wr  <= '1';
				last_op_reg_in  <= '0';
				clr_all         <= '0';
				inc_begin_count <= '0';
				inc_end_count   <= '0';
				wr_mem          <= '0';
				rd_mem          <= '1';
				busy 				 <= '1';
			when s_read2=>
				last_op_reg_wr  <= '0';
				last_op_reg_in  <= '0';
				clr_all         <= '0';
				inc_begin_count <= '1';
				inc_end_count   <= '0';
				wr_mem          <= '0';
				rd_mem          <= '0';
				busy 				 <= '1';
			end case;
	end process;

	
	-- with state select 
	-- 	s <= 
	-- 		"000" when s_wait,
	-- 		"001" when s_clear,
	-- 		"010" when s_write1,
	-- 		"011" when s_write2,
	-- 		"100" when s_read1,
	-- 		"101" when s_read2,
	-- 		"111" when others;
	
	
end my_arch;
