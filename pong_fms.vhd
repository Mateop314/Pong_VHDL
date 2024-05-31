library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	
entity pong_fms is 
	generic	(	N 		: integer:= 6);
	port		(	btt0	: in std_logic;
					btt1	: in std_logic;
					clk	: in std_logic;
					y		: out std_logic_vector(5 downto 0));	
end entity;

architecture rtl of pong_fms is  
	type state is (state0, state1, state2, state3, state4, state5);
	signal state_pr, state_next : state;
	
	signal count_next0			: unsigned(N-1 downto 0);
	signal count_s0 				: unsigned(5 downto 0);
	
begin		

	inicio: process(clk, rst)
		variable temp0 : unsigned(N-1 downto 0);
		begin
			if(rst = '1') then 
			state_pr		 <= state0;
			temp0			 := (others => '0');
			elsif(rising_edge(clk)) then 
				state_pr		 	 <= state_next;
				temp0 		 	 := count_next0;
			end if;
			count_s0 	<= temp0;
		end process;
		
	LedControll: process()
		begin
			case state_pr is
				when state0 => 
				count_next0 <= "100001" 
				if(btt0 = '1') then 
					state_next <= state1;
				elsif(btt1 = '1') then 
					state_next <= state2;
				else
					state_next <= state3;
				end if;
					
				when state1 =>
					count_next0 <= count_s0 + 8;
					if(count_next0 >= 54 or count_next0 <= 0) then 
						state_next <= state5;
					else
						state_next <= state4;
					end if;
				when state2 =>
					count_next0 <= count_s0 - 8;
					if(count_next0 >= 54 or count_next0 <= 0) then 
						state_next <= state5;
					else
						state_next <= state4;
					end if;
					
				when state3 =>
					count_next0 <= count_s0;
					if(count_next0 >= 54 or count_next0 <= 0) then 
						state_next <= state5;
					else
						state_next <= state4;
					end if;
					
				when state4 =>
					y <= count_s0;
					if(btt0 = '1') then 
						state_next <= state1;
					elsif(btt1 = '1') then 
						state_next <= state2;
					else
						state_next <= state3;
					end if;
					
				when state5 =>
					y <= std_logic_vector(count_s0 - 1);
					if(btt0 = '1') then 
						state_next <= state1;
					elsif(btt1 = '1') then 
						state_next <= state2;
					else
						state_next <= state3;
					end if;
					
			end case;
		end process;
end architecture;