library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity Multiplier is
	generic (n: integer :=4);
	port (
			Rst, CLK, SI : in std_logic;
			Low, High : out std_logic_vector (n-1 downto 0));
end Multiplier;

architecture RTL of Multiplier is


component CtrlLogic
	generic ( n: integer := 4 );
	port ( 	Rst, CLK : in std_logic;
			SL_A, SL_B, SL_H, SL_L, SL_C : out std_logic;
			EN_A, EN_B, EN_H, EN_L, EN_C : out std_logic );
end component;
component AdderKZ
	generic (n: integer :=4);
	port ( 	CTRL : in std_logic;
			A, B : in std_logic_vector (n-1 downto 0);
			F : out std_logic_vector (n-1 downto 0);
			COUT : out std_logic );
end component;
component Reg
	generic (n: integer:=4);
	port ( 	D_IN: in std_logic_vector (n-1 downto 0);
			SI, CLK, RST, SLOAD, ENABLE: in std_logic;
			SO: out std_logic;
			D_OUT: out std_logic_vector (n-1 downto 0));
end component;

signal SL_A,EN_A, SO_A,SL_B,EN_B, SO_B,SL_C,EN_C, SO_C : STD_LOGIC;
signal SL_H,EN_H, SO_H,SL_L,EN_L, SO_L : STD_LOGIC;
signal A,B,F_ADD, H:STD_LOGIC_VECTOR(N-1 downto 0);
signal C, COUT:STD_LOGIC_VECTOR(0 downto 0);

BEGIN 
uA: Reg generic map(n=>4)
	port map(D_IN=>(n-1 downto 0=>'0'), SI=>SI,CLK=>CLK,RST=>RST,SLOAD=>SL_A,
				ENABLE=>EN_A,SO=>SO_A,D_OUT=>A);
uB: Reg generic map(n=>4)
	port map(D_IN=>(n-1 downto 0=>'0'), SI=>SI,CLK=>CLK,RST=>RST,SLOAD=>SL_B,
				ENABLE=>EN_B,SO=>SO_B,D_OUT=>B);
uAdder:AdderKZ generic map(n=>4)	
				PORT MAP( CTRL=>B(0), A=>A,B=>H,F=>F_ADD,COUT=>COUT(0));
uC: Reg generic map(n=>1)
	port map(D_IN=>COUT, SI=>'0',CLK=>CLK,RST=>RST,SLOAD=>SL_C,
				ENABLE=>EN_C,SO=>SO_C,D_OUT=>C);
uH: Reg generic map(n=>4)
	port map(D_IN=>F_ADD, SI=>SO_C,CLK=>CLK,RST=>RST,SLOAD=>SL_H,
				ENABLE=>EN_H,SO=>SO_H,D_OUT=>H);
uL: Reg generic map(n=>4)
	port map(D_IN=>(n-1 downto 0=>'0'), SI=>SO_H,CLK=>CLK,RST=>RST,SLOAD=>SL_L,
				ENABLE=>EN_L,SO=>SO_L,D_OUT=>Low);		
uCTRL: CtrlLogic generic map (n=>4)
		port map(Rst=>RST,CLK=>CLK,SL_A=>SL_A,SL_B=>SL_B,SL_H=>SL_H,SL_L=>SL_L,
		SL_C=>SL_C,EN_A=>EN_A,EN_B=>EN_B,EN_H=>EN_H,EN_L=>EN_L,EN_C=>EN_C);
High<=h;
end RTL;		
		