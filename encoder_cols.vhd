library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity encoder_cols is 
	port(	x	: in std_logic_vector(3 downto 0);
			y	: out std_logic_vector(7 downto 0));
end entity;

architecture functional of encoder_cols is 
begin 
	with x select 
		y <= 	"10000000" when "0000" else 
				"01000000" when "0001" else 
				"00100000" when "0010" else 
				"00010000" when "0011" else 
				"00001000" when "0100" else 
				"00000100" when "0101" else 
				"00000010" when "0110" else 
				"00000001" when others;
end architecture;