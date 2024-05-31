library ieee;
	use ieee.std_logic_1164.all;
	
entity sync_mux is 
	generic(	N : integer := 4);
	port(		clk : in std_logic;
				rst : in std_logic;
				d	 : in std_logic;
				a,b : in std_logic_vector(N-1 downto 0);
				x	 : out std_logic_vector(N-1 downto 0));
end entity;

architecture state_machine of sync_mux is 
	type state is (stateA, stateB);
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
	
	process(a,b,d,pr_state)
	begin 
		case pr_state is 
			when stateA => 
				x <= a;
				if(d = '1') then 
					nx_state <= stateB;
				else
					nx_state <= stateA;
				end if;
			when stateB =>
				x <= b;
				if(d = '0') then 
					nx_state <= stateA;
				else
					nx_state <= stateB;
				end if;
		end case;
	end process;
end architecture;
			