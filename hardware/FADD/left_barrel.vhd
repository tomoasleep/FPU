library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity BARREL_LEFT is
	port (D   : in std_logic_vector(26 downto 0);
	      v   : in std_logic_vector(7 downto 0);
	      R   :out std_logic_vector(26 downto 0));
end BARREL_LEFT;

architecture shift_left of BARREL_LEFT is

begin
				R <=  D(26 downto 0)     		  when v = "00000000"  else  
				      D(25 downto 0) &"0" 		  when v = "00000001"  else  
				      D(24 downto 0) &"00"		  when v = "00000010"  else  
				      D(23 downto 0) &"000"		  when v = "00000011"  else  
				      D(22 downto 0)       & x"0" 	  when v = "00000100"  else  
				      D(21 downto 0) &"0"  & x"0" 	  when v = "00000101"  else  
				      D(20 downto 0) &"00" & x"0" 	  when v = "00000110"  else  
				      D(19 downto 0) &"000"& x"0" 	  when v = "00000111"  else  
				      D(18 downto 0)       & x"00"	  when v = "00001000"  else  
				      D(17 downto 0) &"0"  & x"00"	  when v = "00001001"  else  
				      D(16 downto 0) &"00" & x"00"	  when v = "00001010"  else  
				      D(15 downto 0) &"000"& x"00"	  when v = "00001011"  else  
				      D(14 downto 0)       & x"000"	  when v = "00001100"  else  
				      D(13 downto 0) &"0"  & x"000"	  when v = "00001101"  else  
				      D(12 downto 0) &"00" & x"000"	  when v = "00001110"  else  
				      D(11 downto 0) &"000"& x"000"	  when v = "00001111"  else  
				      D(10 downto 0)       & x"0000"	  when v = "00010000"  else  
				      D( 9 downto 0) &"0"  & x"0000"	  when v = "00010001"  else  
				      D( 8 downto 0) &"00" & x"0000"	  when v = "00010010"  else  
				      D( 7 downto 0) &"000"& x"0000"	  when v = "00010011"  else  
				      D( 6 downto 0)       & x"00000"	  when v = "00010100"  else  
				      D( 5 downto 0) &"0"  & x"00000"	  when v = "00010101"  else  
				      D( 4 downto 0) &"00" & x"00000"	  when v = "00010110"  else  
				      D( 3 downto 0) &"000"& x"00000"	  when v = "00010111"  else  
				      D( 2 downto 0)       & x"000000"	  when v = "00011000"  else  
				      D( 1 downto 0) &"0"  & x"000000"	  when v = "00011001"  else  
				      D( 0)          &"00" & x"000000" 	  when v = "00011010"  else  
				                      "000"& x"000000";	
end;
