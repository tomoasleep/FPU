library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity BARREL_RIGHT is
	port (D   : in std_logic_vector(26 downto 0);
	      v   : in std_logic_vector(7 downto 0);
	      R   :out std_logic_vector(26 downto 0));
end BARREL_RIGHT;

architecture shift_right of BARREL_RIGHT is

begin
	R <=     
		                   D(26 downto 0)	when v = "00000000"
	else "0" 		 & D(26 downto 1)	when v = "00000001"
	else "00"		 & D(26 downto 2)	when v = "00000010"
	else "000"		 & D(26 downto 3)       when v = "00000011"
	else        x"0"	 & D(26 downto 4) 	when v = "00000100"
	else "0"  & x"0"	 & D(26 downto 5) 	when v = "00000101"
	else "00" & x"0"	 & D(26 downto 6) 	when v = "00000110"
	else "000"& x"0"	 & D(26 downto 7) 	when v = "00000111"
	else        x"00"	 & D(26 downto 8)	when v = "00001000"
	else "0"  & x"00"	 & D(26 downto 9)	when v = "00001001"
	else "00" & x"00"	 & D(26 downto 10)    	when v = "00001010"
	else "000"& x"00"	 & D(26 downto 11)    	when v = "00001011"
	else        x"000"	 & D(26 downto 12)   	when v = "00001100"
	else "0"  & x"000"	 & D(26 downto 13)   	when v = "00001101"
	else "00" & x"000"	 & D(26 downto 14)   	when v = "00001110"
	else "000"& x"000"	 & D(26 downto 15)   	when v = "00001111"
	else        x"0000"	 & D(26 downto 16)  	when v = "00010000"
	else "0"  & x"0000"	 & D(26 downto 17)  	when v = "00010001"
	else "00" & x"0000"	 & D(26 downto 18)  	when v = "00010010"
	else "000"& x"0000"	 & D(26 downto 19)  	when v = "00010011"
	else        x"00000"	 & D(26 downto 20) 	when v = "00010100"
	else "0"  & x"00000"	 & D(26 downto 21) 	when v = "00010101"
	else "00" & x"00000"	 & D(26 downto 22) 	when v = "00010110"
	else "000"& x"00000"	 & D(26 downto 23) 	when v = "00010111"
	else        x"000000"	 & D(26 downto 24)	when v = "00011000"
	else "0"  & x"000000"	 & D(26 downto 25)	when v = "00011001"
	else "00" & x"000000"	 & D(26)          	when v = "00011010"
	else "000"& x"000000";
end;
