------------------------------------------------------------------------------------
-- Engineer:		C2C Sabin Park
-- Create Date:   23:19:22 02/19/2015
-- File Name:		control_unit_tb.vhd

-- Description:	testbench for the control unit
------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY control_unit_tb IS
END control_unit_tb;
 
ARCHITECTURE behavior OF control_unit_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT lab2_fsm
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         sw : IN  std_logic_vector(2 downto 0);
         cw : OUT  std_logic_vector(2 downto 0)
        );
    END COMPONENT;
	
	component new_counter is
		generic (N: integer := 4);
		Port(	clk: in  STD_LOGIC;
				reset : in  STD_LOGIC;
				ctrl: in std_logic_vector(1 downto 0);
				Q: out unsigned (N-1 downto 0));
	end component;

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal sw : std_logic_vector(2 downto 0) := (others => '0');

 	--Outputs
   signal cw : std_logic_vector(2 downto 0) := (others => '0');
	signal Q : unsigned(9 downto 0) := (others => '0');
	
	--Intermediary
	signal ready : std_logic := '0';

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: lab2_fsm PORT MAP (
          clk => clk,
          reset => reset,
          sw => sw,
          cw => cw
        );
		  
	new_cnt: new_counter
		generic map(10)
		port map(clk, reset, cw(1 downto 0), Q);

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;

   -- Ready process definitions
   ready_process :process
   begin
		ready <= '0';
		wait for clk_period*4;
		ready <= '1';
		wait for clk_period;
   end process;
 
	sw(0) <= ready;
	sw(1) <= '1' when Q = "1111111111" else '0';
	sw(2) <= '1' when (Q = "0000000000" and cw(1 downto 0) = "00") else '0';

   -- Stimulus process
   stim_proc: process
   begin		

      wait for clk_period*2;
		
		reset <= '1';

      wait;
   end process;

END;
