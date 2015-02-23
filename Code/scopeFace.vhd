----------------------------------------------------------------------------------
-- Company: USAFA
-- Engineer: C2C John Paul Terragnoli
-- 
-- Create Date:    13:58:31 01/22/2015 
-- Module Name:    scopeFace - Behavioral 
-- Project Name: lab01
-- Target Devices: ATLYS Spartan 6
-- Tool versions: 1.0
-- Description: responsible for generating the RBG value of a pixel when given 
--					when given the row, column, and pair.  
--
-- Dependencies: VGA
--
-- Revision: none				
-- Revision 0.01 - File Created
-- Additional Comments: none
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

entity scopeFace is
Port ( row : in  unsigned(11 downto 0);
           column : in  unsigned(11 downto 0);
			  trigger_volt: in unsigned (11 downto 0);
			  trigger_time: in unsigned (11 downto 0);
           r : out  std_logic_vector(7 downto 0);
           g : out  std_logic_vector(7 downto 0);
           b : out  std_logic_vector(7 downto 0);
			  ch1: in std_logic;
			  ch1_enb: in std_logic;
			  ch2: in std_logic;
			  ch2_enb: in std_logic);
end scopeFace;

architecture Behavioral of scopeFace is

signal timeMarker: std_logic; 
signal voltageMarker: std_logic;
signal horizontalGrid: std_logic;
signal verticalGrid: std_logic;
signal grid: std_logic;
signal horizontalHash: std_logic;
signal verticalHash: std_logic;
signal onOScope: std_logic;
signal channel1: std_logic;
signal channel2: std_logic;




begin					
					
r <= 
	x"FF" when (timeMarker = '1') else		--time trigger
	x"FF" when (voltageMarker = '1') else	--volt trigger
	x"FF" when channel1 = '1' else 			--channel one
	x"00" when channel2 = '1' else 			--channel two
	x"FF" when grid = '1' else 				--all of grid
	x"00";
	
		
g <= 
	x"00" when (timeMarker = '1') else		--time trigger
	x"00" when (voltageMarker = '1') else	--volt trigger
	x"FF" when channel1 = '1' else 			--channel one
	x"80" when channel2 = '1' else 			--channel two
	x"FF" when grid = '1' else					--all of grid
	x"00";
		
b <= 

	x"00" when (timeMarker = '1') else		--time trigger
	x"00" when (voltageMarker = '1') else	--volt trigger
	x"00" when channel1 = '1' else 			--channel one
	x"00" when channel2 = '1' else 			--channel two
	x"FF" when  grid = '1' else				--all of grid
	x"00";
	
	

	
	
	

-------------------------------------------------------------------------------------------------------
--SIMPLIFICATION OF PICTURES---------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
horizontalGrid <= '1' when ((column>19) and (column <621) and ((row=20) or (row=70) or (row=120) or (row=170) or 
						(row = 220) or (row = 270) or (row = 320) or (row = 370) or (row=420))) else--horizontal lines
					'0';
					
verticalGrid <= '1' when ((row>20) and (row<421) and ((column = 20) or (column = 80) or (column =140) or (column = 200) or
						(column = 260) or (column =320) or (column = 380) or (column = 440) or (column = 500) or (column = 560) or
						 (column = 620))) else --verticle lines
					'0';
					
horizontalHash <= '1' when (( column > 19) and (column < 621) and (row<223) and (row > 217) and (((column-20) mod 15)=0)) else --horizontal hash
					'0';

verticalHash <= '1' when (( row >19) and (row <421) and (column >317) and (column <323) and (((row-20) mod 10)=0)) else 
					'0';


grid <= '1' when ((horizontalGrid = '1') or (verticalGrid = '1') or (horizontalHash = '1') or (verticalHash = '1'))
			else '0';

onOScope <= '1' when((row>19) and (column>19) and (row<421) and (row <621))
			else '0';


channel1 <= '1' when ((onOScope = '1') and (ch1_enb = '1') and (ch1 = '1')) 
			else '0';

channel2 <= '1' when ((onOScope= '1') and (ch2_enb = '1') and (ch2 = '1')) 
			else '0';

timeMarker <= '1' when (((column > (trigger_time - 3)) and (column < (trigger_time + 3)) and (row = 21)) or
					((column > (trigger_time - 2)) and (column < (trigger_time + 2)) and (row = 22)) or
					((column > (trigger_time - 1)) and (column < (trigger_time + 1)) and (row = 23)) or 
					((column = trigger_time) and (row = 24)))
					else '0';
					
voltageMarker <= '1' when (((row > (trigger_volt - 3)) and (row < (trigger_volt + 3)) and (column = 21)) or
					((row > (trigger_volt - 2)) and (row < (trigger_volt + 2)) and (column = 22)) or
					((row > (trigger_volt - 1)) and (row < (trigger_volt + 1)) and (column = 23)) or 
					((row = trigger_volt) and (column = 24)))
					else '0';
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------					

	
end Behavioral;