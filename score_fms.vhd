library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	
entity score_fms is 
	port		(	clk		: in std_logic;
					rst		: in std_logic;
					addr_in	: in std_logic_vector(6 downto 0);
					p_j1		: out std_logic_vector(3 downto 0);
					p_j2		: out std_logic_vector(3 downto 0);
					gol		: out std_logic;
					win_j1	: out std_logic;
					win_j2	: out std_logic);	
end entity;

architecture rtl of score_fms is  
	type state is (state0, state1, state2);
	signal state_pr, state_next : state;
	
	signal count_next0, count_next1		: unsigned(3 downto 0);
	signal count_s0, count_s1 				: unsigned(3 downto 0);
		
	signal addr : unsigned(6 downto 0);

begin		
	addr <= unsigned(addr_in);

	inicio: process(clk, rst)
		variable temp0 : unsigned(3 downto 0);
		variable temp1 : unsigned(3 downto 0);
		begin
			if(rst = '1') then 
			state_pr		 <= state0;
			temp0			 := (others => '0');
			temp1			 := (others => '0');
			elsif(rising_edge(clk)) then 
				state_pr		 	 <= state_next;
				temp0 		 	 := count_next0;
				temp1 		 	 := count_next1;
			end if;	
			p_j1 <= std_logic_vector(temp0);
			p_j2 <= std_logic_vector(temp1);
			count_s0 	 <= temp0;
			count_s1 	 <= temp1;

		end process;
		
	LedControll: process(count_s0,count_s1,count_next0,count_next1, state_pr, addr)
		begin
			case state_pr is
				when state0 =>
					gol <= '0';
					count_next0 <= count_s0;
					count_next1 <= count_s1;
					if(addr = 0 or addr= 16 or addr= 32 or addr= 48 or addr= 64 or addr= 80 or addr= 96 or addr= 112) then 
						state_next <= state1;
					elsif(addr = 15 or addr= 31 or addr= 47 or  addr= 63 or addr= 79 or addr= 95 or addr= 111 or addr= 127) then 
						state_next <= state2;
					else
						state_next <= state0;
					end if;
				when state1 =>
					gol <= '1';
					count_next0 <= count_s0 + 1;
					count_next1 <= count_s1;
					state_next <= state0;
				when state2 => 
					gol <= '1';
					count_next0 <= count_s0;
					count_next1 <= count_s1 + 1;
					state_next <= state0;
			end case;
		end process;
--win----------------------------------------------
win: process(count_s0, count_s1)
	begin 
		if( count_s0 >= 9) then 
			win_j1 <= '1';
			win_j2 <= '0';
		elsif(count_s1 >= 9) then 
			win_j2 <= '1';
			win_j1 <= '0';
		else 
			win_j1 <= '0';
			win_j2 <= '0';
		end if;
	end process;
end architecture;