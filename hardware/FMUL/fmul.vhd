library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fmul is
  port (A   : in std_logic_vector(31 downto 0);
        B   : in std_logic_vector(31 downto 0);
        clk : in std_logic;
        R   :out std_logic_vector(31 downto 0));
end fmul;

architecture behave of fmul is
  type exception is (ok, overflow, underflow);

  alias A_sign : std_logic is A(31);
  alias A_exponent : std_logic_vector(7 downto 0) is A(30 downto 23);
  alias A_fraction : std_logic_vector(22 downto 0) is A(22 downto 0);

  alias B_sign : std_logic is B(31);
  alias B_exponent : std_logic_vector(7 downto 0) is B(30 downto 23);
  alias B_fraction : std_logic_vector(22 downto 0) is B(22 downto 0);

  alias R_sign : std_logic is R(31);
  alias R_exponent : std_logic_vector(7 downto 0) is R(30 downto 23);
  alias R_fraction : std_logic_vector(22 downto 0) is R(22 downto 0);

  signal st1_sign: std_logic;
  signal st1_exponent: std_logic_vector(8 downto 0);
  signal st1_fraction: std_logic_vector(47 downto 0);

  signal st2_sign: std_logic;
  signal st2_exponent: std_logic_vector(8 downto 0);
  signal st2_fraction: std_logic_vector(26 downto 0);
  signal st2_exception: exception;

  constant fraction_roundup: std_logic_vector(25 downto 0) := (25 => '0', others => '1');
begin
  stage1: process(A, B) begin
    st1_exponent(8 downto 0) <= std_logic_vector(unsigned('0' & A_exponent) +
      unsigned('0' & B_exponent));
    st1_fraction <= std_logic_vector(unsigned('1' & A_fraction) *
                    unsigned('1' & B_fraction));
    st1_sign <= A_sign xor B_sign;
  end process;

  stage2: process(clk, st1_exponent, st1_fraction, st1_sign)
    variable fraction_shifted : std_logic_vector(26 downto 0);
    variable fraction_guard : std_logic_vector(26 downto 0);
  begin
    if rising_edge(clk) then
      if st1_fraction(47) = '1' then
        if unsigned(st1_fraction(22 downto 0)) > 0 then
          fraction_shifted := st1_fraction(47 downto 24) & "000";
          fraction_guard := (3 => st1_fraction(23), others => '0');
        else
          fraction_shifted := st1_fraction(47 downto 24) & "000";
          fraction_guard :=
            (3 => st1_fraction(23) and st1_fraction(24), others => '0');
        end if;
      else
        if unsigned(st1_fraction(21 downto 0)) > 0 then
          fraction_shifted := st1_fraction(47 downto 23) & "00";
          fraction_guard := (2 => st1_fraction(22), others => '0');
        else
          fraction_shifted := st1_fraction(47 downto 23) & "00";
          fraction_guard :=
            (2 => st1_fraction(22) and st1_fraction(23), others => '0');
        end if;
      end if;

      st2_exponent <= std_logic_vector(unsigned(st1_exponent) - 127);
      st2_fraction <= std_logic_vector(unsigned(fraction_shifted) +
                                       unsigned(fraction_guard));

      st2_sign <= st1_sign;
      if unsigned(st1_exponent) < 127 then
        st2_exception <= underflow;
      elsif unsigned(st1_exponent) > 381 then
        st2_exception <= overflow;
      else
        st2_exception <= ok;
      end if;
    end if;
  end process;

  stage3: process(clk, st2_exponent, st2_fraction, st2_exception, st2_sign) begin
    if rising_edge(clk) then
      case st2_exception is
        when underflow =>
          R_sign <= st2_sign;
          R_exponent <= (others => '0');
          R_fraction <= (others => '0');
        when overflow =>
          R_sign <= st2_sign;
          R_exponent <= (others => '1');
          R_fraction <= (others => '0');
        when ok =>
          R_sign <= st2_sign;

          if st2_fraction(26) = '1' then
            R_exponent <= std_logic_vector(unsigned(st2_exponent(7 downto 0)) + 1);
            R_fraction <= st2_fraction(25 downto 3);

          elsif st2_fraction(25 downto 0) = fraction_roundup then
            R_exponent <= std_logic_vector(unsigned(st2_exponent) + 1);
            R_fraction <= (others => '0');

          elsif st2_exponent(7 downto 0) = x"00" then
            R_exponent <= (others => '0');
            R_fraction <= (others => '0');
          elsif st2_exponent(7 downto 0) = x"FF" then
            R_exponent <= (others => '1');
            R_fraction <= (others => '0');
          else
            R_exponent <= st2_exponent(7 downto 0);
            R_fraction <= st2_fraction(24 downto 2);
          end if;
      end case;
    end if;
  end process;
end behave;
