LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY debounce IS
	GENERIC(clk_freq    : INTEGER := 50000000;  
           stable_time : INTEGER := 10);         
	PORT(clk, reset, button : IN  STD_LOGIC;  
		  result             : OUT STD_LOGIC); 
END debounce;

ARCHITECTURE logic OF debounce IS
  SIGNAL flipflops   : STD_LOGIC_VECTOR(1 DOWNTO 0);  
  SIGNAL counter_set : STD_LOGIC;                     

BEGIN

  counter_set <= flipflops(0) xor flipflops(1);   
  
  PROCESS(clk, reset)
    VARIABLE count :  INTEGER RANGE 0 TO clk_freq*stable_time/1000;   

  BEGIN
    IF(reset = '1') THEN                            
      flipflops(1 DOWNTO 0) <= "00";                  
      result <= '0';                                  
    ELSIF(clk'EVENT and clk = '1') THEN               
      flipflops(0) <= button;                         
      flipflops(1) <= flipflops(0);                   
      If(counter_set = '1') THEN                      
        count := 0;                                     
      ELSIF(count < clk_freq*stable_time/1000) THEN   
        count := count + 1;                             
      ELSE                                            
        result <= flipflops(1);                         
      END IF;    
    END IF;
  END PROCESS;
  
END logic;