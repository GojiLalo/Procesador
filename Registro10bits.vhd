LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY registro10 IS 
PORT(
    	d   : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    	ld  : IN STD_LOGIC;
    	clr : IN STD_LOGIC;
    	clk : IN STD_LOGIC;
    	q   : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
END registro10;

ARCHITECTURE aRegistro10 OF registro10 IS

BEGIN
    process(clk, clr)
    begin
        if clr = '1' then
            q <= "0000000000";
        elsif rising_edge(clk) then
            if ld = '1' then
                q <= d;
            end if;
        end if;
    end process;
END aRegistro10;