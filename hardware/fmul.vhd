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
	signal fraction: std_logic_vector(8 downto 0);
	signal sign : std_logic;
	signal exponent: std_logic_vector(26 downto 0);
	signal stage : std_logic_vector(47 downto 0);
	signal result : std_logic_vector(31 downto 0);

begin
	process(A,B)
	begin
		fraction<=("0"&A(8 downto 1))+("0"&B(8 downto 1));
		stage <= ("0"&A(22 downto 0)) * ("0"&B(22 downto 0));
		sign    <= ( A(0) xor B(0) );
	end process;


	process(stage)
	begin
		if fraction < 127 then
			exponent<="000000000000000000000000000";
			fraction<="00000000";
			stage   <=x"000000000000";
		elsif fraction > 381 then
			exponent<="000000000000000000000000000";
			fraction<="00000000";
			stage   <=x"000000000000";
		else
			fraction<=fraction-127;
			if (stage(21 downto 0) > 0) then exponent<=stage(47 downto 22)&"1";
			else exponent<=stage(47 downto 22)&"0";
			end if;
		end if;
	end process;

	process(exponent)
	begin
		exponent<=(exponent(26 downto 2)&"00") + (x"000000"&(exponent(1) and (exponent(2) or exponent(0)))&"00" );
		if (state='0') then state<='1';
		end if;
	end process;

	process(state)
	begin
				--case (state) is
				--when 1 => result <= sign&"0000000000000000000000000000000";
				--when 3 => result <= sign&"1111111100000000000000000000000";
				--when 2 => 
		if (exponent(26)='1') then
			fraction<=fraction+1;
			exponent<=exponent(25 downto 0)&"0";
		elsif (exponent(26 downto 1)="01111111111111111111111111") then
			fraction<=fraction+1;
			exponent<="000000000000000000000000000";
		end if;
		result<=sign&fraction(7 downto 0)&exponent(26 downto 4);
				--end case;
		state<='0';
	end process;

	process (result)
	begin
		if    fraction=0   then R<= sign&"0000000000000000000000000000000";
		elsif fraction=255 then R<= sign&"1111111100000000000000000000000";
		else R<=result;
		end if;
	end process;
end;

