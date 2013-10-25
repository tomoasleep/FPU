library IEEE;
use IEEE.std_logic_1164.all;

entity SLICE_ADDER is
  port (clk            : in  std_logic;
        i              : in  std_logic_vector(7 downto 0);
        o          : out std_logic_vector(3 downto 0));
end SLICE_ADDER;

architecture saGATE of SLICE_ADDER is

  component HALF_ADDER
   port(A,B : in  std_logic;
        T,O : out std_logic);
  end component;

  component FULL_ADDER
   port(A,B,C : in  std_logic;
        T,O   : out std_logic);
  end component;

signal interCarry : std_logic_vector(9 downto 0);

begin
    
     ha0: HALF_ADDER port map(
               A => interCarry(9),
               B => interCarry(8),
               T => o(3),
               O => o(2) );

     ha1: HALF_ADDER port map(
               A => interCarry(6),
               B => interCarry(7),
               T => interCarry(9),
               O => o(1) );

     ha2: HALF_ADDER port map(
               A => i(6),
               B => i(7),
               T => interCarry(5),
               O => interCarry(4) );

     fa0: FULL_ADDER port map(
               A => interCarry(0),
               B => interCarry(2),
               C => interCarry(4),
               T => interCarry(6),
               O => o(0) );

     fa1: FULL_ADDER port map(
               A => interCarry(1),
               B => interCarry(3),
               C => interCarry(5),
               T => interCarry(8),
               O => interCarry(7) );

     fa2: FULL_ADDER port map(
               A => i(0),
               B => i(1),
               C => i(2),
               T => interCarry(1),
               O => interCarry(0) );

     fa3: FULL_ADDER port map(
               A => i(3),
               B => i(4),
               C => i(5),
               T => interCarry(3),
               O => interCarry(2) );

end saGATE;







