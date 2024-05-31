library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity encoder_rows is 
	port(	x		: in std_logic_vector(2 downto 0);
			y		: out std_logic_vector(7 downto 0));
end entity;

architecture functional of encoder_rows is 
	signal y_temp	: std_logic_vector(7 downto 0);
begin 
	with x select
		y_temp <= 		"10000000" when "000",
						"01000000" when "001", 
						"00100000" when "010", 
						"00010000" when "011", 
						"00001000" when "100", 
						"00000100" when "101",
						"00000010" when "110", 
						"00000001" when others;
						
		y <= not y_temp;
		
end architecture;