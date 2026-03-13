library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity InstructionDecoderController_tb is
end InstructionDecoderController_tb;

architecture TB of InstructionDecoderController_tb is

    signal RESET : std_logic := '1';
    signal CLK   : std_logic := '0';
    signal IR    : std_logic_vector(15 downto 0) := (others => '0');
    signal V, C, N, Z : std_logic := '0';
    signal PS    : std_logic_vector(1 downto 0);
    signal IL    : std_logic;
    signal DX, AX, BX, FS : std_logic_vector(3 downto 0);
    signal MB, MD, RW, MM, MW : std_logic;

    constant CLK_PERIOD : time := 10 ns;

begin

    UUT: entity work.InstructionDecoderController
        port map (
            RESET => RESET, CLK => CLK, IR => IR,
            V => V, C => C, N => N, Z => Z,
            PS => PS, IL => IL,
            DX => DX, AX => AX, BX => BX, FS => FS,
            MB => MB, MD => MD, RW => RW, MM => MM, MW => MW
        );

    clk_process: process
    begin
        CLK <= '0'; wait for CLK_PERIOD / 2;
        CLK <= '1'; wait for CLK_PERIOD / 2;
    end process;

    stim_process: process
    begin
        -- Reset -> INF
        RESET <= '1';
        wait for CLK_PERIOD * 2;
        RESET <= '0';
        wait for 1 ns; -- let combinatorial settle

        -- === INF state: check fetch signals ===
        assert IL = '1'  report "FAIL INF: IL should be 1" severity error;
        assert MM = '1'  report "FAIL INF: MM should be 1" severity error;
        assert RW = '0'  report "FAIL INF: RW should be 0" severity error;
        assert MW = '0'  report "FAIL INF: MW should be 0" severity error;
        assert PS = "00" report "FAIL INF: PS should be 00" severity error;

        -- Clock into EX0
        wait for CLK_PERIOD - 1 ns;

        -- === ADD: opcode=0000010, DR=001, SA=010, SB=011 ===
        IR <= "0000010001010011";
        wait for 1 ns;
        assert PS = "01"   report "FAIL ADD: PS should be 01" severity error;
        assert FS = "0010" report "FAIL ADD: FS should be 0010" severity error;
        assert RW = '1'    report "FAIL ADD: RW should be 1" severity error;
        assert MD = '0'    report "FAIL ADD: MD should be 0" severity error;
        assert MB = '0'    report "FAIL ADD: MB should be 0" severity error;
        assert MW = '0'    report "FAIL ADD: MW should be 0" severity error;
        assert MM = '0'    report "FAIL ADD: MM should be 0" severity error;
        assert DX = "0001" report "FAIL ADD: DX should be 0001" severity error;
        assert AX = "0010" report "FAIL ADD: AX should be 0010" severity error;
        assert BX = "0011" report "FAIL ADD: BX should be 0011" severity error;

        -- Clock -> INF, then EX0
        wait for CLK_PERIOD - 1 ns;  -- now in INF
        wait for CLK_PERIOD;          -- now in EX0

        -- === SUB: opcode=0000101, DR=010, SA=011, SB=001 ===
        IR <= "0000101010011001";
        wait for 1 ns;
        assert PS = "01"   report "FAIL SUB: PS" severity error;
        assert FS = "0101" report "FAIL SUB: FS should be 0101" severity error;
        assert RW = '1'    report "FAIL SUB: RW" severity error;

        wait for CLK_PERIOD - 1 ns;
        wait for CLK_PERIOD;

        -- === LD: opcode=0010000, DR=001, SA=010 ===
        IR <= "0010000001010000";
        wait for 1 ns;
        assert PS = "01"   report "FAIL LD: PS" severity error;
        assert MD = '1'    report "FAIL LD: MD should be 1" severity error;
        assert RW = '1'    report "FAIL LD: RW" severity error;
        assert MW = '0'    report "FAIL LD: MW" severity error;
        assert MM = '0'    report "FAIL LD: MM" severity error;

        wait for CLK_PERIOD - 1 ns;
        wait for CLK_PERIOD;

        -- === ST: opcode=0100000, DR=001, SA=010, SB=011 ===
        IR <= "0100000001010011";
        wait for 1 ns;
        assert PS = "01"  report "FAIL ST: PS" severity error;
        assert RW = '0'   report "FAIL ST: RW should be 0" severity error;
        assert MW = '1'   report "FAIL ST: MW should be 1" severity error;

        wait for CLK_PERIOD - 1 ns;
        wait for CLK_PERIOD;

        -- === LDI: opcode=1001100, DR=010, SB=101 ===
        IR <= "1001100010000101";
        wait for 1 ns;
        assert MB = '1'    report "FAIL LDI: MB should be 1" severity error;
        assert RW = '1'    report "FAIL LDI: RW" severity error;
        assert FS = "0000" report "FAIL LDI: FS" severity error;

        wait for CLK_PERIOD - 1 ns;
        wait for CLK_PERIOD;

        -- === ADI: opcode=1000010, DR=010, SA=011, SB=101 ===
        IR <= "1000010010011101";
        wait for 1 ns;
        assert MB = '1'    report "FAIL ADI: MB should be 1" severity error;
        assert FS = "0010" report "FAIL ADI: FS should be 0010" severity error;
        assert RW = '1'    report "FAIL ADI: RW" severity error;

        wait for CLK_PERIOD - 1 ns;
        wait for CLK_PERIOD;

        -- === BRZ with Z=1 (taken) ===
        IR <= "1100000001010000";
        Z <= '1';
        wait for 1 ns;
        assert PS = "10" report "FAIL BRZ taken: PS should be 10" severity error;
        assert RW = '0'  report "FAIL BRZ taken: RW should be 0" severity error;

        wait for CLK_PERIOD - 1 ns;
        wait for CLK_PERIOD;

        -- === BRZ with Z=0 (not taken) ===
        IR <= "1100000001010000";
        Z <= '0';
        wait for 1 ns;
        assert PS = "01" report "FAIL BRZ not taken: PS should be 01" severity error;

        wait for CLK_PERIOD - 1 ns;
        wait for CLK_PERIOD;

        -- === BRN with N=1 (taken) ===
        IR <= "1100001001010000";
        N <= '1';
        wait for 1 ns;
        assert PS = "10" report "FAIL BRN taken: PS should be 10" severity error;
        N <= '0';

        wait for CLK_PERIOD - 1 ns;
        wait for CLK_PERIOD;

        -- === JMP: opcode=1110000 ===
        IR <= "1110000000011000";
        wait for 1 ns;
        assert PS = "11" report "FAIL JMP: PS should be 11" severity error;
        assert RW = '0'  report "FAIL JMP: RW should be 0" severity error;

        wait for CLK_PERIOD - 1 ns;
        wait for CLK_PERIOD;

        -- === NOT: opcode=0001011 ===
        IR <= "0001011001010000";
        wait for 1 ns;
        assert FS = "1011" report "FAIL NOT: FS should be 1011" severity error;
        assert RW = '1'    report "FAIL NOT: RW" severity error;

        wait for CLK_PERIOD - 1 ns;
        wait for CLK_PERIOD;

        -- === OR: opcode=0001000 ===
        IR <= "0001000001010011";
        wait for 1 ns;
        assert FS = "1000" report "FAIL OR: FS should be 1000" severity error;

        wait for CLK_PERIOD - 1 ns;
        wait for CLK_PERIOD;

        -- === AND: opcode=0001001 ===
        IR <= "0001001001010011";
        wait for 1 ns;
        assert FS = "1001" report "FAIL AND: FS should be 1001" severity error;

        report "InstructionDecoderController: All tests passed" severity note;
        wait;
    end process;

end TB;
