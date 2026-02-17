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

    signal C: std_logic_vector(2 downto 0);

begin
    I0: HalfAdder port map (A,B,C(2), C(1));
    I1: HalfAdder port map (C(2), Cin, S, C(0));
    Co <= C(1) or C(2);
end behavior;