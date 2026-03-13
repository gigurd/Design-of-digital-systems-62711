library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MicroprogramController_tb is
end MicroprogramController_tb;

architecture TB of MicroprogramController_tb is

    signal RESET          : std_logic := '1';
    signal CLK            : std_logic := '0';
    signal Address_In     : std_logic_vector(7 downto 0) := (others => '0');
    signal Address_Out    : std_logic_vector(7 downto 0);
    signal Instruction_In : std_logic_vector(15 downto 0) := (others => '0');
    signal Constant_Out   : std_logic_vector(7 downto 0);
    signal V, C, N, Z     : std_logic := '0';
    signal DX, AX, BX, FS : std_logic_vector(3 downto 0);
    signal MB, MD, RW, MM, MW : std_logic;

    constant CLK_PERIOD : time := 10 ns;

begin

    UUT: entity work.MicroprogramController
        port map (
            RESET => RESET, CLK => CLK,
            Address_In => Address_In, Address_Out => Address_Out,
            Instruction_In => Instruction_In, Constant_Out => Constant_Out,
            V => V, C => C, N => N, Z => Z,
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
        -- Reset
        RESET <= '1';
        wait for CLK_PERIOD * 2;
        RESET <= '0';
        wait for 1 ns;

        -- After reset: INF state, PC=0
        assert Address_Out = x"00"
            report "FAIL: Address_Out should be 0 after reset" severity error;
        assert IL = '1'
            report "FAIL: IL should be 1 in INF" severity error;
        assert MM = '1'
            report "FAIL: MM should be 1 in INF" severity error;

        -- === ADD: opcode=0000010, DR=001, SA=010, SB=011 ===
        Instruction_In <= "0000010001010011";
        wait for CLK_PERIOD - 1 ns; -- clock -> EX0, IR loaded
        wait for 1 ns; -- let combinatorial settle after EX0 entered
        -- Now in EX0 with ADD decoded
        assert FS = "0010"
            report "FAIL MCU ADD: FS should be 0010" severity error;
        assert RW = '1'
            report "FAIL MCU ADD: RW should be 1" severity error;
        assert MW = '0'
            report "FAIL MCU ADD: MW should be 0" severity error;

        -- Clock -> INF (PC incremented to 1)
        wait for CLK_PERIOD - 1 ns;
        wait for 1 ns;
        assert Address_Out = x"01"
            report "FAIL MCU: PC should be 1 after ADD" severity error;
        assert IL = '1'
            report "FAIL MCU: IL should be 1 in INF" severity error;

        -- === MOVA: opcode=0000000, DR=100, SA=010, SB=001 ===
        Instruction_In <= "0000000100010001";
        wait for CLK_PERIOD - 1 ns;
        wait for 1 ns;
        assert FS = "0000"
            report "FAIL MCU MOVA: FS should be 0000" severity error;
        assert RW = '1'
            report "FAIL MCU MOVA: RW should be 1" severity error;

        -- Clock -> INF (PC=2)
        wait for CLK_PERIOD - 1 ns;
        wait for 1 ns;
        assert Address_Out = x"02"
            report "FAIL MCU: PC should be 2 after MOVA" severity error;

        -- === LDI: opcode=1001100, DR=010, SB=101 ===
        Instruction_In <= "1001100010000101";
        wait for CLK_PERIOD - 1 ns;
        wait for 1 ns;
        assert MB = '1'
            report "FAIL MCU LDI: MB should be 1" severity error;
        assert RW = '1'
            report "FAIL MCU LDI: RW should be 1" severity error;
        assert Constant_Out = x"05"
            report "FAIL MCU LDI: Constant_Out should be 0x05" severity error;

        -- Clock -> INF (PC=3)
        wait for CLK_PERIOD - 1 ns;
        wait for 1 ns;
        assert Address_Out = x"03"
            report "FAIL MCU: PC should be 3 after LDI" severity error;

        -- === JMP: opcode=1110000, SA=011 ===
        Instruction_In <= "1110000000011000";
        Address_In <= x"20";
        wait for CLK_PERIOD - 1 ns;
        wait for 1 ns;
        -- EX0 for JMP: PS=11
        assert RW = '0'
            report "FAIL MCU JMP: RW should be 0" severity error;
        assert MW = '0'
            report "FAIL MCU JMP: MW should be 0" severity error;

        -- Clock -> INF (PC jumped)
        -- Note: JMP sets PS=11 which loads Address_In into PC
        -- But Address_In connects to the external bus, not R[SA] in the MPC alone
        -- The PC should load Address_In = 0x20
        wait for CLK_PERIOD - 1 ns;
        wait for 1 ns;
        assert Address_Out = x"20"
            report "FAIL MCU: PC should be 0x20 after JMP" severity error;

        report "MicroprogramController: All tests passed" severity note;
        wait;
    end process;

end TB;
