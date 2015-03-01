----------------------------------------------------------------------------------
-- Company: USAFA
-- Engineer: C2C Terragnoli
-- 
-- Create Date:    17:27:13 02/17/2015 
-- Module Name:    lab2_fsm - Behavioral 
-- Project Name: 	lab2
-- Target Devices:  ATLYS
-- Tool versions: N/A
-- Description: serves as the control unit for the oscilloscope
--
-- Dependencies: lab2 and lab2_datapath
--
-- Revision:  none
-- Revision 0.01 - File Created
-- Additional Comments: none
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity lab2_fsm is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           sw : in  STD_LOGIC_VECTOR (2 downto 0);
           cw : out  STD_LOGIC_VECTOR (2 downto 0));
end lab2_fsm;

architecture Behavioral of lab2_fsm is



--creates the different types of states
type stateType is (resetState, waitTrigger, storeSample, waitNextSample); 
signal state: stateType; 






begin


--CW Table-----------------------------------------------------------------------
--CW(0XX) = exSel off
--CW(1XX) = exSel on
--CW(X00) = reset counter
--CW(X01) = count up
--CW(X10) = hold
--CW(X11) = **not used**
---------------------------------------------------------------------------------


--NEXT STATE LOGIC
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(reset = '0') then 
				state <= resetState;
			else 
			
			
				CASE state is 

					when resetState =>
						cw <= "000"; 
						state <= waitTrigger;
					
					
					when waitTrigger =>
						cw <= "000"; 
						if(sw(2) = '1') then 
							state <= storeSample; 
						else
							state <= waitTrigger;
						end if; 

					
					when storeSample =>
						cw <= "101";  
	--					cw <= "010";  
						state <= waitNextSample; 
					
					
					when waitNextSample =>
						cw <= "010";
	--					cw <= "101";
						if(sw(0) = '1') then 
							state <= storeSample; 
						elsif(sw(1) = '1') then 
							state <= waitTrigger;
						else
							state <= waitNextSample; 
						end if; 
					end case; 
				end if; 
		end if;
	end process;


end Behavioral;

