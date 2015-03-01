------------------------------------------------------------------------------------
-- Engineer:		C2C Sabin Park
-- Create Date:   00:06:07 02/22/2015  
-- File Name:		flag_register_tb.vhd

-- Description:	testbench for the flag register
------------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY flag_register_tb IS
END flag_register_tb;
 
ARCHITECTURE behavior OF flag_register_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT flag_register
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
	
	--Intermediary
	
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: flag_register PORT MAP (
          clk => clk,
          reset => reset,
          set => set,
          clear => clear,
          Q => OPEN
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

      -- insert stimulus here 

      wait;
   end process;

END;
