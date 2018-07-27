library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Testbench for 32 word (8-bit) FIFO
--                   _________
-- i_write_en   --->|         |--->o_read_data
-- i_write_data --->|         |--->o_full
-- i_read_en    --->|  FIFO   |--->o_empty
--                  |         |
-- i_clk        --->|         |
-- i_reset      --->|_________|
--

entity FIFO_tb is
end FIFO_tb;

architecture testbench of FIFO_tb is 
-- First, create tb signals 
	signal tb_WRITE_EN   : std_logic := '0';
	signal tb_WRITE_DATA : std_logic_vector(7 downto 0) := x"00";
   signal tb_READ_EN    : std_logic := '0';
   signal tb_CLK        : std_logic := '0';
   signal tb_RESET      : std_logic := '1';
   signal tb_READ_DATA  : std_logic_vector(7 downto 0);
   signal tb_FULL       : std_logic;
	signal tb_WRDCNT     : natural range 0 to 32 := 0;
   signal tb_EMPTY      : std_logic;

-- Create component
   component FIFO is 
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
	end component FIFO;
begin
--instantiate 
	UUT : FIFO 
		port map (
			i_write_en   => tb_WRITE_EN,
			i_write_data => tb_WRITE_DATA,
			i_read_en    => tb_READ_EN,
			i_clk        => tb_CLK,
			i_nreset     => tb_RESET,
			o_read_data  => tb_READ_DATA,
			o_full       => tb_FULL,
			o_wrd_cnt    => tb_WRDCNT,
			o_empty      => tb_EMPTY
		);

-- clk @ 10 MHz
	clk_gen : process is
	begin 
		wait for 50 ns; 
		tb_CLK <= not tb_CLK;
	end  process clk_gen;
	
	test : process is
	begin
	   wait for 100 ns;
	   -- I made reset active low so keep it high
		tb_WRITE_DATA <= x"BB";
		tb_READ_EN    <= '0';
		tb_WRITE_EN   <= '1';
		wait for 100 ns;
		
		tb_WRITE_EN <= '0';
		wait for 100 ns;
		
		tb_WRITE_DATA <= x"EE";
		tb_WRITE_EN   <= '1';
		wait for 100 ns;
		
		tb_WRITE_DATA <= x"FF";
		wait for 100 ns;
		
		tb_WRITE_EN <= '0';
		tb_READ_EN  <= '1';
		wait for 100 ns;
		
		tb_READ_EN <= '0';
		wait for 100 ns;
		
		tb_READ_EN <= '1';
		wait;
	end process test;
end testbench;
