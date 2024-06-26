library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity my_DPRAM is 
	generic(	data_width	:	integer:=8;
				addr_width	:	integer:=2);
	port(		clk			:	in		std_logic;
				wr_en			:	in 	std_logic;
				w_addr		:	in 	std_logic_vector(addr_width-1 downto 0);
				r_addr		:	in		std_logic_vector(addr_width-1	downto 0);
				w_data		:	in		std_logic_vector(data_width-1 downto 0);
				r_data		:	out	std_logic_vector(data_width-1	downto 0));
end entity;

architecture rtl of my_DPRAM is 
	type mem_type is array (0 to 2**addr_width-1) of std_logic_vector(data_width-1 downto 0);
	signal ram			: 	mem_type;
	signal addr_reg	:	std_logic_vector(addr_width-1 downto 0);
begin
	write_process: process(clk)
	begin
		if (rising_edge(clk)) then
			if (wr_en = '1') then 
				ram(to_integer(unsigned(w_addr))) <= w_data;
			end if;
			addr_reg <= r_addr;
		end if;
	end process;
	
	r_data <= ram(to_integer(unsigned(addr_reg)));
end architecture;