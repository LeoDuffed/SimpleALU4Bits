-- Leonardo Martínez Peña

library ieee;
use ieee.std_logic_1164.all;

entity ALU is
	port(
		A,B: in std_logic_vector(3 downto 0);
		S: in std_logic_vector(2 downto 0);
		F: out std_logic_vector(3 downto 0);
		Co: out std_logic
	);
end ALU;

architecture behavior of ALU is
	component SumRes is
		port(
			A,B: in std_logic_vector(3 downto 0);
			M: in std_logic;
			S: out std_logic_vector(3 downto 0);
			Co: out std_logic
		);
	end component;

	signal BminusA: std_logic_vector(3 downto 0); -- Resultado de 4 bits
	signal AminusB: std_logic_vector(3 downto 0); -- Resultado de 4 bits
	signal AplusB: std_logic_vector(3 downto 0); -- Resultado de 4 bits
	signal AxorB: std_logic_vector(3 downto 0); -- Resultado de 4 bits
	signal AorB: std_logic_vector(3 downto 0); -- Resultado de 4 bits
	signal AandB: std_logic_vector(3 downto 0); -- Resultado de 4 bits
	signal CarryRestUno, CarryRestDos, CarrySum: std_logic;

begin
	RestUno: SumRes port map(A=>B, B=>A, M=>'1', S=>BminusA, Co=>CarryRestUno); -- Resta uno B - A -> (M = 1)
	RestDos: SumRes port map(B=>B, A=>A, M=>'1', S=>AminusB, Co=>CarryRestDos); -- Resta dos A - B -> (M = 1)
	SumaUno: SumRes port map(A=>A, B=>B, M=>'0', S=>AplusB, Co=>CarrySum); -- Suma A + B -> (M = 0)
	AxorB <= A xor B;
	AorB <= A or B;
	AandB <= A and B;

	with S select -- "MUX" de 8 a 1
		F <= "0000" when "000",
			BminusA when "001",
			AminusB when "010",
			AplusB when "011",
			AxorB when "100",
			AorB when "101",
			AandB when "110",
			"1111" when "111",
			"0000" when others;

	with S select
		Co <= CarryRestUno when "001",
			CarryRestDos when "010",
			CarrySum when "011",
			'0' when others;

end behavior;