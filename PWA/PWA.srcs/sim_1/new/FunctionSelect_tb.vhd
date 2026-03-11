library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity FunctionSelect_tb is
end;

architecture bench of FunctionSelect_tb is

  component FunctionSelect
      Port (
          FS : in  STD_LOGIC_VECTOR(3 downto 0);
          MF : out STD_LOGIC
      );
  end component;

  signal FS : STD_LOGIC_VECTOR(3 downto 0);
  signal MF : STD_LOGIC;

begin

  uut: FunctionSelect port map ( FS => FS,
                                  MF => MF );

  stimulus: process
  begin

    -- FS3=0, FS2=0 => MF=0 (ALU output)
    FS <= "0000";
    wait for 100 ns;
    assert MF = '0' report "FAIL: FS=0000, expected MF=0" severity error;

    -- FS3=0, FS2=1 => MF=0 (ALU output)
    FS <= "0100";
    wait for 100 ns;
    assert MF = '0' report "FAIL: FS=0100, expected MF=0" severity error;

    -- FS3=1, FS2=0 => MF=0 (ALU output)
    FS <= "1000";
    wait for 100 ns;
    assert MF = '0' report "FAIL: FS=1000, expected MF=0" severity error;

    -- FS3=1, FS2=1 => MF=1 (Shifter output)
    FS <= "1100";
    wait for 100 ns;
    assert MF = '1' report "FAIL: FS=1100, expected MF=1" severity error;

    -- Verify FS1/FS0 don't affect MF: FS3=1, FS2=1, FS1=1, FS0=1
    FS <= "1111";
    wait for 100 ns;
    assert MF = '1' report "FAIL: FS=1111, expected MF=1" severity error;

    -- FS3=1, FS2=0, FS1=1, FS0=1 => MF=0
    FS <= "1011";
    wait for 100 ns;
    assert MF = '0' report "FAIL: FS=1011, expected MF=0" severity error;

    -- FS3=0, FS2=1, FS1=1, FS0=0 => MF=0
    FS <= "0110";
    wait for 100 ns;
    assert MF = '0' report "FAIL: FS=0110, expected MF=0" severity error;

    -- FS3=1, FS2=1, FS1=0, FS0=1 => MF=1
    FS <= "1101";
    wait for 100 ns;
    assert MF = '1' report "FAIL: FS=1101, expected MF=1" severity error;

    report "FunctionSelect testbench completed successfully";
    wait;
  end process;

end;
