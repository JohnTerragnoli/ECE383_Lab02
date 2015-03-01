----------------------------------------------------------------------------------
-- Company:   USAFA
-- Engineer:  C2C John Terragnoli
-- 
-- Create Date:    00:18:10 03/01/2015 
-- Module Name:    flagRegister - Behavioral 
-- Project Name:   Lab02
-- Target Devices: ATLYS
-- Tool versions: Spartan 6
-- Description: needed for lab 03.  Used for outputting required bits into microblaze.  
--
-- Dependencies: LAB02.vhd
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
use work.lab2Parts.all;		



entity flagRegister is
	Generic (N: integer := 8);
	Port(	clk: in  STD_LOGIC;
			reset : in  STD_LOGIC;
			set, clear: in std_logic_vector(N-1 downto 0);
			Q: out std_logic_vector(N-1 downto 0));
end flagRegister;

architecture Behavioral of flagRegister is

	signal Q_internal : std_logic_vector (N-1 downto 0); 


begin

	
		
		process(clk,reset)	
		begin
			if(reset = '0') then
					Q_internal <= (others => '0');
			end if; 
			
			
			--basically should do nothing during this period anyway? 
--			if(clk = '0') then 
--				--Q just stays as Q
--			elsif(clk = '1') then 
--				--Q just stays as Q
--			elsif(falling_edge(clk)) then 
--				--Q just stays as Q
--			end if;
			
			
			if(rising_edge(clk)) then 
				for i in 0 to N-1 loop	
					
					if((set(i) = '0') and (clear(i) ='0')) then 
						--Q just stays as Q
					elsif((set(i)= '1') and (clear(i) ='0')) then
						Q_internal(i) <= '1'; 
					elsif((set(i) = '0') and (clear(i) ='1')) then
						Q_internal(i) <= '0'; 
					elsif((set(i) = '0') and (clear(i)='1')) then
						--don't care about Q.  
					else
						--don't care about Q.  
					end if;
					
				end loop; 
			end if; 
			
			
			
			Q <= Q_internal;
			
			
		end process;
	

end Behavioral;

