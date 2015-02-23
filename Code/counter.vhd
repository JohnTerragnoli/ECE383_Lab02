--------------------------------------------------------------------------------
-- Name:	Chris Coulston
-- Date:	Jan 10, 2015
-- File:	lec04.vhdl
-- HW:	Lecture 4
--	Crs:	ECE 383
-- Purp:	testbench for lec4.vhdl
-------------------------------------------------------------------------------
--	Edited: by C2C John Paul Terragnoli
-- Changes: Removed junk signals.  1/15/15
-- Purpose: to link two mod-5 digit counters, with one to operate as the least
--	significan digit and the other as the most significant digit.  
--------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--	Edited: by C2C John Paul Terragnoli
-- Changes: Made the counter able to count to an inputted value.  1/25/15
-- Purpose: For this counter to add 1 to its count on each rising edge of the clock.  
-- 			should be able to do this for an arbitrary number value given to the module.  
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter is
    Port ( clk : 	in  STD_LOGIC;
					reset: 	in  STD_LOGIC;
					crtl: 	in  STD_LOGIC;
					valueCountTo: in  unsigned(11 downto 0);
					roll: 	out std_logic;
					Q	: 	out unsigned(11 downto 0));
end counter;

	architecture Behavioral of counter is

--internal signal which holds the value of the digit 
--until it is ready to be outputted.  
	signal processQ  	 : unsigned(11 downto 0);

-----------------------------------------------------------------------------
-- Control Key
-- 0 and the counter will stick and not count anymore
-- 1 and the counter will keep counting up. 

-- Reset
-- 0 = will start the counter over at zero again
-- 1 = will allow the counter to keep counting.   	
-----------------------------------------------------------------------------



begin
--enter process if clock changes
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(reset = '0') then
					--sets the digit to zero if it is reset
					processQ <= (others => '0');
			elsif((processQ < valueCountTo) and (crtl = '1')) then
					--keeps counting 
					processQ <= processQ + 1;
			elsif((processQ = valueCountTo) and (crtl = '1')) then
			--initiates a roll over
					processQ <= (others => '0');
			end if;
		end if;
	end process;
	
	Q <= processQ;
	--logic if weather a roll over should occur or not.  This will turn into 
	--the control signal for the next counter unit.  
	roll <= '1' when (processQ = valueCountTo) and (crtl = '1') else '0';
	

end Behavioral;