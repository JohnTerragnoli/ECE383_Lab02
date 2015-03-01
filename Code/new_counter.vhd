------------------------------------------------------------------------------------
-- Engineer:		C2C Sabin Park
-- Create Date:   13:08:16 02/18/2015 
-- File Name:		new_counter.vhd

-- Description:	the counter used for ensuring the entire screen is written to BRAM
------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity new_counter is
	generic (N: integer := 4);
	Port(	clk: in  STD_LOGIC;
			reset : in  STD_LOGIC;
			ctrl: in std_logic_vector(1 downto 0);
			Q: out unsigned (N-1 downto 0));
end new_counter;

architecture Behavioral of new_counter is

	signal processQ: unsigned (N-1 downto 0);

begin
	-----------------------------------------------------------------------------
	--		crtl
	--		00			reset
	--		01			count up mod 3ff
	--		10			hold
	--		11			unused
	-----------------------------------------------------------------------------
	process(clk)
	begin
		if (rising_edge(clk)) then		
			if (reset = '0') then
				processQ <= (others => '0');
			elsif (ctrl = "01") then
				processQ <= processQ + 1;
			elsif (ctrl = "00") then
				processQ <= (others => '0');
			end if;
		end if;
	end process;
 
	Q <= processQ;

end Behavioral;

