library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity InstructionRegister is
    port (
        RESET          : in  std_logic;
        CLK            : in  std_logic;
        Instruction_In : in  std_logic_vector(15 downto 0);
        IL             : in  std_logic;
        IR             : out std_logic_vector(15 downto 0)
    );
end InstructionRegister;

architecture IR_Behavorial of InstructionRegister is
begin

    process(CLK, RESET)
    begin
        if RESET = '1' then
            IR <= (others => '0');
        elsif rising_edge(CLK) then
            if IL = '1' then
                IR <= Instruction_In;
            end if;
        end if;
    end process;

end IR_Behavorial;
