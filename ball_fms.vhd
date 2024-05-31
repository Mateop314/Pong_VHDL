library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	
entity ball_fms is 
	generic	(	N 			: integer:= 7;
					DeltaX	: std_logic := '1';
					DeltaY	: integer := 2;
					PosIni	: integer:= 56);
	port		(	clk		: in std_logic;
					rst		: in std_logic;
					r0_addr_in	: in std_logic_vector(N-1 downto 0):= (others => '0');
					r1_addr_in	: in std_logic_vector(N-1 downto 0):= (others => '0');
					ena_timer: out std_logic;
					rst_timer: out std_logic;
					max_tick	: in std_logic;
					dataO		: out std_logic := '0';
					addr		: out std_logic_vector(N-1 downto 0):= (others => '0');
					gol		: in std_logic);	
end entity;

architecture rtl of ball_fms is  
	type state is (state0, state1, state2, state3, state4, state5, state6, state7, state8, state9);
	signal state_pr, state_next : state;
	
	signal count_next0					: unsigned(N-1 downto 0);
	signal count_s0 						: unsigned(N-1 downto 0);	
	
	signal deltaXpr, deltaXpr_pre	:std_logic;
	signal deltaYpr, deltaYpr_pre	:unsigned(1 downto 0);
	
	signal r0_addr : unsigned(N-1 downto 0);
	signal r1_addr : unsigned(N-1 downto 0);
