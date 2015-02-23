----------------------------------------------------------------------------------
-- Company:  USAFA
-- Engineer: C2C Terragnoli
-- 
-- Create Date:    23:44:29 02/22/2015 
-- Module Name:    lab2_datapath - Behavioral 
-- Project Name:  lab2
-- Target Devices: ATLYS
-- Tool versions: 1.0
-- Description: Carrys out all of the work of the oscilloscope, puts the signal onto a monitor.  
--
-- Dependencies: control unit.  
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
library UNIMACRO;
use UNIMACRO.vcomponents.all;
use work.lab2Parts.all;		



entity lab2_datapath is
	Port(	clk : in  STD_LOGIC;
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
end lab2_datapath;

architecture Behavioral of lab2_datapath is




	--AC97 hookup signals
	signal L_bus_in, R_bus_in : std_logic_vector(17 downto 0);
	signal L_bus_out, R_bus_out : std_logic_vector(17 downto 0);
	
	--BRAM hookup signals: 
	signal readL : std_logic_vector(17 downto 0);
	signal tempReadL: std_logic_vector(17 downto 0); 
	signal wENB : std_logic; 
	
	--BRAM counter signals: 
	signal BRAM_count_reset: std_logic; 
	signal BRAM_count_cntr: std_logic; 
	signal BRAM_counting : unsigned (9 downto 0); 
	signal write_cntr : unsigned(9 downto 0);
	signal write_cntr_counter : unsigned(11 downto 0);
	signal WRADDR : unsigned (9 downto 0); 
	
	
	
	--video hookup signals
	signal row_12bit, column_12bit : unsigned(11 downto 0);
	signal row, column : unsigned(9 downto 0);
	signal trigger_time, trigger_volt : unsigned(11 downto 0);
	signal ch1, ch1_enb : std_logic; 
	signal ch2, ch2_enb : std_logic;
	
	--unsigned input
	signal unsigned_L_bus_out : unsigned(17 downto 0);
	signal Din : unsigned (17 downto 0); 
	
	
	--button decoder signals: 
	signal old_button, button_activity: std_logic_vector(4 downto 0);
	
	--trigger Logic: 
	signal newCompare : unsigned (9 downto 0); 
	signal oldCompare : unsigned (9 downto 0); 
	signal unsigned_L_bus_greater, old_unsigned_L_bus_less: std_logic; 
	
	
	--sw signals
	signal ready : std_logic;			--sw(0)
	signal countOver: std_logic; 		--sw(1)
	--comes from trigger logic 		--sw(2)
	

	
	
	
	
	

begin

--ac97 instant--------------------------------------------------------------------------------------------------
	-- the ac97 instantiation
	ac97_wrap: ac97_wrapper port map(
		reset => reset,
		clk => clk,
		ac97_sdata_out => SDATA_OUT,
		ac97_sdata_in => SDATA_IN,
		ac97_sync => SYNC,
		ac97_bitclk => BIT_CLK,
		ac97_n_reset => AC97_n_RESET,
		ac97_ready_sig => ready,
		L_out => L_bus_in,
		R_out => R_bus_in,
		L_in => L_bus_out,
		R_in => R_bus_out);
		
sw(0) <= ready;
----------------------------------------------------------------------------------------------------------------





--BRAM instant--------------------------------------------------------------------------------------------------
    sampleMemory: BRAM_SDP_MACRO
		generic map (
			BRAM_SIZE => "18Kb", 				-- Target BRAM, "9Kb" or "18Kb"
			DEVICE => "SPARTAN6", 				-- Target device: "VIRTEX5", "VIRTEX6", "SPARTAN6"
			DO_REG => 0, 							-- Optional output register disabled
			INIT => X"000000000000000000",	-- Initial values on output port
			INIT_FILE => "NONE",					-- Not sure how to initialize the RAM from a file
			WRITE_WIDTH => 18, 					-- Valid values are 1-36
			READ_WIDTH => 18, 					-- Valid values are 1-36
			SIM_COLLISION_CHECK => "NONE",	-- Simulation collision check
			SRVAL => X"000000000000000000")	-- Set/Reset value for port output
		port map (
			DO => readL,					-- Output read data port, width defined by READ_WIDTH parameter
--			DO => OPEN,					-- Output read data port, width defined by READ_WIDTH parameter
			RDADDR => std_logic_vector(column),		-- Input address, width defined by port depth
			RDCLK => clk,	 				-- 1-bit input clock
			RST => (not reset),				-- active high reset
			RDEN => '1',					-- read enable 
			REGCE => '1',					-- 1-bit input read output register enable - ignored
			DI => std_logic_vector(Din),	-- Input data port, width defined by WRITE_WIDTH parameter
			WE => "11",						-- since RAM is byte read, this determines high or low byte
			WRADDR => std_logic_vector(WRADDR),		-- Input write address, width defined by write port depth
			WRCLK => clk,		 			-- 1-bit input write clock
			WREN => cw(2));				-- 1-bit input write port enable
----------------------------------------------------------------------------------------------------------------







--VIDEO instant-------------------------------------------------------------------------------------------------
	video_inst: video port map(
		clk => clk,
		reset => reset,
		tmds => tmds,
		tmdsb => tmdsb,
		trigger_time => trigger_time,
		trigger_volt => trigger_volt,
		row => row_12bit,
		column => column_12bit,
		ch1 => ch1,
		ch1_enb => '1',
		ch2 => ch2,
		ch2_enb => '1');
		
--make that diagonal line.  
ch2 <= '1' when (row_12bit = column_12bit) else
		'0';	
----------------------------------------------------------------------------------------------------------------





-----------------------------------------------------------------------------------------------
----BUTTON DECODER START
-----------------------------------------------------------------------------------------------
--makes it work with just one click and not a press so it doesn't run across the screen. 	
process(clk)
	begin
	if(rising_edge(clk)) then
		if(reset = '0') then
			old_button <= "00000";
		else
			button_activity <= (not old_button) and btn;
		end if;
			old_button <= btn;
	end if;
end process;



--checks to see if a button has been hit for every clock cycle.  		
	process(clk)
	begin
		if(rising_edge(clk)) then
			--centers the triggers again.  
			if(reset='0') then
				trigger_time <= x"140";
				trigger_volt <= x"0DC";
				
			--moves volt trigger up
			elsif((button_activity = "00001") and (trigger_volt>=30)) then
				trigger_volt <= trigger_volt - x"0A";
				
			--move time trigger left
			elsif((button_activity= "00010") and (trigger_time>=30)) then
				trigger_time <= trigger_time - x"0A";
				
			--moes volt trigger down
			elsif((button_activity = "00100") and (trigger_volt<=410)) then
				trigger_volt <= trigger_volt + x"0A";
			
			--moves time trigger right
			elsif((button_activity = "01000") and (trigger_time<=610))then
				trigger_time <= trigger_time + x"0A";
			
			--moves the triggers back to center.  
			elsif(button_activity = "10000") then
				trigger_time <= x"140";
				trigger_volt <= x"0DC";
				
			end if;
		end if;
	end process;
---------------------------------------------------------------------------------------------
--BUTTON DECODER END
---------------------------------------------------------------------------------------------









--Signed2Unsign Mux---------------------------------------------------------------------------------------------
unsigned_L_bus_out <= "100000000000000000" + unsigned(L_bus_out);
--implement someday, keep it simple for now.  
Din <= unsigned_L_bus_out; 
----------------------------------------------------------------------------------------------------------------





--AudioLoop-----------------------------------------------------------------------------------------------------
  process (clk)
	begin
	if (rising_edge(clk)) then
	    if reset = '0' then
		L_bus_in <= (others => '0');
		R_bus_in <= (others => '0');				
	    elsif(ready = '1') then
		L_bus_in <= L_bus_out;
		R_bus_in <= R_bus_out;
	    end if;
	end if;
  end process;
----------------------------------------------------------------------------------------------------------------







--wENB Mux BRAM-------------------------------------------------------------------------------------------------
wENB <= cw(2); 
----------------------------------------------------------------------------------------------------------------




--BRAM Counter--------------------------------------------------------------------------------------------------
--BRAM_count_reset <= '0' when (cw(1 downto 0) = "00") else
--							'1'; 
--							
--BRAM_count_cntr <= '1' when (cw(1 downto 0) = "01") else
--						'0' when (cw (1 downto 0) = "10") else
--						'1'; 


  process (clk)
	begin
	if (rising_edge(clk)) then
	    if reset = '0' then
			BRAM_count_reset <= '0'; 
	    elsif(cw(1 downto 0) = "00") then
			BRAM_count_reset <= '0'; 
		 elsif(cw(1 downto 0) = "01") then
			BRAM_count_cntr <= '1';
		 elsif(cw(1 downto 0) = "10") then
			BRAM_count_cntr <= '0';
	    end if;
	end if;
  end process;				
						

--BRAM_count : counter
--		port map (clk, BRAM_count_reset, BRAM_count_cntr, x"3FF", countOver, write_cntr_counter);

	process(clk)
	begin
		if(rising_edge(clk)) then
			if(reset = '0') then
					BRAM_counting <= (others => '0');
			elsif(BRAM_count_reset = '0') then
					BRAM_counting <= (others => '0');
			elsif((BRAM_counting < x"3ff") and (BRAM_count_cntr = '1')) then
					BRAM_counting <= BRAM_counting + 1;
			elsif((BRAM_counting = x"3ff") and (BRAM_count_cntr = '1')) then
					BRAM_counting <= (others => '0');
			end if;
		end if;
	end process;
	
	countOver <= '1' when (BRAM_counting = x"3ff") and (BRAM_count_cntr = '1') else '0';

--write_cntr <= write_cntr_counter(9 downto 0); 	
--	
--sw(1) <= countOver; 

write_cntr <= BRAM_counting; 	
	
sw(1) <= countOver; 
----------------------------------------------------------------------------------------------------------------




--BRAM Counter Mux----------------------------------------------------------------------------------------------
--make it fancier later.  
WRADDR <= write_cntr; 
----------------------------------------------------------------------------------------------------------------




--Trigger Logic-------------------------------------------------------------------------------------------------
process(clk)
	begin
	if(rising_edge(clk)) then
		if(reset = '0') then
			newCompare <= "0000000000"; 
		else
			newCompare <= unsigned_L_bus_out(17 downto 8); 
		end if; 
	end if;
end process;

process(clk)
	begin
	if(rising_edge(clk)) then
		if(reset = '0') then
			oldCompare <= "0000000000"; 
		else
			oldCompare <= newCompare; 
		end if; 
	end if;
end process;


greaterTrigger : comparator_10bit
	port map (std_logic_vector(newCompare), trigger_volt (9 downto 0), OPEN, OPEN, unsigned_L_bus_greater); 
	
lessTrigger : comparator_10bit
	port map (std_logic_vector(oldCompare), trigger_volt (9 downto 0), old_unsigned_L_bus_less, OPEN, OPEN); 
	
sw(2) <= (unsigned_L_bus_greater and old_unsigned_L_bus_less); 

--sw(2) <= '1';
----------------------------------------------------------------------------------------------------------------







--ReadL Compare-------------------------------------------------------------------------------------------------
	readLComp : comparator_10bit 
		port map (readL(17 downto 8), row, OPEN, ch1, OPEN); 
----------------------------------------------------------------------------------------------------------------



--not using this right now.  
JB <= "00000000"; 




end Behavioral;

