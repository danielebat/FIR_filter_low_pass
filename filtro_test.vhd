LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

--declaration of our filter
entity FILTRO_TD is
	
end FILTRO_TD;

--description and declaration af all signals contained
--in our architecture
architecture FILTRO_TEST of FILTRO_TD is

	component FILTRO is
		port (X		:in std_logic_vector(15 downto 0);
			Y		:out std_logic_vector(15 downto 0);
			CLK		:in std_logic;
			RESET	:in std_logic
			);
				
	end component;	
	
	--signals
	signal X 		: std_logic_vector(15 downto 0) := "0000000000000000";
	signal Y		: std_logic_vector(15 downto 0);
	signal CLK		: std_logic:='0';
	signal RESET	: std_logic:='0';
	signal clk_cycle: INTEGER;
		
	begin
	
	--instance of the filter
	FILTRO1: FILTRO PORT MAP(X, Y, CLK, RESET);
	
	--declaration of our clock and reset
	CLK <= NOT CLK AFTER 50ns;
	RESET <= '1' after 123 ns;
			
	PROVA: PROCESS(CLK)
	
		VARIABLE count: INTEGER:= 0;
		
		BEGIN   
		clk_cycle <= (count+1)/2;
		
		if ( RESET = '0') THEN 
			--inizialization of our input 
			X <= "0000000000000000";
		else  
			--creating some cases that will be shown during the simulation
	    	CASE count IS
			
				WHEN 10 => X <= "0000000000000000";
				
				--particular wave presentaed to the filter
				--to see which is the output, including some step functions
				when 20 => X <= "1100001110001011";
				when 30 => X <= "1100000000011011";
				when 50 => X <= "0000000000000000";
				when 60 => X <= "1111111111111111";
				when 80 => X <= "0111111111111111";
				when 92 => X <= "0000000000000000";	
				
				--step function equal to '65328'
				when 110 => X <= "1111111100110000";
				when 130 => X <= "0000000000000000";
				
				--dirac delta equal to '58352'
				when 160 => X <= "1110001111110000";
				when 162 => X <= "0000000000000000";
				
				--step function equal to '65408'
				when 190 => X <= "1111111110000000"; 
				when 210 => X <= "0000000000000000";
				
				--dirac delta equal to '25584'
				when 230 => X <= "0110001111110000";
				when 232 => X <= "0000000000000000";
				
				--particular wave to show a filter response with values
				--starting from '32752' to '65504', incremented at each clock
				when 250 => X <= "0111111111110000";
				when 252 => X <= "1011111111110000";
				when 254 => X <= "1101111111110000";
				when 256 => X <= "1110111111110000";
				when 258 => X <= "1111011111110000";
				when 260 => X <= "1111101111110000";
				when 262 => X <= "1111110111110000";
				when 264 => X <= "1111111011110000";
				when 266 => X <= "1111111101110000";
				when 268 => X <= "1111111110110000";
				when 270 => X <= "1111111111010000";
				when 272 => X <= "1111111111100000";
				
				when 274 => X <= "1111111111100000";
				when 276 => X <= "1111111111010000";
				when 278 => X <= "1111111110110000";
				when 280 => X <= "1111111101110000";
				when 282 => X <= "1111111011110000";
				when 284 => X <= "1111110111110000";
				when 286 => X <= "1111101111110000";
				when 288 => X <= "1111011111110000";
				when 290 => X <= "1110111111110000";
				when 292 => X <= "1101111111110000";
				when 294 => X <= "1011111111110000";
				when 296 => X <= "0111111111110000";
				when 298 => X <= "0000000000000000";
				
				--other cases
				WHEN OTHERS => X <= X;
			
			END CASE;
		
		end if;
		
		count:= count + 1;		
	 
	END PROCESS PROVA;
			
end FILTRO_TEST;