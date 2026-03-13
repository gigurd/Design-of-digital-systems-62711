library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SignExtender_tb is
end SignExtender_tb;

architecture TB of SignExtender_tb is

    signal IR         : std_logic_vector(15 downto 0) := (others => '0');
    signal Extended_8 : std_logic_vector(7 downto 0);

begin

    UUT: entity work.SignExtender
        port map (
            IR         => IR,
            Extended_8 => Extended_8
        );

    stim_process: process
    begin
        -- Test 1: IR(8)=0, IR(7)=1, IR(6)=1, IR(2:0)=111
        -- Expected: 000_11_111 = 0x1F
        IR <= "0000000011000111";
        wait for 10 ns;
        assert Extended_8 = "00011111"
            report "FAIL: SE test 1 - expected 0x1F" severity error;

        -- Test 2: IR(8)=1, IR(7)=1, IR(6)=0, IR(2:0)=101
        -- Expected: 111_10_101 = 0xF5
        IR <= "0000000110000101";
        wait for 10 ns;
        assert Extended_8 = "11110101"
            report "FAIL: SE test 2 - expected 0xF5" severity error;

        -- Test 3: All relevant bits 0
        -- Expected: 000_00_000 = 0x00
        IR <= "0000000000000000";
        wait for 10 ns;
        assert Extended_8 = "00000000"
            report "FAIL: SE test 3 - expected 0x00" severity error;

        -- Test 4: IR(8)=1, all relevant bits 1
        -- Expected: 111_11_111 = 0xFF
        IR <= "0000000111000111";
        wait for 10 ns;
        assert Extended_8 = "11111111"
            report "FAIL: SE test 4 - expected 0xFF" severity error;

        -- Test 5: IR(8)=0, IR(7)=0, IR(6)=1, IR(2:0)=010
        -- Expected: 000_01_010 = 0x0A
        IR <= "0000000001000010";
        wait for 10 ns;
        assert Extended_8 = "00001010"
            report "FAIL: SE test 5 - expected 0x0A" severity error;

        -- Test 6: IR(8)=1, IR(7)=0, IR(6)=0, IR(2:0)=001 => -31
        -- Expected: 111_00_001 = 0xE1
        IR <= "0000000100000001";
        wait for 10 ns;
        assert Extended_8 = "11100001"
            report "FAIL: SE test 6 - expected 0xE1" severity error;

        report "SignExtender: All tests passed" severity note;
        wait;
    end process;

end TB;
