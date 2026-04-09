library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SignExtender is
    port (
        IR         : in  STD_LOGIC_VECTOR(15 downto 0);
        Extended_8 : out STD_LOGIC_VECTOR(7 downto 0)
    );
end SignExtender;

architecture SE_Structual of SignExtender is

begin
    
    Extended_8 <= (7 downto 5 => IR(8)) & -- IR(8) extended
                IR(7 downto 6) &          
                IR(2 downto 0);

end SE_Structual;
