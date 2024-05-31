library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity nBitcomparator is 
	generic	(	max_width		:	integer	:= 4);
	port		(	x					:	in std_logic_vector(max_width-1 downto 0);
					y					:	in std_logic_vector(max_width-1 downto 0);
					eq					: 	out std_logic;
					lg					:	out std_logic;
					ls					:	out std_logic);
end entity;
		
architecture gatelevel of nBitcomparator is
	signal	eqs	:	std_logic_vector(max_width-1 downto 0);
begin
	eq <= '1' when x = y else '0';
	lg <= '1' when x > y else '0';
	ls <= '1' when x < y else '0';
end architecture;