LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

--entity "multiplier" declaration with all its inputs and outputs variables
ENTITY multiplier is

   port( value          :in  std_logic_VECTOR(16 downto 0);
         factor         :in  std_logic_VECTOR(16 downto 0);
         out_value      :out std_logic_VECTOR(33 downto 0)
		 );
		 
END multiplier;


architecture BEHAVIOURAL of multiplier is

BEGIN
	
	MULTIPLICATION: process(value, factor)
	
	--variables needed to evaluate mid-sums
	variable reg : std_logic_vector(33 downto 0);
	variable add : std_logic_vector(17 downto 0);
	
	begin		
	
		reg := "00000000000000000"&factor;	
		--loop to evaluate all lsb
		for i in 0 to 16 loop
		
			if ( reg(0) = '1' ) then 
				--computation of 'add' and 'reg' if reg(0) = 1
				add := ('0'&value)+('0'&reg(33 downto 17));
				reg := add&reg(16 downto 1);			
			
			else
	    		
				reg:= '0'&reg(33 downto 1);
				
			end if;
			
		end loop;		
	    
		out_value <= reg;
		
	END  process MULTIPLICATION;
	
END BEHAVIOURAL;