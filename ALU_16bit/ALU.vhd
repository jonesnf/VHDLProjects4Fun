library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- 16-bit ALU, based on tutorial from: http://www.fpga4student.com/p/vhdl-project.html
-- 16-bit ALU with the following functions:
-- 1. add
-- 2. sub
-- 3. mult
-- 4. div
-- 5. shift ABUS L
-- 6. shift ABUS R
-- 7. rotate ABUS L
-- 8. rotate ABUS R
-- 9. and
-- 10. or
-- 11. xor
-- 12. nand
-- 13. nor
-- 14. xnor
-- 15. A < B
-- 16. A = B
 

entity ALU is 
	port (
		i_abus   : in std_logic_vector(15 downto 0); --unsigned integers
		i_bbus   : in std_logic_vector(15 downto 0); --unsigned integers
		i_aluctl : in std_logic_vector(3 downto 0);
		o_aluout : out std_logic_vector(15 downto 0); 
		o_carry  : out std_logic -- carry flag
	);
end ALU;

architecture alu_comp of ALU is 
	constant onebit : natural := 1;
	signal tempvec  : std_logic_vector(16 downto 0);
	signal alu_result : unsigned(15 downto 0);
begin
	-- process of ALU based on small instruction set
	alu : process(i_aluctl) is 
	begin
		case i_aluctl is
			when "0000" =>
				o_aluout <= std_logic_vector(unsigned(i_abus) + unsigned(i_bbus)); -- A + B
			when "0001" =>
				o_aluout <= std_logic_vector(unsigned(i_abus) - unsigned(i_bbus)); -- A - B
			when "0010" =>
				o_aluout <= std_logic_vector(to_unsigned(to_integer(unsigned(i_abus)) * to_integer(unsigned(i_bbus)),16)); -- A & B
			when "0011" =>
				o_aluout <= std_logic_vector(to_unsigned(to_integer(unsigned(i_abus)) / to_integer(unsigned(i_bbus)),16)); -- A | B
			when "0100" => 
				o_aluout <= std_logic_vector(shift_left(unsigned(i_abus), onebit));
			when "0101" =>
				o_aluout <= std_logic_vector(shift_right(unsigned(i_abus), onebit));
			when "0110" => 
				o_aluout <= std_logic_vector(unsigned(i_abus) rol onebit);
			when "0111" =>
				o_aluout <= std_logic_vector(unsigned(i_abus) ror onebit);
			when "1000" =>
				o_aluout <= i_abus and i_bbus;
			when "1001" => 
				o_aluout <= i_abus or i_bbus;
			when "1010" => 
				o_aluout <= i_abus xor i_bbus;
			when "1011" =>
				o_aluout <= i_abus nand i_bbus; 
			when "1100" =>
				o_aluout <= i_abus nor i_bbus;
			when "1101" =>
				o_aluout <= i_abus xnor i_bbus;
			when "1110" =>
				if i_abus > i_bbus then
					o_aluout <= x"0001";
				else 
					o_aluout <= x"0000";
				end if;
			when "1111" =>
				if i_abus = i_bbus then 
					o_aluout <= x"0001";
				else 
					o_aluout <= x"0000";
				end if;	
			when others =>
				o_aluout <= i_abus;  -- if nothing selected, just output A
		end case;
	end process alu;		
	tempvec <= std_logic_vector(unsigned(( '0' & i_abus )) + unsigned(( '0' & i_bbus )));
	o_carry <= tempvec(16);
end alu_comp;
