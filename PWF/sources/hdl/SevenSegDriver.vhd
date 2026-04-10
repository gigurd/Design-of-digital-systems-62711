library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- 4-digit 7-segment display driver with time-multiplexing
-- Shows the 16-bit D_Word (MR1:MR0) as 4 hex digits on the Nexys 4 DDR board
entity SevenSegDriver is
    port (
        clk      : in  STD_LOGIC;
        reset    : in  STD_LOGIC;
        D_Word   : in  STD_LOGIC_VECTOR(15 downto 0);
        segments : out STD_LOGIC_VECTOR(6 downto 0);  -- CA..CG (active-low)
        dp       : out STD_LOGIC;                     -- decimal point (active-low)
        Anode    : out STD_LOGIC_VECTOR(7 downto 0)   -- digit selects (active-low)
    );
end SevenSegDriver;

architecture SSD_Behavorial of SevenSegDriver is

    -- TODO: Declare counter for refresh multiplexing
    -- TODO: Declare current nibble signal

begin

    -- TODO: Refresh counter process (divide clk to ~1 kHz per digit)
    -- TODO: Select nibble from D_Word based on refresh counter
    -- TODO: Decode nibble to 7-segment pattern
    -- TODO: Drive Anode with one-hot (active-low)

end SSD_Behavorial;
