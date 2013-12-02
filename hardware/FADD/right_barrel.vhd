library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity BARREL_RIGHT is
	port (D   : in std_logic_vector(26 downto 0);
	      v   : in std_logic_vector(7 downto 0);
	      clk : in std_logic;
	      R   :out std_logic_vector(26 downto 0));
end BARREL_RIGHT;

architecture shift_right of BARREL_RIGHT is

begin
	process(clk)
	begin
		if rising_edge(clk) then
			case(v) is
				when "00000000" => R <=     		   D(26 downto 0);
				when "00000001" => R <= "0" 		 & D(26 downto 1);
				when "00000010" => R <= "00"		 & D(26 downto 2);
				when "00000011" => R <= "000"		 & D(26 downto 3);
				when "00000100" => R <=        x"0"	 & D(26 downto 4);
				when "00000101" => R <= "0"  & x"0"	 & D(26 downto 5);
				when "00000110" => R <= "00" & x"0"	 & D(26 downto 6);
				when "00000111" => R <= "000"& x"0"	 & D(26 downto 7);
				when "00001000" => R <=        x"00"	 & D(26 downto 8);
				when "00001001" => R <= "0"  & x"00"	 & D(26 downto 9);
				when "00001010" => R <= "00" & x"00"	 & D(26 downto 10);
				when "00001011" => R <= "000"& x"00"	 & D(26 downto 11);
				when "00001100" => R <=        x"000"	 & D(26 downto 12);
				when "00001101" => R <= "0"  & x"000"	 & D(26 downto 13);
				when "00001110" => R <= "00" & x"000"	 & D(26 downto 14);
				when "00001111" => R <= "000"& x"000"	 & D(26 downto 15);
				when "00010000" => R <=        x"0000"	 & D(26 downto 16);
				when "00010001" => R <= "0"  & x"0000"	 & D(26 downto 17);
				when "00010010" => R <= "00" & x"0000"	 & D(26 downto 18);
				when "00010011" => R <= "000"& x"0000"	 & D(26 downto 19);
				when "00010100" => R <=        x"00000"	 & D(26 downto 20);
				when "00010101" => R <= "0"  & x"00000"	 & D(26 downto 21);
				when "00010110" => R <= "00" & x"00000"	 & D(26 downto 22);
				when "00010111" => R <= "000"& x"00000"	 & D(26 downto 23);
				when "00011000" => R <=        x"000000"	 & D(26 downto 24);
				when "00011001" => R <= "0"  & x"000000"	 & D(26 downto 25);
				when "00011010" => R <= "00" & x"000000"	 & D(26);
				when others => R <= "000"& x"000000";	
			end case;
		end if;
	end process;
end;
