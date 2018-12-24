--Full watch

library ieee;

use ieee.std_logic_1164.all;



entity Watch is

	port(Clk, Tune, IncMin, IncHr: in std_logic;
		choice, clear: in std_logic;
       
		AM_PM: out std_logic;

		 LCD_RS, LCD_E			: OUT	STD_LOGIC;
		 LCD_RW				: OUT   STD_LOGIC;
		 DATA_BUS			: INOUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
		LCD_ON, LCD_BLON : OUT STD_LOGIC);

end Watch;



architecture ECE222_FinalProject of Watch is
	component Counter2 is
  
		port(Clk, Tune, IncMin, IncHr: in std_logic;  
       
			choice: in std_logic:='0'; --choose between AM/PM
       
			AM_PM: out std_logic:='0'; --shows if it is AM/PM
       
			minute_ones: out std_logic_vector(3 downto 0); --minute ones place
       
			minute_tens: out std_logic_vector(2 downto 0); --minute tens place
       
			hour_ones: out std_logic_vector(3 downto 0); --hour ones place
       
			hour_tens: out std_logic_vector(1 downto 0)); --hour tens place

	end component;


	

Component second_clk is
  
		port (In_Clk: in std_logic;
	
        Out_Clk: out std_logic);

	END Component;

	COMPONENT LCD_Display IS

		PORT(reset, clk_48Mhz			: IN	STD_LOGIC;
		 H0,M0				: IN	STD_LOGIC_VECTOR(3 DOWNTO 0); -- 0 through 9 = 4 bits
		 H1				: IN	STD_LOGIC_VECTOR(1 DOWNTO 0); -- 0, 1, 2
		 M1				: IN	STD_LOGIC_VECTOR(2 DOWNTO 0); -- 0-5
		 LCD_RS, LCD_E			: OUT	STD_LOGIC;
		 LCD_RW				: OUT   STD_LOGIC;
		 DATA_BUS			: INOUT	STD_LOGIC_VECTOR(7 DOWNTO 0));
	END Component;


	Signal CLK_INT: std_logic;	
	SIGNAL h0,m0	: STD_LOGIC_VECTOR(3 DOWNTO 0); -- 0 through 9 = 4 bits
	SIGNAL h1	: STD_LOGIC_VECTOR(1 DOWNTO 0); -- 0, 1, 2
	SIGNAL m1	: STD_LOGIC_VECTOR(2 DOWNTO 0); -- 0-5
begin

	second_clk1 :  second_clk port map(Out_Clk=>CLK_INT, In_Clk=>CLK);
	LCD_ON <= '1';
	LCD_BLON <= '1';
	
Counter1 :  Counter2 port map(Clk=>CLK_INT, Tune=>Tune, IncMin=>IncMin, IncHr=>IncHr, choice=>choice, AM_PM=>AM_PM, minute_ones=>m0, hour_ones=>h0, minute_tens=>m1, hour_tens=>h1);
LCD1 : LCD_Display port map(H0=>h0, H1=>h1, M0=>m0, M1=>m1, reset=>clear, clk_48Mhz=>CLK, LCD_RS=>LCD_RS, LCD_E=>LCD_E, LCD_RW=>LCD_RW, DATA_BUS=>DATA_BUS);

end ECE222_FinalProject;
