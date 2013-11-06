library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity BARREL_RIGHT is
	port (D   : in std_logic_vector(26 downto 0);
	      v   : in std_logic_vector(4 downto 0);
	      R   :out std_logic_vector(26 downto 0));
end BARREL_RIGHT;

architecture shift_right of BARREL_RIGHT is

begin
	case(v) is
		when "00000" => R <=     		 & A(26 downto 0);
		when "00001" => R <= "0" 		 & A(26 downto 1);
		when "00010" => R <= "00"		 & A(26 downto 2);
		when "00011" => R <= "000"		 & A(26 downto 3);
		when "00100" => R <=      & x"0"	 & A(26 downto 4);
		when "00101" => R <= "0"  & x"0"	 & A(26 downto 5);
		when "00110" => R <= "00" & x"0"	 & A(26 downto 6);
		when "00111" => R <= "000"& x"0"	 & A(26 downto 7);
		when "01000" => R <=      & x"00"	 & A(26 downto 8);
		when "01001" => R <= "0"  & x"00"	 & A(26 downto 9);
		when "01010" => R <= "00" & x"00"	 & A(26 downto 10);
		when "01011" => R <= "000"& x"00"	 & A(26 downto 11);
		when "01100" => R <=      & x"000"	 & A(26 downto 12);
		when "01101" => R <= "0"  & x"000"	 & A(26 downto 13);
		when "01110" => R <= "00" & x"000"	 & A(26 downto 14);
		when "01111" => R <= "000"& x"000"	 & A(26 downto 15);
		when "10000" => R <=      & x"0000"	 & A(26 downto 16);
		when "10001" => R <= "0"  & x"0000"	 & A(26 downto 17);
		when "10010" => R <= "00" & x"0000"	 & A(26 downto 18);
		when "10011" => R <= "000"& x"0000"	 & A(26 downto 19);
		when "10100" => R <=      & x"00000"	 & A(26 downto 20);
		when "10101" => R <= "0"  & x"00000"	 & A(26 downto 21);
		when "10110" => R <= "00" & x"00000"	 & A(26 downto 22);
		when "10111" => R <= "000"& x"00000"	 & A(26 downto 23);
		when "11000" => R <=      & x"000000"	 & A(26 downto 24);
		when "11001" => R <= "0"  & x"000000"	 & A(26 downto 25);
		when "11010" => R <= "00" & x"000000"	 & A(26);
		when "11011" => R <= "000"& x"000000"	
		when "11100" => R <= "000"& x"000000"
		when "11101" => R <= "000"& x"000000"
		when "11110" => R <= "000"& x"000000"
		when "11111" => R <= "000"& x"000000"
	end case;
end;
