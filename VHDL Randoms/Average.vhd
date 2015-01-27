library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_REAL.ALL;

ENTITY Average IS
    GENERIC(
        D_WIDTH :POSITIVE := 3;
        POINTS  :POSITIVE := 2      --exponent of 2
    );
    PORT(
        RESET   :in  STD_LOGIC;
        CLK     :in  STD_LOGIC;
        
        X       :in  SIGNED(D_WIDTH-1 downto 0);
        Y       :out SIGNED(D_WIDTH-1 downto 0);
    );
END ENTITY Average;

ARCHITECTURE behaviour OF Average IS
    TYPE SIGNED_VECTOR IS ARRAY(NATURAL RANGE<>) of SIGNED(X'range);
    
    SIGNAL shift_reg    :SIGNED_VECTOR( 2**POINTS - 1 downto 0) := (others => (others => '0');
BEGIN
    
    Delay: PROCESS(CLK, RESET, X)
    VARIABLE sum : SIGNED(D_WIDTH-1+2**POINTS downto 0);
    BEGIN
        IF(RESET = '1') THEN
            shift_reg <= (others => (others => '0'));
        ELSIF(RISING_EDGE(CLK)) THEN
            sum := RESIZE(shift_reg(2**POINTS-1),D_WIDTH-1+2**POINTS);
            FOR i in 0 to shift_reg'high LOOP
                sum := sum + shift_reg(i);
            END LOOP
            Y <= RESIZE(SHIFT_RIGHT(sum,POINTS), 2**POINTS);
        END IF;
    END PROCESS;
END ARCHITECTURE behaviour;