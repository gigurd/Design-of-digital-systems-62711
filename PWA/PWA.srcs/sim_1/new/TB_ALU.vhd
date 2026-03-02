library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity TB_ALU is
end TB_ALU;

architecture bench of TB_ALU is

    component ALU
        Port (
            A, B     : in  STD_LOGIC_VECTOR(7 downto 0);
            JSel     : in  STD_LOGIC_VECTOR(3 downto 0);
            Cin      : in  STD_LOGIC;
            V, C     : out STD_LOGIC;
            J        : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    signal A, B  : STD_LOGIC_VECTOR(7 downto 0);
    signal JSel  : STD_LOGIC_VECTOR(3 downto 0);
    signal Cin   : STD_LOGIC;
    signal V, C  : STD_LOGIC;
    signal J     : STD_LOGIC_VECTOR(7 downto 0);

begin

    uut: ALU 
    port map (
        A    => A,
        B    => B,
        JSel => JSel,
        Cin  => Cin,
        V    => V,
        C    => C,
        J    => J
    );

    stimulus: process
    begin
        report "ALU TB started" severity note;

        A <= "00000101"; -- 5
        B <= "00000011"; -- 3

        -- =========================================================
        -- ARITHMETIC MODE (J3 = 0)
        -- =========================================================

        -- J=0000 : F = A
        JSel <= "0000"; Cin <= '0'; wait for 50 ns;

        -- J=0001 : F = A + 1
        JSel <= "0000"; Cin <= '1'; wait for 50 ns;

        -- J=0010 : F = A + B
        JSel <= "0010"; Cin <= '0'; wait for 50 ns;

        -- J=0011 : F = A + B + 1
        JSel <= "0010"; Cin <= '1'; wait for 50 ns;

        -- J=0100 : F = A + not B
        JSel <= "0100"; Cin <= '0'; wait for 50 ns;

        -- J=0101 : F = A + not B + 1  (A - B)
        JSel <= "0100"; Cin <= '1'; wait for 50 ns;

        -- J=0110 : F = A - 1
        JSel <= "0110"; Cin <= '0'; wait for 50 ns;

        -- J=0111 : F = A
        JSel <= "0110"; Cin <= '1'; wait for 50 ns;

        -- =========================================================
        -- LOGIC MODE (J3 = 1)
        -- =========================================================

        -- J=1X00 : F = A OR B
        JSel <= "1100"; wait for 50 ns;

        -- J=1X01 : F = A AND B
        JSel <= "1101"; wait for 50 ns;

        -- J=1X10 : F = A XOR B
        JSel <= "1110";  wait for 50 ns;

        -- J=1X11 : F = NOT A
        JSel <= "1111";  wait for 50 ns;

        -- =========================================================
        -- EXTRA TEST (overflow/carry sanity)
        -- =========================================================

        A <= "11111111"; -- 255
        B <= "00000001"; -- 1

        -- J=0010 : A + B (expect carry)
        JSel <= "0010"; Cin <= '0'; wait for 50 ns;

        -- J=0001 : A + 1
        JSel <= "0000"; Cin <= '1'; wait for 50 ns;

        -- J=0101 : A - B
        JSel <= "0100"; Cin <= '1'; wait for 50 ns;

        wait;
    end process;

end bench;