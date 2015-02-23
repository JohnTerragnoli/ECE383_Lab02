library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNIMACRO;
use UNIMACRO.vcomponents.all;
use work.lab2Parts.all;		


entity lab2 is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  SDATA_IN : in STD_LOGIC;
			  BIT_CLK : in STD_LOGIC;
			  SYNC : out STD_LOGIC;
			  SDATA_OUT : out STD_LOGIC;
			  AC97_n_RESET : out STD_LOGIC;
  			  tmds : out  STD_LOGIC_VECTOR (3 downto 0);
           tmdsb : out  STD_LOGIC_VECTOR (3 downto 0);
			  btn: in	STD_LOGIC_VECTOR(4 downto 0);
			  JB : out std_logic_vector(7 downto 0));
end lab2;

architecture behavior of lab2 is

	signal sw: std_logic_vector(2 downto 0);
	signal cw: std_logic_vector (2 downto 0);

	
begin


	
	datapath: lab2_datapath port map(
		clk => clk,
		reset => reset,
		SDATA_IN => SDATA_IN,
		BIT_CLK => BIT_CLK,
		SYNC => SYNC,
		SDATA_OUT => SDATA_OUT,
		AC97_n_RESET => AC97_n_RESET,
		tmds => tmds,
		tmdsb => tmdsb,
		sw => sw,
		cw => cw,
		btn => btn, 
		exWrAddr => "0000000000",
		exWen => '0',
		exSel => '0',
		Lbus_out => OPEN,
		Rbus_out => OPEN,
		exLbus => "0000000000000000",
		exRbus => "0000000000000000",		
		flagQ => OPEN,
		flagClear => "00000000",
		JB => JB);
		
			  
	control: lab2_fsm port  map( 
		clk => clk,
		reset => reset,
		sw => sw,
		cw => cw);

end behavior;