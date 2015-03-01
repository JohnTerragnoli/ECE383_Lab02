----------------------------------------------------------------------------------
-- Company:  USAFA
-- Engineer: C2C John Terragnoli
-- 
-- Create Date:    11:00:55 02/25/2015 
-- Module Name:    BRAM_counter - Behavioral 
-- Project Name: 	Lab02
-- Target Devices: ATLYS
-- Tool versions: Spartan 6
-- Description: is a counter for BRAM.  Should count up to 0x3FF and outputs a rollover signal
--					as well as what value the module is currently on.  It is tailored to receive 
--					and work on the last two bits of the cw from datapath.  
--
-- Dependencies: none
--
-- Revision: none
-- Revision 0.01 - File Created
-- Additional Comments: none
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;


entity BRAM_counter is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           cw : in  STD_LOGIC_VECTOR (1 downto 0);
           write_cntr : out  unsigned (11 downto 0);
           countOver : out  STD_LOGIC);
end BRAM_counter;

architecture Behavioral of BRAM_counter is

	signal processQ  	 : unsigned(11 downto 0);
	
begin

--enter process if clock changes
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(reset = '0' or cw = "00") then
					processQ <= (others => '0');
				
			elsif((processQ < x"3ff") and (cw = "01")) then
					processQ <= processQ + 1;
					
			elsif((processQ = x"3ff") and (cw = "01")) then
					processQ <= (others => '0');
			
			else
					
					
			end if;
		end if;
	end process;
	
	
	write_cntr <= processQ;
	
	
	countOver <= '1' when (processQ = x"3FF") else '0';

end Behavioral;

