library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity BARREL_LEFT is
	port (D   : in std_logic_vector(26 downto 0);
	      v   : in std_logic_vector(7 downto 0);
	      clk: in std_logic;
	      R   :out std_logic_vector(26 downto 0));
end BARREL_LEFT;

architecture shift_left of BARREL_LEFT is

begin
	process(clk)
	begin
		if rising_edge(clk) then
			case(v) is
				when "00000000" => R <=  D(26 downto 0)     		  ;
				when "00000001" => R <=  D(25 downto 0) &"0" 		  ;
				when "00000010" => R <=  D(24 downto 0) &"00"		  ;
				when "00000011" => R <=  D(23 downto 0) &"000"		  ;
				when "00000100" => R <=  D(22 downto 0)       & x"0" 	  ;
				when "00000101" => R <=  D(21 downto 0) &"0"  & x"0" 	  ;
				when "00000110" => R <=  D(20 downto 0) &"00" & x"0" 	  ;
				when "00000111" => R <=  D(19 downto 0) &"000"& x"0" 	  ;
				when "00001000" => R <=  D(18 downto 0)       & x"00"	  ;
				when "00001001" => R <=  D(17 downto 0) &"0"  & x"00"	  ;
				when "00001010" => R <=  D(16 downto 0) &"00" & x"00"	  ;
				when "00001011" => R <=  D(15 downto 0) &"000"& x"00"	  ;
				when "00001100" => R <=  D(14 downto 0)       & x"000"	  ;
				when "00001101" => R <=  D(13 downto 0) &"0"  & x"000"	  ;
				when "00001110" => R <=  D(12 downto 0) &"00" & x"000"	  ;
				when "00001111" => R <=  D(11 downto 0) &"000"& x"000"	  ;
				when "00010000" => R <=  D(10 downto 0)       & x"0000"	  ;
				when "00010001" => R <=  D( 9 downto 0) &"0"  & x"0000"	  ;
				when "00010010" => R <=  D( 8 downto 0) &"00" & x"0000"	  ;
				when "00010011" => R <=  D( 7 downto 0) &"000"& x"0000"	  ;
				when "00010100" => R <=  D( 6 downto 0)       & x"00000"	  ;
				when "00010101" => R <=  D( 5 downto 0) &"0"  & x"00000"	  ;
				when "00010110" => R <=  D( 4 downto 0) &"00" & x"00000"	  ;
				when "00010111" => R <=  D( 3 downto 0) &"000"& x"00000"	  ;
				when "00011000" => R <=  D( 2 downto 0)       & x"000000"	  ;
				when "00011001" => R <=  D( 1 downto 0) &"0"  & x"000000"	  ;
				when "00011010" => R <=  D( 0)	   & "00" & x"000000" ;	  
				when others => R <=  "000"& x"000000";	
			end case;
		end if;
	end process;
end;
