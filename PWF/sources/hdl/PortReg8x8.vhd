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

    signal MR0 : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal MR1 : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal MR2 : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal MR3 : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal MR4 : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal MR5 : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal MR6 : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal MR7 : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

    signal MMR_int : STD_LOGIC;

begin

    -- MMR is high when Address_in is in the range 0xF8..0xFF (top 5 bits = "11111")
    MMR_int <= '1' when Address_in(7 downto 3) = "11111" else '0';
    MMR     <= MMR_int;

    -- Synchronous writes and button latches
    process(clk)
    begin
        if rising_edge(clk) then
            -- CPU writes to MR0..MR2 (writable port registers) when MW=1 and address matches
            if MW = '1' and MMR_int = '1' then
                case Address_in(2 downto 0) is
                    when "000" => MR0 <= Data_In;  -- 0xF8
                    when "001" => MR1 <= Data_In;  -- 0xF9
                    when "010" => MR2 <= Data_In;  -- 0xFA
                    when others => null;           -- 0xFB..0xFF are read-only
                end case;
            end if;

            -- Button-driven loads for MR3..MR7 (level-sensitive: while button held, MR tracks SW)
            if BTNR = '1' then MR3 <= SW; end if;
            if BTNL = '1' then MR4 <= SW; end if;
            if BTND = '1' then MR5 <= SW; end if;
            if BTNU = '1' then MR6 <= SW; end if;
            if BTNC = '1' then MR7 <= SW; end if;
        end if;
    end process;

    -- Read multiplexer: selected MR (zero-extended to 16 bits) -> Data_outR
    Data_outR <= x"00" & MR0 when Address_in(2 downto 0) = "000" else
                 x"00" & MR1 when Address_in(2 downto 0) = "001" else
                 x"00" & MR2 when Address_in(2 downto 0) = "010" else
                 x"00" & MR3 when Address_in(2 downto 0) = "011" else
                 x"00" & MR4 when Address_in(2 downto 0) = "100" else
                 x"00" & MR5 when Address_in(2 downto 0) = "101" else
                 x"00" & MR6 when Address_in(2 downto 0) = "110" else
                 x"00" & MR7;

    -- 7-seg drive word: MR1 (high byte) : MR0 (low byte)
    D_word <= MR1 & MR0;

    -- LEDs directly driven by MR2
    LED    <= MR2;

end PR_Behavorial;
