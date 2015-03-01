------------------------------------------------------------------------------------
-- Engineer:		C2C Sabin Park
-- Create Date:   14:42:11 02/17/2015
-- File Name:		sign2unsign.vhd

-- Description:	converts a signed value into an unsigned one
------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sign2unsign is
	port( A : in std_logic_vector(17 downto 0);
			Y : out unsigned(17 downto 0));
end sign2unsign;

architecture Behavioral of sign2unsign is

begin

	Y <= "100000000000000000" + unsigned(A);

end Behavioral;

