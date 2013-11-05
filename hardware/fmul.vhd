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
	signal state	:integer range 0 to 2 := 0;
	signal exception :integer range 0 to 1 := 1;
	signal exponent: std_logic_vector(8 downto 0);
	signal sign : std_logic;
	signal fraction: std_logic_vector(26 downto 0);
	signal stage : std_logic_vector(47 downto 0);

begin
	process(clk)
	begin
		case(state) is
			when 0 =>
				exponent<=("0"&A(30 downto 23)) + ("0"&B(30 downto 23));
				stage <= ("1"&A(22 downto 0)) * ("1"&B(22 downto 0));
				sign    <= ( A(31) xor B(31) );
				state<=1;

			when 1 =>
				state<=2;
				if exponent < 127 then
					R  <=sign&"0000000000000000000000000000000";
					exception<=1;
				elsif exponent > 381 then
					R  <=sign&"1111111100000000000000000000000";
					exception<=1;
				else
					exponent<=exponent-127;
					if (stage(21 downto 0) > 0) then
						fraction<=(stage(47 downto 23)&"00") +(x"000000"&stage(22)& "00" );
					else
						fraction<=(stage(47 downto 23)&"00") +(x"000000"&(stage(22) and stage(23) )& "00" );
					end if;
					exception<=0;
				end if;
			when 2 =>
				case (exception) is
					when 1 =>state<=0;
					when 0 => 
						if (fraction(26)='1') then
							R<=sign&(exponent(7 downto 0)+1)&fraction(25 downto 3);
						elsif (fraction(25 downto 0)="01111111111111111111111111") then
							R<=sign&(exponent(7 downto 0)+1)&"000000000000000000000000000";
						else
							R<=sign&exponent(7 downto 0)&fraction(24 downto 2);
						end if; 
						state<=0;
				end case;
		end case;
	end process;
end;

