library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Microprocessor_tb is
end Microprocessor_tb;

architecture TB of Microprocessor_tb is

    signal CLK    : STD_LOGIC := '0';
    signal RESET  : STD_LOGIC := '1';
    signal SW     : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal BTNC, BTNU, BTNL, BTNR, BTND : STD_LOGIC := '0';
    signal LED    : STD_LOGIC_VECTOR(7 downto 0);
    signal D_Word : STD_LOGIC_VECTOR(15 downto 0);

    constant CLK_PERIOD : time := 10 ns;
    signal   done       : boolean := false;

    procedure check(cond : boolean; msg : string) is
    begin
        assert cond report "FAIL: " & msg severity error;
    end procedure;

begin

    UUT: entity work.Microprocessor
        port map (
            CLK    => CLK,
            RESET  => RESET,
            SW     => SW,
            BTNC   => BTNC,
            BTNU   => BTNU,
            BTNL   => BTNL,
            BTNR   => BTNR,
            BTND   => BTND,
            LED    => LED,
            D_Word => D_Word
        );

    clk_process: process
    begin
        while not done loop
            CLK <= '0'; wait for CLK_PERIOD / 2;
            CLK <= '1'; wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    stim_process: process
    begin
        ------------------------------------------------------------------
        -- Reset, then let CPU enter the main loop with MR3=MR4=0 (sum=0)
        ------------------------------------------------------------------
        RESET <= '1';
        wait for CLK_PERIOD * 2;
        RESET <= '0';

        wait for CLK_PERIOD * 100;   -- let a few loop iterations run

        check(LED = x"00", "with MR3=MR4=0, LED should be 0x00");
        check(D_Word = x"0000", "with MR3=MR4=0, D_Word should be 0x0000");

        ------------------------------------------------------------------
        -- Latch MR3 = 0x12 via BTNR
        ------------------------------------------------------------------
        SW <= x"12"; BTNR <= '1';
        wait for CLK_PERIOD * 4;     -- press
        BTNR <= '0';

        wait for CLK_PERIOD * 200;   -- let several loop iterations run

        check(LED = x"12", "MR3=0x12, MR4=0 -> LED = 0x12");
        check(D_Word = x"1212", "D_Word should be MR1:MR0 = 0x12:0x12");

        ------------------------------------------------------------------
        -- Latch MR4 = 0x34 via BTNL (MR3 stays 0x12)
        ------------------------------------------------------------------
        SW <= x"34"; BTNL <= '1';
        wait for CLK_PERIOD * 4;
        BTNL <= '0';

        wait for CLK_PERIOD * 200;

        check(LED = x"46", "MR3=0x12 + MR4=0x34 -> LED = 0x46");
        check(D_Word = x"1246", "D_Word should be MR3:sum = 0x12:0x46");

        ------------------------------------------------------------------
        -- Re-press BTNR with new SW; demo should follow
        ------------------------------------------------------------------
        SW <= x"05"; BTNR <= '1';
        wait for CLK_PERIOD * 4;
        BTNR <= '0';

        wait for CLK_PERIOD * 200;

        check(LED = x"39", "MR3=0x05 + MR4=0x34 -> LED = 0x39");
        check(D_Word = x"0539", "D_Word should be 0x05:0x39");

        report "Microprocessor_tb: ALL CHECKS PASSED" severity note;
        done <= true;
        wait;
    end process;

end TB;
