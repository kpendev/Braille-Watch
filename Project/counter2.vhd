library ieee;

use ieee.std_logic_1164.all;

use ieee.std_logic_arith.all;

--connect second_clk to CLK

--Choice is for military time vs AM/PM (Military='1', AM/PM='0')

--AM_PM (AM='0') and (PM='1')

--Tune mode activated='1', otherwise deactivated

entity Counter2 is
  
	port(Clk, Tune, IncMin, IncHr: in std_logic;  
       
		choice: in std_logic:='0'; --choose between military time and normal
       
		AM_PM: out std_logic:='0'; --indicator for AM/PM
       
		minute_ones: out std_logic_vector(3 downto 0); -- minute ones digit
       
		minute_tens: out std_logic_vector(2 downto 0); -- minute tens digit
       
		hour_ones: out std_logic_vector(3 downto 0); -- hour ones digit
       
		hour_tens: out std_logic_vector(1 downto 0)); -- hour tens digit

end Counter2;



architecture ECE222_Counter of Counter2 is
    
	signal choice_int: std_logic:='0';

begin
  
	process (Clk, choice, Tune)
  
  
		variable hour_cout_M_ones: integer range 0 to 10:=1; --intermediate counter for the Military time hours
  
		variable hour_cout_M_tens: integer range 0 to 2:=1; --intermediate counter for the Military time hours
  
		variable hour_cout_P_ones: integer range 0 to 10:=1; --intermediate counter for the AM/PM time hours
  
		variable hour_cout_P_tens: integer range 0 to 1:=1; --intermediate counter for the AM/PM time hours
  
		variable minute_count_ones: integer range 0 to 10:=0; --intermediate counter for  the minutes
  
		variable minute_count_tens: integer range 0 to 7:=0; --intermediate counter for  the minutes
  
	begin
    
	if (Tune='0') then --Only if not in tune mode
		if (rising_edge(clk)) then --if on the rising edge
			minute_count_ones:= minute_count_ones + 1; --increment minute
      
			if (minute_count_ones=10) then --reset case for the minute ones
        
				minute_count_ones:=0;
        
				minute_count_tens:= minute_count_tens+1; --increments the tens place
      
			end if;
        
			if (minute_count_ones = 0 and minute_count_tens=6) then --if minutes reach 60, then need to change hours
          
				if (minute_count_ones=0 and minute_count_tens=6 and hour_cout_P_ones =2 and hour_cout_P_tens =1) then --reset case for the AM/PM clock counter
          --roll over to 1:00 after reaching 12:59
					hour_cout_P_ones:=1;
            
					hour_cout_P_tens:=0;
            
				else
          
					hour_cout_P_ones := hour_cout_P_ones +1; --if not reseting, increment
          
					if (hour_cout_P_ones=10) then --if the hour ones reaches 10, increment the tens place and reset ones place
            
						hour_cout_P_ones:=0;
            
						hour_cout_P_tens:=1;
                        
					end if;
          
				end if;
          
				if (minute_count_ones=0 and minute_count_tens=6 and hour_cout_M_ones =3 and hour_cout_M_tens =2) then --reset case for the Military time
          --roll over from 23:59 to 00:00 
					hour_cout_M_ones:=0;
            
					hour_cout_M_tens:=0;
            
				else
          
					hour_cout_M_ones := hour_cout_M_ones +1; --if not reseting, increment
          
					if (hour_cout_M_ones=10) then --if the ones reach 10, reset ones and increment tens
            
						hour_cout_M_ones:=0;
            
						hour_cout_M_tens:=hour_cout_M_tens+1;
          
					end if;
          
				end if;
          
				minute_count_ones := 0; --reset the minutes 
          
				minute_count_tens := 0; --reset the minutes         
        
			end if;
    
		end if;
    end if;
    
	if ((hour_cout_M_tens >= 1 and hour_cout_M_ones >= 2) or (hour_cout_M_tens = 2)) then --determines if it is AM/PM based off of the Military time
            
		AM_PM<='1';
         
	else
            
		AM_PM<='0';
    
	end if;
	  

		--Tune function--If tune mode is on, the counter stops and user can edit AM/PM and Adjust time	  
	if (rising_edge(clk)) then
		if (Tune='1') then
	 --minutes adjustment
	    
			if (IncMin='1') then --if user presses button
        
				minute_count_ones:= minute_count_ones + 1; --increment minute
			
				if (minute_count_ones=10) then --if ones reach 10, reset ones and increment tens
          
					minute_count_ones:=0;
          
					minute_count_tens:= minute_count_tens+1;
          
					if (minute_count_tens = 6) then --if tens reach 6, reset ones and tens
            
						minute_count_ones:=0;
            
						minute_count_tens:=0;
          
					end if;
        
				end if;
	    
			end if;
	    
		--Hours adjustment
	    
			if (IncHr='1') then --if user presses button, increment
	    	 
				hour_cout_M_ones := hour_cout_M_ones +1; --increment military time ones 
	    	 
				hour_cout_P_ones := hour_cout_P_ones +1; --increment normal time ones
        
				if (hour_cout_M_ones=10) then --if military time ones reach 10, reset ones and increment tens
            
					hour_cout_M_ones:=0;
            
					hour_cout_M_tens:=hour_cout_M_tens+1;
        
				end if;
        
				if(hour_cout_M_tens=2 and (hour_cout_M_ones=4)) then --the roll over case for military time, 23:59 to 00:00
            
					hour_cout_M_ones:=0;
            
					hour_cout_M_tens:=0;
        
				end if;
        
				if (hour_cout_P_ones=10) then -- normal time- if the ones reach 10, reset ones and set tens to 1
            
					hour_cout_P_ones:=0;
				
					hour_cout_P_tens:=1;
			
				end if;
        
				if (hour_cout_P_ones = 3 and hour_cout_P_tens=1) then --roll over case for normal time 12:59 to 01:00
            
					hour_cout_P_ones:=1;
            
					hour_cout_P_tens:=0; 
        
				end if;
	    
			end if;
	    
	    
		--changes between military time and AM/PM only if in tune mode 
	    
			if (choice='1') then 
	        
				choice_int<='1';
				
			else
				
				choice_int<='0'; 
			
			end if;
		end if;
	end if;
	  
  
	minute_ones<= conv_std_logic_vector(minute_count_ones, 4); --minute ones(convert from integer to std_logic_vector)
  
	minute_tens<= conv_std_logic_vector(minute_count_tens, 3); --minute tens(convert from integer to std_logic_vector)
	  
	--chooses what to output depending on if user wants AM/PM or MilLitary time
	  
	if (choice_int='1') then --Military Time
	   
		hour_tens <= conv_std_logic_vector(hour_cout_M_tens, 2);
	   
		hour_ones <= conv_std_logic_vector(hour_cout_M_ones, 4);
	   
	else --Normal Time
	   
		hour_tens <= conv_std_logic_vector(hour_cout_P_tens, 2);
	   
		hour_ones <= conv_std_logic_vector(hour_cout_P_ones, 4);
	  
	end if;
	  
  
	end process;

end ECE222_Counter;



