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
signal state	:integer range 0 to 10 :=0;
signal fraction: std_logic_vector(8 downto 0);
signal sign : std_logic;
signal exponent: std_logic_vector(26 downto 0);
signal stage : std_logic_vector(47 downto 0);

	begin
statemachine:process(A,B)
	begin
	fraction<=A(8 downto 1)+B(8 downto 1);
	if fraction < 127 then
	exponent<="000000000000000000000000000";
	fraction<="00000000";
	sign    <= ( A(0) xor B(0) );
	state   <=0;
	elsif fraction > 381 then
	exponent<="000000000000000000000000000";
	fraction<="00000000";
	sign    <= ( A(0) xor B(0) );
	state   <=1;
	else
	fraction<=fraction-127;
	state   <=2;
	end if;
	stage <= ("0"&A(22 downto 0)) * ("0"&B(22 downto 0));
	end process;







