library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Board-level top module for the Nexys 4 DDR.
-- Wraps the Microprocessor core and connects it to the physical pins
-- (constraints in Nexys_4_DDR_Master.xdc).
--
-- The RESET pin is the board's cpu_resetn (active-LOW). Internally every
-- entity uses RESET as active-HIGH, so we invert at the boundary.
entity TOP_MODUL_F is
    port (
        CLK      : in  STD_LOGIC;
        RESET    : in  STD_LOGIC;  -- cpu_resetn (active-low)
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

    signal D_Word_sig    : STD_LOGIC_VECTOR(15 downto 0);
    signal reset_high    : STD_LOGIC;

begin

    -- cpu_resetn (active-low at pin) -> active-high internal reset
    reset_high <= not RESET;

    MP_inst: entity work.Microprocessor
        port map (
            CLK    => CLK,
            RESET  => reset_high,
            SW     => SW,
            BTNC   => BTNC,
            BTNU   => BTNU,
            BTNL   => BTNL,
            BTNR   => BTNR,
            BTND   => BTND,
            LED    => LED,
            D_Word => D_Word_sig
        );

    SSD_inst: entity work.SevenSegDriver
        port map (
            clk      => CLK,
            reset    => reset_high,
            D_Word   => D_Word_sig,
            segments => segments,
            dp       => dp,
            Anode    => Anode
        );

end TOP_Structural;
