library IEEE;
use IEEE.STD_LOGIC_1164.All;
use IEEE.STD_LOGIC_ARITH.All;
use IEEE.STD_LOGIC_UNSIGNED.All;

library UNISIM;
use UNISIM.VComponents.all;

entity top is
  port ( MCLK1 : in std_logic;
  	 RS_TX : out std_logic;
	 RS_RX : in std_logic);
end top;

ARCHITECTURE loopback of top IS
--SIGNALS
signal clk:std_logic;
signal iclk:std_logic;
signal ugo:std_logic;
signal uwent:std_logic;
signal ubusy:std_logic;
signal bufstat:std_logic_vector(2 downto 0):="000";
signal output:std_logic_vector(7 downto 0):="00000000";
signal buff:std_logic_vector(7 downto 0):="00000000";
--COMPONENTS
COMPONENT u232c 
  GENERIC(wtime: std_logic_vector(15 downto 0):=x"1ADB");
  Port ( clk  : in  STD_LOGIC;
        data : in  STD_LOGIC_VECTOR (7 downto 0);
	go   : in  STD_LOGIC;
	busy : out STD_LOGIC;
	tx   : out STD_LOGIC);
end component;

COMPONENT mirror
  GENERIC(rtime: std_logic_vector(15 downto 0):=x"1B16");
  PORT (
  im:in std_logic;
  clk:in std_logic;
  mo:out std_logic_vector(7 downto 0);
  went:out std_logic
  );
END COMPONENT;

BEGIN
--PROCESSES
ib: IBUFG port map (
  i=>MCLK1,
  o=>iclk);
bg: BUFG port map (
  i=>iclk,
  o=>clk);
mr: mirror port map(
  im=>RS_RX,
  clk=>clk,
  mo=>output,
  went=>uwent);
uc: u232c port map(
clk=>clk,
data=>buff,
go=>ugo,
busy=>ubusy,
tx=>RS_TX);

buf:process(clk)
begin
if rising_edge(clk)then
 case bufstat is
  when "000" => --入力待ち
    ugo<='0';
	if uwent='1' then
    	bufstat<="100"; buff<=output;
 	end if;
  when "001" => --出力中
   ugo<='0';
    if uwent='1' then
    bufstat<="010";buff<=output;
    else
	if ubusy='0' then 
    	bufstat<="000";
	end if;
    end if;
  when "100" => --書き換え
  	ugo<='1';
	if uwent='1'then bufstat<="101"; else bufstat<="001";end if;
  when "010" => --出力終わり待ち
    if ubusy='0' then bufstat<="100";end if;
    if uwent='1' then bufstat<="011";end if;
  when "011" =>
    if ubusy='0' then ugo<='1';bufstat<="110"; end if;
    if uwent='1' then bufstat<="111"; end if;
  when "110" =>
    ugo<='0';buff<=output;
    if uwent='1' then bufstat<="011"; else bufstat<="010"; end if;
  when "101" =>
    ugo<='0';
    bufstat<="010";buff<=output;
  when "111" =>
    ugo<='1';
  when others => bufstat<="000";
 end case; 	  
end if;
end process;

END;
