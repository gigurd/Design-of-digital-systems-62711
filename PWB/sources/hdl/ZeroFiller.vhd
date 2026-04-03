library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ZeroFiller is
    port (
        IR           : in  STD_LOGIC_VECTOR(15 downto 0);
        ZeroFilled_8 : out STD_LOGIC_VECTOR(7 downto 0)
    );
end ZeroFiller;

architecture ZF_Structual of ZeroFiller is
begin

    ZeroFilled_8 <= (7 downto 3 => '0') & -- 5 nuller
                  IR(2 downto 0); --LSB af IR

end ZF_Structual;