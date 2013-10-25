library IEEE;
use IEEE.std_logic_1164.all;

entity PRI_ENCODER_8TO3 is
  port ( i : in std_logic_vector(7 downto 0);
  	 o : out std_logic_vector(2 downto 0);
	 Valid : out std_logic);
  end PRI_ENCODER_8TO3;

  architecture priority_8to3 of PRI_ENCODER_8TO3 is
  begin
    process( i )
    begin
        Valid<='1';
	if    (i(7) = '1') => o <= "111";
	elsif (i(6) = '1') => o <= "110";
	elsif (i(5) = '1') => o <= "101";
	elsif (i(4) = '1') => o <= "100";
	elsif (i(3) = '1') => o <= "011";
	elsif (i(2) = '1') => o <= "010";	
	elsif (i(1) = '1') => o <= "001";	
	elsif (i(0) = '1') => o <= "000";
	else
		Valid<=0;
		o<="XXX";
	end if
     end process
   end priority_8to3;