begin		
	
	r0_addr <= unsigned(r0_addr_in);
	r1_addr <= unsigned(r1_addr_in);
	
	inicio: process(clk, rst)
		variable temp0 : unsigned(N-1 downto 0);
		variable xDelt : std_logic;
		variable yDelt : unsigned(1 downto 0);
		begin
			if(rst = '1') then 
			state_pr		 <= state0;
			temp0			 := to_unsigned(posIni, N);
			xDelt			 := deltaX;
			yDelt			 := to_unsigned(deltaY, 2);
			elsif(rising_edge(clk)) then 
				state_pr		 	 <= state_next;
				temp0 		 	 := count_next0;
				xDelt				 := deltaXpr;
				yDelt				 := deltaYpr;

			end if;	
			count_s0 	 <= temp0;
			deltaXpr_pre <= xDelt;
			deltaYpr_pre <= yDelt;
		end process;
		
	LedControll: process(count_s0, count_next0, state_pr, max_tick, deltaXpr, deltaXpr_pre, deltaYpr, deltaYpr_pre, r0_addr, r1_addr, gol)
		begin
			case state_pr is
				when state0 =>
					ena_timer <= '0';
					rst_timer <= '1';
					dataO <= '0';
					deltaXpr <= deltaXpr_pre;
					deltaYpr <= deltaYpr_pre;
					
					if( deltaYpr = 1 and deltaXpr = '1') then 
						count_next0 <= count_s0 + 16 + 1;
					elsif(deltaYpr = 0 and deltaXpr = '1') then
						count_next0 <= count_s0 - 16 + 1;
					elsif(deltaYpr = 2 and deltaXpr = '1') then 
						count_next0 <= count_s0 + 1;
					elsif(deltaYpr = 1 and deltaXpr = '0') then
						count_next0 <= count_s0 + 16 - 1;
					elsif(deltaYpr = 0 and deltaXpr = '0') then 
						count_next0 <= count_s0 - 16 - 1;
					elsif(deltaYpr = 2 and deltaXpr = '0') then 
						count_next0 <= count_s0 - 1;
					else 
						count_next0 <= count_s0;
					end if;
					
					addr <= std_logic_vector(count_s0);
					if(gol = '1') then
						state_next <= state9;
					elsif((count_next0 = r0_addr+1) or (count_next0 = r1_addr-1)) then 
						state_next <= state6;
					elsif((count_next0 = r0_addr + 17) or (count_next0 = r1_addr + 15)) then
						state_next <= state7;
					elsif((count_next0 = r0_addr - 15) or (count_next0 = r1_addr - 17)) then 
						state_next <= state8;
					elsif(count_next0 = 0 or count_next0 = 16 or count_next0 = 32 or count_next0 = 48 or count_next0 = 64 or count_next0 = 80 or count_next0 = 96 or count_next0 = 112) then
						state_next <= state1;
					elsif(count_next0 = 15 or count_next0 = 31 or count_next0 = 47 or  count_next0 = 63 or count_next0 = 79 or count_next0 = 95 or count_next0 = 111 or count_next0 = 127) then
						state_next <= state2;
					elsif(count_next0 >= 112 and count_next0 <= 127) then 
						state_next <= state3;
					elsif(count_next0 >= 0 and count_next0 <= 15) then 
						state_next <= state4;
					else 
						state_next <= state5;
					end if;
					
				when state1 =>
					rst_timer <= '0';
					ena_timer <= '1';
					dataO <= '1';
					addr <= std_logic_vector(count_s0);
					deltaXpr <= '1';
					deltaYpr <= deltaYpr_pre;
					count_next0 <= count_s0;
					if(max_tick = '1') then 
						state_next <= state0;
					else
						state_next <= state1;
					end if;
					
				when state2 => 
					rst_timer <= '0';
					ena_timer <= '1';
					dataO <= '1';
					addr <= std_logic_vector(count_s0);
					deltaXpr <= '0';
					deltaYpr <= deltaYpr_pre;
					count_next0 <= count_s0;
					if(max_tick = '1') then 
						state_next <= state0;
					else
						state_next <= state2;
					end if;
					
				when state3 =>
					rst_timer <= '0';
					ena_timer <= '1';
					dataO <= '1';
					addr <= std_logic_vector(count_s0);
					deltaXpr <= deltaXpr_pre;
					deltaYpr <= "00";
					count_next0 <= count_s0;
					if(max_tick = '1') then 
						state_next <= state0;
					else
						state_next <= state3;
					end if;	
					
				when state4 =>
					rst_timer <= '0';
					ena_timer <= '1';
					dataO <= '1';
					addr <= std_logic_vector(count_s0);
					deltaXpr <= deltaXpr_pre;
					deltaYpr <= "01";

					count_next0 <= count_s0;
					if(max_tick = '1') then 
						state_next <= state0;
					else
						state_next <= state4;
					end if;
				when state5 =>
					rst_timer <= '0';
					ena_timer <= '1';
					dataO <= '1';
					addr <= std_logic_vector(count_s0);
					deltaXpr <= deltaXpr_pre;
					deltaYpr <= deltaYpr_pre;
					count_next0 <= count_s0;
					if(max_tick = '1') then 
						state_next <= state0;
					else
						state_next <= state5;
					end if;
				when state6 => 
					rst_timer <= '0';
					ena_timer <= '1';
					dataO <= '1';
					addr <= std_logic_vector(count_s0);
					deltaXpr <= not deltaXpr_pre;
					deltaYpr <= "10";
					count_next0 <= count_s0;
					if(max_tick = '1') then 
						state_next <= state0;
					else
						state_next <= state6;
					end if;
				when state7 => 
					rst_timer <= '0';
					ena_timer <= '1';
					dataO <= '1';
					addr <= std_logic_vector(count_s0);
					deltaXpr <= not deltaXpr_pre;
					deltaYpr <= "01";
					count_next0 <= count_s0;
					if(max_tick = '1') then 
						state_next <= state0;
					else
						state_next <= state7;
					end if;
				when state8 => 
					rst_timer <= '0';
					ena_timer <= '1';
					dataO <= '1';
					addr <= std_logic_vector(count_s0);
					deltaXpr <= not deltaXpr_pre;
					deltaYpr <= "00";
					count_next0 <= count_s0;
					if(max_tick = '1') then 
						state_next <= state0;
					else
						state_next <= state8;
					end if;
					
				when state9 => 
					rst_timer <= '0';
					ena_timer <= '1';
					dataO <= '0';
					addr <= std_logic_vector(count_s0);
					deltaXpr <= not deltaXpr_pre;
					deltaYpr <= "01";
					count_next0 <= to_unsigned(posIni, N);
					if(max_tick = '1') then 
						state_next <= state0;
					else
						state_next <= state9;
					end if;
			end case;
		end process;

end architecture;