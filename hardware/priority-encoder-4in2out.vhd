library IEEE;
use IEEE.std_logic_1164.all;

entity PRI_ENCODER_4TO2 is
  port ( i : in std_logic_vector(3 downto 0);
  	 o : out std_logic_vector(1 downto 0);
	 Valid : out std_logic);
  end PRI_ENCODER_4TO2;

  architecture priority_4to2 of PRI_ENCODER_4TO2 is
  begin
    process( i )
    begin
        Valid<='1';
	if    (i(3) = '1') => o <= "11";
	elsif (i(2) = '1') => o <= "10";	
	elsif (i(1) = '1') => o <= "01";	
	elsif (i(0) = '1') => o <= "00";
	else
		Valid<=0;
		o<="XX";
	end if
     end process
   end priority_4to2;





