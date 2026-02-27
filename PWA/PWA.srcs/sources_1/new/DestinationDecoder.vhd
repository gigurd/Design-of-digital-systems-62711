----------------------------------------------------------------------------------
-- Module Name: DestinationDecoder
-- Description: Decodes DA(3:0) + WRITE into one-hot LOAD(15:0)
--              When WRITE=1, sets LOAD(DA) = 1, all others = 0
--              When WRITE=0, all LOAD bits = 0 (no register write)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DestinationDecoder is
    Port (
        WRITE : in  STD_LOGIC;
        DA    : in  STD_LOGIC_VECTOR(3 downto 0);
        LOAD  : out STD_LOGIC_VECTOR(15 downto 0)
    );
end DestinationDecoder;

architecture dataflow of DestinationDecoder is
begin
    -- One-hot decode: LOAD(i) = 1 only when WRITE=1 and DA matches i
    GEN_LOAD: for i in 0 to 15 generate
        LOAD(i) <= '1' when (WRITE = '1' and DA = std_logic_vector(to_unsigned(i, 4)))
                       else '0';
    end generate GEN_LOAD;
end dataflow;
