----------------------------------------------------------------------------------
-- Company:   USAFA 
-- Engineer: C2C John Paul Terragnoli
-- 
-- Create Date:    13:57:28 01/22/2015 
-- Module Name:    vga - Behavioral 
-- Project Name:   Lab01
-- Target Devices: ATLYS Spartan 6
-- Tool versions: 1.0
-- Description: Counts through all of the pixels on the screen and determines the RGB
--					value for each pixel.  Takes care of all the horizontal and vertical 
--					syncs on the screen to ensure the image is displayed correctly.  
--
-- Dependencies: cascadeCounter, counter, h_synch, v_synch, and scopeFace
--
-- Revision:     none
-- Revision 0.01 - File Created
-- Additional Comments: none
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

entity vga is
Port(	clk: in  STD_LOGIC;
			reset : in  STD_LOGIC;
			h_sync : out  STD_LOGIC;
			v_sync : out  STD_LOGIC; 
			blank : out  STD_LOGIC;
			r: out STD_LOGIC_VECTOR(7 downto 0);
			g: out STD_LOGIC_VECTOR(7 downto 0);
			b: out STD_LOGIC_VECTOR(7 downto 0);
			trigger_time: in unsigned(11 downto 0);
			trigger_volt: in unsigned (11 downto 0);
			row: out unsigned(11 downto 0);
			column: out unsigned(11 downto 0);
			ch1: in std_logic;
			ch1_enb: in std_logic;
			ch2: in std_logic;
			ch2_enb: in std_logic);
end vga;

architecture Behavioral of vga is

signal columnNumber, rowNumber: unsigned (11 downto 0);

--middle synch and blank signals;
signal h_synch_signal, h_blank_signal: std_logic;
signal v_synch_signal, v_blank_signal: std_logic;





--preparing the digit counter to be used.  
component counter_glue is 
		Port(	clk: in  STD_LOGIC;
			reset : in  STD_LOGIC;
			crtl: in std_logic;
			countA1 : out unsigned (11 downto 0);
			countA0 : out unsigned (11 downto 0));
	end component;	
	
	
	
	
	
component h_synch is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           column : in  unsigned (11 downto 0);
           h_synch : out  STD_LOGIC;
           h_blank : out  STD_LOGIC);
end component;


component v_synch is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           row : in  unsigned (11 downto 0);
           v_synch : out  STD_LOGIC;
           v_blank : out  STD_LOGIC);
end component;

COMPONENT scopeFace is
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
end COMPONENT;
	
	
begin


--combined the columns and the glue
--should count through all of the pixels on the screen according to the clock.
--returns the row and column number for the rest of this module to use.  
		doubleCounter: counter_glue port map(
			clk => clk,
			reset => reset,
			crtl => '1',
			countA1 => rowNumber,
			countA0 => columnNumber);

--makes the h_synch box
--ensures that horizontal sync occurs
		h_synch_component: h_synch port map(
			clk => clk,
          reset => reset,
          column => columnNumber,
          h_synch => h_synch_signal,
          h_blank => h_blank_signal);

--makes the v_synch box
--ensures that vertical sync occurs
		v_synch_component: v_synch port map(
			clk => clk,
          reset => reset,
          row => rowNumber,
          v_synch => v_synch_signal,
          v_blank => v_blank_signal);


--makes the colors happen appropriately to draw desired images on the screen. 
--also has signals for how to draw basic parts of the screen (EX the grid) 
		scopeface_1 : scopeFace port map (
			  row => rowNumber,
           column => columnNumber,
			  trigger_volt => trigger_volt,
			  trigger_time => trigger_time,
           r => r,
           g => g, 
           b => b, 
			  ch1 => ch1,
			  ch1_enb => ch1_enb,
			  ch2 => ch2,
			  ch2_enb => ch2_enb);

			 


--outputs: 
row <= rowNumber;
column <= columnNumber;

blank <= (h_blank_signal or v_blank_signal);
h_sync <= h_synch_signal;
v_sync <= v_synch_signal;


end Behavioral;