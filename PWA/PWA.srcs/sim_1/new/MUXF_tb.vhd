library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity MUXF_tb is
end;

architecture bench of MUXF_tb is

  component MUX2x1x8
      Port (
          J, H : in  STD_LOGIC_VECTOR(7 downto 0);
          MF   : in  STD_LOGIC;
          Y    : out STD_LOGIC_VECTOR(7 downto 0)
      );
  end component;

  signal J  : STD_LOGIC_VECTOR(7 downto 0);
  signal H  : STD_LOGIC_VECTOR(7 downto 0);
  signal MF : STD_LOGIC;
  signal Y  : STD_LOGIC_VECTOR(7 downto 0);

begin

  uut: MUX2x1x8 port map ( J  => J,
                             H  => H,
                             MF => MF,
                             Y  => Y );

  stimulus: process
  begin

    -- MF=0 => Y = J (ALU output selected)
    J  <= "10101010";
    H  <= "01010101";
    MF <= '0';
    wait for 100 ns;
    assert Y = "10101010" report "FAIL: MF=0, expected Y=J=10101010" severity error;

    -- MF=1 => Y = H (Shifter output selected)
    MF <= '1';
    wait for 100 ns;
    assert Y = "01010101" report "FAIL: MF=1, expected Y=H=01010101" severity error;

    -- New values, MF=0 => Y = J
    J  <= "11110000";
    H  <= "00001111";
    MF <= '0';
    wait for 100 ns;
    assert Y = "11110000" report "FAIL: MF=0, expected Y=J=11110000" severity error;

    -- Same values, MF=1 => Y = H
    MF <= '1';
    wait for 100 ns;
    assert Y = "00001111" report "FAIL: MF=1, expected Y=H=00001111" severity error;

    -- Both inputs zero, MF=0
    J  <= "00000000";
    H  <= "00000000";
    MF <= '0';
    wait for 100 ns;
    assert Y = "00000000" report "FAIL: MF=0, both zero, expected Y=00000000" severity error;

    -- Both inputs zero, MF=1
    MF <= '1';
    wait for 100 ns;
    assert Y = "00000000" report "FAIL: MF=1, both zero, expected Y=00000000" severity error;

    -- Both inputs 0xFF, MF=0
    J  <= "11111111";
    H  <= "11111111";
    MF <= '0';
    wait for 100 ns;
    assert Y = "11111111" report "FAIL: MF=0, both FF, expected Y=11111111" severity error;

    -- Both inputs 0xFF, MF=1
    MF <= '1';
    wait for 100 ns;
    assert Y = "11111111" report "FAIL: MF=1, both FF, expected Y=11111111" severity error;

    -- Distinct values to verify bit-level selection
    J  <= "11001100";
    H  <= "00110011";
    MF <= '0';
    wait for 100 ns;
    assert Y = "11001100" report "FAIL: MF=0, expected Y=J=11001100" severity error;

    MF <= '1';
    wait for 100 ns;
    assert Y = "00110011" report "FAIL: MF=1, expected Y=H=00110011" severity error;

    report "MUXF testbench completed successfully";
    wait;
  end process;

end;
