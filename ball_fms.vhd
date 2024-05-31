library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	
entity ball_fms is 
	generic	(	N 			: integer:= 6;
					DeltaX	: std_logic := '1';
					DeltaY	: std_logic := '1';
					PosIni	: integer:= 45);
	port		(	clk		: in std_logic;
					rst		: in std_logic;
					max_tick	: in std_logic;
					dataO		: out std_logic := '0';
					addr		: out std_logic_vector(5 downto 0):= (others => '0'));	
end entity;

architecture rtl of ball_fms is  
	type state is (state0, state1, state2, state3, state4);
	signal state_pr, state_next : state;
	
	signal count_next0			: unsigned(N-1 downto 0);
	signal count_s0 				: unsigned(N-1 downto 0);
	
	signal deltaXpr, deltaXpr_pre	:std_logic;
	signal deltaYpr, deltaYpr_pre	:std_logic;
begin		

	inicio: process(clk, rst)
		variable temp0 : unsigned(N-1 downto 0);
		variable temp1 : unsigned(N-1 downto 0);
		variable temp2 : unsigned(N-1 downto 0);
		variable xDelt : std_logic;
		variable yDelt : std_logic;
		begin
			if(rst = '1') then 
			state_pr		 <= state0;
			temp0			 := to_unsigned(posIni, N);
			xDelt				 <= deltaX;
			yDelt				 <= deltaY;
			elsif(rising_edge(clk)) then 
				state_pr		 	 <= state_next;
				temp0 		 	 := count_next0;
				xDelt				 <= deltaXpr;
				yDelt				 <= deltaYpr;

			end if;			
			count_s0 	 <= temp0;
			deltaXpr_pre <= xDelt;
			deltaYpr_pre <= yDelt;
		end process;
		
	LedControll: process(count_s0, count_next0,count_s1, count_next1, state_pr)
		begin
			case state_pr is
				when state0 =>
					dataO <= '1';
					deltaXpr <= deltaXpr_pre;
					deltaYpr <= deltaYpr_pre;
					
					if( deltaYpr = '1') then 
						count_next0 <= count_s0 + 8;
					else
						count_next0 <= count_s0 - 8;
					end if;
					if( deltaXpr = '1') then 
						count_next0 <= count_s0 + 1;
					else
						count_next0 <= count_s0 - 1;
					end if;
					addr <= count_s0;
					
					if(count_next0 = 0 or count_next0 = 8 or count_next0 = 16 or count_next0 = 24 or count_next0 = 32 or count_next0 = 40 or count_next0 = 48 or count_next0 = 56) then
						state_next <= state1;
					elsif(count_next0 = 7 or count_next0 = 15 or count_next0 = 23 or  count_next0 = 31 or or count_next0 = 39 or count_next0 = 47 or count_next0 = 55 or count_next0 = 63) then
						state_next <= state2;
					elsif(count_next0 >= 53 and count_next0 <= 63) then 
						state_next <= state3;
					elsif(count_next0 >= 0 and count_next0 <= 7) then 
						state_next <= state4;
					end if;
					
				when state1 =>
					dataO <= '0';
					addr <= count_s0;
					deltaXpr <= '1';
					deltaYpr <= deltaXpr_pre;
					if( deltaYpr = '1') then 
						count_next0 <= count_s0 + 1 + 8;
					else
						count_next0 <= count_s0 + 1 - 8;
					end if;
					
					if(max_tick = '1') then 
						state_next <= state0;
					else
						state_next <= state1;
					
				when state2 => 
					dataO <= '0';
					addr <= count_s0;
					deltaXpr <= '0';
					deltaYpr <= deltaYpr_pre;
					if( deltaYpr = '1') then 
						count_next0 <= count_s0 - 1 + 8;
					else
						count_next0 <= count_s0 - 1 - 8;
					end if;
					
					if(max_tick = '1') then 
						state_next <= state0;
					else
						state_next <= state2;
					
					
				when state3 =>
					dataO <= '0';
					addr <= count_s0;
					deltaXpr <= deltaXpr_pre;
					deltaYpr <= '0';
					if( deltaXpr = '1') then 
						count_next0 <= count_s0 + 1 - 8;
					else
						count_next0 <= count_s0 - 1 - 8;
					end if;
					
					if(max_tick = '1') then 
						state_next <= state0;
					else
						state_next <= state3;
						
				when state4 =>
					dataO <= '0';
					addr <= count_s0;
					deltaXpr <= deltaXpr_pre;
					deltaYpr <= '1';
					if( deltaXpr = '1') then 
						count_next0 <= count_s0 + 1 + 8;
					else
						count_next0 <= count_s0 - 1 + 8;
					end if;
					
					if(max_tick = '1') then 
						state_next <= state0;
					else
						state_next <= state4;
					
			end case;
		end process;
end architecture;