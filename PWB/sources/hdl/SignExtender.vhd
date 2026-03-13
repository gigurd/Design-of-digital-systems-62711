library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SignExtender is
    port (
        IR         : in  std_logic_vector(15 downto 0);
        Extended_8 : out std_logic_vector(7 downto 0)
    );
end SignExtender;

architecture SE_Behavorial of SignExtender is
begin

    Extended_8 <= "000" & IR(7) & IR(6) & IR(2) & IR(1) & IR(0) when IR(8) = '0'
            else "111" & IR(7) & IR(6) & IR(2) & IR(1) & IR(0);

end SE_Behavorial;
