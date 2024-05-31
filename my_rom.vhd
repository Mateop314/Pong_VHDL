library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity my_rom is 
	port(	clk		:	in		std_logic;
			r_addr	:	in		std_logic_vector(3 downto 0);
			r_data	:	out	std_logic_vector(7 downto 0));
end entity;

architecture rtl of my_rom is 
	constant data_width	:	integer:= 8;
	constant addr_width	:	integer:= 4;
	signal	data_reg		:	std_logic_vector(data_width-1 downto 0);
	
	type mem_type is array (0 to 2**addr_width-1) of std_logic_vector(data_width-1 downto 0);
	constant data_rom		:	mem_type:=(	"00000001","01001111","00010010","00000110",
													"01001100","00100100","00100000","00001111",
													"00000000","00000100","00001000","01000000",
													"00110001","10000010","00110000","00111000");
begin 
	read_process: process(clk)
	begin
		if (rising_edge(clk)) then 
			data_reg <= data_rom(to_integer(unsigned(r_addr)));
		end if;
	end process;
	
	r_data <= data_reg;
end architecture;