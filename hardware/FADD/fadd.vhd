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
	signal  bsl_data   : std_logic_vector(26 downto 0); 
	signal  bsl_value  : std_logic_vector( 7 downto 0); 
	signal  bsl_result : std_logic_vector(26 downto 0); 
	signal  bsr_data   : std_logic_vector(26 downto 0); 
	signal  bsr_value  : std_logic_vector( 7 downto 0); 
	signal  bsr_result : std_logic_vector(26 downto 0);
	signal rev_input : std_logic_vector(31 downto 0);
	signal rev_output : std_logic_vector(4 downto 0);
	signal pri_input : std_logic_vector(31 downto 0);
	signal pri_output : std_logic_vector(4 downto 0);
	signal state	:integer range 0 to 2 := 0;
	signal exponent: std_logic_vector(7 downto 0);
	signal sign : std_logic;
	signal fraction: std_logic_vector(27 downto 0);

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
			R => bsr_result	 );

	rev: REV_ENCODER
	port map(
			i => rev_input,
			o => rev_output);

	pri: PRI_ENCODER
	port map(
			i => pri_input,
			o => pri_output);

	process(clk)
	variable Winnerfrc :std_logic_vector(26 downto 0);
	variable Loserfrc :std_logic_vector(26 downto 0);
	begin
		if rising_edge(clk) then
			case(state) is
				when 0 => --大小比較し、小さい方を指数差分シフト
					state<=1;
					if (A(30 downto 0)>=B(30 downto 0)) then
						Winnerfrc <= "1"&A(22 downto 0)&"000";
						bsr_data  <= "1"&B(22 downto 0)&"000";
						bsr_value <= A(30 downto 23)-B(30 downto 23); 	
						Loserfrc  <= bsr_result;
						exponent  <= A(30 downto 23);
						sign<=A(31);
						rev_input <= B;
					else
						Winnerfrc <= "1"&B(22 downto 0)&"000";
						bsr_data  <= "1"&A(22 downto 0)&"000";
						bsr_value <= B(30 downto 23)-A(30 downto 23); 	
						Loserfrc  <= bsr_result;
						exponent  <= B(30 downto 23);
						sign<=B(31);
						rev_input <= A;
					end if;
				when 1 =>
					state<=2;
					if (A(31)=B(31)) 
					then --足し算
						if (rev_output<bsr_value)
						then
							fraction<="0"&(Winnerfrc(26 downto 1)+Loserfrc(26 downto 1))&"1";
						else
							fraction<="0"&(Winnerfrc+Loserfrc);
						end if;
						pri_input <= fraction&"0000";
					else --引き算
						if (rev_output<bsr_value)
						then
							fraction<="0"&(Winnerfrc(26 downto 1)-Loserfrc(26 downto 1))&"1";
						else
							fraction<="0"&(Winnerfrc-Loserfrc);
						end if;
					end if;

				when 2 =>
					state<=0;
					pri_input <= fraction&"0000";
					case (pri_output) is
						when "11111" =>
							if (exponent/=x"FE") then
								R <= sign&(exponent + 1)&
								     ((fraction(26 downto 4) + (fraction(3) and (fraction(4) or fraction(2) or fraction(1) or fraction(0)))));
							else 
								R <= sign&x"FF"&"000"&x"00000";
							end if;
						when "11110" =>
							if (fraction(26 downto 2)=x"1FFFFFF") then
								R <= sign&(exponent + 1)&"000"&x"00000";
							else
								R <= sign&(exponent)&(fraction(25 downto 3)
								     + (fraction(2) and (fraction(3) or fraction(1) or fraction(0))));
							end if;
						when "11101" =>
							if (fraction(25 downto 1) = x"1FFFFFF") then
								R <= sign&(exponent)&"000"&x"00000";
							else
								R <= sign&(exponent - 1)&fraction(24 downto 2)
								     + (fraction(1) and (fraction(2) or fraction(0)));
							end if;
						when others =>
							if (exponent > ("000"& (30 - pri_output))) then
								bsl_data <= x"0"&fraction(24 downto 2);
								bsl_value <= "000"&(30 - pri_output);
								R <= sign&(exponent -( "000"&(30 - pri_output)) )
								     &( bsl_result(22 downto 0));
							else
								R <= sign&"000"&x"0000000";
							end if;
					end case;
			end case;
		end if;
	end process;
end;
