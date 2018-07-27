library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Simple 32 word fifo (word is 8 bits in this example)
-- Currently, fifo does not act like what one might consider to be a "regular" queue;
-- 	data gets over written instead of being removed from queue after a read
--                   _________
-- i_write_en   --->|         |--->o_read_data
-- i_write_data --->|         |--->o_full
-- i_read_en    --->|  FIFO   |--->o_empty
--                  |         |
-- i_clk        --->|         |
-- i_reset      --->|_________|
--

entity FIFO is 
	generic (
		g_width : natural := 8;
		g_depth : integer := 32
	);
	port ( 
		i_write_en   : in std_logic;
		i_write_data : in std_logic_vector(g_width-1 downto 0);
		i_read_en    : in std_logic;
		i_clk        : in std_logic;
		i_nreset     : in std_logic; -- active low reset
		
		o_read_data  : out std_logic_vector(g_width-1 downto 0);
		o_full       : out std_logic;
		o_wrd_cnt    : out natural range 0 to g_depth; 
		o_empty      : out std_logic
	);
end FIFO;
	
architecture fifo_behave of FIFO is 
	type t_FIFO is array ( 0 to g_depth-1 ) of std_logic_vector( g_width-1 downto 0 );
	
	signal FIFO     : t_FIFO := ( others => ( others => '0' ) );
	signal w_index  : natural range 0 to g_depth-1 := 0;
	signal r_index  : natural range 0 to g_depth-1 := 0;
	signal word_cnt : natural range 0 to g_depth   := 0;
	signal wr_case  : std_logic_vector(1 downto 0);
	signal full     : std_logic := '0';
	signal empty    : std_logic := '1';
begin 
	control : process(i_clk)
	begin
		if rising_edge(i_clk) then 
			if i_nreset = '0' then
				FIFO   <= ( others => ( others => '0' ) );
				word_cnt <= 0;
				w_index  <= 0;
				r_index  <= 0;
			else 
				wr_case <= i_write_en & i_read_en;
				case wr_case is
					-- case w=0, r=1 : read from FIFO if not empty
					when "01" =>
						if empty = '0' then 
							word_cnt <= word_cnt - 1;
							if r_index <= g_depth - 1 then 
								r_index <= 0;
							else 
								r_index <= r_index + 1;
							end if;
						end if;
					-- case w=1, r=0 : write to FIFO if not full
					when "10" =>
						if full = '0' then 
							word_cnt <= word_cnt + 1;
							if w_index = g_depth - 1 then 
								w_index <= 0;
							else 
								w_index <= w_index + 1;
							end if;
							FIFO(w_index) <= i_write_data;
						end if;
					-- default : do nothing
					when others =>
						null;
				end case;
			end if; -- reset check
		end if;    -- clk
	end process control;
	
	o_read_data <= FIFO(r_index);
	
	full    <= '1' when word_cnt = g_depth else '0';
	o_full  <= full;
	empty   <= '1' when word_cnt = 0 else '0';
	o_empty <= empty;	
	
	o_wrd_cnt <= word_cnt;
	
end fifo_behave;