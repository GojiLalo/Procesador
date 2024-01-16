library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MUX_4to1 is
    Port ( 
        S    : in  STD_LOGIC_VECTOR(1 downto 0); -- Selección de entrada
        D0   : in  STD_LOGIC_VECTOR(7 downto 0); -- Datos de entrada 0
        D1   : in  STD_LOGIC_VECTOR(7 downto 0); -- Datos de entrada 1
        D2   : in  STD_LOGIC_VECTOR(7 downto 0); -- Datos de entrada 2
        D3   : in  STD_LOGIC_VECTOR(7 downto 0); -- Datos de entrada 3
        Y    : out STD_LOGIC_VECTOR(7 downto 0)  -- Salida
    );
end MUX_4to1;

architecture Behavioral of MUX_4to1 is
begin
    process(S, D0, D1, D2, D3)
    begin
        case S is
            when "00" =>
                Y <= D0;
            when "01" =>
                Y <= D1;
            when "10" =>
                Y <= D2;
            when "11" =>
                Y <= D3;
            when others =>
                Y <= (others => '0');
        end case;
    end process;
end Behavioral;
