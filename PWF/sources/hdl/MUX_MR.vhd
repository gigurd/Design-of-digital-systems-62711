library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Multiplexer for selecting between RAM output and Port Register output
-- MMR = 0: Data_Bus_Out <= Data_outM (from RAM)
-- MMR = 1: Data_Bus_Out <= Data_outR (from Port Register)
entity MUX_MR is
    port (
        Data_outM    : in  STD_LOGIC_VECTOR(15 downto 0);
        Data_outR    : in  STD_LOGIC_VECTOR(15 downto 0);
        MMR          : in  STD_LOGIC;
        Data_Bus_Out : out STD_LOGIC_VECTOR(15 downto 0)
    );
end MUX_MR;

architecture MUXMR_Behavorial of MUX_MR is
begin

    Data_Bus_Out <= (Data_OutR AND    (15 downto 0 => MMR) ) OR
                    (Data_OutM AND NOT(15 downto 0 => MMR) );

end MUXMR_Behavorial;
