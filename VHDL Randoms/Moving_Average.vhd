library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_REAL.ALL;

ENTITY Moving_Average IS
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
END ENTITY Moving_Average;

ARCHITECTURE behaviour OF Moving_Average IS
    TYPE SIGNED_VECTOR IS ARRAY(NATURAL RANGE<>) of SIGNED(X'range);
    
    SIGNAL shift_reg    :SIGNED_VECTOR( 2**POINTS downto 0) := (others => (others => '0');
    SIGNAL sum          :SIGNED(D_WIDTH downto 0);
    SIGNAL prev_y       :SIGNED(D_WIDTH-1 downto 0);
    SIGNAL result       :SIGNED(D_WIDTH-1 downto 0);
BEGIN
    sum <= RESIZE(shift_reg(2**POINTS),D_WIDTH) - RESIZE(shift_reg(0),D_WIDTH);
    result <= RESIZE(SHIFT_RIGHT(sum, POINTS) + prev_y, D_WIDTH);
    Y <= result;
    
    Delay: PROCESS(CLK, RESET, X)
    BEGIN
        IF(RESET = '1') THEN
            shift_reg <= (others => (others => '0'));
            sum <= (others => '0');
            prev_y <= (others => '0');
        ELSIF(RISING_EDGE(CLK)) THEN
            FOR i in 0 to 2**POINTS -1 LOOP
                shift_reg(i) <= shift_reg(i+1);
            END LOOP
            shift_reg(shift_reg'high) <= X;
            prev_y <= result;
        END IF;
    END PROCESS;
END ARCHITECTURE behaviour;