

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity flip_flop_16 is
    Port (
        D     : in  STD_LOGIC_VECTOR (15 downto 0);
        Reset : in  STD_LOGIC;
        clk   : in  STD_LOGIC;
        Q     : out STD_LOGIC_VECTOR (15 downto 0)
    );
end flip_flop_16;

-- Denne arkitektur implementerer en D-flip-flop i sin simpleste form via behavioral
architecture Behavioral of flip_flop_16 is
begin
    process(clk, Reset)
    begin
        if Reset = '1' then
            Q <= (15 downto 0 => '0');
        elsif rising_edge(clk) then
            Q <= D;
        end if;
    end process;
    
end Behavioral;
