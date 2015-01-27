library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_REAL.ALL;

ENTITY Decimator IS
    GENERIC(
        R        :POSITIVE := 3; --decimation ratio
        D_WIDTH  :POSITIVE := 2
    );
    PORT(
        RESET   :in  STD_LOGIC;
        CLK     :in  STD_LOGIC;
        
        X       :in  SIGNED(D_WIDTH-1 downto 0);
        Y       :out SIGNED(D_WIDTH-1 downto 0)
    );
END ENTITY Decimator;

ARCHITECTURE behaviour OF Decimator IS
    CONSTANT count          :NATURAL := NATURAL(CEIL(LOG2(REAL(R)))) - 1;
    SIGNAL counter          :UNSIGNED(count downto 0) := (others => '0');
BEGIN
    PROCESS(CLK, RESET, X)
    BEGIN
        IF(RESET = '1') THEN
            counter <= (others => '0');
        ELSIF (RISING_EDGE(CLK)) THEN
            IF(counter = count) THEN
                Y <= X;
                counter <= (others => '0');
            ELSE
                counter <= counter + 1;
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE behaviour;
