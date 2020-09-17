-- pseudo_mux - A Finite State Machine that mimics the behavior of mux
-- Copyright (C) 2018  Digital Systems Group - UFMG
-- 
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 3 of the License, or
-- (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, see <https://www.gnu.org/licenses/>.
--

library ieee;
use ieee.std_logic_1164.all;

entity pseudo_mux is
    port (
        RESET   : in    std_logic; -- reset input
        CLK     : in    std_logic; -- clock input
        S       : in    std_logic; -- control input
        A,B,C,D : in    std_logic; -- data inputs
        Q       : out   std_logic  -- data output
    );
end pseudo_mux;

architecture arch of pseudo_mux is
	type state_type is (ST0,ST1,ST2,ST3,ST0aux,ST1aux,ST2aux,ST3aux);
	signal PS,NS : state_type;
begin
	sync_proc: process(CLK,NS,RESET)
	begin
		-- take care of the asynchronous input
		if (RESET = '1') then PS <= ST0;
		elsif (rising_edge(CLK)) then
			PS <= NS;
		end if;
	end process sync_proc;
	
	comb_proc: process(PS,S,A,B,C,D)
	begin
		Q <= '0'; -- pre-assign output
		case PS is
			when ST0aux => -- items regarding state ST0
				Q <= A; -- Moore output
				if (S = '0') then NS <= ST0;
				else NS <= ST0aux;
				end if;
			when ST0 => -- items regarding state ST0
				Q <= A; -- Moore output
				if (S = '1') then NS <= ST1aux;
				else NS <= ST0;
				end if;
			when ST1aux => -- items regarding state ST1
				Q <= B; -- Moore output
				if (S = '0') then NS <= ST1;
				else NS <= ST1aux;
				end if;
			when ST1 => -- items regarding state ST1
				Q <= B; -- Moore output
				if (S = '1') then NS <= ST2aux;
				else NS <= ST1;
				end if;
			when ST2aux => -- items regarding state ST1
				Q <= C; -- Moore output
				if (S = '0') then NS <= ST2;
				else NS <= ST2aux;
				end if;
			when ST2 => -- items regarding state ST2
				Q <= C; -- Moore output
				if (S = '1') then NS <= ST3aux;
				else NS <= ST2;
				end if;
			when ST3aux => -- items regarding state ST1
				Q <= D; -- Moore output
				if (S = '0') then NS <= ST3;
				else NS <= ST3aux;
				end if;
			when ST3 => -- items regarding state ST3
				Q <= D; -- Moore output
				if (S = '1') then NS <= ST0aux;
				else NS <= ST3;
				end if;
			when others => -- the catch-all condition
				Q <= '0'; -- arbitrary; it should never
				NS <= ST0; -- make it to these two statements
		end case;
	end process comb_proc;
end arch;
