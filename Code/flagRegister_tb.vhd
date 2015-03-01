--------------------------------------------------------------------------------
-- Company: 			USAFA
-- Engineer:		C2C John Terragnoli
--
-- Create Date:   01:16:43 03/01/2015
-- Module Name:   C:/Users/C16John.Terragnoli/Documents/Junior year/Academics/Second Semester/ECE 383/ISE Projects/Lab02_startover_b/flagRegister_tb.vhd
-- Project Name:  Lab02_startover_b
-- Target Device:  ATLYS
-- Tool versions:  Spartan 6
-- Description:   should test the flagRegister for all cases.  
-- 
-- VHDL Test Bench Created by ISE for module: flagRegister
-- 
-- Dependencies: flagRegister.vhd
-- 
-- Revision:   none
-- Revision 0.01 - File Created
-- Additional Comments:none
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY flagRegister_tb IS
END flagRegister_tb;
 
ARCHITECTURE behavior OF flagRegister_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT flagRegister
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         set : IN  std_logic_vector(7 downto 0);
         clear : IN  std_logic_vector(7 downto 0);
         Q : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal set : std_logic_vector(7 downto 0) := (others => '0');
   signal clear : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal Q : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: flagRegister 
		PORT MAP (
          clk => clk,
          reset => reset,
          set => set,
          clear => clear,
          Q => Q
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
		
		reset <= '1'; 
		 
		set <= "00000000", "00000000" after 15 ns, "11111111" after 25 ns, "00000000"  after 35 ns;
		clear <= "00000000", "11111111" after 15 ns, "00000000" after 25 ns, "11111111"  after 35 ns;
		

      wait;
   end process;

END;
