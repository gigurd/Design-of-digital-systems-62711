library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity NegZero_tb is
end;

architecture bench of NegZero_tb is

  component NegZero
      Port (
          MUXF : in  STD_LOGIC_VECTOR(7 downto 0);
          N, Z : out STD_LOGIC
      );
  end component;

  signal MUXF : STD_LOGIC_VECTOR(7 downto 0);
  signal N    : STD_LOGIC;
  signal Z    : STD_LOGIC;

begin

  uut: NegZero port map ( MUXF => MUXF,
                           N    => N,
                           Z    => Z );

  stimulus: process
  begin

    -- Input = 0x00: not negative, is zero
    MUXF <= "00000000";
    wait for 100 ns;
    assert N = '0' report "FAIL: 0x00 N should be 0" severity error;
    assert Z = '1' report "FAIL: 0x00 Z should be 1" severity error;

    -- Input = 0x01: not negative, not zero
    MUXF <= "00000001";
    wait for 100 ns;
    assert N = '0' report "FAIL: 0x01 N should be 0" severity error;
    assert Z = '0' report "FAIL: 0x01 Z should be 0" severity error;

    -- Input = 0x80 (-128): negative, not zero
    MUXF <= "10000000";
    wait for 100 ns;
    assert N = '1' report "FAIL: 0x80 N should be 1" severity error;
    assert Z = '0' report "FAIL: 0x80 Z should be 0" severity error;

    -- Input = 0xFF (-1): negative, not zero
    MUXF <= "11111111";
    wait for 100 ns;
    assert N = '1' report "FAIL: 0xFF N should be 1" severity error;
    assert Z = '0' report "FAIL: 0xFF Z should be 0" severity error;

    -- Input = 0x7F (+127): not negative, not zero
    MUXF <= "01111111";
    wait for 100 ns;
    assert N = '0' report "FAIL: 0x7F N should be 0" severity error;
    assert Z = '0' report "FAIL: 0x7F Z should be 0" severity error;

    -- Input = 0x40 (+64): not negative, not zero
    MUXF <= "01000000";
    wait for 100 ns;
    assert N = '0' report "FAIL: 0x40 N should be 0" severity error;
    assert Z = '0' report "FAIL: 0x40 Z should be 0" severity error;

    -- Input = 0xFE (-2): negative, not zero
    MUXF <= "11111110";
    wait for 100 ns;
    assert N = '1' report "FAIL: 0xFE N should be 1" severity error;
    assert Z = '0' report "FAIL: 0xFE Z should be 0" severity error;

    -- Input = 0x55: not negative, not zero
    MUXF <= "01010101";
    wait for 100 ns;
    assert N = '0' report "FAIL: 0x55 N should be 0" severity error;
    assert Z = '0' report "FAIL: 0x55 Z should be 0" severity error;

    -- Input = 0xAA: negative, not zero
    MUXF <= "10101010";
    wait for 100 ns;
    assert N = '1' report "FAIL: 0xAA N should be 1" severity error;
    assert Z = '0' report "FAIL: 0xAA Z should be 0" severity error;

    report "NegZero testbench completed successfully";
    wait;
  end process;

end;
