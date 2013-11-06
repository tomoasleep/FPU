library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity FADD is
	port (A   : in std_logic_vector(31 downto 0);
	      B   : in std_logic_vector(31 downto 0);
	      clk : in std_logic;
	      R   :out std_logic_vector(31 downto 0));
end FADD;

architecture fadd32 of FADD is

	--COMPONENTS
	component BARREL_LEFT
		port( D : in  std_logic_vector(26 downto 0);
		      v : in  std_logic_vector(4 downto 0);
		      R : out std_logic_vector(26 downto 0));
	end component;
	
	component BARREL_RIGHT
		port( D : in  std_logic_vector(26 downto 0);
		      v : in  std_logic_vector(4 downto 0);
		      R : out std_logic_vector(26 downto 0));
	end component;

	--SIGNALS
	signal  bsl_data   : std_logic_vector(26 downto 0); 
	signal  bsl_value  : std_logic_vector( 4 downto 0); 
	signal  bsl_result : std_logic_vector(26 downto 0); 
	signal  bsr_data   : std_logic_vector(26 downto 0); 
	signal  bsr_value  : std_logic_vector( 4 downto 0); 
	signal  bsr_result : std_logic_vector(26 downto 0); 
	signal Winnerfrc :std_logic_vector(26 downto 0);
	signal Loserfrc :std_logic_vector(26 downto 0);
	signal state	:integer range 0 to 2 := 0;
	signal exception :integer range 0 to 1 := 1;
	signal exponent: std_logic_vector(8 downto 0);
	signal sign : std_logic;
	signal fraction: std_logic_vector(26 downto 0);

begin
	bsl: BARREL_LEFT
	port map(
			D => bsl_data,
			v => bsl_value,
			R => bsl_result	 );
	bsr: BARREL_RIGHT
	port map(
			D => bsl_data,
			v => bsl_value,
			R => bsl_result	 );


	process(clk)
	begin
		case(state) is
			when 0 => --大小比較し、小さい方を指数差分シフト
				state<=1;
				if (A(30 downto 0)>=B(30 downto 0)) then
					Winnerfrc <= "1"&A(22 downto 0)&"000";
					bsr_data  <= "1"&B(22 downto 0)&"000";
				        bsr_value <= A(30 downto 23)-B(30 downto 23); 	
					Loserfrc  <= bsr_result;
					exponent  <= "0"&A(30 downto 23);
					sign<=A(31);
				else
					Winnerfrc <= "1"&B(22 downto 0)&"000";
					bsr_data  <= "1"&A(22 downto 0)&"000";
				        bsr_value <= B(30 downto 23)-A(30 downto 23); 	
					Loserfrc  <= bsr_result;
					exponent  <= "0"&B(30 downto 0);
					sign<=B(31);
				when 1 =>
					state<=2;
				when 2 =>
					state<=0;
			end case;
		end process;
	end;
