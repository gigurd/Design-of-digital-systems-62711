----------------------------------------------------------------------------------
-- Module Name: TOP_MODUL_tb
-- Description: Testbench for TOP_MODUL (PWA)
--              Simulates clock, reset, switches, and buttons
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TOP_MODUL_tb is
    -- Testbench has no ports
end TOP_MODUL_tb;

architecture tb of TOP_MODUL_tb is

    -- Clock period (matches constraint file: 50 ns = 20 MHz)
    constant CLK_PERIOD : time := 50 ns;

    -- Signals to drive the UUT
    signal clk      : STD_LOGIC := '0';
    signal reset    : STD_LOGIC := '0';
    signal sw       : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal btnc     : STD_LOGIC := '0';
    signal btnu     : STD_LOGIC := '0';
    signal btnl     : STD_LOGIC := '0';
    signal btnr     : STD_LOGIC := '0';
    signal btnd     : STD_LOGIC := '0';

    -- Signals to observe from the UUT
    signal led      : STD_LOGIC_VECTOR(7 downto 0);
    signal segments : STD_LOGIC_VECTOR(6 downto 0);
    signal dp       : STD_LOGIC;
    signal anode    : STD_LOGIC_VECTOR(7 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: entity work.TOP_MODUL
        port map (
            CLK      => clk,
            RESET    => reset,
            SW       => sw,
            LED      => led,
            segments => segments,
            dp       => dp,
            Anode    => anode,
            BTNC     => btnc,
            BTNU     => btnu,
            BTNL     => btnl,
            BTNR     => btnr,
            BTND     => btnd
        );

    -- Clock generation
    clk_process: process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- Stimulus process
    stim_process: process
    begin
        -- Hold reset for 100 ns
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait for CLK_PERIOD * 2;

        -- Add test stimulus here

        wait;
    end process;

end tb;
