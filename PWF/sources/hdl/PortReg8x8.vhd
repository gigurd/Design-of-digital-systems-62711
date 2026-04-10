library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Port Register Module: 8 x 8-bit port registers mapped to memory addresses 0xF8-0xFF
--   MR0 (0xF8): D_Word low byte  (7-seg low) -- writable
--   MR1 (0xF9): D_Word high byte (7-seg high) -- writable
--   MR2 (0xFA): LEDs                          -- writable
--   MR3 (0xFB): BTNR input                    -- read-only (loaded from SW on BTNR press)
--   MR4 (0xFC): BTNL input                    -- read-only
--   MR5 (0xFD): BTND input                    -- read-only
--   MR6 (0xFE): BTNU input                    -- read-only
--   MR7 (0xFF): BTNC input                    -- read-only
entity PortReg8x8 is
    port (
        clk        : in  STD_LOGIC;
        MW         : in  STD_LOGIC;
        Data_In    : in  STD_LOGIC_VECTOR(7 downto 0);
        Address_in : in  STD_LOGIC_VECTOR(7 downto 0);
        SW         : in  STD_LOGIC_VECTOR(7 downto 0);
        BTNC       : in  STD_LOGIC;
        BTNU       : in  STD_LOGIC;
        BTNL       : in  STD_LOGIC;
        BTNR       : in  STD_LOGIC;
        BTND       : in  STD_LOGIC;
        MMR        : out STD_LOGIC;
        D_word     : out STD_LOGIC_VECTOR(15 downto 0);
        Data_outR  : out STD_LOGIC_VECTOR(15 downto 0);
        LED        : out STD_LOGIC_VECTOR(7 downto 0)
    );
end PortReg8x8;

architecture PR_Behavorial of PortReg8x8 is

    -- TODO: Declare internal signals for the 8 port registers MR0..MR7
    -- TODO: MMR is high when Address_in is in the range 0xF8..0xFF

begin

    -- TODO: Synchronous write logic for MR0, MR1, MR2 (when MW=1 and address matches)
    -- TODO: Button-driven load for MR3..MR7 (SW -> MRn on respective button press)
    -- TODO: Read multiplexer: Data_outR selects based on Address_in
    -- TODO: D_word = MR1 & MR0 (concatenated for 7-seg driver)
    -- TODO: LED <= MR2

end PR_Behavorial;
