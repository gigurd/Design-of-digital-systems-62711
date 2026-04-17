library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SevenSegDriver_tb is
end SevenSegDriver_tb;

architecture TB of SevenSegDriver_tb is

    signal clk      : STD_LOGIC := '0';
    signal reset    : STD_LOGIC := '1';
    signal D_Word   : STD_LOGIC_VECTOR(15 downto 0) := x"1234";
    signal segments : STD_LOGIC_VECTOR(6 downto 0);
    signal dp       : STD_LOGIC;
    signal Anode    : STD_LOGIC_VECTOR(7 downto 0);

    constant CLK_PERIOD : time := 10 ns;
    signal   done       : boolean := false;

    procedure check(cond : boolean; msg : string) is
    begin
        assert cond report "FAIL: " & msg severity error;
    end procedure;

begin

    -- Small counter width so full rotation is 16 cycles
    DUT: entity work.SevenSegDriver
        generic map (COUNTER_WIDTH => 4)
        port map (
            clk      => clk,
            reset    => reset,
            D_Word   => D_Word,
            segments => segments,
            dp       => dp,
            Anode    => Anode
        );

    clk_process: process
    begin
        while not done loop
            clk <= '0'; wait for CLK_PERIOD / 2;
            clk <= '1'; wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    stim: process
    begin
        -- Hold reset for a few cycles
        reset <= '1';
        wait for CLK_PERIOD * 3;
        reset <= '0';

        -- dp should always be off
        check(dp = '1', "dp should always be '1' (off)");

        -- With COUNTER_WIDTH=4, counter wraps every 16 cycles.
        -- Top 2 bits (= counter(3..2)) = "00" for cycles 0..3,
        -- "01" for 4..7, "10" for 8..11, "11" for 12..15.
        -- After reset-release at cycle 3 (rising edge), we are at counter=0 → sel="00".

        -- Digit 0 (sel="00") → nibble = D_Word(3:0) = 0x4
        -- "0011001" is the 4-pattern. Anode should be "11111110".
        wait for CLK_PERIOD;  -- let first clock happen after reset
        check(Anode = "11111110", "sel=00: Anode should be 11111110 (AN0)");
        check(segments = "0011001", "sel=00: D_Word(3:0)=4 segments should be 0011001");

        -- Advance 4 cycles → sel becomes "01", nibble = D_Word(7:4) = 0x3
        wait for CLK_PERIOD * 4;
        check(Anode = "11111101", "sel=01: Anode should be 11111101 (AN1)");
        check(segments = "0110000", "sel=01: D_Word(7:4)=3 segments should be 0110000");

        -- Advance 4 more cycles → sel="10", nibble = D_Word(11:8) = 0x2
        wait for CLK_PERIOD * 4;
        check(Anode = "11111011", "sel=10: Anode should be 11111011 (AN2)");
        check(segments = "0100100", "sel=10: D_Word(11:8)=2 segments should be 0100100");

        -- Advance 4 more cycles → sel="11", nibble = D_Word(15:12) = 0x1
        wait for CLK_PERIOD * 4;
        check(Anode = "11110111", "sel=11: Anode should be 11110111 (AN3)");
        check(segments = "1111001", "sel=11: D_Word(15:12)=1 segments should be 1111001");

        ---------------------------------------------------------------
        -- Spot-check additional hex encodings by changing D_Word
        ---------------------------------------------------------------
        D_Word <= x"ABCD";
        wait for CLK_PERIOD * 4;   -- wrap to sel="00"
        check(Anode = "11111110", "ABCD: sel=00 Anode");
        check(segments = "0100001", "ABCD: nibble 0xD pattern");

        wait for CLK_PERIOD * 4;
        check(segments = "1000110", "ABCD: nibble 0xC pattern");

        wait for CLK_PERIOD * 4;
        check(segments = "0000011", "ABCD: nibble 0xB pattern");

        wait for CLK_PERIOD * 4;
        check(segments = "0001000", "ABCD: nibble 0xA pattern");

        report "SevenSegDriver_tb: ALL CHECKS PASSED" severity note;
        done <= true;
        wait;
    end process;

end TB;
