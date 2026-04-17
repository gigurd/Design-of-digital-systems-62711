library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PortReg8x8_tb is
end PortReg8x8_tb;

architecture TB of PortReg8x8_tb is

    signal clk        : STD_LOGIC := '0';
    signal MW         : STD_LOGIC := '0';
    signal Data_In    : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal Address_in : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal SW         : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal BTNC, BTNU, BTNL, BTNR, BTND : STD_LOGIC := '0';
    signal MMR        : STD_LOGIC;
    signal D_word     : STD_LOGIC_VECTOR(15 downto 0);
    signal Data_outR  : STD_LOGIC_VECTOR(15 downto 0);
    signal LED        : STD_LOGIC_VECTOR(7 downto 0);

    constant CLK_PERIOD : time := 10 ns;
    signal   done       : boolean := false;

    procedure check(cond : boolean; msg : string) is
    begin
        assert cond report "FAIL: " & msg severity error;
    end procedure;

begin

    DUT: entity work.PortReg8x8
        port map (
            clk        => clk,
            MW         => MW,
            Data_In    => Data_In,
            Address_in => Address_in,
            SW         => SW,
            BTNC       => BTNC,
            BTNU       => BTNU,
            BTNL       => BTNL,
            BTNR       => BTNR,
            BTND       => BTND,
            MMR        => MMR,
            D_word     => D_word,
            Data_outR  => Data_outR,
            LED        => LED
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
        wait for CLK_PERIOD * 2;

        ----------------------------------------------------------------
        -- MMR decode: high only for 0xF8..0xFF
        ----------------------------------------------------------------
        Address_in <= x"00"; wait for CLK_PERIOD;
        check(MMR = '0', "MMR should be 0 at 0x00");
        Address_in <= x"F7"; wait for CLK_PERIOD;
        check(MMR = '0', "MMR should be 0 at 0xF7");
        Address_in <= x"F8"; wait for CLK_PERIOD;
        check(MMR = '1', "MMR should be 1 at 0xF8");
        Address_in <= x"FF"; wait for CLK_PERIOD;
        check(MMR = '1', "MMR should be 1 at 0xFF");

        ----------------------------------------------------------------
        -- Write MR0 (0xF8) = 0xAA, verify read-back and D_word low byte
        ----------------------------------------------------------------
        Address_in <= x"F8"; Data_In <= x"AA"; MW <= '1';
        wait for CLK_PERIOD;
        MW <= '0';
        wait for CLK_PERIOD;
        check(Data_outR = x"00AA", "MR0 read-back should be 0x00AA");
        check(D_word(7 downto 0) = x"AA", "D_word low byte should be MR0 = 0xAA");

        ----------------------------------------------------------------
        -- Write MR1 (0xF9) = 0xBB, verify D_word high byte
        ----------------------------------------------------------------
        Address_in <= x"F9"; Data_In <= x"BB"; MW <= '1';
        wait for CLK_PERIOD;
        MW <= '0';
        wait for CLK_PERIOD;
        check(Data_outR = x"00BB", "MR1 read-back should be 0x00BB");
        check(D_word = x"BBAA", "D_word should be MR1:MR0 = 0xBBAA");

        ----------------------------------------------------------------
        -- Write MR2 (0xFA) = 0x55, verify LED output
        ----------------------------------------------------------------
        Address_in <= x"FA"; Data_In <= x"55"; MW <= '1';
        wait for CLK_PERIOD;
        MW <= '0';
        wait for CLK_PERIOD;
        check(Data_outR = x"0055", "MR2 read-back should be 0x0055");
        check(LED = x"55", "LED should be MR2 = 0x55");

        ----------------------------------------------------------------
        -- Attempt to write MR3 (0xFB) — should be read-only, write ignored
        ----------------------------------------------------------------
        Address_in <= x"FB"; Data_In <= x"99"; MW <= '1';
        wait for CLK_PERIOD;
        MW <= '0';
        wait for CLK_PERIOD;
        check(Data_outR = x"0000", "MR3 should still be 0 (read-only to CPU)");

        ----------------------------------------------------------------
        -- Button latches: press each button with a unique SW value,
        -- then verify the corresponding MR.
        ----------------------------------------------------------------
        -- BTNR → MR3 (0xFB)
        SW <= x"11"; BTNR <= '1';
        wait for CLK_PERIOD * 2;
        BTNR <= '0';
        wait for CLK_PERIOD;
        Address_in <= x"FB"; wait for CLK_PERIOD;
        check(Data_outR = x"0011", "BTNR should latch SW=0x11 into MR3");

        -- BTNL → MR4 (0xFC)
        SW <= x"22"; BTNL <= '1';
        wait for CLK_PERIOD * 2;
        BTNL <= '0';
        wait for CLK_PERIOD;
        Address_in <= x"FC"; wait for CLK_PERIOD;
        check(Data_outR = x"0022", "BTNL should latch SW=0x22 into MR4");

        -- BTND → MR5 (0xFD)
        SW <= x"33"; BTND <= '1';
        wait for CLK_PERIOD * 2;
        BTND <= '0';
        wait for CLK_PERIOD;
        Address_in <= x"FD"; wait for CLK_PERIOD;
        check(Data_outR = x"0033", "BTND should latch SW=0x33 into MR5");

        -- BTNU → MR6 (0xFE)
        SW <= x"44"; BTNU <= '1';
        wait for CLK_PERIOD * 2;
        BTNU <= '0';
        wait for CLK_PERIOD;
        Address_in <= x"FE"; wait for CLK_PERIOD;
        check(Data_outR = x"0044", "BTNU should latch SW=0x44 into MR6");

        -- BTNC → MR7 (0xFF)
        SW <= x"55"; BTNC <= '1';
        wait for CLK_PERIOD * 2;
        BTNC <= '0';
        wait for CLK_PERIOD;
        Address_in <= x"FF"; wait for CLK_PERIOD;
        check(Data_outR = x"0055", "BTNC should latch SW=0x55 into MR7");

        ----------------------------------------------------------------
        -- Verify earlier writes survived (MR0..MR2 unchanged)
        ----------------------------------------------------------------
        Address_in <= x"F8"; wait for CLK_PERIOD;
        check(Data_outR = x"00AA", "MR0 should still be 0xAA");
        Address_in <= x"F9"; wait for CLK_PERIOD;
        check(Data_outR = x"00BB", "MR1 should still be 0xBB");
        Address_in <= x"FA"; wait for CLK_PERIOD;
        check(Data_outR = x"0055", "MR2 should still be 0x55");
        check(D_word = x"BBAA", "D_word should still be 0xBBAA");
        check(LED = x"55", "LED should still be 0x55");

        report "PortReg8x8_tb: ALL CHECKS PASSED" severity note;
        done <= true;
        wait;
    end process;

end TB;
