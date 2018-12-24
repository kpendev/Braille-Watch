--One Second clock

library ieee;

use ieee.std_logic_1164.all;



entity second_clk is
  
	port (In_Clk: in std_logic; --internal clock will connect to this port
        
	Out_Clk: out std_logic);

end second_clk;



architecture ECE222_Clock of second_clk is

begin
   
	Process (In_Clk)
      
		Variable cnt : INTEGER RANGE 0 TO 50000000;
   
	Begin
     
	--if on rising edge, increment
      
	IF (rising_edge(In_CLK)) THEN
         
		cnt := cnt + 1;
         
		--internal clock=50MHz, so after 50million times, out_CLK='1';
         
		IF cnt = 50000000 THEN
            
			Out_Clk <= '1';
         
		ELSE
            
			Out_Clk <= '0';
         
		END IF;
      
	END IF;
   
	End Process;

eND ECE222_Clock;

