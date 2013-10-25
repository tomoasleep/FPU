library IEEE;
use IEEE.STD_LOGIC_1164.All;
use IEEE.STD_LOGIC_ARITH.All;
use IEEE.STD_LOGIC_UNSIGNED.All;

library UNISIM;
use UNISIM.VComponents;

ENTITY mirror IS
GENERIC (rtime: std_logic_vector(15 downto 0) := x"1B16"); 
   PORT( im:in std_logic;
         clk:in std_logic;
	 mo:out std_logic_vector(7 downto 0);
	 went:out std_logic);
END mirror;


ARCHITECTURE reflection OF mirror is
--SIGNALS
signal average: std_logic_vector(15 downto 0) :=x"0000";
signal countdown: std_logic_vector(15 downto 0);
signal uwent :std_logic :='0';
signal memory   :std_logic_vector(8 downto 0) :="000100100";
signal state    :integer range 0 to 10 :=0;
--COMPONENTS

BEGIN
--PORT MAPS
went<=uwent;
--PROCESSES
statemachine: process(clk)
begin
  if rising_edge(clk) then
    case state is
      when 0=>
      uwent<='0';
        if im='0' then
	    countdown<=rtime;state<=1;
	  else countdown<=rtime;
	end if;

      when 2 =>
        if memory(8 downto 1)>x"7F" then state<=0; average<=x"0000"; end if;
	--to check the 2nd exercize, delete the double hyphen on the succeeding line. All the small alphabets would become to Capital.
	--if x"60"<memory(8 downto 1) and memory(8 downto 1)<x"7B" then memory(8 downto 1)<=memory(8 downto 1)-x"20"; end if;
        if countdown=x"00FF" then state<=0;countdown<=rtime;mo<=memory(8 downto 1);uwent<='1';average<=x"0000";
	else countdown<=countdown-1;
	end if;

      when 1 =>
	 if im='1'and countdown>x"0020"  then
		 state<=0;
	 else
           if countdown=0 then
		memory<="0"&memory(8 downto 1); state<=10;average<=x"0000";countdown<=rtime;
           else
	    countdown<=countdown-1;
	   end if;
	 end if;

      when 10|9|8|7|6|5|4|3 =>
	if countdown=0 then
	     average<=x"0000";
	     state<=state-1;
	     countdown<=rtime;
	else
	 if x"0B00"<countdown AND countdown< x"1000" then
	    countdown<=countdown-1;if im='1' then average<=average+1;end if;
	 else
           if countdown=x"0B00" then
		   if average>x"280" then memory<="1"&memory(8 downto 1);
		   else memory<="0"&memory(8 downto 1);
		   end if;
		   countdown<=countdown-1;
           else
	    countdown<=countdown-1;
	   end if;
	 end if;
	end if;

       when others =>
        state<=0;

    end case;
  end if;
end process;

END;
