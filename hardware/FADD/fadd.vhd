library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity FADD is
	port (A   : in std_logic_vector(31 downto 0);
	      B   : in std_logic_vector(31 downto 0);
	      clk : in std_logic;
	      R   :out std_logic_vector(31 downto 0));
end FADD;

architecture fadd32 of FADD is

	--COMPONENTS
	component BARREL_LEFT
		port( D : in  std_logic_vector(26 downto 0);
		      v : in  std_logic_vector(7 downto 0);
		      R : out std_logic_vector(26 downto 0));
	end component;

	component BARREL_RIGHT
		port( D : in  std_logic_vector(26 downto 0);
		      v : in  std_logic_vector(7 downto 0);
		      R : out std_logic_vector(26 downto 0));
	end component;

	component REV_ENCODER
		port( i : in  std_logic_vector(31 downto 0);
		      o : out std_logic_vector( 4 downto 0)
	      );
	end component;


	component PRI_ENCODER
		port( i : in  std_logic_vector(31 downto 0);
		      o : out std_logic_vector( 4 downto 0)
	      );
	end component;

	--SIGNALS
	signal  sign_same0,sign_same1 :std_logic;
	signal  bsl_data   : std_logic_vector(26 downto 0); 
	signal  bsl_value  : std_logic_vector( 7 downto 0); 
	signal  bsl_result : std_logic_vector(26 downto 0); 
	signal  bsr_data   : std_logic_vector(26 downto 0); 
	signal  bsr_value,exp_sub1  : std_logic_vector( 7 downto 0); 
	signal  bsr_result0,bsr_result1 : std_logic_vector(26 downto 0);
	signal rev_input : std_logic_vector(31 downto 0);
	signal rev_output0,rev_output1 : std_logic_vector(4 downto 0);
	signal pri_input : std_logic_vector(31 downto 0);
	signal pri_output1,pri_output2 : std_logic_vector(4 downto 0);
	signal exponent0,exponent1,exponent2: std_logic_vector(7 downto 0);
	signal sign0,sign1,sign2 : std_logic;
	signal fraction1,fraction2: std_logic_vector(27 downto 0);

	signal Winnerfrc0,Winnerfrc1: std_logic_vector(26 downto 0);

begin
	bsl: BARREL_LEFT
	port map(
			D => bsl_data,
			v => bsl_value,
			R => bsl_result	 );
	bsr: BARREL_RIGHT
	port map(
			D => bsr_data,
			v => bsr_value,
			R => bsr_result0 );

	rev: REV_ENCODER
	port map(
			i => rev_input,
			o => rev_output0);

	pri: PRI_ENCODER
	port map(
			i => pri_input,
			o => pri_output1);

	--process(clk)
	--variable Winnerfrc :std_logic_vector(26 downto 0);
	--variable Loserfrc :std_logic_vector(26 downto 0);
	--variable fraction_sub : std_logic_vector(27 downto 0);
	--variable result_sub :std_logic_vector(31 downto 0);
	--begin
	--if rising_edge(clk) then
	--case(state) is
	--	when 0 => --大小比較し、小さい方を指数差分シフト
	--		state<=1;
	--if (A(30 downto 0)>=B(30 downto 0)) then
	Winnerfrc0 <= "1"&A(22 downto 0)&"000" 		when (A(30 downto 0)>=B(30 downto 0)) else
		      "1"&B(22 downto 0)&"000";
	bsr_data  <=  "1"&B(22 downto 0)&"000" 		when (A(30 downto 0)>=B(30 downto 0)) else
		      "1"&A(22 downto 0)&"000";
	bsr_value <= A(30 downto 23)-B(30 downto 23) 	when (A(30 downto 0)>=B(30 downto 0)) else
		     B(30 downto 23)-A(30 downto 23); 	
	--Loserfrc  := bsr_result;
	exponent0  <= A(30 downto 23)			when (A(30 downto 0)>=B(30 downto 0)) else
		      B(30 downto 23);
	sign0<=A(31) 					when (A(30 downto 0)>=B(30 downto 0)) else
	       B(31);
	rev_input <= B 					when (A(30 downto 0)>=B(30 downto 0)) else
		     A;



	sign_same0<='1' when A(31)=B(31) else
		    '0';
	--			else
	--				Winnerfrc0 <= "1"&B(22 downto 0)&"000";
	--				bsr_data  <= "1"&A(22 downto 0)&"000";
	--				bsr_value <= B(30 downto 23)-A(30 downto 23); 	
	--				--Loserfrc  := bsr_result;
	--				exponent0  <= B(30 downto 23);
	--				sign0<=B(31);
	--				rev_input <= A;
	--			end if;
	latch_0_1:process(clk)
	begin
		if rising_edge(clk) then
			Winnerfrc1<=Winnerfrc0;
			exponent1 <=exponent0;
			sign1<=sign0;
			rev_output1<=rev_output0;
			bsr_result1<=bsr_result0;
			exp_sub1<=bsr_value;
			sign_same1<=sign_same0;
		end if;
	end process;
	--	when 1 =>
	--		state<=2;


	--if (A(31)=B(31)) 
	--then --足し算
	--	if (rev_output<bsr_value)
	--	then
	fraction1 <= ("0"&Winnerfrc1)+("0"&bsr_result1(26 downto 1)&"1") when((sign_same1='1') and ((rev_output1+3) <  exp_sub1)) else
		     ("0"&Winnerfrc1)+("0"&bsr_result1) 		      when(sign_same1='1') else
		     ("0"&Winnerfrc1)-("0"&bsr_result1(26 downto 1)&"1") when((rev_output1+3) < exp_sub1)else
		     ("0"&Winnerfrc1)-("0"&bsr_result1);
		     --	end if;
		     --end if;

	pri_input <= fraction1&"0000";

	latch_1_2:process(clk)
	begin
		if rising_edge(clk) then
			fraction2<=fraction1;
			pri_output2<=pri_output1;
			exponent2<=exponent1;
			sign2<=sign1;
			bsl_data <= x"0"&fraction1(24 downto 2);
			bsl_value <= "000"&(30 - pri_output1);
		end if;
	end process;



	R<= sign2&(exponent2 + 1)&
	    ((fraction2(26 downto 4) + (fraction2(3) and (fraction2(4) or fraction2(2) or fraction2(1) or fraction2(0))))) when(pri_output2="11111" and exponent2/=x"FE") else
	    sign2&x"FF"&"000"&x"00000" when(pri_output2="11111" )else

	    sign2&(exponent2 + 1)&"000"&x"00000" when(pri_output2="11110" and fraction2(26 downto 2)=x"1FFFFFF") else
	    sign2&(exponent2)&(fraction2(25 downto 3)
	    + (fraction2(2) and (fraction2(3) or fraction2(1) or fraction2(0)))) when(pri_output2="11110") else

	    sign2&(exponent2)&"000"&x"00000" when(pri_output2="11101" and fraction2(25 downto 1) = x"1FFFFFF") else
	    sign2&(exponent2 - 1)&fraction2(24 downto 2)
	    + (fraction2(1) and (fraction2(2) or fraction2(0))) when(pri_output2="11101" )else

	    sign2&(exponent2 -("000"&(30-pri_output2))) & bsl_result(23 downto 1) when(exponent2>("000"&(30-pri_output2)))else
	    sign2&"000"&x"0000000";
end;
