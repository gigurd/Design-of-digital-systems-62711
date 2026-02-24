----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Kun Jonas Beck Jensen og ingen andre, kun ham, han er så smuk og dygtig og klog
-- 
-- Create Date: 24.02.2026 20:51:20
-- Design Name: 
-- Module Name: full_adder_8_bit - Structural
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity full_adder_8_bit is
    Port ( A : in STD_LOGIC_VECTOR (7 downto 0);
           B : in STD_LOGIC_VECTOR (7 downto 0);
           sum : out STD_LOGIC_VECTOR (7 downto 0);
           Cin : in STD_LOGIC_VECTOR (7 downto 0);
           Cout : out STD_LOGIC (7 downto 0)
           );
end full_adder_8_bit;

architecture Structural of full_adder_8_bit is
    
    signal carry : STD_LOGIC_VECTOR(8 downto 0);
    begin

    carry(0) <= Cin;
    bit_0: entity work.full_adder_1_bit
    port map(
        A => A(0),
        B => B(0),
        Cin => Cin, 
        res => sum(0),
        Co => Cout

    ); 

bit_1: entity work.full_adder_1_bit
    port map(
        A => A(1),
        B => B(1),
        Cin => Co(0), 
        res => sum(0),
        Co => Cout
        
    );    
bit_2: entity work.full_adder_1_bit
    port map(
        A => A(2),
        B => B(2),
        Cin => , 
        res => sum(2),
        Co => Cout
        
    );
bit_3: entity work.full_adder_1_bit
    port map(
        A => A(3),
        B => B(3),
        Cin => Co(2), 
        res => sum(3),
        Co => Cout
        
    );
bit_4: entity work.full_adder_1_bit
    port map(
        A => A(4),
        B => B(4),
        Ci => Co(3), 
        res => sum(4),
        Co => Cout
    );
bit_5: entity work.full_adder_1_bit
    port map(
        A => A(5),
        B => B(5),
        Ci => Co(4), 
        res => sum(5),
        Co => Cout
    );

bit_6: entity work.full_adder_1_bit
    port map(
        A => A(6),
        B => B(6),
        Cin => Co(5), 
        res => sum(6),
        Co => Cout
    );    
bit_7: entity work.full_adder_1_bit
    port map(
        A => A(7),
        B => B(7),
        Cin => Co(6), 
        res => sum(7),
        Co => Cout
    );FA0: full_adder port map(A(0), B(0), carry(0), Sum(0), carry(1));
end Structural; 
