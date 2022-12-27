----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2022 11:58:12
-- Design Name: 
-- Module Name: TOP - Behavioral
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


entity TOP is
PORT(
boton_diez_cent : in STD_LOGIC;     -- Entrada para la señal de 10 cents 
boton_veinte_cent : in STD_LOGIC;  -- Entrada para la señal de 20 cents 
boton_cincuenta_cent : in STD_LOGIC;   -- Entrada para la señal de 50 cents 
boton_un_euro : in STD_LOGIC;     -- Entrada para la señal de 1 euro
clk: IN std_logic; -- Señal de reloj 
reset: IN std_logic; -- Señal de RESET 
producto: in std_logic_vector(3 downto 0);   -- Entrada para los switches que servirán para seleccionar el producto deseado
led : out std_logic_vector(3 downto 0);      -- Salida para encender los LEDs de cada producto
digsel : out std_logic_vector(7 downto 0);   -- Salida para la activación de cada uno de los displays de la placa 
segmentos : out std_logic_vector(7 downto 0) -- Salida para la activación de cada uno de los segmentos los display de la placa
);
end TOP;


architecture Behavioral of TOP is

--Señales intermedias de los sincronizadores
signal sync_media: std_logic_vector(3 downto 0);
--Señales para las salidas de los debouncers
signal deb_media: std_logic_vector(3 downto 0);
--Señales para las salidas de los detectores de flanco
signal sal_edge: std_logic_vector(3 downto 0);
--Señal para el bit de error de la FSM
signal error: std_logic;
--Señal para el bit de venta de la FSM
signal venta: std_logic;
--Señal para llevar la cuenta del dinero del contador
signal cuenta: std_logic_vector (3 downto 0);
--Señal para agrupar las entradas del dinero en un vector 
signal monedas: std_logic_vector(3 downto 0);
--COMPONENTES DE LA ENTIDAD
COMPONENT Sincro
PORT (
    CLK : in std_logic;
    sincro_in : in std_logic;
    sincro_out : out std_logic;
    reset: in std_logic
    );
END COMPONENT;

COMPONENT DEBOUNCER
PORT (
    CLK	    : in std_logic;
    btn_in	: in std_logic;
    btn_out	: out std_logic;
    reset: in std_logic
    );
END COMPONENT;

COMPONENT EDGEDTCTR
PORT (
    CLK : in std_logic;
    sync_in : in std_logic;
    edge : out std_logic;
    reset: in std_logic
    );
END COMPONENT;

COMPONENT CONTADOR
PORT (
    CLK : in STD_LOGIC;
    diez_cent : in STD_LOGIC;
    veinte_cent : in STD_LOGIC;
    cincuenta_cent : in STD_LOGIC;
    un_euro : in STD_LOGIC;
    RESET : in STD_LOGIC;
    ERROR : in STD_LOGIC;
    VENTA : in STD_LOGIC;
    CUENTA : out STD_LOGIC_VECTOR (3 downto 0)
    );
END COMPONENT;

COMPONENT FSM
PORT (
    CUENTA : in STD_LOGIC_VECTOR (3 downto 0);
    PRODUCTO : in STD_LOGIC_VECTOR (3 downto 0);
    CLK : in STD_LOGIC;
    RESET : in STD_LOGIC;
    LED : out STD_LOGIC_VECTOR (3 downto 0);
    VENTA : out STD_LOGIC;
    ERROR : out STD_LOGIC
    );
END COMPONENT;

COMPONENT DISPLAY port(
    cuenta : IN std_logic_vector(3 DOWNTO 0);
    clk: IN std_logic;
    error: IN std_logic;
    venta: IN std_logic;
    digsel : OUT std_logic_vector(7 DOWNTO 0);
    segmentos : OUT std_logic_vector(7 DOWNTO 0)
    );
END COMPONENT;

begin
--ASIGNACIÓN DE LOS BOTONES DE MONEDAS A CADA POSICIÓN DEL VECTOR
monedas(0)<=boton_diez_cent;
monedas(1)<=boton_veinte_cent;
monedas(2)<=boton_cincuenta_cent;
monedas(3)<=boton_un_euro;

--INSTANCIACIÓN DE LAS ENTIDADES Sincro, DEBOUNCER Y EDGEDTCTR PARA EL ACONDICIONAMIENTO
--DE LA SEÑAL PROCEDENTE DE LOS PULSADORES
acondicionamiento_botones: for i in 0 to 3 generate
inst_sincro: Sincro port map(
                            clk=>clk,
                            sincro_in=>monedas(i),
                            sincro_out=>sync_media(i),
                            reset=>reset);
                            
inst_debouncer: DEBOUNCER port map(
                            CLK=>clk,
                            btn_in=>sync_media(i),
                            btn_out=>deb_media(i),
                            reset=>reset);
                            
inst_edgedtctr: EDGEDTCTR port map(
                            CLK=>clk,
                            sync_in=>deb_media(i),
                            edge=>sal_edge(i),
                            reset=>reset);
end generate acondicionamiento_botones;

--CONTADOR
Inst_CONTADOR: CONTADOR PORT MAP(
CLK=>clk,
diez_cent=>sal_edge(0),
veinte_cent=>sal_edge(1),
cincuenta_cent=>sal_edge(2),
un_euro=>sal_edge(3),
RESET=>reset,
ERROR=>error,
venta=>venta,
CUENTA=>cuenta
);

--MÁQUINA DE ESTADOS
Inst_FSM: FSM PORT MAP(
CUENTA=>cuenta,
PRODUCTO=>producto,
CLK=>clk,
RESET=>reset,
LED=>led,
VENTA=>venta,
ERROR=>error 
);

--CONTROL DE LOS DISPLAYS
Inst_DISPLAY: DISPLAY port map(
clk=>clk,
error=>error,
venta=>venta,
digsel=>digsel,
segmentos=>segmentos,
cuenta=> cuenta
);

end Behavioral;