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

    -- Internal signals
    signal IR_sig : std_logic_vector(15 downto 0);
    signal PS_sig : std_logic_vector(1 downto 0);
    signal IL_sig : std_logic;
    signal SE_out : std_logic_vector(7 downto 0);
    signal ZF_out : std_logic_vector(7 downto 0);

    -- Component declarations
    component ProgramCounter is
        port (
            RESET      : in  std_logic;
            CLK        : in  std_logic;
            Address_In : in  std_logic_vector(7 downto 0);
            PS         : in  std_logic_vector(1 downto 0);
            Offset     : in  std_logic_vector(7 downto 0);
            PC         : out std_logic_vector(7 downto 0)
        );
    end component;

    component InstructionRegister is
        port (
            RESET          : in  std_logic;
            CLK            : in  std_logic;
            Instruction_In : in  std_logic_vector(15 downto 0);
            IL             : in  std_logic;
            IR             : out std_logic_vector(15 downto 0)
        );
    end component;

    component SignExtender is
        port (
            IR         : in  std_logic_vector(15 downto 0);
            Extended_8 : out std_logic_vector(7 downto 0)
        );
    end component;

    component ZeroFiller is
        port (
            IR           : in  std_logic_vector(15 downto 0);
            ZeroFilled_8 : out std_logic_vector(7 downto 0)
        );
    end component;

    component InstructionDecoderController is
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
    end component;

begin

    -- (1) Program Counter
    PC_inst: ProgramCounter port map (
        RESET      => RESET,
        CLK        => CLK,
        Address_In => Address_In,
        PS         => PS_sig,
        Offset     => SE_out,
        PC         => Address_Out
    );

    -- (2) Instruction Register
    IR_inst: InstructionRegister port map (
        RESET          => RESET,
        CLK            => CLK,
        Instruction_In => Instruction_In,
        IL             => IL_sig,
        IR             => IR_sig
    );

    -- Sign Extender
    SE_inst: SignExtender port map (
        IR         => IR_sig,
        Extended_8 => SE_out
    );

    -- Zero Filler
    ZF_inst: ZeroFiller port map (
        IR           => IR_sig,
        ZeroFilled_8 => ZF_out
    );

    -- (3) Instruction Decoder / Controller
    IDC_inst: InstructionDecoderController port map (
        RESET => RESET,
        CLK   => CLK,
        IR    => IR_sig,
        V     => V,
        C     => C,
        N     => N,
        Z     => Z,
        PS    => PS_sig,
        IL    => IL_sig,
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

    -- Wire ZeroFiller output to top-level Constant_Out
    Constant_Out <= ZF_out;

end MCU_Behavorial;
