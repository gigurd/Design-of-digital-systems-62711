----------------------------------------------------------------------------------
-- Module Name: display
-- Description: 7-segment display driver for Nexys 4 DDR
--              Multiplexes 8 digits using time-division (anode scanning)
--              Active-low segments and anodes on the Nexys 4 DDR board
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display is
    Port (
        clk      : in  STD_LOGIC;
        reset    : in  STD_LOGIC;
        digit0, digit1, digit2, digit3 : in STD_LOGIC_VECTOR(3 downto 0);
        digit4, digit5, digit6, digit7 : in STD_LOGIC_VECTOR(3 downto 0);
        segments : out STD_LOGIC_VECTOR(6 downto 0);
        dp       : out STD_LOGIC;
        anode    : out STD_LOGIC_VECTOR(7 downto 0)
    );
end display;

architecture Behavioral of display is
begin

end Behavioral;
