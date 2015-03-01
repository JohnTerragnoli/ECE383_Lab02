----------------------------------------------------------------------------------
-- Company:  USAFA
-- Engineer: C2C Terragnoli
-- 
-- Create Date:    23:44:29 02/22/2015 
-- Module Name:    lab2_datapath - Behavioral 
-- Project Name:  lab2
-- Target Devices: ATLYS
-- Tool versions: 1.0
-- Description: Takes in an electrical signal through an aux input and displays the signal
--					on the screen like an amature oscilloscope.   
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




	-- signals for the ac97_wrap
	signal L_bus_in, R_bus_in : std_logic_vector(17 downto 0);
	signal L_bus_out, R_bus_out : std_logic_vector(17 downto 0);

	
	-- signals for the video_inst
	signal row_12bit, column_12bit : unsigned(11 downto 0);
	signal trigger_time, trigger_volt : unsigned(9 downto 0);
	signal trigger_time_12bit, trigger_volt_12bit : unsigned (11 downto 0);  
	signal row, column : unsigned(9 downto 0);
	signal ch1, ch1_enb : std_logic;  
	signal ch2, ch2_enb : std_logic;


	--BRAM signals
	signal write_cntr : unsigned(9 downto 0);
	signal write_cntr_12bit : unsigned (11 downto 0);
	signal readL : std_logic_vector(17 downto 0);
	
	--Trigger Logic Signals
	signal greaterThanTrigger : std_logic;
	signal lessThanTrigger : std_logic; 
	signal newUnsigned, oldUnsigned : unsigned (9 downto 0);  

	
	--Button Signals
	signal old_button, button_activity: std_logic_vector(4 downto 0);
	
	--internal signals for sw, so we can view them with the logic analyzer.  
	signal ready : std_logic; 			--sw(0)
	signal BRAM_over : std_logic; 	--sw(1)
	signal trigger_sw : std_logic; 	--sw(2)

		--misc signals
	signal unsigned_L_bus_out : unsigned(17 downto 0);
	signal aligned_column : unsigned(9 downto 0);



	--for some reason it doesn't trigger correctly, so I have to use this where ever trigger is mentioned.  
	constant trigger_shift : integer := 290; 



begin 


---- the ac97 instantiation-------------------------------------------------------------------------------
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
----------------------------------------------------------------------------------------------------------	
sw(0) <= ready;
		



--Video Instantiation----------------------------------------------------------------------------------------	
	video_inst: video port map(
		clk => clk,
		reset => reset,
		tmds => tmds,
		tmdsb => tmdsb,
		trigger_time => "00"&trigger_time,
--		trigger_volt => "00"&trigger_volt,
		trigger_volt => "00"&trigger_volt-trigger_shift,
		row => row_12bit,
		column => column_12bit,
		ch1 => ch1,
		ch1_enb => '1',
		ch2 => ch2,
		ch2_enb => '1');
row<= row_12bit (9 downto 0); 
column <= column_12bit (9 downto 0);
--
--ch2 <= '1' when (row=column) else
--		'0';  
ch2 <= '1' when (row = 400) else
		'0';  
---------------------------------------------------------------------------------------------------------------	
			
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
			RDADDR => std_logic_vector(aligned_column),		-- Input address, width defined by port depth
			RDCLK => clk,	 				-- 1-bit input clock
			RST => (not reset),				-- active high reset
			RDEN => '1',					-- read enable 
			REGCE => '1',					-- 1-bit input read output register enable - ignored
			DI => std_logic_vector(unsigned_L_bus_out),	-- Input data port, width defined by WRITE_WIDTH parameter
			WE => "11",						-- since RAM is byte read, this determines high or low byte
			WRADDR => std_logic_vector(write_cntr),		-- Input write address, width defined by write port depth
			WRCLK => clk,		 			-- 1-bit input write clock
			WREN => cw(2));				-- 1-bit input write port enable
--			WREN => '1');				-- 1-bit input write port enable
----------------------------------------------------------------------------------------------------------------
	
	
--2Unsigned---------------------------------------------------------------------------------------------------
	unsigned_L_bus_out <= "100000000000000000" + unsigned(L_bus_out);
--------------------------------------------------------------------------------------------------------------



