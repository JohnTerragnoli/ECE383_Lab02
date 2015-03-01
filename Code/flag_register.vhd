------------------------------------------------------------------------------------
-- Engineer:		C2C Sabin Park
-- Create Date:   14:43:25 02/19/2015 
-- File Name:		flag_register.vhd

-- Description:	interfaces the lab 2 components with a microBlaze by setting or
--						clearing bits by the lab 2 components and the microBlaze
------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity flag_register is
	Generic (N: integer := 8);
	Port(	clk: in  STD_LOGIC;
			reset : in  STD_LOGIC;
			set, clear: in std_logic_vector(N-1 downto 0);
			Q: out std_logic_vector(N-1 downto 0));
end flag_register;

architecture Behavioral of flag_register is

	signal Q_old : std_logic_vector(N-1 downto 0);

begin

	process(clk)
	begin
		if(rising_edge(clk)) then
			if(reset = '0') then
				Q_old <= (others => '0');
			end if;
		end if;
			
			for i in 0 to N-1 loop
				if(set(N) = clear(N)) then
					Q_old(N) <= Q_old(N);	-- essentially do nothing
				elsif(set(N) = '1') then
					Q_old(N) <= '1';			-- set the bit
				elsif(clear(N) = '1') then
					Q_old(N) <= '0';			-- clear the bit
				end if;
			end loop;

	end process;
	
	Q <= Q_old;

end Behavioral;

