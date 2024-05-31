library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity encoder_cols is 
	port(	x	: in std_logic_vector(2 downto 0);
			z	: in std_logic_vector(6 downto 0);
			y	: out std_logic_vector(15 downto 0));
end entity;

architecture functional of encoder_cols is 
	signal x_temp : unsigned(7 downto 0);
	signal Z_temp : unsigned(6 downto 0);
	signal sel	  : unsigned(7 downto 0);
begin 
	x_temp <= unsigned(x) * "10000";
	Z_Temp <= unsigned(z);
	sel	 <= (z_temp - x_temp);
	
	with std_logic_vector(sel) select 
		y <= 	"1000000000000000" when "00000000",
				"0100000000000000" when "00000001", 
				"0010000000000000" when "00000010", 
				"0001000000000000" when "00000011", 
				"0000100000000000" when "00000100", 
				"0000010000000000" when "00000101",
				"0000001000000000" when "00000110", 
				"0000000100000000" when "00000111",
				"0000000010000000" when "00001000",
				"0000000001000000" when "00001001",
				"0000000000100000" when "00001010",
				"0000000000010000" when "00001011",
				"0000000000001000" when "00001100",
				"0000000000000100" when "00001101",
				"0000000000000010" when "00001110",
				"0000000000000001" when others;
				
end architecture;