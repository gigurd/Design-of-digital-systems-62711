library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MicroprogramController is
    port (
        RESET              : in  std_logic;
        CLK                : in  std_logic;
        Address_In         : in  std_logic_vector(7 downto 0);
        Address_Out        : out std_logic_vector(7 downto 0);
        Instruction_In     : in  std_logic_vector(15 downto 0);
        Constant_Out       : out std_logic_vector(7 downto 0);
        V, C, N, Z         : in  std_logic;
        DX, AX, BX, FS    : out std_logic_vector(3 downto 0);
        MB, MD, RW, MM, MW : out std_logic
    );
end MicroprogramController;

architecture MCU_Behavorial of MicroprogramController is

    signal IR_int      : std_logic_vector(15 downto 0);
    signal IL_int      : std_logic;
    signal PS_int      : std_logic_vector(1 downto 0);
    signal Offset_int  : std_logic_vector(7 downto 0);
    signal ZF_int      : std_logic_vector(7 downto 0);

begin

    -- (1) Program Counter
    PC: entity work.ProgramCounter
        port map (
            RESET      => RESET,
            CLK        => CLK,
            Address_In => Address_In,
            PS         => PS_int,
            Offset     => Offset_int,
            PC         => Address_Out
        );

    -- (2) Instruction Register
    IR_inst: entity work.InstructionRegister
        port map (
            RESET          => RESET,
            CLK            => CLK,
            Instruction_In => Instruction_In,
            IL             => IL_int,
            IR             => IR_int
        );

    -- (3) Sign Extender
    SE: entity work.SignExtender
        port map (
            IR         => IR_int,
            Extended_8 => Offset_int
        );

    -- (4) Zero Filler
    ZF: entity work.ZeroFiller
        port map (
            IR           => IR_int,
            ZeroFilled_8 => ZF_int
        );

    -- (5) Instruction Decoder Controller
    IDC: entity work.InstructionDecoderController
        port map (
            RESET => RESET,
            CLK   => CLK,
            IR    => IR_int,
            V     => V,
            C     => C,
            N     => N,
            Z     => Z,
            PS    => PS_int,
            IL    => IL_int,
            DX    => DX,
            AX    => AX,
            BX    => BX,
            FS    => FS,
            MB    => MB,
            MD    => MD,
            RW    => RW,
            MM    => MM,
            MW    => MW
        );

    -- Constant output from Zero Filler
    Constant_Out <= ZF_int;

end MCU_Behavorial;
