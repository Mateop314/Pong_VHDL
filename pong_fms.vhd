library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	
entity pong_fms is 
	generic	(	N 			: integer:= 6;
					TopeInf	: integer:= 54;
					TopeSup	: integer:= 1;
					posIni	: integer:= 33);
	port		(	btt0	: in std_logic;
					btt1	: in std_logic;
					clk	: in std_logic;
					rst	: in std_logic;
					dataO	: out std_logic := '0';
					y0		: out std_logic_vector(N-1 downto 0):= (others => '0');
					y1		: out std_logic_vector(N-1 downto 0):= (others => '0');
					y2		: out std_logic_vector(N-1 downto 0):= (others => '0'));
end entity;

architecture rtl of pong_fms is  
	type state is (state0, state1, state2, state3, state4, state5);
	signal state_pr, state_next : state;
	
	signal count_next0			: unsigned(N-1 downto 0);
	signal count_s0 				: unsigned(N-1 downto 0);
	
begin		

	inicio: process(clk, rst)
		variable temp0 : unsigned(N-1 downto 0);
		begin
			if(rst = '1') then 
			state_pr		 <= state0;
			temp0			 := to_unsigned(posIni, N);
			elsif(rising_edge(clk)) then 
				state_pr		 	 <= state_next;
				temp0 		 	 := count_next0;
			end if;
						
			count_s0 	<= temp0;
		end process;
		
	LedControll: process(count_s0, count_next0, state_pr, btt0, btt1)
		begin
			case state_pr is
				when state0 => 
				dataO <= '0';
				count_next0 <= count_s0;
				y0 <= std_logic_vector(count_next0 - 16);
				y1 <= std_logic_vector(count_next0);
				y2 <= std_logic_vector(count_next0 + 16);
				if(btt0 = '1') then 
					state_next <= state1;
				elsif(btt1 = '1') then 
					state_next <= state2;
				else
					state_next <= state4;
				end if;
					
				when state1 =>
					dataO <= '0';
					count_next0 <= count_s0 + "10000";
					y0 <= std_logic_vector(count_s0 - 16);
					y1 <= std_logic_vector(count_s0);
					y2 <= std_logic_vector(count_s0 + 16);
					if(count_next0 >= topeInf) then 
						state_next <= state5;
					elsif(count_next0 <= topeSup) then 
						state_next <= state3;
					else
						state_next <= state4;
					end if;
					
				when state2 =>
					dataO <= '0';
					count_next0 <= count_s0 - "10000";
					y0 <= std_logic_vector(count_s0 - 16);
					y1 <= std_logic_vector(count_s0);
					y2 <= std_logic_vector(count_s0 + 16);
					if(count_next0 >= topeInf) then 
						state_next <= state5;
					elsif(count_next0 <= topeSup) then 
						state_next <= state3;
					else
						state_next <= state4;
					end if;
					
				when state3 =>
					dataO <= '1';
					count_next0 <= count_s0 + "10000";
					y0 <= std_logic_vector(count_next0 - 16);
					y1 <= std_logic_vector(count_next0);
					y2 <= std_logic_vector(count_next0 + 16);
					if(btt0 = '1') then 
						state_next <= state1;
					elsif(btt1 = '1') then 
						state_next <= state2;
					else
						state_next <= state4;
					end if;
					
				when state4 =>
					dataO <= '1';
					count_next0 <= count_s0;
					y0 <= std_logic_vector(count_next0 - 16);
					y1 <= std_logic_vector(count_next0);
					y2 <= std_logic_vector(count_next0 + 16);
					if(btt0 = '1') then 
						state_next <= state1;
					elsif(btt1 = '1') then 
						state_next <= state2;
					else
						state_next <= state4;
					end if;
					
				when state5 =>
					dataO <= '1';
					count_next0 <= count_s0 - "10000";
					y0 <= std_logic_vector(count_next0 - 16);
					y1 <= std_logic_vector(count_next0);
					y2 <= std_logic_vector(count_next0 + 16);
					if(btt0 = '1') then 
						state_next <= state1;
					elsif(btt1 = '1') then 
						state_next <= state2;
					else
						state_next <= state4;
					end if;
					
			end case;
		end process;
end architecture;