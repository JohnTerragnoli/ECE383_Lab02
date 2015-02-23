----------------------------------------------------------------------------------
-- Company: USAFA
-- Engineer: C2C John Terragnoli
-- 
-- Create Date:    17:56:17 01/25/2015 
-- Module Name:    v_synch - Behavioral 
-- Project Name: 	lab01
-- Target Devices: ATLYS spartan 6
-- Description: outputs the desired waveform for v_synch and v_blanck according to the 
--						counter in the vga module
--
-- Dependencies: nothing inside it
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

entity v_synch is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           row : in  unsigned (11 downto 0);
           v_synch : out  STD_LOGIC;
           v_blank : out  STD_LOGIC);
end v_synch;

architecture Behavioral of v_synch is

begin


--actual logic for vertical synch and blank signals. 
v_synch <= '1' when (row < x"1EA") else
				'1' when (row >= x"1EC") else
				'0';
				
v_blank <= '0' when (row < x"1E0") else
				'1';


end Behavioral;