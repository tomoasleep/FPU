library IEEE;
use IEEE.std_logic_1164.all;



entity PRI_ENCODER is
	port (i : in std_logic_vector(31 downto 0);
	      o : out std_logic_vector(4 downto 0));
end PRI_ENCODER;

architecture priority_32to5 of PRI_ENCODER is

  --合成したほうがよい、と言う場合のための下準備
  --  component PRI_ENCODER_8TO3 
  --    port (i : in std_logic_vector(7 downto 0);
  --      	  o : out std_logic_vector(2 downto 0);
  --	  Valid : out std_logic);
  --    end PRI_ENCODER_8TO3;
  --
  --  component PRI_ENCODER_4TO2 
  --    port (i : in std_logic_vector(3 downto 0);
  --      	  o : out std_logic_vector(1 downto 0);
  --	  Valid : out std_logic);
  --    end PRI_ENCODER_4TO2;
  --
  --signal interCarry: std_logic_vector()

begin
	process( i )
	begin
		if    (i(31) = '1') then o <= "11111";   
		elsif (i(30) = '1') then o <= "11110";
		elsif (i(29) = '1') then o <= "11101";
		elsif (i(28) = '1') then o <= "11100";
		elsif (i(27) = '1') then o <= "11011";
		elsif (i(26) = '1') then o <= "11010";
		elsif (i(25) = '1') then o <= "11001";
		elsif (i(24) = '1') then o <= "11000";
		elsif (i(23) = '1') then o <= "10111";
		elsif (i(22) = '1') then o <= "10110";
		elsif (i(21) = '1') then o <= "10101";
		elsif (i(20) = '1') then o <= "10100";
		elsif (i(19) = '1') then o <= "10011";
		elsif (i(18) = '1') then o <= "10010";
		elsif (i(17) = '1') then o <= "10001";
		elsif (i(16) = '1') then o <= "10000";
		elsif (i(15) = '1') then o <= "01111";
		elsif (i(14) = '1') then o <= "01110";
		elsif (i(13) = '1') then o <= "01101";
		elsif (i(12) = '1') then o <= "01100";
		elsif (i(11) = '1') then o <= "01011";
		elsif (i(10) = '1') then o <= "01010";
		elsif (i(9 ) = '1') then o <= "01001";
		elsif (i(8 ) = '1') then o <= "01000";
		elsif (i(7 ) = '1') then o <= "00111";
		elsif (i(6 ) = '1') then o <= "00110";
		elsif (i(5 ) = '1') then o <= "00101";
		elsif (i(4 ) = '1') then o <= "00100";
		elsif (i(3 ) = '1') then o <= "00011";
		elsif (i(2 ) = '1') then o <= "00010";
		elsif (i(1 ) = '1') then o <= "00001";
		elsif (i(0 ) = '1') then o <= "00000";
		else
			o<="00000";
		end if;
	end process;
end priority_32to5;
