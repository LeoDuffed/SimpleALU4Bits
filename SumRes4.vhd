-- Leonardo Martínez Peña

library ieee;
use ieee.std_logic_1164.all;

entity SumRes4 is
    port( 
        A,B: in std_logic_vector(3 downto 0);
		M: in std_logic;
        S: out std_logic_vector(3 downto 0);
        Co: out std_logic
    );
end SumRes4;

architecture behavior of SumRes4 is

    component FullAdder is
        port( 
            A,B, Cin: in std_logic;
            S, Co: out std_logic
        );
    end component;

    signal C: std_logic_vector(4 downto 0);
	signal xorB: std_logic_vector(3 downto 0);

    begin

        C(0) <= M;
	 
		xorB(0) <= B(0) xor M; 
		xorB(1) <= B(1) xor M;
		xorB(2) <= B(2) xor M;
		xorB(3) <= B(3) xor M;

        FA0: FullAdder port map(A=>A(0), B=>xorB(0), Cin=>C(0), S=>S(0), Co=>C(1));
        FA1: FullAdder port map(A=>A(1), B=>xorB(1), Cin=>C(1), S=>S(1), Co=>C(2));
        FA2: FullAdder port map(A=>A(2), B=>xorB(2), Cin=>C(2), S=>S(2), Co=>C(3));
        FA3: FullAdder port map(A=>A(3), B=>xorB(3), Cin=>C(3), S=>S(3), Co=>C(4));

        Co <= C(4);
end behavior;