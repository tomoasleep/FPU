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
	signal state1	:integer range 0 to 2 := 1;
	signal state2	:integer range 0 to 2 := 2;
	signal state3	:integer range 0 to 2 := 0;
	signal exception :std_logic_vector (2 downto 0);
	signal exponent: std_logic_vector(26 downto 0);
	signal sign : std_logic_vector(2 downto 0);
	signal fraction: std_logic_vector(80 downto 0);
	signal stage : std_logic_vector(143 downto 0);

begin
	process(clk)
	begin

		case(state1) is
			when 0 =>
				state1<=2;
				state2<=0;
				state3<=1;

			when 1 =>
				state1<=0;
				state2<=1;
				state3<=2;
			when 2 =>
				state1<=1;
				state2<=2;
				state3<=0;
		end case;

		--case(state) is
		--	when 0 =>
		exponent((8 + (state1 * 9)) downto (state1 * 9))<=("0"&A(30 downto 23)) + ("0"&B(30 downto 23));
		stage((47 + (state1 * 48)) downto (state1 * 48)) <= ("1"&A(22 downto 0)) * ("1"&B(22 downto 0));
		sign(state1)    <= ( A(31) xor B(31) );



		--	when 1 =>
		if exponent((8+(state2 * 9)) downto (state2 * 9)) < 127 then
			exponent((8+(state2*9))downto(state2*9))<="000000000";
			exception(state2)<='1';
		elsif exponent((8+(state2 * 9)) downto (state2 * 9)) > 381 then
			exponent((8+(state2*9))downto(state2*9))<="111111111";
			exception(state2)<='1';
		else
			if (stage(47 + (state2 * 48))='1') then
				exponent((8+(state2 * 9)) downto (state2 * 9))
				<=exponent((8+(state2 * 9)) downto (state2 * 9))-127;
				if (stage((22 + (state2 * 48)) downto (state2 * 48)) > 0) then
					fraction((26+(27*state2)) downto (27*state2))<=(stage((47 + (state2 * 48)) downto (24+(state2*48)))&"000")
					+("000"&x"00000"&stage(23+(state2*48))& "000" );
				else
					fraction((26+(27*state2)) downto (27*state2))<=(stage((47+(48*state2)) downto (24+(48*state2)))&"000")
					+("000"&x"00000"&(stage(23+(state2*48)) and stage(24+(48*state2)) )& "000" );
				end if;


			else
				exponent(8+(state2*9) downto (state2*9))<=exponent(8+(state2*9) downto (state2*9))-127;
				if (stage((21+(48*state2)) downto (48*state2)) > 0) then
					fraction((26+(27*state2)) downto (27*state2))
					<=(stage((47+(48*state2)) downto (23+(48*state2)))&"00") +(x"000000"&stage(22+(48*state2))& "00" );
				else
					fraction((26+(27*state2)) downto (27*state2))
					<=(stage((47+(48*state2)) downto (23+(48*state2)))&"00") +(x"000000"&(stage(22+(48*state2)) and stage(23+(48*state2)) )& "00" );
				end if;
			end if;
			exception(state2)<='0';
		end if;




		--when 2 =>
		if (exception(state3)='0') then
			if (fraction(26+(27*state3))='1') then
				R<=sign(state3)&(exponent((7+(9*state3)) downto (9*state3))+1)
				   &fraction((25+(27*state3)) downto (3+(27*state3)));
			elsif (fraction((25+(27*state3)) downto (27*state3))="01111111111111111111111111") then
				R<=sign(state3)&(exponent((7+(9*state3)) downto (6*state3))+1)&"000000000000000000000000000";
			else
				if (exponent((7+(9*state3)) downto (9*state3)) = 0) then
					R<=sign(state3)&x"00"&"000"&x"00000";
				elsif (exponent((7+(9*state3)) downto (9*state3)) = x"FF") then
					R<=sign(state3)&x"FF"&"000"&x"00000";
				else
					R<=sign(state3)&exponent((7+(9*state3)) downto (9*state3))
					   &fraction((24+(27*state3)) downto (2+(27*state3)));
				end if;
			end if;
		elsif (exponent((8+(9*state3))downto(9*state3))="000000000") then
			R<=sign(state3) & x"00" & "000"&x"00000";
		else
			R<=sign(state3) & x"FF" & "000"&x"00000";
		end if;
	--end case;
	end process;
end;

