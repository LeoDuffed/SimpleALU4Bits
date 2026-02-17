library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Bin2Disp is
    Port ( 
        F : in STD_LOGIC_VECTOR (3 downto 0);           -- Recibe la salida de la ALU
        seg_decenas : out STD_LOGIC_VECTOR (6 downto 0); -- Display izquierdo
        seg_unidades : out STD_LOGIC_VECTOR (6 downto 0) -- Display derecho
    );
end Bin2Disp;

architecture behavior of Bin2Disp is
    signal numero : integer range 0 to 29;
    signal decenas : integer range 0 to 3;
    signal unidades : integer range 0 to 9;
begin
    -- Convertir binario a entero
    numero <= to_integer(unsigned(F));
    
    -- Separar en decenas y unidades
    decenas <= numero / 10;    -- 15/10 = 1
    unidades <= numero mod 10; -- 15 mod 10 = 5
    
    with decenas select
        seg_decenas <= "0000001" when 0,  -- 0
							"1001111" when 1,  -- 1
							"0010010" when 2,  -- 2
							"0000110" when 3,  -- 3
							"1111111" when others;

    with unidades select
        seg_unidades <= "0000001" when 0,  -- 0
                        "1001111" when 1,  -- 1
                        "0010010" when 2,  -- 2
                        "0000110" when 3,  -- 3
                        "1001100" when 4,  -- 4
                        "0100100" when 5,  -- 5
                        "0100000" when 6,  -- 6
                        "0001111" when 7,  -- 7
                        "0000000" when 8,  -- 8
                        "0000100" when 9,  -- 9
                        "1111111" when others;
end behavior;

-- Mapa 7 segmentos
-- seg(6) = a
-- seg(5) = b
-- seg(4) = c
-- seg(3) = d
-- seg(2) = e
-- seg(1) = f
-- seg(0) = g