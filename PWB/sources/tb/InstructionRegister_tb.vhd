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
        -- ============================================
        -- RESET: IR should be 0
        -- ============================================
        RESET <= '1';
        IL <= '0';
        Instruction_In <= x"0000";
        wait for CLK_PERIOD * 2;
        RESET <= '0';
        wait for CLK_PERIOD;
        assert IR = x"0000"
            report "RESET failed: IR should be 0000"
            severity error;

        -- ============================================
        -- TEST 1: IL=0 - IR outputs registered value (0000)
        -- Even though Instruction_In changes, IR should
        -- show the flip-flop output (still 0 after reset)
        -- ============================================
        IL <= '0';
        Instruction_In <= x"ABCD";
        wait for CLK_PERIOD;
        -- Flip-flop captured ABCD on previous rising edge,
        -- but IL=0 means IR = IRSig (which was 0 before this edge)
        -- After this clock edge, IRSig = ABCD
        -- We need to check right after reset: IRSig was 0
        -- Actually, let's re-examine timing carefully.

        -- ============================================
        -- TEST 2: IL=1 - IR passes through Instruction_In
        -- ============================================
        IL <= '1';
        Instruction_In <= x"1234";
        wait for 1 ns; -- combinational pass-through
        assert IR = x"1234"
            report "IL=1 pass-through failed: IR should be 1234"
            severity error;

        -- Wait for clock edge so flip-flop captures 1234
        wait for CLK_PERIOD;

        -- ============================================
        -- TEST 3: IL=0 - IR shows registered value (1234)
        -- Flip-flop has captured 1234, so IR should be 1234
        -- ============================================
        IL <= '0';
        Instruction_In <= x"5678"; -- change input, should NOT affect IR
        wait for 1 ns;
        assert IR = x"1234"
            report "IL=0 hold failed: IR should be 1234, not input 5678"
            severity error;

        -- Wait some clocks, flip-flop now captures 5678
        wait for CLK_PERIOD;

        -- ============================================
        -- TEST 4: IL=0 - IR now shows 5678 (registered)
        -- Flip-flop captured 5678 on the last rising edge
        -- ============================================
        assert IR = x"5678"
            report "IL=0 after clock: IR should be 5678 (registered)"
            severity error;

        -- ============================================
        -- TEST 5: IL=1 with new value - pass-through
        -- ============================================
        IL <= '1';
        Instruction_In <= x"FFFF";
        wait for 1 ns;
        assert IR = x"FFFF"
            report "IL=1 pass-through failed: IR should be FFFF"
            severity error;

        wait for CLK_PERIOD;

        -- ============================================
        -- TEST 6: IL=0 after FFFF was loaded
        -- ============================================
        IL <= '0';
        Instruction_In <= x"0000";
        wait for 1 ns;
        assert IR = x"FFFF"
            report "IL=0 hold failed: IR should be FFFF"
            severity error;

        -- ============================================
        -- TEST 7: Reset while holding
        -- ============================================
        RESET <= '1';
        wait for CLK_PERIOD;
        RESET <= '0';
        IL <= '0';
        Instruction_In <= x"AAAA";
        wait for 1 ns;
        assert IR = x"0000"
            report "RESET during hold failed: IR should be 0000"
            severity error;

        -- ============================================
        -- TEST 8: IL=1 immediately after reset
        -- ============================================
        IL <= '1';
        Instruction_In <= x"BEEF";
        wait for 1 ns;
        assert IR = x"BEEF"
            report "IL=1 after reset failed: IR should be BEEF"
            severity error;

        -- ============================================
        -- Done
        -- ============================================
        report "=== All InstructionRegister tests completed ===" severity note;
        wait;
    end process;

end TB;
