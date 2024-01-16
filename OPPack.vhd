LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

PACKAGE OPpack is

COMPONENT ROM IS
	PORT(address: IN integer range 0 to 128;
		data: OUT std_logic_vector (23 downto 0));
END COMPONENT ROM;

FUNCTION ADD(
    a, b: IN std_logic_vector (8 downto 0);
    cin: IN std_logic) RETURN std_logic_vector;
	
FUNCTION SUB(
    a, b: IN std_logic_vector (8 downto 0)
) RETURN std_logic_vector;


FUNCTION TIMES(
    a, b: IN std_logic_vector (4 downto 0)
) RETURN std_logic_vector;

				
FUNCTION CMP(
    x, y: IN std_logic_vector(8 downto 0)
) RETURN std_logic_vector;


FUNCTION DIV(
    a, b: IN std_logic_vector(8 downto 0)
) RETURN std_logic_vector;

FUNCTION SHIFT(
    A: IN std_logic_vector(8 downto 0);
    Modo, Entrada: IN std_logic
) RETURN std_logic_vector;


FUNCTION OPLOG(
		SELEC : std_logic_vector (1 downto 0); 
		A : std_logic_vector (9 downto 0); 
		B :std_logic_vector (9 downto 0)) RETURN std_logic_vector;


PROCEDURE ALU (A,B: IN std_logic_vector(8 downto 0);
				SEL: IN std_logic_vector(3 downto 0);
				RESULTADO: INOUT std_logic_vector(9 downto 0);
				FLAGS: OUT std_logic_vector(3 downto 0));


END OPpack;


PACKAGE BODY OPpack IS

--SUMA--
FUNCTION ADD(
    a, b: IN std_logic_vector (8 downto 0);
    cin: IN std_logic
			) RETURN std_logic_vector IS
    VARIABLE sum_result: std_logic_vector (9 downto 0);
    VARIABLE flags_result: std_logic_vector (3 downto 0);
    VARIABLE cout: std_logic;
BEGIN
    cout := cin;
    FOR i IN 0 TO 8 LOOP
        IF cout = '0' THEN
            sum_result(i) := a(i) XOR b(i);
            cout := a(i) AND b(i);
        ELSE
            sum_result(i) := a(i) XNOR b(i);
            cout := a(i) OR b(i);
        END IF;
    END LOOP;
	sum_result(9) := cout;

RETURN sum_result;
END FUNCTION ADD;
--FIN SUMA--

--RESTA--
FUNCTION SUB(
    a, b: IN std_logic_vector (8 downto 0)
) RETURN std_logic_vector IS
    VARIABLE sum_result: std_logic_vector (9 downto 0);
BEGIN
    sum_result := ADD(a, NOT b, '1');
    IF sum_result(9) = '0' THEN
        sum_result := (NOT sum_result) + '1';
        sum_result(9) := '1';
    ELSIF sum_result(9) = '1' THEN
        sum_result := '0' & sum_result(8 downto 0);
    END IF;
RETURN sum_result;
END FUNCTION SUB;
--FIN RESTA--


---MULTIPLICACION--
FUNCTION TIMES(
    a, b: IN std_logic_vector (4 downto 0)
) RETURN std_logic_vector IS
    VARIABLE mult1, mult2, mult3, mult4: std_logic_vector (8 downto 0) := "000000000";
    VARIABLE sum1, sum2, sum3, sum4: std_logic_vector (9 downto 0) := "0000000000";
    VARIABLE result: std_logic_vector (9 downto 0) := "0000000000";
BEGIN
    FOR i IN 0 TO 4 LOOP
        IF b(i) = '1' THEN
            CASE i IS
                WHEN 0 =>
                    mult1 := "0000" & a(4 downto 0);
                WHEN 1 =>
                    mult2 := "000" & a(4 downto 0) & "0";
                WHEN 2 =>
                    mult3 := "00" & a(4 downto 0) & "00";
                WHEN 3 =>
                    mult4 := "0" & a(4 downto 0) & "000";
                WHEN 4 =>
                    sum4 := "0" & a(4 downto 0) & "0000";
            END CASE;
        END IF;
    END LOOP;

    sum1 := ADD(mult1, mult2, '0');
    sum2 := ADD(mult3, mult4, '0');
    sum3 := ADD(sum1(8 downto 0), sum2(8 downto 0), '0');
    result := ADD(sum3(8 downto 0), sum4(8 downto 0), '0');
    
