LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;

ENTITY alutb IS
END alutb;

ARCHITECTURE testbench OF alutb IS 
  -- Component Declaration for the Unit Under Test (UUT)
  COMPONENT SLICE_ADDER
    PORT(
      clk          : in  std_logic;
      i            : in  std_logic_vector(7 downto 0);
      o        : out std_logic_vector(3 downto 0) 
      );
  END COMPONENT;

  --Inputs
    signal i  : std_logic_vector(7 downto 0) := (others => '0');

  --Outputs
    signal o : std_logic_vector(3 downto 0) := (others => '0');

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
