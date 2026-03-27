library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ZeroFiller is
    port (
        IR           : in  std_logic_vector(15 downto 0);
        ZeroFilled_8 : out std_logic_vector(7 downto 0)
    );
end ZeroFiller;

architecture ZF_Behavorial of ZeroFiller is
begin

    -- ZeroFilled_8 = 00000.IR2.IR1.IR0
    ZeroFilled_8 <= "00000" & IR(2 downto 0);

end ZF_Behavorial;
