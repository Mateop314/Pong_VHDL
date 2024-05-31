library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity encoder_rows is 
	port(	x		: in std_logic_vector(2 downto 0)
			y		: out std_logic_vector(7 downto 0));
end entity;

architecture functional of encoder_rows is 
begin 
		y <= 	std_logic_vector( 255 - 2**(8 - 1 - unsigned(x)));
end architecture;