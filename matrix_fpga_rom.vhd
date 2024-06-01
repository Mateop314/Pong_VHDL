library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	
entity matrix_fpga_rom is 
	port(	clk		: in std_logic;
			rst		: in std_logic;
			rows	: out std_logic_vector(7 downto 0):= (others => '1');
			cols	: out std_logic_vector(15 downto 0):= (others => '0');
			p1_ss	: out std_logic_vector(6 downto 0);
			p2_ss	: out std_logic_vector(6 downto 0);
			btt0	: in std_logic;
			btt1	: in std_logic;
			btt2	: in std_logic;
			btt3	: in std_logic);
end entity;

architecture rtl of matrix_fpga_rom is 
	signal rd_addr 		: std_logic_vector(6 downto 0);
	signal data_in 		: std_logic_vector(0 downto 0);
	signal max_tick		: std_logic;
	signal max_tick_B	: std_logic;
	signal ena_time		: std_logic;
	signal syn_clr		: std_logic;
	signal data_ram		: std_logic_vector(0 downto 0);
	signal data_rom1	: std_logic_vector(0 downto 0);
	signal data_rom2	: std_logic_vector(0 downto 0);
	
	signal btt0_dt		: std_logic;
	signal btt1_dt		: std_logic;
	signal btt2_dt		: std_logic;
	signal btt3_dt		: std_logic;
	
	signal w_data_R0	: std_logic_vector(0 downto 0);
	signal w_addr_R0	: std_logic_vector(6 downto 0);
	signal w_addr_R0A	: std_logic_vector(6 downto 0);
	signal w_addr_R0B	: std_logic_vector(6 downto 0);
	signal w_data_R1	: std_logic_vector(0 downto 0);
	signal w_addr_R1	: std_logic_vector(6 downto 0);
	signal w_addr_R1A	: std_logic_vector(6 downto 0);
	signal w_addr_R1B	: std_logic_vector(6 downto 0);
	
	signal mux_exit		: std_logic_vector(7 downto 0);
	signal count_mux 	: std_logic_vector(2 downto 0);
	signal count_rst 	: std_logic_vector(6 downto 0);
	signal max_tick_m	: std_logic;
	signal mem_data		: std_logic_vector(0 downto 0);
	signal mem_addr		: std_logic_vector(6 downto 0);
	
	signal cols_enc	: std_logic_vector(15 downto 0);
	signal rows_enc	: std_logic_vector(7 downto 0);
	signal row_num	: std_logic_vector(2 downto 0);
	
	signal ena_timerB : std_logic;
	signal rst_timerB : std_logic;
	
	signal w_data_B	: std_logic_vector(0 downto 0);
	signal w_addr_B	: std_logic_vector(6 downto 0);
	
	signal gol		: std_logic;
	signal rst_ball	: std_logic;
	
	signal max_tick_m1, max_tick_m2	: std_logic;
	signal count_mux1				: std_logic_vector(2 downto 0);
	signal mux_exit1 				: std_logic_vector(9 downto 0);
	
	signal p_j1, p_j2		: std_logic_vector(3 downto 0);
	signal win_j1, win_j2	: std_logic;
	signal selMem			: std_logic_vector(1 downto 0);