RETURN result;
END FUNCTION TIMES;
---FIN MULTIPLICACION--



--COMPARADOR
FUNCTION CMP(
    x, y: IN std_logic_vector(8 downto 0)
) RETURN std_logic_vector IS
    VARIABLE Gi, Li: std_logic := '0';
    VARIABLE Go, Lo: std_logic;
BEGIN
    FOR i IN 0 TO 7 LOOP
        Gi := (x(i) AND (NOT y(i))) OR (x(i) AND Gi) OR ((NOT y(i)) AND Gi);
        Li := (NOT x(i) AND y(i)) OR (NOT x(i) AND Li) OR (y(i) AND Li);
    END LOOP;

    Go := Gi;
    Lo := Li;

    RETURN Go&Lo; -- Devolver el resultado como std_logic_vector
END FUNCTION;
---FIN COMPARADOR---



--DIVISION----
FUNCTION DIV(
    a, b: IN std_logic_vector(8 downto 0)
) RETURN std_logic_vector IS
    VARIABLE numComp: std_logic_vector(17 downto 0);
    VARIABLE resta: std_logic_vector(9 downto 0);
    VARIABLE cociente: std_logic_vector(8 downto 0);
    VARIABLE cTemp: std_logic;
	VARIABLE comparacion: std_logic_vector(1 downto 0);
BEGIN
    numComp := "000000000"&a;
	--numComp := numComp(16 downto 0)&numComp(17);
    
    FOR i IN 8 DOWNTO 0 LOOP
		numComp := numComp(16 downto 0)&numComp(17);
        comparacion := CMP(x => numComp(17 downto 9), y => b);

        IF comparacion = "10" THEN --Mayor
            cTemp := '1';
            resta := SUB(a => numComp(17 downto 9), b => b);
            numComp(17 downto 9) := resta(8 downto 0);
            --numComp := numComp(16 downto 0) & numComp(17);

        ELSIF comparacion = "01" THEN --Menor
            cTemp := '0';
            --numComp := numComp(16 downto 0) & numComp(17);

        ELSIF comparacion = "00" THEN --Igual
            cTemp := '1';
            resta := SUB(a => numComp(17 downto 9), b => b);
            numComp(17 downto 9) := resta(8 downto 0);
            --numComp := numComp(16 downto 0) & numComp(17);
        END IF;

        cociente(i) := cTemp;
    END LOOP;

    RETURN "0" & cociente;
END FUNCTION DIV;

--FIN DIVISION---


---OPERACIONES LOGICAS---
FUNCTION OPLOG(
		SELEC : std_logic_vector (1 downto 0); 
		A : std_logic_vector (9 downto 0); 
		B :std_logic_vector (9 downto 0)) RETURN std_logic_vector IS
		VARIABLE Co : std_logic_vector(9 downto 0) := (others => '0'); --Variable de acarreo out
		VARIABLE xorAC : std_logic_vector(9 downto 0) := (others => '0'); 
		CONSTANT C : std_logic_vector(9 downto 0) := "0000000001";  --Numero 1 de 10 bits para calcular el complemento a 2
		VARIABLE notA : std_logic_vector(9 downto 0);
		VARIABLE RESULT : std_logic_vector (9 downto 0);
		VARIABLE auxSELEC : std_logic_vector(1 downto 0);
		VARIABLE S : std_logic_vector(9 downto 0);
	BEGIN
		auxSELEC := SELEC;
		CASE auxSELEC is 
			WHEN "00" => --Complemento a 1 de A
				S := not A;
			WHEN "01" => --Complemento a 2 de A
				notA := not A;
				FOR i IN 0 TO 9 LOOP --Este algoritmo hace una suma de 10 bits ignorando el ultimo Carry out 
					xorAC(i) := notA(i) xor C(i);
					S(i) := xorAC(i) xor Co(i);
					IF i < 9 THEN
						Co(i+1):= (notA(i) and C(i)) or (Co(i) and xorAC(i));
					END IF;
				END LOOP;
			WHEN "10" => --A and B
				S := A and B;
			WHEN "11" => --A or B
				S := A or B;
			WHEN OTHERS => S := "0000000000";
		END CASE;
		RETURN S;
	END FUNCTION;
