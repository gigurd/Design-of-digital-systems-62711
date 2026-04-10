library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Board-level top module for the Nexys 4 DDR.
-- Wraps the Microprocessor core and connects it to the physical pins
-- (constraints in Nexys_4_DDR_Master.xdc).
entity TOP_MODUL_F is
    port (
        CLK      : in  STD_LOGIC;
        RESET    : in  STD_LOGIC;  -- e.g. CPU_RESETN or a button
        SW       : in  STD_LOGIC_VECTOR(7 downto 0);
        BTNC     : in  STD_LOGIC;
        BTNU     : in  STD_LOGIC;
        BTNL     : in  STD_LOGIC;
        BTNR     : in  STD_LOGIC;
        BTND     : in  STD_LOGIC;
        LED      : out STD_LOGIC_VECTOR(7 downto 0);
        segments : out STD_LOGIC_VECTOR(6 downto 0);
        dp       : out STD_LOGIC;
        Anode    : out STD_LOGIC_VECTOR(7 downto 0)
    );
end TOP_MODUL_F;

architecture TOP_Structural of TOP_MODUL_F is

    signal D_Word_sig : STD_LOGIC_VECTOR(15 downto 0);

begin

    -- TODO: Instantiate Microprocessor core
    -- TODO: Instantiate SevenSegDriver to display D_Word on the 4-digit display

end TOP_Structural;