begin
--CONTROLADOR DE LA MATRIZ----------------------------------------------------------
	ledsDelay: entity work.univ_bin_counter
		generic map(	N => 14)
		port map(		clk 		=> clk,
					rst 		=> rst,
					ena 		=> ena_time,
					syn_clr		=> syn_clr,
					MAX		=> "10011100010000",--110000110101000, 11000011010100
					max_tick	=> max_tick);
	
	matrixControl: entity work.matrix_controller
		port map(	data_in		=> data_in(0),
				max_tick 	=> max_tick,
				clk		=> clk,
				rst		=> rst,
				cols_enc 	=> cols_enc,
				rows_enc 	=> rows_enc,
				rd_addr		=> rd_addr,
				enable_time 	=> ena_time,
				syn_clr 	=> syn_clr,
				rows		=> rows,
				cols		=> cols);
	
	comparadorF: process(rd_addr)
	begin
		if((unsigned(rd_addr) < 16) and (unsigned(rd_addr) >= 0)) then
			row_num <= "000";
		elsif((unsigned(rd_addr) < 32) and (unsigned(rd_addr) >= 16)) then
			row_num <= "001";
		elsif((unsigned(rd_addr) < 48) and (unsigned(rd_addr) >= 32)) then
			row_num <= "010";
		elsif((unsigned(rd_addr) < 64) and (unsigned(rd_addr) >= 48)) then
			row_num <= "011";
		elsif((unsigned(rd_addr) < 80) and (unsigned(rd_addr) >= 64)) then
			row_num <= "100";
		elsif((unsigned(rd_addr) < 96) and (unsigned(rd_addr) >= 80)) then
			row_num <= "101";
		elsif((unsigned(rd_addr) < 112) and (unsigned(rd_addr) >= 96)) then
			row_num <= "110";
		elsif((unsigned(rd_addr) < 128) and (unsigned(rd_addr) >= 112)) then
			row_num <= "111";
		else 
			row_num <= "111";
		end if;
	end process;
							
	encoderCols: entity work.encoder_cols
		port map(	x	=> row_num,
				z	=> rd_addr,
				y	=> cols_enc);
		
	encoderRows: entity work.encoder_rows
		port map(	x	=> row_num,
				y	=> rows_enc);
--MEMORIA USADA-------------------------------------------------------------------
	timerMux: entity work.univ_bin_counter
		generic map(	N => 11)
		port map(		clk 		=> clk,
					rst 		=> rst,
					ena  		=> '1',
					syn_clr		=> '0',
					MAX		=> "11010000010",-- 5000000 en binario
					max_tick 	=> max_tick_m);
		
		timerMux1: entity work.univ_bin_counter
		generic map(	N => 3)
		port map(		clk 		=> max_tick_m,
					rst 		=> rst,
					ena  		=> '1',
					syn_clr	=> '0',
					MAX		=> "110",
					counter => count_mux);
	
	mux: entity work.sync_mux
		generic map(	N => 8)
		port map(		clk => clk,
					rst => rst,
					s	 => count_mux,
					a	 => w_data_R0(0)& w_addr_R0,
					b	 => w_data_R1(0)& w_addr_R1,
					c	 => W_data_B(0) & w_addr_B,
					d	 => w_data_R0(0) & w_addr_R0A,
					e	 => w_data_R0(0) & w_addr_R0B,
					f	 => w_data_R1(0) & w_addr_R1A,
					g	 => w_data_R1(0) & w_addr_R1B,
					x	 => mux_exit);
	timerRST: entity work.univ_bin_counter
		generic map(	N => 7)
		port map(		clk 		=> clk,
					rst 		=> '0',
					ena  		=> '1',
					syn_clr	=> '0',
					MAX		=> "1111111",
					counter => count_rst);
	with rst select
		mem_data <= 	(others => '0') when '1',
				mux_exit(7 downto 7) when others;
	with rst select
		mem_addr <= 	count_rst when '1',
				mux_exit(6 downto 0)	when others;
	
	selMem <= win_j1 & win_j2;
	with selMem select
		data_in	<=	data_ram when "00",
			   	data_rom1 when "10",
				data_rom2 when "01",
				data_ram when others;
						
	ROM2: entity work.my_rom1
		port map(	clk 		=> clk,
				r_addr	=> rd_addr,
				r_data	=> data_rom2);
	
	ROM1: entity work.my_rom
		port map(	clk 		=> clk,
				r_addr	=> rd_addr,
				r_data	=> data_rom1);
	
	RAM: entity work.my_DPRAM
		generic map(	data_width => 1,
				addr_width => 7)
		port map(	clk 		=> clk,
				wr_en		=> '1',
				w_addr	=> mem_addr,
				w_data	=> mem_data,
				r_addr	=> rd_addr,
				r_data	=> data_ram);
						
--RAQUETAS-------------------------------------------------------------------------
button0: entity work.edge_detect
	port map(	clk 		 => max_tick,
			async_sig 	=> btt0,
			fall		 => btt0_dt);

