----------------------------------------------------------------------------------
-- Company:  USAFA
-- Engineer: 	C2C John Terragnoli
-- 
-- Create Date:    21:40:19 02/26/2015 
-- Module Name:    Delay_one_cycle - Behavioral 
-- Project Name: 	Lab02
-- Target Devices: ATLYS
-- Tool versions: Spartan 6
-- Description: Supposed to delay a N bit unsigned signal by 1 clock cycle.  
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




entity Delay_one_cycle is
	 Generic (N: integer := 8);
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  ready : in std_logic; 
           realTime : in  unsigned (N-1 downto 0);
			  middleSignal : out unsigned (N-1 downto 0);
           delayed : out  unsigned (N-1 downto 0));
end Delay_one_cycle;




architecture Behavioral of Delay_one_cycle is

	signal middle : unsigned (9 downto 0);
	
	



begin
	process(ready)
		begin
			if(rising_edge(ready)) then
				if(reset = '0') then 
					middle <= (others => '0');
					middleSignal <= (others => '0');
				else
					middle <= realTime; 	
					middleSignal <= realTime; 
				end if; 
			end if;
	end process;



	process(ready)
		begin
			if(rising_edge(ready)) then
				delayed <= middle;   
			end if;
	end process;







end Behavioral;

