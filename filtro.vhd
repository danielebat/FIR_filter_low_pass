LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

--entity "Filtro" declaration with all its inputs and outputs variables
entity FILTRO is
	
	port (
	X		:in std_logic_vector(15 downto 0);
	Y		:out std_logic_vector(15 downto 0);
	CLK		:in std_logic;
	RESET	:in std_logic
	);
	
end FILTRO;

architecture BEHAVIOURAL of FILTRO is	

--declaration of all components present in tha architecture
--16 bit adder needed for prior sums
component ADDER_16
	
    port( a          : in  std_logic_VECTOR (15 downto 0);
         b          : in  std_logic_VECTOR (15 downto 0);
         carry_in   : in  std_logic;
         s          : out std_logic_VECTOR (15 downto 0);
         carry_out  : out std_logic
		 );
		 
end component;

--34 bit adder needed for final sums
component ADDER_34
	
    port( a          : in  std_logic_VECTOR (33 downto 0);
         b          : in  std_logic_VECTOR (33 downto 0);
         carry_in   : in  std_logic;
         s          : out std_logic_VECTOR (33 downto 0);
         carry_out  : out std_logic
		 );
		 
end component;

--multiplier needed to solve the product between factors and input values
component MULTIPLIER
		
	port( value          : in  std_logic_VECTOR (16 downto 0);
         factor         : in  std_logic_VECTOR (16 downto 0);
         out_value      : out std_logic_VECTOR (33 downto 0)
		 );

end component;

--register needed to store values coming from the input and
--to create the delays chain
component REGISTER_16
	
	port( D         : in  std_logic_VECTOR (15 downto 0);
         Q          : out std_logic_VECTOR (15 downto 0);
         CLK  		: in std_logic;
		 RESET_N	: in std_logic
		 );
	
