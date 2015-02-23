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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
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
type state is (resetState, waitTrigger, storeSample, waitNextSample); 
signal CurrentState: state; 






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
				CurrentState <= resetState;
			end if; 
			
			
			CASE CurrentState is 

				when resetState =>
					cw <= "000"; 
					CurrentState <= waitTrigger;
				
				
				when waitTrigger =>
					cw <= "000"; 
					if(sw(2) = '1') then 
						CurrentState <= storeSample; 
					else
						CurrentState <= waitTrigger;
					end if; 

				
				when storeSample =>
					cw <= "101";  
					currentState <= waitNextSample; 
				
				
				when waitNextSample =>
					cw <= "010";
					if(sw(0) = '1') then 
						CurrentState <= storeSample; 
					elsif(sw(1) = '1') then 
						CurrentState <= waitTrigger;
					else
						CurrentState <= waitNextSample; 
					end if; 
	
	
				end case; 
		end if;
	end process;


end Behavioral;

