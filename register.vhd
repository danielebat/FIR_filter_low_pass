LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

--entity "Register" declaration with all its inputs and outputs variables
ENTITY REGISTER_16 is

   port( D          : in  std_logic_VECTOR (15 downto 0);
         Q          : out std_logic_VECTOR (15 downto 0);
         CLK  		: in std_logic;
		 RESET_N	: in std_logic
		 );
		 
END REGISTER_16;

architecture BEHAVIOURAL of REGISTER_16 is

--behaviour of the register and related output assignment
BEGIN
    REG:process(CLK)
		begin
			if(rising_edge(clk)) then 
				
				--assignment for our output variable
				if(reset_n = '0') then
					Q <= "0000000000000000";
				else
					Q <= D;
				end if;
			end if;
		end process REG;

END BEHAVIOURAL;