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
  component fmul_exception_handler
    Port ( dataA  : in std_logic_vector(31 downto 0); 
           dataB  : in std_logic_vector(31 downto 0);
           sign   : in std_logic;
           flag   : out std_logic;
           result : out std_logic_vector(31 downto 0));
  end component;

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
  signal st2_calc_exception: exception;

  signal input_exception_flag: std_logic;
  signal input_exception_result: std_logic_vector(31 downto 0);

  signal st2_input_exception_flag: std_logic;
  signal st2_input_exception_result: std_logic_vector(31 downto 0);

  constant fraction_roundup: std_logic_vector(23 downto 0) := (others => '1');
begin
  ex_handler: fmul_exception_handler
  port map (
    dataA => A,
    dataB => B,
    sign => st1_sign,
    flag => input_exception_flag,
    result => input_exception_result);

  stage1: process(A, B) begin
    st1_exponent(8 downto 0) <= std_logic_vector(unsigned('0' & A_exponent) +
      unsigned('0' & B_exponent));
    st1_fraction <= std_logic_vector(unsigned('1' & A_fraction) *
                    unsigned('1' & B_fraction));
    st1_sign <= A_sign xor B_sign;
  end process;

  stage2: process(clk, st1_exponent, st1_fraction, st1_sign, input_exception_flag, input_exception_result)
    variable fraction_shifted : std_logic_vector(26 downto 0);

    variable sticky_bit : std_logic;
    variable exp_increment : std_logic_vector(0 downto 0);
    variable msb : integer := 47;
  begin
    if rising_edge(clk) then
      if st1_fraction(47) = '1' then
        msb := 47;
        exp_increment := "1";
      else
        msb := 46;
        exp_increment := "0";
      end if;

      if unsigned(st1_fraction(msb - 26 downto 0)) = 0 then
        sticky_bit := '0';
      else
        sticky_bit := '1';
      end if;

      fraction_shifted := st1_fraction(msb downto msb - 25) & sticky_bit;

      if fraction_shifted(26 downto 3) = fraction_roundup then
        exp_increment := "1";
      end if;

      st2_fraction <= fraction_shifted;
      st2_exponent <= std_logic_vector(unsigned(st1_exponent) - 127 + unsigned(exp_increment));
      st2_sign <= st1_sign;

      if unsigned(st1_exponent) + unsigned(exp_increment) <= 127 then
        st2_calc_exception <= underflow;
      elsif unsigned(st1_exponent) + unsigned(exp_increment) >= (127 + 255) then
        st2_calc_exception <= overflow;
      else
        st2_calc_exception <= ok;
      end if;

      st2_input_exception_result <= input_exception_result;
      st2_input_exception_flag <= input_exception_flag;
    end if;
  end process;

  stage3: process(clk, st2_exponent, st2_fraction, st2_calc_exception, st2_sign, st2_input_exception_flag, st2_input_exception_result)
    variable rounded_exponent : std_logic_vector(8 downto 0);
    variable rounded_fraction : std_logic_vector(22 downto 0);
  begin
    if rising_edge(clk) then
      if st2_input_exception_flag = '1' then
        R <= st2_input_exception_result;
      else
        case st2_calc_exception is
          when underflow =>
            R_sign <= '0';
            R_exponent <= (others => '0');
            R_fraction <= (others => '0');
          when overflow =>
            R_sign <= st2_sign;
            R_exponent <= (others => '1');
            R_fraction <= (others => '0');
          when ok =>
            R_sign <= st2_sign;
            rounded_exponent := st2_exponent;

            if (st2_fraction(2) and (st2_fraction(3) or st2_fraction(1) or st2_fraction(0))) = '1' then
              rounded_fraction := std_logic_vector(unsigned(st2_fraction(25 downto 3)) + 1);
            else
              rounded_fraction := st2_fraction(25 downto 3);
            end if;

            R_exponent <= rounded_exponent(7 downto 0);
            R_fraction <= rounded_fraction;
        end case;
      end if;
    end if;
  end process;
end behave;
