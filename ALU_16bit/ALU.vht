library ieee;                                               
use ieee.std_logic_1164.all;  
use ieee.std_logic_unsigned.all;                              
use ieee.numeric_std.all;

-- Testbench for 16 bit ALU. Increments to next instruction every 100 ns.

entity ALU_tb is
end ALU_tb;

architecture ALU_tb_behav of ALU_tb is
	-- inputs have to be initialized for simulation
	signal tb_ABUS   : std_logic_vector(15 downto 0) := "0000000000000101";
	signal tb_BBUS   : std_logic_vector(15 downto 0) := "0000000000000011";
	signal tb_ALUctl : std_logic_vector(3 downto 0)  := "0000";
	signal tb_ALUout : std_logic_vector(15 downto 0);
	signal tb_CARRY  : std_logic := '0';

	component ALU is 
		port ( 
			i_abus   : in std_logic_vector(15 downto 0);
			i_bbus   : in std_logic_vector(15 downto 0);
			i_aluctl : in std_logic_vector(3 downto 0);
			o_aluout : out std_logic_vector(15 downto 0);
			o_carry  : out std_logic
		);
	end component ALU;
	
begin
	-- instantiation of ALU
	UUT : ALU
		port map (
			i_abus   => tb_ABUS,
			i_bbus   => tb_BBUS,
			i_aluctl => tb_ALUctl,
			o_aluout => tb_ALUout,
			o_carry  => tb_CARRY
		);
	process
	begin
		tb_ALUctl <= "0000";
		wait for 100 ns;
		for i in 0 to 14 loop
			tb_ALUctl <= tb_ALUctl + '1';
			wait for 100 ns;
		end loop;		
		wait;
	end process;
end ALU_tb_behav;
