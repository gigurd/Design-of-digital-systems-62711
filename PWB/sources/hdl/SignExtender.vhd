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

    -- Extended_8 = sign.sign.sign.IR7.IR6.IR2.IR1.IR0
    -- sign = IR(8)
    Extended_8 <= IR(8) & IR(8) & IR(8) & IR(7 downto 6) & IR(2 downto 0);

end SE_Behavorial;
