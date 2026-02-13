----------------------------------------------------------------------------------
-- Module Name: TOP_MODUL - Structural
-- Project:     PWA - ALU / DataPath
-- Board:       Nexys 4 DDR (Artix-7 xc7a100t)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TOP_MODUL is
    Port (
        -- Clock & Reset
        CLK   : in  STD_LOGIC;
        RESET : in  STD_LOGIC;

        -- Switches
        SW    : in  STD_LOGIC_VECTOR(7 downto 0);

        -- LEDs
        LED   : out STD_LOGIC_VECTOR(7 downto 0);

        -- 7-Segment Display
        segments : out STD_LOGIC_VECTOR(6 downto 0);
        dp       : out STD_LOGIC;
        Anode    : out STD_LOGIC_VECTOR(7 downto 0);

        -- Buttons
        BTNC  : in  STD_LOGIC;
        BTNU  : in  STD_LOGIC;
        BTNL  : in  STD_LOGIC;
        BTNR  : in  STD_LOGIC;
        BTND  : in  STD_LOGIC
    );
end TOP_MODUL;

architecture Structural of TOP_MODUL is

    -- Component declarations go here

begin

    -- Component instantiations go here

end Structural;