---FIN OPERACIONES LOGICAS---




--CORRIMIENTOS---
FUNCTION SHIFT(
    A: IN std_logic_vector(8 downto 0);
    Modo, Entrada: IN std_logic
) RETURN std_logic_vector IS
    VARIABLE cTmp: std_logic_vector(8 downto 0);
BEGIN
	cTmp := A;
    IF Modo = '0' THEN
        cTmp := cTmp(7 downto 0) & Entrada; -- LSL
    ELSIF Modo = '1' THEN
        cTmp := Entrada & cTmp(8 downto 1); -- ASR
    END IF;

    RETURN cTmp;
END FUNCTION SHIFT;
---FIN CORRIMIENTOS---




---ALU----
PROCEDURE ALU (A,B: IN std_logic_vector(8 downto 0);
				SEL: IN std_logic_vector(3 downto 0);
				RESULTADO: INOUT std_logic_vector(9 downto 0);
				FLAGS: OUT std_logic_vector(3 downto 0)) IS
VARIABLE subTMP: std_logic_vector(10 downto 0);
BEGIN
	--Salida de bandera z, s, c, OV
	CASE SEL IS
		WHEN "0000" =>
			RESULTADO := ADD(A, B, SEL(0));
			IF RESULTADO>1023 THEN --Inicio OV
				FLAGS(0) := '1';
			ELSE
				FLAGS(0) := '0';
			END IF;-- Fin OV

			FLAGS(1) := '0'; --C
			FLAGS(2) := '0'; 
			
			IF RESULTADO = "0000000000" THEN --Inicio Z
				FLAGS(3) := '1';
			ELSE
				FLAGS(3) := '0';
			END IF;-- Fin Z
		WHEN "0001" =>
			RESULTADO := SUB(A, B);
			
			IF RESULTADO>1023 THEN --Inicio OV
				FLAGS(0) := '1';
			ELSE
				FLAGS(0) := '0';
			END IF;-- Fin OV
			
			FLAGS(1) := '0'; --C
			
			FLAGS(2) := '0'; --C
			IF RESULTADO(9) = '1' THEN --Inicio signo
				FLAGS(2) := '1';
				RESULTADO(9) := '0';
			END IF; --Fin signo
				
			
			IF RESULTADO = "0000000000" THEN --Inicio Z
				FLAGS(3) := '1';
			ELSE
				FLAGS(3) := '0';
			END IF;
		WHEN "0010" =>
			RESULTADO := TIMES(A(4 downto 0), B(4 downto 0));
			IF RESULTADO>1023 THEN --Inicio OV
				FLAGS(0) := '1';
			ELSE
				FLAGS(0) := '0';
			END IF;-- Fin OV

			FLAGS(1) := '0'; --C
			FLAGS(2) := '0'; 
			
			IF RESULTADO = "0000000000" THEN --Inicio Z
				FLAGS(3) := '1';
			ELSE
				FLAGS(3) := '0';
			END IF;-- Fin Z
		WHEN "0011" =>
			RESULTADO := DIV(A, B);
			IF ((A="111111111")OR(B="111111111")) THEN --Inicio OV
				FLAGS(0) := '1';
			ELSE
				FLAGS(0) := '0';
			END IF;-- Fin OV

			FLAGS(1) := '0'; --C
			FLAGS(2) := '0'; 
			
			IF RESULTADO = "0000000000" THEN --Inicio Z
				FLAGS(3) := '1';
			ELSE
				FLAGS(3) := '0';
			END IF;-- Fin Z
		WHEN "0100" =>
			RESULTADO(8 downto 0) := SHIFT(A, SEL(0), B(0));
		WHEN "0101" =>
			RESULTADO(8 downto 0) := SHIFT(A, SEL(0), B(0));
		WHEN "1000"=>
			RESULTADO(1 downto 0) := CMP(A,B);
		 WHEN OTHERS =>
			RESULTADO := OPLOG(SEL(1 downto 0), '0'&A, '0'&B);
	END CASE;
END ALU;
----FIN ALU----

END OPpack;

