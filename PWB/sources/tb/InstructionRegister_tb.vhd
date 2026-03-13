library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity InstructionRegister_tb is
end InstructionRegister_tb;

architecture TB of InstructionRegister_tb is

    signal RESET          : std_logic := '1';
    signal CLK            : std_logic := '0';
    signal Instruction_In : std_logic_vector(15 downto 0) := (others => '0');
    signal IL             : std_logic := '0';
    signal IR             : std_logic_vector(15 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    UUT: entity work.InstructionRegister
        port map (
            RESET          => RESET,
            CLK            => CLK,
            Instruction_In => Instruction_In,
            IL             => IL,
            IR             => IR
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
        assert IR = x"0000"
            report "FAIL: IR should be 0 after reset" severity error;
        RESET <= '0';

        -- IL=0: No load
        IL <= '0';
        Instruction_In <= x"ABCD";
        wait for CLK_PERIOD * 2;
        assert IR = x"0000"
            report "FAIL: IR should hold 0 when IL=0" severity error;

        -- IL=1: Load
        IL <= '1';
        Instruction_In <= x"1234";
        wait for CLK_PERIOD;
        assert IR = x"1234"
            report "FAIL: IR should be 0x1234 after load" severity error;

        -- IL=0: Hold
        IL <= '0';
        Instruction_In <= x"5678";
        wait for CLK_PERIOD * 2;
        assert IR = x"1234"
            report "FAIL: IR should hold 0x1234 when IL=0" severity error;

        -- IL=1: Load new
        IL <= '1';
        Instruction_In <= x"FFFF";
        wait for CLK_PERIOD;
        assert IR = x"FFFF"
            report "FAIL: IR should be 0xFFFF after load" severity error;

        -- IL=0: Hold
        IL <= '0';
        wait for CLK_PERIOD * 2;
        assert IR = x"FFFF"
            report "FAIL: IR should hold 0xFFFF" severity error;

        report "InstructionRegister: All tests passed" severity note;
        wait;
    end process;

end TB;