--BRAM Section Logic------------------------------------------------------------------------------------------
	BRAM_count : BRAM_counter 
    Port map ( clk => clk, 
           reset => reset, 
           cw => cw(1 downto 0),
           write_cntr => write_cntr_12bit,
           countOver => BRAM_over);
			  
	write_cntr <= write_cntr_12bit (9 downto 0);
	sw(1) <= BRAM_over;
--------------------------------------------------------------------------------------------------------------




--Trigger Logic-----------------------------------------------------------------------------------------------
		process(ready)	
		begin
			if(rising_edge(ready)) then
				if(reset = '0') then
					newUnsigned <= (others => '0');
				else
					newUnsigned <= (unsigned_L_bus_out(17 downto 8));
				end if;
			end if;
		end process;

		process(ready)
		begin
			if(rising_edge(ready)) then
				if(reset = '0') then
					oldUnsigned <= (others => '0');
				else
					oldUnsigned <= newUnsigned;
				end if;
			end if;
		end process;
	
	
	greaterThan : comparator
	port map (std_logic_vector(newUnsigned), trigger_volt, OPEN, OPEN, greaterThanTrigger); 
	
	
	lessThan : comparator
	port map (std_logic_vector(oldUnsigned), trigger_volt,lessThanTrigger, OPEN, OPEN); 
	
	trigger_sw <= (greaterThanTrigger and lessThanTrigger);
	sw(2) <= trigger_sw;
--------------------------------------------------------------------------------------------------------------
	
	
	
	
	
	
--Bottom Right Comparator-------------------------------------------------------------------------------------
	readLComp : comparator
--	port map (std_logic_vector(unsigned(readL(17 downto 8))-300), row, OPEN, ch1, OPEN); 
--	port map (std_logic_vector(unsigned(readL(17 downto 8))-325), row, OPEN, ch1, OPEN); 
--	port map (std_logic_vector(unsigned(readL(17 downto 8))-200), row, OPEN, ch1, OPEN); 
	port map (std_logic_vector(unsigned(readL(17 downto 8))-trigger_shift), row, OPEN, ch1, OPEN); --original
--	port map (std_logic_vector(unsigned(readL(17 downto 8))-225), row, OPEN, ch1, OPEN); 
--	port map (std_logic_vector(unsigned(readL(17 downto 8))-175), row, OPEN, ch1, OPEN); 
--	port map (std_logic_vector(unsigned(readL(17 downto 8))+10), row, OPEN, ch1, OPEN); --kicks
--	port map (std_logic_vector(unsigned(readL(17 downto 8))), row, OPEN, ch1, OPEN); 
--------------------------------------------------------------------------------------------------------------	
	
	
	
	
	
--senters the trigger time on the screen----------------------------------------------------------------------
	aligned_column <= column - 20;
--------------------------------------------------------------------------------------------------------------




	

	 

	 
----audio loop-----------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------------------------- 

	
--BUTTON LOGIC---------------------------------------------------------------------------------------------	
	--copied from Lab01
	process(clk)
		begin
			if(rising_edge(clk)) then
				if(reset = '0') then
					old_button <= "00000";
				else
					button_activity <= btn and (not old_button);
				end if;
				old_button <= btn;
			end if;
	end process;

	process(clk)
		begin 
			if(rising_edge(clk)) then
				if(reset = '0') then
					trigger_time <= "0101000000";
					trigger_volt <= "0011011100" + trigger_shift;
--					trigger_volt <= "0011011100";
				elsif(button_activity(0) = '1') then		-- move up
					trigger_volt <= trigger_volt - 5;
				elsif(button_activity(1) = '1') then		-- move left
					trigger_time <= trigger_time - 5;
				elsif(button_activity(2) = '1') then		-- move down
					trigger_volt <= trigger_volt + 5;
				elsif(button_activity(3) = '1') then		-- move right
					trigger_time <= trigger_time + 5;
				elsif(button_activity(4) = '1') then		-- return both triggers to center
					trigger_time <= "0101000000";
					trigger_volt <= "0011011100" + trigger_shift;		
--					trigger_volt <= "0011011100";		
				end if;
			end if;
	end process;
----------------------------------------------------------------------------------------------------------------	
	
	

end Behavioral;

