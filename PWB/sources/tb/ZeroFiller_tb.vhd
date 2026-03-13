library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ZeroFiller_tb is
end ZeroFiller_tb;

architecture TB of ZeroFiller_tb is

    signal IR           : std_logic_vector(15 downto 0) := (others => '0');
    signal ZeroFilled_8 : std_logic_vector(7 downto 0);

begin

    UUT: entity work.ZeroFiller
        port map (
            IR           => IR,
            ZeroFilled_8 => ZeroFilled_8
        );

    stim_process: process
    begin
        -- Test 1: IR(2:0) = 000
        IR <= x"0000";
        wait for 10 ns;
        assert ZeroFilled_8 = x"00"
            report "FAIL: ZF test 1 - expected 0x00, got " severity error;

        -- Test 2: IR(2:0) = 101
        IR <= x"0005";
        wait for 10 ns;
        assert ZeroFilled_8 = x"05"
            report "FAIL: ZF test 2 - expected 0x05" severity error;

        -- Test 3: IR(2:0) = 111, upper bits don't matter
        IR <= x"FFF7";
        wait for 10 ns;
        assert ZeroFilled_8 = x"07"
            report "FAIL: ZF test 3 - expected 0x07" severity error;

        -- Test 4: IR(2:0) = 011
        IR <= x"1233";
        wait for 10 ns;
        assert ZeroFilled_8 = x"03"
            report "FAIL: ZF test 4 - expected 0x03" severity error;

        report "ZeroFiller: All tests passed" severity note;
        wait;
    end process;

end TB;
