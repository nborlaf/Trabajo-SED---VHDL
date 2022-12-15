----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2022 18:27:50
-- Design Name: 
-- Module Name: FSM - Behavioral
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
use ieee.numeric_std.all;

entity FSM is
    Port ( CUENTA : in STD_LOGIC_VECTOR (3 downto 0);   -- Entrada para la cuenta del dinero introducido en la máquina 
           PRODUCTO : in STD_LOGIC_VECTOR (3 downto 0); -- Entrada para la selección del producto deseado
           CLK : in STD_LOGIC;                          -- Entrada para la señal de reloj
           RESET : in STD_LOGIC;                        -- Entrada para la señal de reset
           LED : out STD_LOGIC_VECTOR (3 downto 0);     -- Salida para el control de los LED asignados a los productos
           VENTA : out STD_LOGIC;                       -- Salida del bit de venta
           ERROR : out STD_LOGIC                        -- Salida del bit de bit de error 
           
           );
end FSM;

architecture Structural of FSM is

--COMPONENTES DE LA FSM
component FSM_PRIN port(
           CLK : in STD_LOGIC;     
           RESET : in STD_LOGIC;   
           CUENTA : in STD_LOGIC_VECTOR (3 downto 0);   
           PRODUCTO : in STD_LOGIC_VECTOR (3 downto 0); 
           DONE : in STD_LOGIC;      
           ERROR : out STD_LOGIC;    
           CONT : out STD_LOGIC;    
           VENTA : out STD_LOGIC;  
           LED : out STD_LOGIC_VECTOR (3 downto 0);  
           DELAY : out unsigned(29 downto 0)
           );
end component;

component FSM_SEC port(
           CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           CONT : in STD_LOGIC;
           DELAY : in UNSIGNED (29 downto 0);
           DONE : out STD_LOGIC
           );
end component;

component EDGEDTCTR port(
           CLK : in std_logic;
           sync_in : in std_logic;
           edge : out std_logic;
           reset: in std_logic
            );
end component;

signal done, cont : std_logic;        -- Señal para los bit de fin e inicio del temporizador
signal delay : unsigned(29 downto 0);  -- Tiempo que se carga en el temporizador
signal cont_edge : std_logic;         -- Señal para el flanco en el bit de inicio del temporizador
signal edge_in : std_logic;            -- Señal para la entrada del detector de flanco

begin
   edge_in<=not cont;  -- El detector de flancos lee flancos negativos, por lo que si queremos flancos ascendentes habrá que negar la señal
    Inst_FSM_PRIN: FSM_PRIN port map(
                           CLK=>CLK,
                           RESET=>RESET,
                           CUENTA=>CUENTA,
                           PRODUCTO=>PRODUCTO,
                           DONE=>done,
                           ERROR=>ERROR,
                           CONT=>cont,
                           VENTA=>VENTA,
                           LED=>LED,
                           DELAY=>delay);
                           
     Inst_FSM_SEC: FSM_SEC port map(
                            CLK=>CLK,
                            RESET=>RESET,
                            CONT=>cont_edge,
                            DELAY=>delay, 
                            DONE=>done
                            );
                            
     Inst_EDGEDTCTR_FSM: EDGEDTCTR port map(
                            CLK=>CLK,
                            reset=>RESET,
                            sync_in=>edge_in,
                            edge=>cont_edge
                            );
    
end Structural;
