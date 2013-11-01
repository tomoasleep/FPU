library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity FMUL is
	port (A   : in std_logic_vector(31 downto 0);
	      B   : in std_logic_vector(31 downto 0);
	      clk : in std_logic;
	      R   :out std_logic_vector(31 downto 0));
end FMUL;

architecture fmul32 of FMUL is

	--SIGNALS
	signal state	:std_logic;
	signal exponent: std_logic_vector(8 downto 0);
	signal sign : std_logic;
	signal fraction: std_logic_vector(26 downto 0);
	signal stage : std_logic_vector(47 downto 0);
	signal result : std_logic_vector(31 downto 0);

begin
	process(A,B)
	begin
		exponent<=("0"&A(8 downto 1))+("0"&B(8 downto 1));
		stage <= ("0"&A(22 downto 0)) * ("0"&B(22 downto 0));
		sign    <= ( A(0) xor B(0) );
	end process;


	process(stage)
	begin
		if exponent < 127 then
			fraction<="000000000000000000000000000";
			exponent<="00000000";
			stage   <=x"000000000000";
		elsif exponent > 381 then
			fraction<="000000000000000000000000000";
			exponent<="00000000";
			stage   <=x"000000000000";
		else
			exponent<=exponent-127;
			if (stage(21 downto 0) > 0) then fraction<=stage(47 downto 22)&"1";
			else fraction<=stage(47 downto 22)&"0";
			end if;
		end if;
	end process;

	process(fraction)
	begin
		fraction<=(fraction(26 downto 2)&"00") + (x"000000"&(fraction(1) and (fraction(2) or fraction(0)))&"00" );
		if (state='0') then state<='1';
		end if;
	end process;

	process(state)
	begin
				--case (state) is
				--when 1 => result <= sign&"0000000000000000000000000000000";
				--when 3 => result <= sign&"1111111100000000000000000000000";
				--when 2 => 
		if (fraction(26)='1') then
			exponent<=exponent+1;
			fraction<=fraction(25 downto 0)&"0";
		elsif (fraction(26 downto 1)="01111111111111111111111111") then
			exponent<=exponent+1;
			fraction<="000000000000000000000000000";
		end if;
		result<=sign&exponent(7 downto 0)&fraction(26 downto 4);
				--end case;
		state<='0';
	end process;

	process (result)
	begin
		if    exponent=0   then R<= sign&"0000000000000000000000000000000";
		elsif exponent=255 then R<= sign&"1111111100000000000000000000000";
		else R<=result;
		end if;
	end process;
end;

