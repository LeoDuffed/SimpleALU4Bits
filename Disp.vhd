-- Leonardo Martínez Peña

library ieee;
use ieee.std_logic_1164.all;

entity Disp is 
    port(
        Cin:in std_logic_vector(9 downto 0); -- switches
        button:in std_logic; -- boton 
        Cout: out std_logic_vector(9 downto 0); -- leds
        HEX0:out std_logic_vector(6 downto 0); -- 7 seg 1 (unidades)
        HEX1:out std_logic_vector(6 downto 0); -- 7 seg 2 (decenas)
        HEX2:out std_logic_vector(6 downto 0) -- 7 seg 3 (signo "-")
    );
end entity;

architecture behavior of Disp is
    
    component ALU is
        port(
            A, B:in std_logic_vector(3 downto 0);
            S:in std_logic_vector(2 downto 0);
            F:out std_logic_vector(3 downto 0);
            Co:out std_logic
        );
    end component;

    component FullAdder is
        port(
            A,B,Cin:in std_logic;
            S,Co:out std_logic
        );
    end component;

    component SumRes is
        port(
            A,B:in std_logic_vector(4 downto 0);
            M:in std_logic;
            S:out std_logic_vector(4 downto 0);
            Co:out std_logic
        );
    end component;

    component SegBCD is
        port(
            bcd:in std_logic_vector(3 downto 0);
            seg:out std_logic_vector(6 downto 0)
        );
    end component;

    signal A,B : std_logic_vector(3 downto 0);
    signal S : std_logic_vector(2 downto 0);
    signal F : std_logic_vector(3 downto 0);
    signal Co : std_logic;
    signal is_sum, is_res, op_disp : std_logic;
    -- Para la resta
    signal newF : std_logic_vector(3 downto 0); -- resultado final 
    signal is_neg : std_logic;
    signal notF : std_logic_vector(3 downto 0);
    signal Co_abs : std_logic_vector(4 downto 0);
    signal absF : std_logic_vector(3 downto 0);

    signal V : std_logic_vector(4 downto 0) -- necesitamos 5 bits para una suma como 15 + 15

    -- señales comparativas para pasar a decimal
    signal V10, V20, V30 : std_logic_vector(4 downto 0);
    signal C10, C20, C30 : std_logic;

    signal dec : std_logic_vector(3 downto 0);
    signal uni : std_logic_vector(3 downto 0);

    signal seg0, seg1 : std_logic_vector(6 downto 0);

begin

    A <= Cin(3 downto 0);
    B <= Cin(7 downto 4);
    S(2) <= not button;
    S(1) <= Cin(9);
    S(0) <= Cin(8);

    Inp: ALU port map(A=>A, B=>B, S=>S, F=>F, Co=>Co);
    Cout(3 downto 0) <= F;
    Cout(9) <= Co;
    Cout(8 downto 4) <= (others => '0');

    -- si es suma o resta usamos los displays, si no no xd
    is_sum <= '1' when (S = "011") else '0';
    is_res <= '1' when (S = "001" or S = "010") else '0';
    op_disp <= '1' when (is_sum = '1' or is_res = '1') else '0';
    is_neg <= '1' when (is_res = '1' and Co = '0') else '0';

    -- quitar el complemento a dos (siempre valor absoluto)
    notF <= not F;
    Co_abs(0) <= '1';
    F0: FullAdder port map(A=>notF(0), B=>'0', Cin=>Co_abs(0), S=>absF(0), Co=>Co_abs(1));
    F1: FullAdder port map(A=>notF(1), B=>'0', Cin=>Co_abs(1), S=>absF(1), Co=>Co_abs(2));
    F2: FullAdder port map(A=>notF(2), B=>'0', Cin=>Co_abs(2), S=>absF(2), Co=>Co_abs(3));
    F3: FullAdder port map(A=>notF(3), B=>'0', Cin=>Co_abs(3), S=>absF(3), Co=>Co_abs(4));
    newF <= absF when (is_neg = '1') else F;

    -- valor final (5 bits)
    -- suma => V = Co + F
    -- resta => V = 0 + absF
    V <= (Co & F) when (is_sum = '1') else ('0' & newF);
    R10: SumRes port map(A=>V, B=>"01010", M=>'1', S=>V10, Co=>C10); -- V - 10
    R20: SumRes port map(A=>V, B=>"10100", M=>'1', S=>V20, Co=>C20); -- V - 20
    R30: SumRes port map(A=>V, B=>"11110", M=>'1', S=>V30, Co=>C30); -- V - 30
    -- si Co = 1 => A > B
    -- si Co = 0 => A < B
    process(V, V10, V20, V30, C10, C20, C30)
    begin -- valor en las decenas
        if C30 = '1' then
            dec <= "0011";
            uni <= V30(3 downto 0);
        elsif C20 = '1' then
            dec <= "0010";
            uni <= V20(3 downto 0);
        elsif C10 = '1' then
            dec <= "0001";
            uni <= V10(3 downto 0);
        else 
            dec <= "0000";
            uni <= V(3 downto 0);
        end if;
    end process;

    -- decodificacion a 7 segmentos
    S0: SegBCD port map(bcd=>uni, seg=>seg0);
    S1: SegBCD port map(bcd=>dec, seg=>seg1);
    process(op_disp, seg0, seg1, dec, is_neg, is_res)
    begin
        HEX0 <= "1111111";
        HEX1 <= "1111111";
        HEX2 <= "1111111";
        if op_disp = '1' then
            HEX0 <= seg0;

            if dec = "0000" then
                HEX1 <= "1111111";
            else
                HEX1 <= seg1;
            end if;

            if (is_res = '1' and is_neg = '1') then
                HEX2 <= "0111111";
            else 
                HEX2 <= "1111111";
            end if;
        
        end if;
    
    end process;

end architecture;