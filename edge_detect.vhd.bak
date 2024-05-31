LIBRARY ieee;
	USE ieee.std_logic_1164.all;
--------------------------------------------------
ENTITY edge_detect IS
  PORT (	clk       : in std_logic;
			async_sig : in std_logic;
			rise      : out std_logic;
			fall      : out std_logic);
END ENTITY edge_detect;
-----------------------------------------------------
ARCHITECTURE rtl OF edge_detect IS
	SIGNAL shifter : std_logic_vector(1 to 3);
BEGIN
  sync1 : PROCESS(clk)
    VARIABLE resync : std_logic_vector(1 to 3); --SHIFT REGISTER FOR EDGE DETECTION
  BEGIN
    IF (rising_edge(clk)) THEN
      -- detect rising and falling edges.
      rise <= resync(2) AND NOT resync(3);
      fall <= resync(3) AND NOT resync(2);
      -- update history shifter.
      resync := async_sig & resync(1 to 2);
		shifter <= resync;
    end if;
  end process;

end architecture;