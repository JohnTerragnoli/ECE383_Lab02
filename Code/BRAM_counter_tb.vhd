--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:08:58 02/25/2015
-- Design Name:   
-- Module Name:   C:/Users/C16John.Terragnoli/Documents/Junior year/Academics/Second Semester/ECE 383/ISE Projects/Lab02_startover_a/BRAM_counter_tb.vhd
-- Project Name:  Lab02_startover_a
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: BRAM_counter
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
USE ieee.numeric_std.ALL;
 
ENTITY BRAM_counter_tb IS
END BRAM_counter_tb;
 
ARCHITECTURE behavior OF BRAM_counter_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT BRAM_counter
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         cw : IN  std_logic_vector(1 downto 0);
         write_cntr : OUT  unsigned(11 downto 0);
         countOver : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal cw : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal write_cntr : unsigned(11 downto 0);
   signal countOver : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: BRAM_counter PORT MAP (
          clk => clk,
          reset => reset,
          cw => cw,
          write_cntr => write_cntr,
          countOver => countOver
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;
		
		reset <= '0', '1' after 10 ns; 
		
		cw <= "01";   

      -- insert stimulus here 

      wait;
   end process;

END;
