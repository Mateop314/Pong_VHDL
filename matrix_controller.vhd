library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	
entity matrix_controller is 
	generic	(		addr_width	: integer:= 7;
					N			: integer:= 7);
	port		( 	data_in		: in std_logic;
					max_tick	: in std_logic;
					clk			: in std_logic;
					rst			: in std_logic;
					cols_enc	: in std_logic_vector(15 downto 0):= (others => '0');
					rows_enc	: in std_logic_vector(7 downto 0):= (others => '1');
					syn_clr		: out std_logic := '0';
					rd_addr		: out std_logic_vector(N-1 downto 0);
					rows		: out std_logic_vector(7 downto 0) := (others => '1');
					cols		: out std_logic_vector(15 downto 0):= (others => '0');
					enable_time	: out std_logic:= '0');	
end entity;

architecture rtl of matrix_controller is  
	type state is (state0, state1, state2);
	signal state_pr, state_next : state;
	
	signal test_vec		: std_logic_vector(15 downto 0):= (others => '0');
	signal count_next0	: unsigned(N-1 downto 0);
	signal count_s0 	: unsigned(N-1 downto 0);
	
begin		

	inicio: process(clk, rst)
		variable temp0 : unsigned(N-1 downto 0);
		begin
			if(rst = '1') then 
			state_pr		 <= state0;
			rd_addr		 <= (others => '0');
			temp0			 := (others => '0');
			elsif(rising_edge(clk)) then 
				state_pr		 	 <= state_next;
				temp0 		 	 := count_next0;
			end if;
			rd_addr		<= std_logic_vector(temp0);
			count_s0 	<= temp0;
		end process;
		
	LedControll: process(state_pr, test_vec, rows_enc, cols_enc, count_s0, max_tick, data_in, count_next0)
		begin
			case state_pr is
				when state0 => 
					test_vec <= (others => '0');
					cols <= (others => '0');
					rows <= (others => '1');
					enable_time <= '0';
					syn_clr <= '0';
					count_next0 <= (others => '0');
					if(count_next0 < 128) then 
						state_next <= state1;
					else 
						state_next <= state0;
					end if;
					
				when state1 =>
					test_vec <= (others => data_in);
					cols <= test_vec and cols_enc;
					rows <= rows_enc;
					count_next0 <= count_s0;
					enable_time <= '1';
					syn_clr <= '0';
					if(max_tick = '1') then 
						state_next <= state2;
					else
						state_next <= state1;
					end if;
					
				when state2 =>
					test_vec <= (others => '0');
					cols <= (others => '0');
					rows <= (others => '1');
					count_next0 <= count_s0 + 1;
					enable_time <= '0';
					syn_clr <= '1';
					if(count_next0 < 128) then 
						state_next <= state1;
					else 
						state_next <= state0;
					end if;

					
			end case;
		end process;
end architecture;