end component;
			
	--wires from registers to prior adders
	signal Q1_TO_S00 : std_logic_vector(15 downto 0);  
	signal Q1_TO_S01 : std_logic_vector(15 downto 0);
	signal Q1_TO_S02 : std_logic_vector(15 downto 0);
	signal Q2_TO_S02 : std_logic_vector(15 downto 0);
	signal Q2_TO_S01 : std_logic_vector(15 downto 0);
	signal Q2_TO_S00 : std_logic_vector(15 downto 0);
	
	--wires from prior adders to multipliers
	signal S00_TO_M0 : std_logic_vector(15 downto 0);
	signal S01_TO_M1 : std_logic_vector(15 downto 0);
	signal S02_TO_M2 : std_logic_vector(15 downto 0);
	signal Q1_TO_M3 : std_logic_vector(15 downto 0);
	
	--wires needed to concatenate the output from prior adders to multipliers
	signal N_S00_TO_M0 : std_logic_vector(16 downto 0);
	signal N_S01_TO_M1 : std_logic_vector(16 downto 0);
	signal N_S02_TO_M2 : std_logic_vector(16 downto 0);
	signal N_Q1_TO_M3 : std_logic_vector(16 downto 0);
	
	--wires from multipliers to last adders
	signal M3_TO_S12 : std_logic_vector(33 downto 0);
	signal M2_TO_S12 : std_logic_vector(33 downto 0);
	signal M1_TO_S11 : std_logic_vector(33 downto 0);
	signal M0_TO_S10 : std_logic_vector(33 downto 0);
	
	--wires for chains of adders
	signal S12_TO_S11 : std_logic_vector(33 downto 0);
	signal S11_TO_S10 : std_logic_vector(33 downto 0);
	
	--wires from last adders to saturation circuit
	signal S10_TO_SAT : std_logic_vector(33 downto 0);
	
	--wires for adders
	signal F_CARRYIN00 : std_logic;
	signal F_CARRYIN01 : std_logic;
	signal F_CARRYIN02 : std_logic;
	signal F_CARRYIN12 : std_logic;
	
	signal F_CARRYOUT00 : std_logic;
	signal F_CARRYOUT01 : std_logic;
	signal F_CARRYOUT02 : std_logic;
	signal F_CARRYOUT10 : std_logic;
	signal F_CARRYOUT11 : std_logic;
	signal F_CARRYOUT12 : std_logic;
	
	--wires representing factors for multipliers (given in fixed-point representation)
	signal FACTOR_0 : std_logic_vector(16 downto 0);
	signal FACTOR_1 : std_logic_vector(16 downto 0);
	signal FACTOR_2 : std_logic_vector(16 downto 0);
	signal FACTOR_3 : std_logic_vector(16 downto 0);
	
	begin 
		
	F_CARRYIN00 <= '0';
	F_CARRYIN01 <= '0';
	F_CARRYIN02 <= '0';
	F_CARRYIN12 <= '0';
	
	FACTOR_0 <= "00000001101110101"; --0.0135
	FACTOR_1 <= "00001010000011001"; --0.0785 
	FACTOR_2 <= "00011110110101100"; --0.2409 
	FACTOR_3 <= "00101010110011011"; --0.3344
	
	--prior adders
	S02: ADDER_16 PORT MAP(Q1_TO_S02, Q2_TO_S02, F_CARRYIN02, S02_TO_M2, F_CARRYOUT02);
	S01: ADDER_16 PORT MAP(Q1_TO_S01, Q2_TO_S01, F_CARRYIN01, S01_TO_M1, F_CARRYOUT01);
	S00: ADDER_16 PORT MAP(Q1_TO_S00, Q2_TO_S00, F_CARRYIN00, S00_TO_M0, F_CARRYOUT00);
	
	--last adders
	S12: ADDER_34 PORT MAP(M3_TO_S12, M2_TO_S12, F_CARRYIN12, S12_TO_S11, F_CARRYOUT12);
	S11: ADDER_34 PORT MAP(M1_TO_S11, S12_TO_S11, F_CARRYOUT12, S11_TO_S10, F_CARRYOUT11);
	S10: ADDER_34 PORT MAP(M0_TO_S10, S11_TO_S10, F_CARRYOUT11, S10_TO_SAT, F_CARRYOUT10);
	
	--multipliers
	M3: MULTIPLIER PORT MAP(N_Q1_TO_M3, FACTOR_3, M3_TO_S12);
	M2: MULTIPLIER PORT MAP(N_S02_TO_M2, FACTOR_2, M2_TO_S12);
	M1: MULTIPLIER PORT MAP(N_S01_TO_M1, FACTOR_1, M1_TO_S11);
	M0: MULTIPLIER PORT MAP(N_S00_TO_M0, FACTOR_0, M0_TO_S10);
	
	--registers
	R6: REGISTER_16 PORT MAP(X, Q1_TO_S00, CLK, RESET);
	R5: REGISTER_16 PORT MAP(Q1_TO_S00, Q1_TO_S01, CLK, RESET);
	R4: REGISTER_16 PORT MAP(Q1_TO_S01, Q1_TO_S02, CLK, RESET);
	R3: REGISTER_16 PORT MAP(Q1_TO_S02, Q1_TO_M3, CLK, RESET);
	R2: REGISTER_16 PORT MAP(Q1_TO_M3, Q2_TO_S02, CLK, RESET);
	R1: REGISTER_16 PORT MAP(Q2_TO_S02, Q2_TO_S01, CLK, RESET);
	R0: REGISTER_16 PORT MAP(Q2_TO_S01, Q2_TO_S00, CLK, RESET); 
	
	--behaviour of the filter based on 2 inputs
	ASSIGNMENTS: process(CLK, S10_TO_SAT)
		begin
			if(rising_edge(CLK)) then
				N_S00_TO_M0 <= F_CARRYOUT00&S00_TO_M0(15 downto 0);
				N_S01_TO_M1 <= F_CARRYOUT01&S01_TO_M1(15 downto 0);
				N_S02_TO_M2	<= F_CARRYOUT02&S02_TO_M2(15 downto 0);
				N_Q1_TO_M3 <= '0'&Q1_TO_M3;
				
				--saturation circuit to let the output be representable on 16 bits
				if ( S10_TO_SAT(32) = '1' ) then
					Y <= "1111111111111111"; 
				else
					Y <= S10_TO_SAT(31 downto 16);
				end if;
			end if;
		end process ASSIGNMENTS;
	
end BEHAVIOURAL;