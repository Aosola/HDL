library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_REAL.ALL;

ENTITY Integrator IS
    GENERIC(
        D_WIDTH_in  :POSITIVE := 2;
        Truncation  :NATURAL  := 0
    );
    PORT(
        RESET   :in  STD_LOGIC;
        CLK     :in  STD_LOGIC;
        
        X       :in  SIGNED(D_WIDTH-1 downto 0);
        Y       :out SIGNED(D_WIDTH_in-Truncation-1 downto 0)
    );
END ENTITY Integrator;

ARCHITECTURE behaviour OF Integrator IS
    SIGNAL prev_y  :SIGNED(X'range) := (others => '0');
    SIGNAL result  :SIGNED(X'range);
BEGIN
    result <= X + prev_y; 
    Y <= RESIZE(result, Y'high+1);
    
    DELAY: PROCESS(CLK, RESET, X)
    BEGIN
        IF(RESET = '1') THEN
            prev_y <= (others => '0');
        ELSIF (RISING_EDGE(CLK)) THEN
            prev_y <= result;
        END IF;
    END PROCESS;
END ARCHITECTURE behaviour;
