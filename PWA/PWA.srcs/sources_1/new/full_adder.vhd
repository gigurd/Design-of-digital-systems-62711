----------------------------------------------------------------------------------
-- Module Name: full_adder
-- Description: Full adder from two half adders
--              S = X xor Y xor Ci,  Co = (X and Y) or (Ci and (X xor Y))
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is
    Port (
        x, y, ci : in  STD_LOGIC;
        so       : out STD_LOGIC;
        co       : out STD_LOGIC
    );
end full_adder;

architecture structural of full_adder is

    component half_adder is
        Port (x, y : in  STD_LOGIC;
              s, c : out STD_LOGIC);
    end component;

begin

end structural;
