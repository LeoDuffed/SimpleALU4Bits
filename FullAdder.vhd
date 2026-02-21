-- Leonardo Martínez Peña

library ieee;
use ieee.std_logic_1164.all;

entity FullAdder is
    port(A, B, Cin: in std_logic;
        Co, S: out std_logic);
end FullAdder;

architecture behavior of FullAdder is
    component HalfAdder is
        port(A,B: in std_logic;
            S, Co: out std_logic);
    end component;

    signal  S1, C1, C2: std_logic;

begin
    I0: HalfAdder port map (A=>A, B=>B,S=>S1, Co=>C1);
    I1: HalfAdder port map (A=>S1, B=>Cin, S=>S, Co=>C2);
    Co <= C1 or C2;
    
end behavior;