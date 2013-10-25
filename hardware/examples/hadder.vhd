library IEEE;
use IEEE.std_logic_1164.all;

entity HALF_ADDER is
  port ( A,B : in  std_logic;
         T,O : out std_logic);
end HALF_ADDER;

architecture GATE of HALF_ADDER is
begin
  T <= A and B;
  O <= A xor B;
end GATE;
