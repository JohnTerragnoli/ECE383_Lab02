----------------------------------------------------------------------------------
-- Company: USAFA
-- Engineer: C2C Terragnoli
-- 
-- Create Date:    01:05:49 02/23/2015 
-- Module Name:    comparator_10bit - Behavioral 
-- Project Name:   Lab2
-- Target Devices: ATLYS
-- Tool versions: 1.0
-- Description: a comparator with a less than, equal to, and greater than signal.
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

entity comparator_10bit is
    Port ( Left : in  std_logic_vector (9 downto 0);
           Right : in  unsigned (9 downto 0);
           LessThan : out  STD_LOGIC;
           Equal : out  STD_LOGIC;
           GreaterThan : out  STD_LOGIC);
end comparator_10bit;

architecture Behavioral of comparator_10bit is

begin

	LessThan <= '1' when (unsigned(Left) < Right) else
					'0'; 
					
	Equal <= '1' when (unsigned(Left) = Right) else
				'0'; 
				
	GreaterThan <= '1' when (unsigned(Left) > Right) else
					'0'; 


end Behavioral;

