----------------------------------------------------------------------------------
-- Module Name: logic_unit
-- Description: n-bit logic unit (internal ALU sub-block)
--              Each bit uses a 4-to-1 MUX selected by J1, J0
--
--              NOTE: PWA order is DIFFERENT from textbook (p. 457)!
--                J1 J0 | Output
--                 0  0 | A or B
--                 0  1 | A and B
--                 1  0 | A xor B
--                 1  1 | not A
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity logic_unit is
    generic (n : integer := 8);
    Port (
        A, B   : in  STD_LOGIC_VECTOR(n-1 downto 0);
        J1, J0 : in  STD_LOGIC;
        G      : out STD_LOGIC_VECTOR(n-1 downto 0)
    );
end logic_unit;

architecture dataflow of logic_unit is
begin

end dataflow;
