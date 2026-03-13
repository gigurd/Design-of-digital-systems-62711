library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ProgramCounter is
    port (
        RESET      : in  std_logic;
        CLK        : in  std_logic;
        Address_In : in  std_logic_vector(7 downto 0);
        PS         : in  std_logic_vector(1 downto 0);
        Offset     : in  std_logic_vector(7 downto 0);
        PC         : out std_logic_vector(7 downto 0)
    );
end ProgramCounter;

architecture PC_Behavorial of ProgramCounter is
    signal PC_reg : std_logic_vector(7 downto 0);
begin

    process(CLK, RESET)
    begin
        if RESET = '1' then
            PC_reg <= (others => '0');
        elsif rising_edge(CLK) then
            case PS is
                when "00" =>
                    PC_reg <= PC_reg;
                when "01" =>
                    PC_reg <= PC_reg + 1;
                when "10" =>
                    PC_reg <= PC_reg + Offset;
                when "11" =>
                    PC_reg <= Address_In;
                when others =>
                    PC_reg <= PC_reg;
            end case;
        end if;
    end process;

    PC <= PC_reg;

end PC_Behavorial;
