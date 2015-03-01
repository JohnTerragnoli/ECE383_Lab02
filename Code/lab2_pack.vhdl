--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;

package lab2Parts is

--/////////////////////// AC97 Driver //////////////////////////////////--

component lab2 
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  SDATA_IN : in STD_LOGIC;
			  BIT_CLK : in STD_LOGIC;
			  SYNC : out STD_LOGIC;
			  SDATA_OUT : out STD_LOGIC;
			  AC97_n_RESET : out STD_LOGIC;
  			  tmds : out  STD_LOGIC_VECTOR (3 downto 0);
           tmdsb : out  STD_LOGIC_VECTOR (3 downto 0);
			  btn: in	STD_LOGIC_VECTOR(4 downto 0));
end component;




component ac97 
	port (
		n_reset        : in  std_logic;
		clk            : in  std_logic;
																				-- ac97 interface signals
		ac97_sdata_out : out std_logic;								-- ac97 output to SDATA_IN
		ac97_sdata_in  : in  std_logic;								-- ac97 input from SDATA_OUT
		ac97_sync      : out std_logic;								-- SYNC signal to ac97
		ac97_bitclk    : in  std_logic;								-- 12.288 MHz clock from ac97
		ac97_n_reset   : out std_logic;								-- ac97 reset for initialization [active low]
		ac97_ready_sig : out std_logic; 								-- pulse for one cycle
		L_out          : in  std_logic_vector(17 downto 0);	-- lt chan output from ADC
		R_out          : in  std_logic_vector(17 downto 0);	-- rt chan output from ADC
		L_in           : out std_logic_vector(17 downto 0);	-- lt chan input to DAC
		R_in           : out std_logic_vector(17 downto 0);	-- rt chan input to DAC
		latching_cmd	: in std_logic;
		cmd_addr       : in  std_logic_vector(7 downto 0);		-- cmd address coming in from ac97cmd state machine
		cmd_data       : in  std_logic_vector(15 downto 0) 	-- cmd data coming in from ac97cmd state machine
		);
end component;




--/////////////// STATE MACHINE TO CONFIGURE THE AC97 ///////////////////////////--

component ac97cmd 
	port (
		 clk      			: in  std_logic;
		 ac97_ready_sig   : in  std_logic;
		 cmd_addr 			: out std_logic_vector(7 downto 0);
		 cmd_data 			: out std_logic_vector(15 downto 0);
		 latching_cmd		: out std_logic;
		 volume   			: in  std_logic_vector(4 downto 0);  			-- input for encoder for volume control 0->31
		 source   			: in  std_logic_vector(2 downto 0)); 			-- 000 = Mic, 100=LineIn
end component;


component ac97_wrapper
	port (
		reset        : in  std_logic;
		clk            : in  std_logic;	
		ac97_sdata_out : out std_logic;								-- ac97 output to SDATA_IN
		ac97_sdata_in  : in  std_logic;								-- ac97 input from SDATA_OUT
		ac97_sync      : out std_logic;								-- SYNC signal to ac97
		ac97_bitclk    : in  std_logic;								-- 12.288 MHz clock from ac97
		ac97_n_reset   : out std_logic;								-- ac97 reset for initialization [active low]
		ac97_ready_sig : out std_logic; 								-- pulse for one cycle
		L_out          : in  std_logic_vector(17 downto 0);	-- lt chan output from ADC
		R_out          : in  std_logic_vector(17 downto 0);	-- rt chan output from ADC
		L_in           : out std_logic_vector(17 downto 0);	-- lt chan input to DAC
		R_in           : out std_logic_vector(17 downto 0));	-- rt chan input to DAC
end component;


component lab2_fsm
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  sw: in std_logic_vector(2 downto 0);
			  cw: out std_logic_vector (2 downto 0) );
end component;


component lab2_datapath
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  SDATA_IN : in STD_LOGIC;
			  BIT_CLK : in STD_LOGIC;
			  SYNC : out STD_LOGIC;
			  SDATA_OUT : out STD_LOGIC;
			  AC97_n_RESET : out STD_LOGIC;
			  tmds : out  STD_LOGIC_VECTOR (3 downto 0);
           tmdsb : out  STD_LOGIC_VECTOR (3 downto 0);
			  sw: out std_logic_vector(2 downto 0);
			  cw: in std_logic_vector (2 downto 0);
			  btn: in	STD_LOGIC_VECTOR(4 downto 0);
			  exWrAddr: in std_logic_vector(9 downto 0);
			  exWen, exSel: in std_logic;
			  Lbus_out, Rbus_out: out std_logic_vector(15 downto 0);
			  exLbus, exRbus: in std_logic_vector(15 downto 0);
			  flagQ: out std_logic_vector(7 downto 0);
			  flagClear: in std_logic_vector(7 downto 0);
			  JB : out std_logic_vector(7 downto 0));
end component;


	component video is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           tmds : out  STD_LOGIC_VECTOR (3 downto 0);
           tmdsb : out  STD_LOGIC_VECTOR (3 downto 0);
			  trigger_time: in unsigned(11 downto 0);
			  trigger_volt: in unsigned (11 downto 0);
			  row: out unsigned(11 downto 0);
			  column: out unsigned(11 downto 0);
			  ch1: in std_logic;
			  ch1_enb: in std_logic;
			  ch2: in std_logic;
			  ch2_enb: in std_logic;
			  v_synch_out: out std_logic);
	end component;
	
component bram_sdp is
	Port (	clk: in  STD_LOGIC;
				reset : in  STD_LOGIC;
				cw: std_logic_vector(5 downto 0));
end component;


component counter is
    Port ( clk 	: 	in  STD_LOGIC;
           reset 	: 	in  STD_LOGIC;
           ctrl 	: 	in  STD_LOGIC_vector(1 downto 0);
			  rollover: in  unsigned(9 downto 0);
			  roll	: 	out std_logic;
           Q		: 	out unsigned(9 downto 0));
end component;

component new_counter is
	generic (N: integer := 10);
	Port(	clk: in  STD_LOGIC;
			reset : in  STD_LOGIC;
			ctrl: in std_logic_vector(1 downto 0);
			Q: out unsigned (N-1 downto 0));
end component;

component sign2unsign is
	Port (	A : in std_logic_vector(17 downto 0);
				Y : out unsigned(17 downto 0));
	
end component;



component comparator is
    Port ( Left : in  std_logic_vector (9 downto 0);
           Right : in  unsigned (9 downto 0);
           LessThan : out  STD_LOGIC;
           Equal : out  STD_LOGIC;
           GreaterThan : out  STD_LOGIC);
end component;








component Delay_one_cycle is
	 Generic (N: integer := 8);
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  ready : in std_logic; 
           realTime : in  unsigned (N-1 downto 0);
			  middleSignal : out unsigned (N-1 downto 0);
           delayed : out  unsigned (N-1 downto 0));
end component;

component BRAM_counter is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           cw : in  STD_LOGIC_VECTOR (1 downto 0);
           write_cntr : out  unsigned (11 downto 0);
           countOver : out  STD_LOGIC);
end component;

component flagRegister 
	Generic (N: integer := 8);
	Port(	clk: in  STD_LOGIC;
			reset : in  STD_LOGIC;
			set, clear: in std_logic_vector(N-1 downto 0);
			Q: out std_logic_vector(N-1 downto 0));
end component;



end lab2Parts;
