library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity FMUL is
	port (A   : in std_logic_vector(31 downto 0);
	      B   : in std_logic_vector(31 downto 0);
	      doit: in std_logic;
	      clk : in std_logic;
	      R   :out std_logic_vector(31 downto 0));
end FMUL;

architecture fmul32 of FMUL is

	--SIGNALS
	signal state	:integer range 0 to 2 := 0;
	signal exception :integer range 0 to 2 := 1;
	signal exponent: std_logic_vector(8 downto 0);
	signal sign : std_logic;
	signal fraction: std_logic_vector(26 downto 0);
	signal stage : std_logic_vector(47 downto 0);
	signal result : std_logic_vector(31 downto 0);

begin
	process(clk)
	begin
		case(state) is
			when 0 =>
				exponent<=("0"&A(8 downto 1)) + ("0"&B(8 downto 1));
				stage <= ("0"&A(31 downto 9)) * ("0"&B(31 downto 9));
				sign    <= ( A(0) xor B(0) );
				state<=1;

			when 1 =>
				state<=2;
				if exponent < 127 then
					fraction<="000000000000000000000000000";
					exponent<="00000000";
					stage   <=x"000000000000";
					exception<=0;
				elsif exponent > 381 then
					fraction<="000000000000000000000000000";
					exponent<="11111111";
					stage   <=x"000000000000";
					exception<=2;
				else
					exponent<=exponent-127;
					if (stage(21 downto 0) > 0) 
					then 
						fraction<=(stage(47 downto 23)&"00") +(x"000000"&(stage(22) and 1 )& "00" );
					else 
						fraction<=(stage(47 downto 23)&"00") +(x"000000"&(stage(22) and stage(23) )& "00" );
					end if;
				end if;
			when 2 =>
				case (exception) is
					when 0 => 
						result <= sign&"0000000000000000000000000000000";
					when 2 => 
						result <= sign&"1111111100000000000000000000000";
					when 1 => 
						if (fraction(26)='1') then
							result<=sign&(exponent(7 downto 0)+1)&fraction(25 downt0 3);
						elsif (fraction(26 downto 1)="01111111111111111111111111") then
							result<=sign&(exponent(7 downto 0)+1)&"000000000000000000000000000";
						else
							result<=sign&exponent(7 downto 0)&fraction(24 downto 2);
						end if; 
						state<='0';
					end process;

				end case;
				--
				--	process(fraction)
				--	begin
				--		fraction<=(fraction(26 downto 2)&"00") + (x"000000"&(fraction(1) and (fraction(2) or fraction(0)))&"00" );
				--		if (state='0') then state<='1';
				--		end if;
				--	end process;
				--

				process (result)
				begin
					if    exponent=0   then R<= sign&"0000000000000000000000000000000";
					elsif exponent=255 then R<= sign&"1111111100000000000000000000000";
					else R<=result;
					end if;
				end process;
			end;

