library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Disp is
    Port ( 
        A, B : in STD_LOGIC_VECTOR (3 downto 0);
        S : in STD_LOGIC_VECTOR (2 downto 0);
        seg_decenas : out STD_LOGIC_VECTOR (6 downto 0);
        seg_unidades : out STD_LOGIC_VECTOR (6 downto 0);
        Co : out STD_LOGIC
    );
end Disp;

architecture behavior of Disp is
    -- Declarar ALU
    component ALU is
        port(
            A, B: in std_logic_vector(3 downto 0);
            S: in std_logic_vector(2 downto 0);
            F: out std_logic_vector(3 downto 0);
            Co: out std_logic
        );
    end component;
    
    -- Declarar conversor
    component Bin2Disp is
        Port ( 
            F : in STD_LOGIC_VECTOR (3 downto 0);
            seg_decenas : out STD_LOGIC_VECTOR (6 downto 0);
            seg_unidades : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component;
    
    -- Señal que conecta ALU con el display
    signal F_interno : STD_LOGIC_VECTOR(3 downto 0);
    signal Co_interno : STD_LOGIC;
    
begin
    -- Instanciar ALU
    U_ALU: ALU port map(
        A => A,
        B => B,
        S => S,
        F => F_interno,
        Co => Co_interno
    );
    
    -- Instanciar conversor, recibe F de la ALU
    U_Display: Bin2Disp port map(
        F => F_interno,
        seg_decenas => seg_decenas,
        seg_unidades => seg_unidades
    );
    
    Co <= Co_interno;
    
end behavior;
