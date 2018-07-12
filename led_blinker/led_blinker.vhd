library IEEE;
use ieee.std_logic_1164.all;

entity led_blinker is 
	port ( 
		i_clock : in std_logic;
		i_sw0   : in std_logic;
		i_sw1   : in std_logic;
		i_enable: in std_logic;
		o_led   : out std_logic
	);
end led_blinker;

architecture blink of led_blinker is
	-- First, we need to define constants for clock division
	-- Our clock is at 25MHz, and we want 1,10,50,100 Hz output
	--   with 50 % duty cycle
	constant c_cnt_100hz : natural := 125000;
	constant c_cnt_50hz  : natural := 250000;
	constant c_cnt_10hz  : natural := 1250000;
	constant c_cnt_1hz   : natural := 12500000;
	
	-- counters for freq's
	signal count_100hz : natural range 0 to c_cnt_100hz;
	signal count_50hz  : natural range 0 to c_cnt_50hz; 
	signal count_10hz  : natural range 0 to c_cnt_10hz;
	signal count_1hz   : natural range 0 to c_cnt_1hz; 
	
	-- signals to toggle LED
	signal toggle_100hz : std_logic := '0';
	signal toggle_50hz  : std_logic := '0';
	signal toggle_10hz  : std_logic := '0';
	signal toggle_1hz   : std_logic := '0';
	
	-- signal to connect mux to and gate
	-- leaving this unitialized gives the default value of 'U'(undefined)
	signal led_select : std_logic;
	
	-- now that we have all of our signals,
	-- we can start the logic of our arch
	
begin
		
		-- Processes for all frequencies
		
		p_100hz : process(i_clock) is
		begin
			if rising_edge(i_clock) then
				if count_100hz = c_cnt_100hz-1 then
					toggle_100hz <= not toggle_100hz;
					count_100hz <= 0;
				else
					count_100hz <= count_100hz + 1;
				end if;
			end if;
		end process p_100hz;
		
		p_50hz : process(i_clock) is
		begin
			if rising_edge(i_clock) then
				if count_50hz = c_cnt_50hz-1 then
					toggle_50hz <= not toggle_50hz;
					count_50hz <= 0;
				else
					count_50hz <= count_50hz + 1;
				end if;
			end if;
		end process p_50hz;
		
		p_10hz : process(i_clock) is
		begin 
			if rising_edge(i_clock) then
				if count_10hz = c_cnt_10hz - 1 then
					toggle_10hz <= not toggle_10hz;
					count_10hz <= 0;
				else
					count_10hz <= count_10hz + 1;
				end if;
			end if;
		end process p_10hz;
		
		p_1hz : process(i_clock) is 
		begin
			if rising_edge(i_clock) then
				if count_1hz = c_cnt_1hz - 1 then
					toggle_1hz <= not toggle_1hz;
					count_1hz <= 0;
				else 
					count_1hz <= count_1hz + 1;
				end if;
			end if;
		end process p_1hz;
		
		-- get output from mux
		led_select <=  toggle_100hz when ( i_sw0 = '0' and i_sw1 = '0' ) else
							toggle_50hz  when ( i_sw0 = '0' and i_sw1 = '1' ) else
							toggle_10hz  when ( i_sw0 = '1' and i_sw1 = '0' ) else
							toggle_1hz;
							
		o_led <= led_select and i_enable;
			
end blink;
