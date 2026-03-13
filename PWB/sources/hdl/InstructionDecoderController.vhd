library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity InstructionDecoderController is
    port (
        RESET              : in  std_logic;
        CLK                : in  std_logic;
        IR                 : in  std_logic_vector(15 downto 0);
        V, C, N, Z         : in  std_logic;
        PS                 : out std_logic_vector(1 downto 0);
        IL                 : out std_logic;
        DX, AX, BX, FS    : out std_logic_vector(3 downto 0);
        MB, MD, RW, MM, MW : out std_logic
    );
end InstructionDecoderController;

architecture IDC_Behavorial of InstructionDecoderController is

    type state_type is (INF, EX0, EX1, EX2, EX3, EX4);
    signal current_state, next_state : state_type;

    alias opcode : std_logic_vector(6 downto 0) is IR(15 downto 9);

begin

    -- Process 1: State register (sequential)
    state_reg: process(CLK, RESET)
    begin
        if RESET = '1' then
            current_state <= INF;
        elsif rising_edge(CLK) then
            current_state <= next_state;
        end if;
    end process;

    -- Process 2: Next-state + output logic (combinatorial)
    comb_logic: process(current_state, opcode, V, C, N, Z)
    begin
        -- Defaults (INF-safe: no writes, hold PC, no load)
        next_state <= INF;
        PS  <= "00";
        IL  <= '0';
        DX  <= '0' & IR(8 downto 6);
        AX  <= '0' & IR(5 downto 3);
        BX  <= '0' & IR(2 downto 0);
        MB  <= '0';
        FS  <= "0000";
        MD  <= '0';
        RW  <= '0';
        MM  <= '0';
        MW  <= '0';

        case current_state is

            -- INF: Instruction Fetch
            -- IR <- M[PC], MM=1, IL=1, PS=00 (hold), NS=EX0
            when INF =>
                next_state <= EX0;
                PS  <= "00";
                IL  <= '1';
                MM  <= '1';
                RW  <= '0';
                MW  <= '0';

            -- EX0: First execute cycle - decode opcode
            when EX0 =>
                case opcode is

                    -- MOVA: R[DR] <- R[SA]
                    when "0000000" =>
                        next_state <= INF;
                        PS  <= "01";  -- PC+1
                        DX  <= '0' & IR(8 downto 6);
                        AX  <= '0' & IR(5 downto 3);
                        BX  <= "0000";
                        MB  <= '0';
                        FS  <= "0000";  -- MOVA
                        MD  <= '0';
                        RW  <= '1';
                        MM  <= '0';
                        MW  <= '0';

                    -- INC: R[DR] <- R[SA] + 1
                    when "0000001" =>
                        next_state <= INF;
                        PS  <= "01";
                        DX  <= '0' & IR(8 downto 6);
                        AX  <= '0' & IR(5 downto 3);
                        BX  <= "0001";
                        MB  <= '0';
                        FS  <= "0001";  -- INC
                        MD  <= '0';
                        RW  <= '1';
                        MM  <= '0';
                        MW  <= '0';

                    -- ADD: R[DR] <- R[SA] + R[SB]
                    when "0000010" =>
                        next_state <= INF;
                        PS  <= "01";
                        DX  <= '0' & IR(8 downto 6);
                        AX  <= '0' & IR(5 downto 3);
                        BX  <= '0' & IR(2 downto 0);
                        MB  <= '0';
                        FS  <= "0010";  -- ADD
                        MD  <= '0';
                        RW  <= '1';
                        MM  <= '0';
                        MW  <= '0';

                    -- SUB: R[DR] <- R[SA] + R[SB] + 1
                    when "0000101" =>
                        next_state <= INF;
                        PS  <= "01";
                        DX  <= '0' & IR(8 downto 6);
                        AX  <= '0' & IR(5 downto 3);
                        BX  <= '0' & IR(2 downto 0);
                        MB  <= '0';
                        FS  <= "0101";  -- SUB
                        MD  <= '0';
                        RW  <= '1';
                        MM  <= '0';
                        MW  <= '0';

                    -- DEC: R[DR] <- R[SA] + (-1)
                    when "0000110" =>
                        next_state <= INF;
                        PS  <= "01";
                        DX  <= '0' & IR(8 downto 6);
                        AX  <= '0' & IR(5 downto 3);
                        BX  <= '0' & IR(2 downto 0);
                        MB  <= '0';
                        FS  <= "0110";  -- DEC
                        MD  <= '0';
                        RW  <= '1';
                        MM  <= '0';
                        MW  <= '0';

                    -- AND: R[DR] <- R[SA] AND R[SB]
                    when "0001001" =>
                        next_state <= INF;
                        PS  <= "01";
                        DX  <= '0' & IR(8 downto 6);
                        AX  <= '0' & IR(5 downto 3);
                        BX  <= '0' & IR(2 downto 0);
                        MB  <= '0';
                        FS  <= "1001";  -- AND
                        MD  <= '0';
                        RW  <= '1';
                        MM  <= '0';
                        MW  <= '0';

                    -- OR: R[DR] <- R[SA] OR R[SB]
                    when "0001000" =>
                        next_state <= INF;
                        PS  <= "01";
                        DX  <= '0' & IR(8 downto 6);
                        AX  <= '0' & IR(5 downto 3);
                        BX  <= '0' & IR(2 downto 0);
                        MB  <= '0';
                        FS  <= "1000";  -- OR
                        MD  <= '0';
                        RW  <= '1';
                        MM  <= '0';
                        MW  <= '0';

                    -- XOR: R[DR] <- R[SA] XOR R[SB]
                    when "0001010" =>
                        next_state <= INF;
                        PS  <= "01";
                        DX  <= '0' & IR(8 downto 6);
                        AX  <= '0' & IR(5 downto 3);
                        BX  <= '0' & IR(2 downto 0);
                        MB  <= '0';
                        FS  <= "1010";  -- XOR
                        MD  <= '0';
                        RW  <= '1';
                        MM  <= '0';
                        MW  <= '0';

                    -- NOT: R[DR] <- NOT R[SA]
                    when "0001011" =>
                        next_state <= INF;
                        PS  <= "01";
                        DX  <= '0' & IR(8 downto 6);
                        AX  <= '0' & IR(5 downto 3);
                        BX  <= '0' & IR(2 downto 0);
                        MB  <= '0';
                        FS  <= "1011";  -- NOT
                        MD  <= '0';
                        RW  <= '1';
                        MM  <= '0';
                        MW  <= '0';

                    -- MOVB: R[DR] <- R[SB]
                    when "0001100" =>
                        next_state <= INF;
                        PS  <= "01";
                        DX  <= '0' & IR(8 downto 6);
                        AX  <= '0' & IR(5 downto 3);
                        BX  <= '0' & IR(2 downto 0);
                        MB  <= '0';
                        FS  <= "1100";  -- MOVB
                        MD  <= '0';
                        RW  <= '1';
                        MM  <= '0';
                        MW  <= '0';

                    -- LD: R[DR] <- M[R[SA]]
                    when "0010000" =>
                        next_state <= INF;
                        PS  <= "01";
                        DX  <= '0' & IR(8 downto 6);
                        AX  <= '0' & IR(5 downto 3);
                        BX  <= "0000";
                        MB  <= '0';
                        FS  <= "0000";
                        MD  <= '1';
                        RW  <= '1';
                        MM  <= '0';
                        MW  <= '0';

                    -- ST: M[R[SA]] <- R[SB]
                    when "0100000" =>
                        next_state <= INF;
                        PS  <= "01";
                        DX  <= '0' & IR(8 downto 6);
                        AX  <= '0' & IR(5 downto 3);
                        BX  <= '0' & IR(2 downto 0);
                        MB  <= '0';
                        FS  <= "0000";
                        MD  <= '0';
                        RW  <= '0';
                        MM  <= '0';
                        MW  <= '1';

                    -- LDI: R[DR] <- zf OP
                    when "1001100" =>
                        next_state <= INF;
                        PS  <= "01";
                        DX  <= '0' & IR(8 downto 6);
                        AX  <= '0' & IR(5 downto 3);
                        BX  <= '0' & IR(2 downto 0);
                        MB  <= '1';
                        FS  <= "0000";  -- pass through B (MOVA on B side)
                        MD  <= '0';
                        RW  <= '1';
                        MM  <= '0';
                        MW  <= '0';

                    -- ADI: R[DR] <- R[SA] + zf OP
                    when "1000010" =>
                        next_state <= INF;
                        PS  <= "01";
                        DX  <= '0' & IR(8 downto 6);
                        AX  <= '0' & IR(5 downto 3);
                        BX  <= '0' & IR(2 downto 0);
                        MB  <= '1';
                        FS  <= "0010";  -- ADD
                        MD  <= '0';
                        RW  <= '1';
                        MM  <= '0';
                        MW  <= '0';

                    -- BRZ: if Z=1 then PC <- PC + se AD, else PC <- PC + 1
                    when "1100000" =>
                        next_state <= INF;
                        if Z = '1' then
                            PS <= "10";  -- Branch
                        else
                            PS <= "01";  -- Increment
                        end if;
                        DX  <= '0' & IR(8 downto 6);
                        AX  <= '0' & IR(5 downto 3);
                        BX  <= '0' & IR(2 downto 0);
                        MB  <= '0';
                        FS  <= "0000";
                        MD  <= '0';
                        RW  <= '0';
                        MM  <= '0';
                        MW  <= '0';

                    -- BRN: if N=1 then PC <- PC + se AD, else PC <- PC + 1
                    when "1100001" =>
                        next_state <= INF;
                        if N = '1' then
                            PS <= "10";  -- Branch
                        else
                            PS <= "01";  -- Increment
                        end if;
                        DX  <= '0' & IR(8 downto 6);
                        AX  <= '0' & IR(5 downto 3);
                        BX  <= '0' & IR(2 downto 0);
                        MB  <= '0';
                        FS  <= "0000";
                        MD  <= '0';
                        RW  <= '0';
                        MM  <= '0';
                        MW  <= '0';

                    -- JMP: PC <- R[SA]
                    when "1110000" =>
                        next_state <= INF;
                        PS  <= "11";  -- Jump
                        DX  <= '0' & IR(8 downto 6);
                        AX  <= '0' & IR(5 downto 3);
                        BX  <= '0' & IR(2 downto 0);
                        MB  <= '0';
                        FS  <= "0000";
                        MD  <= '0';
                        RW  <= '0';
                        MM  <= '0';
                        MW  <= '0';

                    -- LRI: R8 <- M[R[SA]], -> EX1
                    when "0010001" =>
                        next_state <= EX1;
                        PS  <= "00";
                        DX  <= "1000";  -- R8 (DX3=1, IR(8:6) = xxx -> overridden)
                        AX  <= '0' & IR(5 downto 3);
                        BX  <= '0' & IR(2 downto 0);
                        MB  <= '0';
                        FS  <= "0000";
                        MD  <= '1';
                        RW  <= '1';
                        MM  <= '0';
                        MW  <= '0';

                    -- SRM: R8 <- R[SA], Z check -> EX1
                    when "0001101" =>
                        next_state <= EX1;
                        PS  <= "01";
                        DX  <= "1000";  -- R8
                        AX  <= '0' & IR(5 downto 3);
                        BX  <= '0' & IR(2 downto 0);
                        MB  <= '0';
                        FS  <= "0000";  -- MOVA (pass R[SA])
                        MD  <= '0';
                        RW  <= '1';
                        MM  <= '0';
                        MW  <= '0';

                    -- SLM: R8 <- R[SA], Z check -> EX1
                    when "0001110" =>
                        next_state <= EX1;
                        PS  <= "01";
                        DX  <= "1000";  -- R8
                        AX  <= '0' & IR(5 downto 3);
                        BX  <= '0' & IR(2 downto 0);
                        MB  <= '0';
                        FS  <= "0000";  -- MOVA (pass R[SA])
                        MD  <= '0';
                        RW  <= '1';
                        MM  <= '0';
                        MW  <= '0';

                    when others =>
                        next_state <= INF;
                        PS <= "01";

                end case;

            -- EX1: Second execute cycle
            when EX1 =>
                case opcode is

                    -- LRI EX1: R[DR] <- M[R8], -> INF
                    when "0010001" =>
                        next_state <= INF;
                        PS  <= "01";
                        DX  <= '0' & IR(8 downto 6);
                        AX  <= "1000";  -- R8
                        BX  <= '0' & IR(2 downto 0);
                        MB  <= '0';
                        FS  <= "0000";
                        MD  <= '1';
                        RW  <= '1';
                        MM  <= '0';
                        MW  <= '0';

                    -- SRM EX1: R9 <- zf OP, Z check -> EX2 or INF
                    when "0001101" =>
                        if Z = '1' then
                            next_state <= INF;
                        else
                            next_state <= EX2;
                        end if;
                        PS  <= "00";
                        DX  <= "1001";  -- R9
                        AX  <= '0' & IR(5 downto 3);
                        BX  <= '0' & IR(2 downto 0);
                        MB  <= '1';
                        FS  <= "0000";  -- pass zf OP
                        MD  <= '0';
                        RW  <= '1';
                        MM  <= '0';
                        MW  <= '0';

                    -- SLM EX1: R9 <- zf OP, Z check -> EX2 or INF
                    when "0001110" =>
                        if Z = '1' then
                            next_state <= INF;
                        else
                            next_state <= EX2;
                        end if;
                        PS  <= "00";
                        DX  <= "1001";  -- R9
                        AX  <= '0' & IR(5 downto 3);
                        BX  <= '0' & IR(2 downto 0);
                        MB  <= '1';
                        FS  <= "0000";  -- pass zf OP
                        MD  <= '0';
                        RW  <= '1';
                        MM  <= '0';
                        MW  <= '0';

                    when others =>
                        next_state <= INF;

                end case;

            -- EX2: SRM/SLM shift operation
            when EX2 =>
                case opcode is

                    -- SRM EX2: R8 <- sr R8, -> EX3
                    when "0001101" =>
                        next_state <= EX3;
                        PS  <= "00";
                        DX  <= "1000";  -- R8
                        AX  <= "1000";  -- R8
                        BX  <= '0' & IR(2 downto 0);
                        MB  <= '0';
                        FS  <= "1110";  -- shift right
                        MD  <= '0';
                        RW  <= '1';
                        MM  <= '0';
                        MW  <= '0';

                    -- SLM EX2: R8 <- sl R8, -> EX3
                    when "0001110" =>
                        next_state <= EX3;
                        PS  <= "00";
                        DX  <= "1000";  -- R8
                        AX  <= "1000";  -- R8
                        BX  <= '0' & IR(2 downto 0);
                        MB  <= '0';
                        FS  <= "1100";  -- shift left
                        MD  <= '0';
                        RW  <= '1';
                        MM  <= '0';
                        MW  <= '0';

                    when others =>
                        next_state <= INF;

                end case;

            -- EX3: SRM/SLM decrement counter and check Z
            when EX3 =>
                case opcode is

                    -- SRM EX3: R9 <- R9 - 1, if Z -> EX4 else -> EX2
                    when "0001101" =>
                        if Z = '1' then
                            next_state <= EX4;
                        else
                            next_state <= EX2;
                        end if;
                        PS  <= "00";
                        DX  <= "1001";  -- R9
                        AX  <= "1001";  -- R9
                        BX  <= '0' & IR(2 downto 0);
                        MB  <= '0';
                        FS  <= "0110";  -- DEC
                        MD  <= '0';
                        RW  <= '1';
                        MM  <= '0';
                        MW  <= '0';

                    -- SLM EX3: R9 <- R9 - 1, if Z -> EX4 else -> EX2
                    when "0001110" =>
                        if Z = '1' then
                            next_state <= EX4;
                        else
                            next_state <= EX2;
                        end if;
                        PS  <= "00";
                        DX  <= "1001";  -- R9
                        AX  <= "1001";  -- R9
                        BX  <= '0' & IR(2 downto 0);
                        MB  <= '0';
                        FS  <= "0110";  -- DEC
                        MD  <= '0';
                        RW  <= '1';
                        MM  <= '0';
                        MW  <= '0';

                    when others =>
                        next_state <= INF;

                end case;

            -- EX4: SRM/SLM write result back to R[DR]
            when EX4 =>
                case opcode is

                    -- SRM EX4: R[DR] <- R8, -> INF
                    when "0001101" =>
                        next_state <= INF;
                        PS  <= "01";
                        DX  <= '0' & IR(8 downto 6);
                        AX  <= "1000";  -- R8
                        BX  <= '0' & IR(2 downto 0);
                        MB  <= '0';
                        FS  <= "0000";  -- MOVA (pass R8)
                        MD  <= '0';
                        RW  <= '1';
                        MM  <= '0';
                        MW  <= '0';

                    -- SLM EX4: R[DR] <- R8, -> INF
                    when "0001110" =>
                        next_state <= INF;
                        PS  <= "01";
                        DX  <= '0' & IR(8 downto 6);
                        AX  <= "1000";  -- R8
                        BX  <= '0' & IR(2 downto 0);
                        MB  <= '0';
                        FS  <= "0000";  -- MOVA (pass R8)
                        MD  <= '0';
                        RW  <= '1';
                        MM  <= '0';
                        MW  <= '0';

                    when others =>
                        next_state <= INF;

                end case;

        end case;
    end process;

end IDC_Behavorial;