button1: entity work.edge_detect
 port map(		clk 		=> max_tick,
			async_sig 	=> btt1,
			fall		=> btt1_dt);
button2: entity work.edge_detect
	port map(	clk 		=> max_tick,
			async_sig 	=> btt2,
			fall		=> btt2_dt);

button3: entity work.edge_detect
	port map(	clk 		=> max_tick,
			async_sig 	=> btt3,
			fall		=> btt3_dt);
 
raqueta0: entity work.pong_fms
	generic map(	N => 7,
			TopeInf => 113,
			topeSup => 1,
			posIni => 49)
	port map(	btt0 	=> btt0_dt,
			btt1 	=> btt1_dt,
			clk  	=> max_tick,
			rst	=> rst,
			dataO 	=> w_data_R0(0),
			y0	=> w_addr_R0A,
			y1	=> w_addr_R0,
			y2	=> w_addr_R0B);
			
raqueta1: entity work.pong_fms
	generic map(	N => 7,
			TopeInf => 126,
			topeSup => 14,
			posIni => 62)
	port map(	btt0 	=> btt2_dt,
			btt1 	=> btt3_dt,
			clk  	=> max_tick,
			rst	=> rst,
			dataO 	=> w_data_R1(0),
			y0	=> w_addr_R1A,
			y1	=> w_addr_R1,
			y2	=> w_addr_R1B);
--pelota-----------------------------------------------------------------
	CambioDeTiempo0: entity work.univ_bin_counter
		generic map(	N => 26)
		port map(	clk 		=> clk,
				rst 		=> rst,
				ena  		=> '1',
				syn_clr		=> '0',
				MAX		=> "10111110101111000010000000",-- 5000000 en binario
				max_tick 	=> max_tick_m1);
	CambioDeTiempo1: entity work.univ_bin_counter
		generic map(	N => 5)
		port map(	clk 		=> max_tick_m1,
				rst 		=> rst,
				ena  		=> '1',
				syn_clr		=> '0',
				MAX		=> "11110",
				max_tick 	=> max_tick_m2);
							
	tcambioDeTIempo2: entity work.univ_bin_counter
		generic map(	N => 3)
		port map(	clk 		=> max_tick_m2,
				rst 		=> rst,
				ena  		=> '1',
				syn_clr	=> '0',
				MAX		=> "110",
				counter => count_mux1);
							
		mux1: entity work.sync_mux
		generic map(	N => 10)
		port map(	clk => clk,
				rst => rst,
				s	 => count_mux1,
				a	 => "1111101000",
				b	 => "0111110100",
				c	 => "0011111010",
				d	 => "0011100001",
				e	 => "0011001000",
				f	 => "0010101111",
				g	 => "0010010110",
				x	 => mux_exit1);
							
	timerBall: entity work.univ_bin_counter
		generic map(	N => 10)
		port map(	clk 		=> max_tick,
				rst 		=> rst,
				ena  		=> ena_timerB,
				syn_clr		=> rst_timerB,
				MAX		=> mux_exit1,-- 5000000 en binario
				max_tick 	=> max_tick_B);

	ball: entity work.ball_fms
		generic map(	N => 7)
		port map(	clk 		=> max_tick,
				rst 		=> rst,
				r0_addr_in 	=> w_addr_R0,
				r1_addr_in 	=> w_addr_R1,
				ena_timer 	=> ena_timerB,
				rst_timer 	=> rst_timerB,
				max_tick	=> max_tick_B,
				dataO		=> w_data_B(0),
				addr 		=> w_addr_B,
				gol 		=> gol);
						
--score----------------------------------------------------------------
scoreFMS: entity work.score_fms
	port map(	clk 		=> max_tick_B,
			rst 		=> rst,
			addr_in		=> w_addr_B,
			p_j1		=> p_j1,
			p_j2		=> p_j2,
			gol		=> gol,
			win_j1 		=> win_j1,
			win_j2 		=> win_j2);
	
	scoreJ1: entity work.bin_to_sseg
		port map(	bin => p_j1,
				sseg => p1_ss);
	scoreJ2: entity work.bin_to_sseg
		port map(	bin => p_j2,
				sseg => p2_ss);

end architecture;
