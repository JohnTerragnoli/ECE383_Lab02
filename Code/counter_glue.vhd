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
-- Changes: Made for arbitrary length counters 1/25/15
-- Purpose: to link two mod-5 digit counters, with one to operate as the least
--	significan number and the other as the most significant number. Each number can be
--	up to 12 bits long.  
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--necessary to use unsigned numbers and the math operations that go with them.  
use IEEE.NUMERIC_STD.ALL;
--setting up the inputs and outputs of the system.  


entity counter_glue is
    Port ( clk	: 	in STD_LOGIC;
			  reset: in STD_LOGIC;
           crtl: 	in  STD_LOGIC;
           countA1 : out unsigned(11 downto 0);
           countA0 : out unsigned(11 downto 0));
end counter_glue;

------------------------------------------------------------------------------------
-- ARCHITECTURE
------------------------------------------------------------------------------------
	architecture Behavioral of counter_glue is
	
	
	component counter
		Port ( clk: 	in  STD_LOGIC;
				 reset: 	in  STD_LOGIC;
				 crtl	: 	in  STD_LOGIC;
				 valueCountTo:  in  unsigned(11 downto 0);
				 roll	:  out std_logic;
				 Q	: 	out unsigned(11 downto 0));
	end component;
	
	
	--just the internal rollovers of the individual counters
	--the second will just be thrown out unless 3 digis are desired. 
	signal roll1, roll0: std_logic;

begin

--instantiations of the individual counters.
	Q0 : counter port map (
		clk => clk,
		reset => reset,
		crtl => crtl,
		valueCountTo => x"31F",
		roll => roll0,
		Q => countA0 );
	
--rollover from the first one triggers the control signal in the next
	Q1 : counter port map (
		clk => clk,
		reset => reset,
		crtl => roll0,
		valueCountTo => x"20C",
		roll => roll1,
		Q => countA1);
	
end Behavioral;
