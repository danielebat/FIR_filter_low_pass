LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

--entity "adder_34" declaration with all its inputs and outputs variables
ENTITY adder_34 is

   port( a          : in  std_logic_VECTOR (33 downto 0);
         b          : in  std_logic_VECTOR (33 downto 0);
         carry_in   : in  std_logic;
         s          : out std_logic_VECTOR (33 downto 0);
         carry_out  : out std_logic);

END adder_34;

architecture BEHAVIOURAL of adder_34 is

--architectural behaviour of a ripple carry adder
BEGIN 
    SUM:process(a,b,carry_in)
    	variable C:std_logic;
     	begin
     	 C:=carry_in;
		  FOR i IN 0 TO 33 LOOP	   
			    --computation of a bit of the result vector, including carry that will
				--be used for the following computation
         		s(i)<= a(i) XOR b(i) XOR C;
         		C:= (a(i) AND b(i)) OR (a(i) AND C) OR (b(i) AND C);
     		 END LOOP;
       		carry_out <= C;
      	END  process SUM;
END BEHAVIOURAL;
