LIBRARY ieee;
USE ieee.std_logic_1164.all;

PACKAGE ProcesadorPack IS
--------------------------------------------------------
COMPONENT ALU IS
  PORT (
    A, B : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    SEL : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    ENABLE : IN STD_LOGIC;
    RESULTADO : INOUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    FLAGS : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
  );
END COMPONENT ALU;
--------------------------------------------------------

--------------------------------------------------------
COMPONENT MUX_4to1 is
    Port ( 
        S    : in  STD_LOGIC_VECTOR(1 downto 0); -- Selección de entrada
        D0   : in  STD_LOGIC_VECTOR(7 downto 0); -- Datos de entrada 0
        D1   : in  STD_LOGIC_VECTOR(7 downto 0); -- Datos de entrada 1
        D2   : in  STD_LOGIC_VECTOR(7 downto 0); -- Datos de entrada 2
        D3   : in  STD_LOGIC_VECTOR(7 downto 0); -- Datos de entrada 3
        Y    : out STD_LOGIC_VECTOR(7 downto 0)  -- Salida
    );
END COMPONENT MUX_4to1;
--------------------------------------------------------

--------------------------------------------------------
COMPONENT registro10 IS 
PORT(
    	d   : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    	ld  : IN STD_LOGIC;
    	clr : IN STD_LOGIC;
    	clk : IN STD_LOGIC;
    	q   : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
END COMPONENT registro10;
--------------------------------------------------------

END ProcesadorPack;