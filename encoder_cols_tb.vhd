library ieee;
	use ieee.std_logic_1164.all;
	
entity encoder_cols_tb is 
	port();
end entity;

architecture tb of encoder_cols_tb is 
	signal x_tb : std_logic_vector(2 downto 0):= (others => '0');
	signal z_tb : std_logic_vector(5 downto 0):= (others => '0');
	signal y_tb : std_logic_vector(7 downto 0):= (others => '0');
begin 
	x_tb <= "000" after 10ns;
	
	z_tb <=	"00001" after 10ns,
				"00010" after 20ns,
				"00011" after 30ns,
				"00100" after 40ns,
				"00101" after 50ns;
				
	encoder: entity work.encoder_cols
		port map(	x => x_tb,
						z => z_tb,
						y => y_tb);	
end architecture;