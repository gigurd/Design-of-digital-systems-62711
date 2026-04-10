library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Microprocessor_tb is
end Microprocessor_tb;

architecture TB of Microprocessor_tb is

    signal CLK    : STD_LOGIC := '0';
    signal RESET  : STD_LOGIC := '1';
    signal SW     : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal BTNC, BTNU, BTNL, BTNR, BTND : STD_LOGIC := '0';
    signal LED    : STD_LOGIC_VECTOR(7 downto 0);
    signal D_Word : STD_LOGIC_VECTOR(15 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    UUT: entity work.Microprocessor
        port map (
            CLK    => CLK,
            RESET  => RESET,
            SW     => SW,
            BTNC   => BTNC,
            BTNU   => BTNU,
            BTNL   => BTNL,
            BTNR   => BTNR,
            BTND   => BTND,
            LED    => LED,
            D_Word => D_Word
        );

    clk_process: process
    begin
        CLK <= '0'; wait for CLK_PERIOD / 2;
        CLK <= '1'; wait for CLK_PERIOD / 2;
    end process;

    stim_process: process
    begin
        -- TODO: Load RAM with microcode program and verify execution
        RESET <= '1';
        wait for CLK_PERIOD * 2;
        RESET <= '0';

        wait for CLK_PERIOD * 100;
        wait;
    end process;

end TB;
