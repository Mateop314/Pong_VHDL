library ieee;
	use ieee.std_logic_1164.all;
	
entity sync_mux is 
	generic(	N : integer := 4);
	port(		clk : in std_logic;
				rst : in std_logic;
				s	 : in std_logic_vector(2 downto 0);
				a,b,c,d,e,f,g : in std_logic_vector(N-1 downto 0);
				x	 : out std_logic_vector(N-1 downto 0));
end entity;

architecture state_machine of sync_mux is 
	type state is (stateA, stateB, stateC, stateD, stateE, stateF, stateG);
	signal pr_state, nx_state: state;
begin 

	process(rst, clk)
	begin 
		if(rst = '1') then 
			pr_state <= stateA;
		elsif(clk'event and clk = '1') then
			pr_state <= nx_state;
		end if;
	end process;
	
	process(a,b,c,d,e,f,g,s,pr_state)
	begin 
		case pr_state is 
			when stateA => 
				x <= a;
				if(s = "001") then 
					nx_state <= stateB;
				elsif(s = "010") then 
					nx_state <= stateC;
				elsif(s = "011") then
					nx_state <= stateD;
				elsif(s = "100") then
					nx_state <= stateE;
				elsif(s = "101") then
					nx_state <= stateF;
				elsif(s = "110") then 
					nx_state <= stateG;
				else 
					nx_state <= stateA;
				end if;
			when stateB =>
				x <= b;
				if(s = "000") then 
					nx_state <= stateA;
				elsif(s = "010") then 
					nx_state <= stateC;
				elsif(s = "011") then
					nx_state <= stateD;
				elsif(s = "100") then
					nx_state <= stateE;
				elsif(s = "101") then
					nx_state <= stateF;
				elsif(s = "110") then 
					nx_state <= stateG;
				else 
					nx_state <= stateB;
				end if;
			when stateC =>
				x <= c;
				if(s = "001") then 
					nx_state <= stateB;
				elsif(s = "000") then 
					nx_state <= stateA;
				elsif(s = "011") then
					nx_state <= stateD;
				elsif(s = "100") then
					nx_state <= stateE;
				elsif(s = "101") then
					nx_state <= stateF;
				elsif(s = "110") then 
					nx_state <= stateG;
				else 
					nx_state <= stateC;
				end if;
			when stateD => 
				x <= d;
				if(s = "001") then 
					nx_state <= stateB;
				elsif(s = "010") then 
					nx_state <= stateC;
				elsif(s = "000") then
					nx_state <= stateA;
				elsif(s = "100") then
					nx_state <= stateE;
				elsif(s = "101") then
					nx_state <= stateF;
				elsif(s = "110") then 
					nx_state <= stateG;
				else 
					nx_state <= stateD;
				end if;
			when stateE => 
				x <= e;
				if(s = "001") then 
					nx_state <= stateB;
				elsif(s = "010") then 
					nx_state <= stateC;
				elsif(s = "011") then
					nx_state <= stateD;
				elsif(s = "000") then
					nx_state <= stateA;
				elsif(s = "101") then
					nx_state <= stateF;
				elsif(s = "110") then 
					nx_state <= stateG;
				else 
					nx_state <= stateE;
				end if;
				
			when stateF => 
				x <= f;
				if(s = "001") then 
					nx_state <= stateB;
				elsif(s = "010") then 
					nx_state <= stateC;
				elsif(s = "011") then
					nx_state <= stateD;
				elsif(s = "100") then
					nx_state <= stateE;
				elsif(s = "000") then
					nx_state <= stateA;
				elsif(s = "110") then 
					nx_state <= stateG;
				else 
					nx_state <= stateF;
				end if;
				
			when stateG => 
				x <= g;
				if(s = "001") then 
					nx_state <= stateB;
				elsif(s = "010") then 
					nx_state <= stateC;
				elsif(s = "011") then
					nx_state <= stateD;
				elsif(s = "100") then
					nx_state <= stateE;
				elsif(s = "101") then
					nx_state <= stateF;
				elsif(s = "000") then 
					nx_state <= stateA;
				else 
					nx_state <= stateG;
				end if;
		end case;
	end process;
end architecture;