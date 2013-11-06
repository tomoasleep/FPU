library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity BARREL_LEFT is
	port (D   : in std_logic_vector(26 downto 0);
	      v   : in std_logic_vector(4 downto 0);
	      R   :out std_logic_vector(26 downto 0));
end BARREL_LEFT;

architecture shift_left of BARREL_LEFT is

begin
	case(v) is
		when "00000" => R <=  A(26 downto 0)     		  ;
		when "00001" => R <=  A(25 downto 0) &"0" 		  ;
		when "00010" => R <=  A(24 downto 0) &"00"		  ;
		when "00011" => R <=  A(23 downto 0) &"000"		  ;
		when "00100" => R <=  A(22 downto 0) &     & x"0" 	  ;
		when "00101" => R <=  A(21 downto 0) &"0"  & x"0" 	  ;
		when "00110" => R <=  A(20 downto 0) &"00" & x"0" 	  ;
		when "00111" => R <=  A(19 downto 0) &"000"& x"0" 	  ;
		when "01000" => R <=  A(18 downto 0) &     & x"00"	  ;
		when "01001" => R <=  A(17 downto 0) &"0"  & x"00"	  ;
		when "01010" => R <=  A(16 downto 0) &"00" & x"00"	  ;
		when "01011" => R <=  A(15 downto 0) &"000"& x"00"	  ;
		when "01100" => R <=  A(14 downto 0) &     & x"000"	  ;
		when "01101" => R <=  A(13 downto 0) &"0"  & x"000"	  ;
		when "01110" => R <=  A(12 downto 0) &"00" & x"000"	  ;
		when "01111" => R <=  A(11 downto 0) &"000"& x"000"	  ;
		when "10000" => R <=  A(10 downto 0) &     & x"0000"	  ;
		when "10001" => R <=  A( 9 downto 0) &"0"  & x"0000"	  ;
		when "10010" => R <=  A( 8 downto 0) &"00" & x"0000"	  ;
		when "10011" => R <=  A( 7 downto 0) &"000"& x"0000"	  ;
		when "10100" => R <=  A( 6 downto 0) &     & x"00000"	  ;
		when "10101" => R <=  A( 5 downto 0) &"0"  & x"00000"	  ;
		when "10110" => R <=  A( 4 downto 0) &"00" & x"00000"	  ;
		when "10111" => R <=  A( 3 downto 0) &"000"& x"00000"	  ;
		when "11000" => R <=  A( 2 downto 0) &     & x"000000"	  ;
		when "11001" => R <=  A( 1 downto 0) &"0"  & x"000000"	  ;
		when "11010" => R <=  A( 0)	   & "00" & x"000000" ;	  ;
		when "11011" => R <=  "000"& x"000000"	
		when "11100" => R <=  "000"& x"000000"
		when "11101" => R <=  "000"& x"000000"
		when "11110" => R <=  "000"& x"000000"
		when "11111" => R <=  "000"& x"000000"
	end case;
end;
