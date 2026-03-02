library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FunctionUnitTB is
end FunctionUnitTB;

architecture Behavioral of FunctionUnitTB is

    signal A, B : STD_LOGIC_VECTOR(7 downto 0);
    signal FS : STD_LOGIC_VECTOR(3 downto 0);
    signal Cin : STD_LOGIC;
    signal V, C, N, Z : STD_LOGIC;
    signal F : STD_LOGIC_VECTOR(7 downto 0);

begin

    uut: entity work.FunctionUnit
    port map (
        A   => A,
        B   => B,
        FS3 => FS(3),
        FS2 => FS(2),
        FS1 => FS(1),
        FS0 => FS(0),
        Cin => Cin,
        V   => V,
        C   => C,
        N   => N,
        Z   => Z,
        F   => F
    );

    stim: process
    begin

        -- =============================================
        -- ALU TEST 1: A + B med overflow (FS=0010, Cin=0)
        -- A=127, B=1 -> 127+1=128 = "10000000"
        -- V=1 (signed overflow), C=0, N=1, Z=0
        -- =============================================
        A <= "01111111"; -- 127
        B <= "00000001"; -- 1
        FS <= "0010"; Cin <= '0';
        wait for 50 ns;
        assert F = "10000000" report "ALU TEST 1: F forkert" severity error;
        assert V = '1'        report "ALU TEST 1: V skal vaere 1 (overflow)" severity error;
        assert N = '1'        report "ALU TEST 1: N skal vaere 1 (negativt resultat)" severity error;
        assert Z = '0'        report "ALU TEST 1: Z skal vaere 0 (ikke nul)" severity error;

        -- =============================================
        -- ALU TEST 2: A - B hvor A=B (FS=0100, Cin=1)
        -- A=5, B=5 -> A + not B + 1 = 0
        -- V=0, C=1, N=0, Z=1
        -- =============================================
        A <= "00000101"; -- 5
        B <= "00000101"; -- 5
        FS <= "0100"; Cin <= '1';
        wait for 50 ns;
        assert F = "00000000" report "ALU TEST 2: F forkert" severity error;
        assert V = '0'        report "ALU TEST 2: V skal vaere 0 (ingen overflow)" severity error;
        assert N = '0'        report "ALU TEST 2: N skal vaere 0 (ikke negativt)" severity error;
        assert Z = '1'        report "ALU TEST 2: Z skal vaere 1 (resultat er nul)" severity error;

        -- =============================================
        -- SHIFTER TEST 1: sr B (FS=1101)
        -- B="00000110" (6) -> shift right -> "00000011" (3)
        -- N=0, Z=0
        -- =============================================
        B <= "00000110"; -- 6
        FS <= "1101"; Cin <= '0';
        wait for 50 ns;
        assert F = "00000011" report "SHIFTER TEST 1: F forkert" severity error;
        assert N = '0'        report "SHIFTER TEST 1: N skal vaere 0" severity error;
        assert Z = '0'        report "SHIFTER TEST 1: Z skal vaere 0" severity error;

        -- =============================================
        -- SHIFTER TEST 2: sl B (FS=1110)
        -- B="01000001" (65) -> shift left -> "10000010" (130)
        -- N=1, Z=0
        -- =============================================
        B <= "01000001"; -- 65
        FS <= "1110"; Cin <= '0';
        wait for 50 ns;
        assert F = "10000010" report "SHIFTER TEST 2: F forkert" severity error;
        assert N = '1'        report "SHIFTER TEST 2: N skal vaere 1 (MSB=1)" severity error;
        assert Z = '0'        report "SHIFTER TEST 2: Z skal vaere 0" severity error;

        report "Alle tests faerdige" severity note;
        wait;
    end process;

end Behavioral;
