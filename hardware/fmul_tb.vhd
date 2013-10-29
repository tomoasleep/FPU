LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;

ENTITY fmul_tb IS
END fmul_tb;

ARCHITECTURE FMUL_TESTBENCH OF fmul_tb IS 
  -- Component Declaration for the Unit Under Test (UUT)
  COMPONENT FMUL
    PORT(
      A            : in  std_logic_vector(31 downto 0);
      B            : in  std_logic_vector(31 downto 0);
      clk          : in  std_logic;
      R            : out std_logic_vector(31 downto 0) 
      );
  END COMPONENT;

  --Inputs
    signal iA  : std_logic_vector(31 downto 0) := (others => '0');
    signal iB  : std_logic_vector(31 downto 0) := (others => '0');

  --Outputs
    signal r : std_logic_vector(31 downto 0) := (others => '0');

  --Signals
    signal addr: std_logic_vector(7 downto 0) := "00000000";
    signal simclk: std_logic := '0';
BEGIN
  uut: SLICE_ADDER PORT MAP (
    clk => simclk,
    i => i,
    o => o
    );
  
 this_loops_forever: process(simclk)
  begin
    if rising_edge(simclk) then
      i<=addr;
      addr<=addr+1;
    end if;
  end process;

  clockgen: process
  begin
    simclk<='0';
    wait for 5 ns;
    simclk<='1';
    wait for 5 ns;
  end process;
END;
