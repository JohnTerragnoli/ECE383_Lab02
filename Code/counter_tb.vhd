--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:12:50 02/19/2015
-- Design Name:   
-- Module Name:   C:/Users/C16Sabin.Park/Documents/Classes/Semester 6/ECE 383/ISE Projects/Labs/Lab_2/counter_tb.vhd
-- Project Name:  Lab_2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: new_counter
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY counter_tb IS
END counter_tb;
 
ARCHITECTURE behavior OF counter_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT new_counter
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         ctrl : IN  std_logic_vector(1 downto 0);
         Q : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    
	 component lab2_fsm is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  sw: in std_logic_vector(2 downto 0);
			  cw: out std_logic_vector (2 downto 0) );
	end component;

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '1';
   signal ctrl : std_logic_vector(1 downto 0) := (others => '0');
	
	signal sw : std_logic_vector(2 downto 0);

 	--Outputs
   signal Q : std_logic_vector(3 downto 0);
	
	signal cw : std_logic_vector(2 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	constant ready_period :time := 80 ns;
	
	signal ready : std_logic := '0';
	
	signal cw_temp : std_logic_vector(2 downto 0) := (others => "000");
	signal sw_temp : std_logic_vector(2 downto 0) := (others => "000");
 
BEGIN

 
	-- Instantiate the Unit Under Test (UUT)
   uut: new_counter PORT MAP (
          clk => clk,
          reset => reset,
          ctrl => ctrl,
          Q => Q
        );
		  
	fsm : lab2_fsm port map (clk, reset, sw_temp, cw_temp);


   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
	   -- Clock process definitions
   process
   begin
		ready <= '0';
		wait for clk_period*4;
		ready <= '1';
		wait for clk_period*4;
   end process;
 
	-- sets sw(0)
	-- the ready signal
	process
	begin
		sw_temp(0) <= '0';
		wait for clk_period*4;
		sw_temp(0) <= '1';
		wait for clk_period*4;
	end process;

	sw_temp(1) <= '1' when Q >= "1111111111" else '0';

   -- Stimulus processdd
   stim_proc: process
   begin		
      wait for ready_period*2

		sw

      wait;
   end process;

END;
