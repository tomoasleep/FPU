library IEEE;
use IEEE.std_logic_1164.all;

entity FULL_ADDER is
  port (A,B,C : in std_logic;
        T,O   : out std_logic);
end FULL_ADDER;

architecture faGATE of FULL_ADDER is
begin
  T <= (A and B) or (B and C) or (C and A);
  O <= (A xor B) xor C;
end faGATE;
