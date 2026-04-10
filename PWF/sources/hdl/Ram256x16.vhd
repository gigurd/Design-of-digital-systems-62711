library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Ram256x16 is
    port (
        clk        : in  STD_LOGIC;
        Reset      : in  STD_LOGIC;
        Data_in    : in  STD_LOGIC_VECTOR(15 downto 0);
        Address_in : in  STD_LOGIC_VECTOR(7 downto 0);
        MW         : in  STD_LOGIC;
        Data_out   : out STD_LOGIC_VECTOR(15 downto 0)
    );
end Ram256x16;

architecture RAM_Behavorial of Ram256x16 is

    -- TODO: Implement using Xilinx Block RAM macro or behavioral array
    -- Language Templates -> VHDL -> Device Macro Instantiation -> Artix 7 -> RAM -> Single Port RAM

begin

    -- TODO: RAM read/write logic

end RAM_Behavorial;
