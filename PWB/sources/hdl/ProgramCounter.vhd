library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ProgramCounter is
    port (
        RESET      : in  STD_LOGIC;
        CLK        : in  STD_LOGIC;
        Address_In : in  STD_LOGIC_VECTOR(7 downto 0);
        PS         : in  STD_LOGIC_VECTOR(1 downto 0);
        Offset     : in  STD_LOGIC_VECTOR(7 downto 0);
        PC         : out STD_LOGIC_VECTOR(7 downto 0)
    );
end ProgramCounter;

architecture PC_Behavorial of ProgramCounter is
    signal PC_reg : unsigned(7 downto 0);
begin

    process(CLK, RESET)
    begin
        if RESET = '1' then
            PC_reg <= (others => '0');
        elsif rising_edge(CLK) then
            case PS is
                when "00"   => PC_reg <= PC_reg;                    -- Hold
                when "01"   => PC_reg <= PC_reg + 1;                -- Increment
                when "10"   => PC_reg <= PC_reg + unsigned(Offset); -- Branch
                when "11"   => PC_reg <= unsigned(Address_In);      -- Jump
                when others => PC_reg <= PC_reg;
            end case;
        end if;
    end process;

    PC <= std_logic_vector(PC_reg);

end PC_Behavorial;
