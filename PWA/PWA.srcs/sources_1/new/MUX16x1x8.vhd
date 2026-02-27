----------------------------------------------------------------------------------
-- Module Name: MUX16x1x8
-- Description: 16-to-1 multiplexer, 8-bit wide
--              D_Select(3:0) chooses which register output appears at Y_Data
--              Used for A_Data and B_Data output muxes in the Register File
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX16x1x8 is
    Port (
        R0, R1, R2, R3     : in  STD_LOGIC_VECTOR(7 downto 0);
        R4, R5, R6, R7     : in  STD_LOGIC_VECTOR(7 downto 0);
        R8, R9, R10, R11   : in  STD_LOGIC_VECTOR(7 downto 0);
        R12, R13, R14, R15 : in  STD_LOGIC_VECTOR(7 downto 0);
        D_Select            : in  STD_LOGIC_VECTOR(3 downto 0);
        Y_Data              : out STD_LOGIC_VECTOR(7 downto 0)
    );
end MUX16x1x8;
architecture dataflow of MUX16x1x8 is
begin
    with D_Select select
        Y_Data <= R0  when "0000",
                  R1  when "0001",
                  R2  when "0010",
                  R3  when "0011",
                  R4  when "0100",
                  R5  when "0101",
                  R6  when "0110",
                  R7  when "0111",
                  R8  when "1000",
                  R9  when "1001",
                  R10 when "1010",
                  R11 when "1011",
                  R12 when "1100",
                  R13 when "1101",
                  R14 when "1110",
                  R15 when "1111",
                  (others => '0') when others;
end dataflow;
