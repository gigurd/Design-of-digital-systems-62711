library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ProgramCounter_tb is
end ProgramCounter_tb;

architecture TB of ProgramCounter_tb is

    signal RESET      : std_logic := '1';
    signal CLK        : std_logic := '0';
    signal Address_In : std_logic_vector(7 downto 0) := (others => '0');
    signal PS         : std_logic_vector(1 downto 0) := "00";
    signal Offset     : std_logic_vector(7 downto 0) := (others => '0');
    signal PC         : std_logic_vector(7 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    UUT: entity work.ProgramCounter
        port map (
            RESET      => RESET,
            CLK        => CLK,
            Address_In => Address_In,
            PS         => PS,
            Offset     => Offset,
            PC         => PC
        );

    clk_process: process
    begin
        CLK <= '0'; wait for CLK_PERIOD / 2;
        CLK <= '1'; wait for CLK_PERIOD / 2;
    end process;

    stim_process: process
    begin
        -- Reset
        RESET <= '1';
        wait for CLK_PERIOD * 2;
        assert PC = x"00"
            report "FAIL: PC should be 0 after reset" severity error;
        RESET <= '0';

        -- PS=00: Hold
        PS <= "00";
        wait for CLK_PERIOD * 2;
        assert PC = x"00"
            report "FAIL: PC should stay 0 on hold" severity error;

        -- PS=01: Increment 3 times -> 1, 2, 3
        PS <= "01";
        wait for CLK_PERIOD;
        assert PC = x"01"
            report "FAIL: PC should be 1 after 1st inc" severity error;
        wait for CLK_PERIOD;
        assert PC = x"02"
            report "FAIL: PC should be 2 after 2nd inc" severity error;
        wait for CLK_PERIOD;
        assert PC = x"03"
            report "FAIL: PC should be 3 after 3rd inc" severity error;

        -- PS=00: Hold at 3
        PS <= "00";
        wait for CLK_PERIOD;
        assert PC = x"03"
            report "FAIL: PC should hold at 3" severity error;

        -- PS=10: Branch +5 -> 8
        Offset <= x"05";
        PS <= "10";
        wait for CLK_PERIOD;
        assert PC = x"08"
            report "FAIL: PC should be 8 after branch +5" severity error;

        -- PS=00: Hold at 8
        PS <= "00";
        wait for CLK_PERIOD;
        assert PC = x"08"
            report "FAIL: PC should hold at 8" severity error;

        -- PS=10: Branch -3 (0xFD) -> 5
        Offset <= x"FD";
        PS <= "10";
        wait for CLK_PERIOD;
        assert PC = x"05"
            report "FAIL: PC should be 5 after branch -3" severity error;

        -- PS=00: Hold at 5
        PS <= "00";
        wait for CLK_PERIOD;
        assert PC = x"05"
            report "FAIL: PC should hold at 5" severity error;

        -- PS=11: Jump to 0x42
        Address_In <= x"42";
        PS <= "11";
        wait for CLK_PERIOD;
        assert PC = x"42"
            report "FAIL: PC should be 0x42 after jump" severity error;

        -- PS=00: Hold at 0x42
        PS <= "00";
        wait for CLK_PERIOD;
        assert PC = x"42"
            report "FAIL: PC should hold at 0x42" severity error;

        report "ProgramCounter: All tests passed" severity note;
        wait;
    end process;

end TB;
