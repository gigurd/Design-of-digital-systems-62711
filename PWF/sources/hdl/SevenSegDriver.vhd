library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- 4-digit 7-segment display driver with time-multiplexing
-- Shows the 16-bit D_Word (MR1:MR0) as 4 hex digits on the Nexys 4 DDR board.
--
-- COUNTER_WIDTH controls the refresh prescaler:
--   Digit refresh rate = clk / 2^(COUNTER_WIDTH-2).
--   @18 bits, 20 MHz clk: ~305 Hz per digit (flicker-free).
--   @18 bits, 100 MHz clk: ~1.5 kHz per digit.
-- Unit TB overrides to a small width (e.g. 4) for fast simulation.
entity SevenSegDriver is
    generic (
        COUNTER_WIDTH : integer := 18
    );
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

    signal counter : UNSIGNED(COUNTER_WIDTH - 1 downto 0) := (others => '0');
    signal sel     : STD_LOGIC_VECTOR(1 downto 0);
    signal nibble  : STD_LOGIC_VECTOR(3 downto 0);

begin

    -- Refresh counter: free-running, synchronous reset
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                counter <= (others => '0');
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    -- Top 2 bits pick the active digit
    sel <= std_logic_vector(counter(COUNTER_WIDTH - 1 downto COUNTER_WIDTH - 2));

    -- Select nibble from D_Word
    with sel select
        nibble <= D_Word(3 downto 0)   when "00",
                  D_Word(7 downto 4)   when "01",
                  D_Word(11 downto 8)  when "10",
                  D_Word(15 downto 12) when others;

    -- Hex → 7-seg decoder (active-LOW, seg(6..0) = g,f,e,d,c,b,a)
    with nibble select
        segments <= "1000000" when "0000",  -- 0
                    "1111001" when "0001",  -- 1
                    "0100100" when "0010",  -- 2
                    "0110000" when "0011",  -- 3
                    "0011001" when "0100",  -- 4
                    "0010010" when "0101",  -- 5
                    "0000010" when "0110",  -- 6
                    "1111000" when "0111",  -- 7
                    "0000000" when "1000",  -- 8
                    "0010000" when "1001",  -- 9
                    "0001000" when "1010",  -- A
                    "0000011" when "1011",  -- b
                    "1000110" when "1100",  -- C
                    "0100001" when "1101",  -- d
                    "0000110" when "1110",  -- E
                    "0001110" when others;  -- F

    -- Decimal point always off
    dp <= '1';

    -- Anode one-cold on the active digit (bottom 4 used, upper 4 held off)
    with sel select
        Anode <= "11111110" when "00",   -- AN0 (rightmost)
                 "11111101" when "01",   -- AN1
                 "11111011" when "10",   -- AN2
                 "11110111" when others; -- AN3

end SSD_Behavorial;
