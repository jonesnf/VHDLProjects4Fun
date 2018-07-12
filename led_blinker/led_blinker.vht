library IEEE;
use ieee.std_logic_1164.all;

-- Testbench used for simulating LED blinker code
-- Simulated in modelsim through Altera/Intel's Quartus II Prime Lite

entity led_blinker_tb is 
end led_blinker_tb;



architecture blink_tb of led_blinker_tb is
	-- 25MHz freq = 40 ns period
	constant CLOCK_PERIOD : time := 40 ns;
	
	signal tb_CLOCK : std_logic := '0';
	signal tb_SW0   : std_logic := '0';
	signal tb_SW1   : std_logic := '0';
	signal tb_ENABLE: std_logic := '0';
	signal tb_LED   : std_logic;
	
	-- component goes in the architecture!
	component led_blinker is 
		port(
			i_clock : in std_logic;
			i_sw0   : in std_logic;
			i_sw1   : in std_logic;
			i_enable: in std_logic;
			o_led   : out std_logic
		);
	end component led_blinker;
	
begin

	-- PORT MAPS DON'T REQUIRE SEMI-COLONS
	UUT : led_blinker
		port map (
			i_clock => tb_CLOCK,
			i_sw0   => tb_SW0,
			i_sw1   => tb_SW1,
			i_enable=> tb_ENABLE,
			o_led   => tb_LED
		);
		
	-- generate clock for testbench
	p_CLK_GEN : process is 
	begin 
		wait for CLOCK_PERIOD / 2;
		tb_CLOCK <= not tb_CLOCK;
	end process p_CLK_GEN;
	
	process
	begin 
		tb_ENABLE <= '1';
		
		tb_SW0    <= '0';
		tb_SW1    <= '0';
		wait for 0.2 sec; 
		
		tb_SW0    <= '1';
		tb_SW1    <= '0';
		wait for 0.2 sec;
		
		tb_SW0    <= '0';
		tb_SW1    <= '1';
		wait for 0.5 sec;
		
		tb_SW0    <= '1';
		tb_SW1    <= '1';
		wait for 2 sec;
	end process;
end blink_tb;
