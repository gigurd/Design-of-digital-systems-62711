library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Top-level Microprocessor: Datapath + Microprogram Controller + RAM + Port Register + MUX MR
-- This is the core system (excluding the board-level TOP_MODUL wrapper)
entity Microprocessor is
    port (
        CLK      : in  STD_LOGIC;
        RESET    : in  STD_LOGIC;
        -- Board peripherals (exposed through Port Register)
        SW       : in  STD_LOGIC_VECTOR(7 downto 0);
        BTNC     : in  STD_LOGIC;
        BTNU     : in  STD_LOGIC;
        BTNL     : in  STD_LOGIC;
        BTNR     : in  STD_LOGIC;
        BTND     : in  STD_LOGIC;
        LED      : out STD_LOGIC_VECTOR(7 downto 0);
        D_Word   : out STD_LOGIC_VECTOR(15 downto 0)  -- drives 7-seg via TOP_MODUL_F
    );
end Microprocessor;

architecture MP_Structural of Microprocessor is

    -- Control signals from MPC to Datapath
    signal DX_sig, AX_sig, BX_sig, FS_sig : STD_LOGIC_VECTOR(3 downto 0);
    signal MB_sig, MD_sig, RW_sig         : STD_LOGIC;
    signal MM_sig, MW_sig                 : STD_LOGIC;

    -- MPC <-> Datapath data/address
    signal Address_Out_DP  : STD_LOGIC_VECTOR(7 downto 0);  -- from Datapath
    signal Address_Out_PC  : STD_LOGIC_VECTOR(7 downto 0);  -- from MPC (PC)
    signal Data_Out_DP     : STD_LOGIC_VECTOR(7 downto 0);  -- from Datapath to memory
    signal Constant_Out    : STD_LOGIC_VECTOR(7 downto 0);  -- from MPC (ZeroFiller)

    -- Status flags
    signal V_sig, C_sig, N_sig, Z_sig : STD_LOGIC;

    -- MUX M: selects between Datapath address (MM=0) and PC (MM=1)
    signal Mem_Address : STD_LOGIC_VECTOR(7 downto 0);

    -- RAM and PortReg outputs
    signal Data_outM    : STD_LOGIC_VECTOR(15 downto 0);
    signal Data_outR    : STD_LOGIC_VECTOR(15 downto 0);
    signal MMR_sig      : STD_LOGIC;

    -- MUX MR output (goes to Datapath DataIn and MPC Instruction_In)
    signal Data_Bus_Out : STD_LOGIC_VECTOR(15 downto 0);

    -- Zero-filled 16-bit Data_In for RAM (from Datapath's 8-bit output)
    signal Data_In_RAM  : STD_LOGIC_VECTOR(15 downto 0);

begin

    -- TODO: MUX M (Mem_Address selector)
    -- TODO: Zero fill Data_Out_DP to 16 bits for RAM
    -- TODO: Instantiate Datapath (from PWA)
    -- TODO: Instantiate MicroprogramController (from PWB)
    -- TODO: Instantiate Ram256x16
    -- TODO: Instantiate PortReg8x8
    -- TODO: Instantiate MUX_MR
    -- TODO: Wire Data_Bus_Out to MPC Instruction_In and Datapath DataIn

end MP_Structural;
