library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity exception_handler is
  Port ( dataA  : in std_logic_vector(31 downto 0); 
         dataB  : in std_logic_vector(31 downto 0);
         sign   : in std_logic;
         flag   : out std_logic;
         result : out std_logic_vector(31 downto 0));
end exception_handler;

architecture main of exception_handler is
  constant exp_max : std_logic_vector(7 downto 0) := (others => '1');
  constant inf : std_logic_vector(30 downto 0)
    := (30 downto 23 => '1', 22 downto 0 => '0');
  constant zero : std_logic_vector(31 downto 0) := (others => '0');
  constant nan_value : std_logic_vector(31 downto 0) := (others => '1');

  signal is_zero_A : std_logic := '0';
  signal is_zero_B : std_logic := '0';

  signal is_exp_zero_A : std_logic := '0';
  signal is_exp_zero_B : std_logic := '0';

  signal is_exp_max_A : std_logic := '0';
  signal is_exp_max_B : std_logic := '0';

  signal is_frac_zero_A : std_logic := '0';
  signal is_frac_zero_B : std_logic := '0';

  signal is_inf_A : std_logic := '0';
  signal is_inf_B : std_logic := '0';

  signal is_nan_A : std_logic := '0';
  signal is_nan_B : std_logic := '0';

  signal is_non_regular_A : std_logic := '0';
  signal is_non_regular_B : std_logic := '0';

  signal is_exception_A : std_logic := '0';
  signal is_exception_B : std_logic := '0';

  signal isnt_pos_inf : std_logic := '0';
  signal isnt_neg_inf : std_logic := '0';
begin
  is_frac_zero_A <= '1' when dataA(22 downto 0) = 0 else '0';
  is_frac_zero_B <= '1' when dataB(22 downto 0) = 0 else '0';
  
  is_exp_zero_A <= '1' when dataA(30 downto 23) = 0 else '0';
  is_exp_zero_B <= '1' when dataB(30 downto 23) = 0 else '0';
  
  is_exp_max_A <= '1' when dataA(30 downto 23) = exp_max else '0';
  is_exp_max_B <= '1' when dataB(30 downto 23) = exp_max else '0';
  
  is_zero_A <= '1' when dataA(30 downto 0) = 0 else '0';
  is_zero_B <= '1' when dataB(30 downto 0) = 0 else '0';

  is_inf_A <= is_exp_max_A and is_frac_zero_A;
  is_inf_B <= is_exp_max_B and is_frac_zero_B;

  is_nan_A <= is_exp_max_A and (not is_frac_zero_A);
  is_nan_B <= is_exp_max_B and (not is_frac_zero_B);

  is_non_regular_A <= is_exp_zero_A and (not is_frac_zero_A);
  is_non_regular_B <= is_exp_zero_B and (not is_frac_zero_B);

  is_exception_A <= is_zero_A or is_inf_A or is_nan_A or is_non_regular_A;
  is_exception_B <= is_zero_B or is_inf_B or is_nan_B or is_non_regular_B;

  flag <= is_exception_A or is_exception_B;
  result <= zero   when is_zero_A = '1' or is_zero_B = '1' else
            dataA   when (is_nan_A or is_non_regular_A) = '1' else
            dataB   when (is_nan_B or is_non_regular_B) = '1' else
            sign & inf when isnt_pos_inf = '1' else
            nan_value;
end main;
