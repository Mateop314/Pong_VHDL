library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity my_rom1 is 
	port(	clk		:	in		std_logic;
			r_addr	:	in		std_logic_vector(6 downto 0);
			r_data	:	out	std_logic_vector(0 downto 0));
end entity;

architecture rtl of my_rom1 is 
	constant data_width	:	integer:= 1;
	constant addr_width	:	integer:= 7;
	signal	data_reg		:	std_logic_vector(data_width-1 downto 0);
	
	type mem_type is array ( 2**addr_width-1 downto 0) of std_logic_vector(data_width-1 downto 0);
	constant data_rom		:	mem_type:=(	"0", "0", "0", "0", "1", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0",
													"1", "0", "1", "0", "0", "0", "1", "0", "0", "1", "0", "0", "1", "1", "1", "0",
													"1", "0", "1", "0", "1", "0", "1", "0", "0", "1", "0", "0", "1", "0", "1", "0",
													"1", "0", "1", "0", "1", "0", "1", "1", "0", "1", "0", "0", "0", "0", "1", "0",
													"1", "1", "1", "0", "1", "0", "1", "0", "1", "1", "0", "0", "0", "1", "0", "0",
													"1", "0", "1", "0", "1", "0", "1", "0", "0", "1", "0", "0", "1", "'", "0", "0",
													"1", "0", "1", "0", "1", "0", "1", "0", "0", "1", "0", "0", "1", "1", "1", "0",
													"0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0");
begin 
	read_process: process(clk)
	begin
		if (rising_edge(clk)) then 
			data_reg <= data_rom(to_integer(unsigned(r_addr)));
		end if;
	end process;
	
	r_data <= data_reg;
end architecture;