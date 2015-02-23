----------------------------------------------------------------------------------
-- Company: USAFA
-- Engineer: C2C John Terragnoli
-- 
-- Create Date:    16:56:17 01/25/2015 
-- Module Name:    h_synch - Behavioral 
-- Project Name: 	lab01
-- Target Devices: ATLYS spartan 6
-- Description: outputs the desired waveform for h_synch and h_blanck according to the 
--						counter in the vga module
--
-- Dependencies: nothing inside it, but needs the column and row signals in video to operate.     
--
-- Revision: none
-- Revision 0.01 - File Created
-- Additional Comments:  none
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;



entity h_synch is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           column : in  unsigned(11 downto 0);
           h_synch : out  STD_LOGIC;
           h_blank : out  STD_LOGIC);
end h_synch;

architecture Behavioral of h_synch is



begin


--determining the syncing signals for horizontal
--(at the end of each row)
h_synch <= '1' when (column <= x"290") else
				'1' when (column >= x"2F0") else
				'0';
				
h_blank <= '0' when (column < x"280") else
				'1';

end Behavioral;