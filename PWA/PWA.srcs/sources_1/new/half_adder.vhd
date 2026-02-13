----------------------------------------------------------------------------------
-- Module Name: half_adder
-- Description: Half adder - 2 inputs, sum and carry out
--              S = X xor Y,  C = X and Y
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_adder is
    Port (
        x, y : in  STD_LOGIC;
        s    : out STD_LOGIC;
        c    : out STD_LOGIC
    );
end half_adder;

architecture dataflow of half_adder is
begin

end dataflow;
