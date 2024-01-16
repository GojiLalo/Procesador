LIBRARY IEEE;
LIBRARY work;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.OPPack.ALL;

ENTITY ALU IS
  PORT (
    A, B : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    SEL : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    ENABLE : IN STD_LOGIC;
    RESULTADO : INOUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    FLAGS : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
  );
END ENTITY ALU;

-- Definir la arquitectura
ARCHITECTURE aALU OF ALU IS
BEGIN
  PROCESS(A,B,SEL,ENABLE,RESULTADO)
  BEGIN
    -- Salida de bandera z, s, c, OV
    IF ENABLE = '1' THEN  -- Verificar si el enable está activo
      CASE SEL IS
        WHEN "0000" =>
          RESULTADO <= ADD(A, B, SEL(0));
          IF RESULTADO > "10000000000" THEN -- Inicio OV
            FLAGS(0) <= '1';
          ELSE
            FLAGS(0) <= '0';
          END IF; -- Fin OV

          FLAGS(1) <= '0'; -- C
          FLAGS(2) <= '0';

          IF RESULTADO = "0000000000" THEN -- Inicio Z
            FLAGS(3) <= '1';
          ELSE
            FLAGS(3) <= '0';
          END IF; -- Fin Z
        WHEN "0001" =>
          RESULTADO <= SUB(A, B);

          IF RESULTADO > "10000000000" THEN -- Inicio OV
            FLAGS(0) <= '1';
          ELSE
            FLAGS(0) <= '0';
          END IF; -- Fin OV

          FLAGS(1) <= '0'; -- C

          FLAGS(2) <= '0'; -- C
          IF RESULTADO(9) = '1' THEN -- Inicio signo
            FLAGS(2) <= '1';
            RESULTADO(9) <= '0';
          END IF; -- Fin signo

          IF RESULTADO = "0000000000" THEN -- Inicio Z
            FLAGS(3) <= '1';
          ELSE
            FLAGS(3) <= '0';
          END IF;
        WHEN "0010" =>
          RESULTADO <= TIMES(A(4 DOWNTO 0), B(4 DOWNTO 0));
          IF RESULTADO > "10000000000" THEN -- Inicio OV
            FLAGS(0) <= '1';
          ELSE
            FLAGS(0) <= '0';
          END IF; -- Fin OV

          FLAGS(1) <= '0'; -- C
          FLAGS(2) <= '0';

          IF RESULTADO = "0000000000" THEN -- Inicio Z
            FLAGS(3) <= '1';
          ELSE
            FLAGS(3) <= '0';
          END IF; -- Fin Z
        WHEN "0011" =>
          RESULTADO <= DIV(A, B);
          IF ((A = "111111111") OR (B = "111111111")) THEN -- Inicio OV
            FLAGS(0) <= '1';
          ELSE
            FLAGS(0) <= '0';
          END IF; -- Fin OV

          FLAGS(1) <= '0'; -- C
          FLAGS(2) <= '0';

          IF RESULTADO = "0000000000" THEN -- Inicio Z
            FLAGS(3) <= '1';
          ELSE
            FLAGS(3) <= '0';
          END IF; -- Fin Z
        WHEN "0100" =>
          RESULTADO(8 DOWNTO 0) <= SHIFT(A, SEL(0), B(0));
        WHEN "0101" =>
          RESULTADO(8 DOWNTO 0) <= SHIFT(A, SEL(0), B(0));
        WHEN "1000" =>
          RESULTADO(1 DOWNTO 0) <= CMP(A, B);
        WHEN OTHERS =>
          RESULTADO <= OPLOG(SEL(1 DOWNTO 0), '0' & A, '0' & B);
      END CASE;
    ELSE
      -- Si el enable está en '0', no se realiza ninguna operación
      RESULTADO <= (OTHERS => '0');
      FLAGS <= (OTHERS => '0');
    END IF;
  END PROCESS;
END ARCHITECTURE aALU;
