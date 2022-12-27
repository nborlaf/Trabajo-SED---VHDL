----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2022 18:01:47
-- Design Name: 
-- Module Name: FSM_PRIN - Behavioral
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

entity FSM_PRIN is
    Port ( CLK : in STD_LOGIC;     -- Entrada para la señal de reloj 
           RESET : in STD_LOGIC;   -- Entrada para la señal de RESET 
           CUENTA : in STD_LOGIC_VECTOR (3 downto 0);   -- Entrada para la cuenta del dinero introducido en la máquina
           PRODUCTO : in STD_LOGIC_VECTOR (3 downto 0); -- Entrada para la selección del producto deseado 
           DONE : in STD_LOGIC;      -- Señal del bit de fin de la cuenta del temporizador 
           ERROR : out STD_LOGIC;    -- Salida del bit de error de la máquina 
           CONT : out STD_LOGIC;    -- Salida del bit de inicio del temporizador
           VENTA : out STD_LOGIC;  -- Salida del bit del estado vendiendo de la máquina
           LED : out STD_LOGIC_VECTOR (3 downto 0);  -- Salida para el control de los LEDs asociados a los productos de la máquina
           DELAY : out unsigned(29 downto 0)); -- Tiempo que se cargará en el temporizador
end FSM_PRIN;

architecture Behavioral of FSM_PRIN is

type STATE is (
    S0, --ESTADO DE REPOSO
    S1, --PRODUCTO 1 SELECCIONADO
    S2, --PRODUCTO 2 SELECCIONADO
    S3, --PRODUCTO 3 SELECCIONADO
    S4, --PRODUCTO 4 SELECCIONADO
    S5, --VENDIENDO PRODUCTO 1
    S6, --VENDIENDO PRODUCTO 2
    S7, --VENDIENDO PRODUCTO 3
    S8, --VENDIENDO PRODUCTO 4
    S9  --ESTADO DE ERROR
    );
signal next_state : STATE;         -- Estado siguiente
signal present_state : STATE:=S0;  -- Estado actual

constant DURACION_ERROR : positive :=400000000; --DURACIÓN DE ESPERA TRAS ESTADO DE ERROR EN CICLOS DE RELOJ
constant DURACION_VENTA: positive :=600000000; --DURACIÓN DE ESPERA TRAS VENTA

begin

    ACTUALIZACION_DE_ESTADO: process(CLK,RESET)
    begin
    --Cuando se activa la señal de reset, se pasará al estado de reposo de forma asíncrona
        if RESET='0' then
            present_state<=S0;
        elsif rising_edge(CLK) then
    --Con cada flanco de reloj se pasará del estado actual al estado que se haya cargado en el estado próximo
            present_state<=next_state;
        end if;
    end process;
    
    CAMBIO_DE_ESTADO: process(PRODUCTO,CUENTA,DONE,PRESENT_STATE)
    begin
        next_state<=present_state;
        case present_state is 
            when S0 =>  if CUENTA /= "0000" then
                            next_state<=S9;   --Si se introduce dinero antes de selecionar un producto, se pasará al estado de error
                        --Cuando se active solo la señal asociada a acada producto, se pasará al estado de ese producto seleccionado    
                        elsif PRODUCTO(0)='1' AND PRODUCTO(1)='0' AND PRODUCTO(2)='0' AND PRODUCTO(3)='0' then
                            next_state<=S1;
                        elsif PRODUCTO(0)='0' AND PRODUCTO(1)='1' AND PRODUCTO(2)='0' AND PRODUCTO(3)='0' then
                            next_state<=S2;
                        elsif PRODUCTO(0)='0' AND PRODUCTO(1)='0' AND PRODUCTO(2)='1' AND PRODUCTO(3)='0' then
                            next_state<=S3;
                        elsif PRODUCTO(0)='0' AND PRODUCTO(1)='0' AND PRODUCTO(2)='0' AND PRODUCTO(3)='1' then
                            next_state<=S4;
                        end if;
            
            when S1 => if CUENTA="1101" then
                       next_state<= S9;
                       elsif CUENTA="1100" then
                       next_state<=S5;  --Si el dinero introducido llega a 1.2euro, se pasará al estado de venta del producto
                       elsif PRODUCTO(0)='0' OR PRODUCTO(1)='1' OR PRODUCTO(2)='1' OR PRODUCTO(3)='1' then
                       next_state<=S0;  --Si se  selecciona otro producto, o se quita el producto seleccionado, se volverá al estado de reposo
                       end if;
            
            when S2 => if CUENTA="1101" then
                       next_state<= S9;
                       elsif CUENTA="1100" then
                       next_state<=S6;  --Si el dinero introducido llega a 1.2euro, se pasará al estado de venta del producto
                       elsif PRODUCTO(0)='1' OR PRODUCTO(1)='0' OR PRODUCTO(2)='1' OR PRODUCTO(3)='1' then
                       next_state<=S0;  --Si se  selecciona otro producto, o se quita el producto seleccionado, se volverá al estado de reposo
                       end if;
            
            when S3 => if CUENTA="1101" then
                       next_state<= S9;
                       elsif CUENTA="1100" then
                       next_state<=S7;  --Si el dinero introducido llega a 1.2euro, se pasará al estado de venta del producto
                       elsif PRODUCTO(0)='1' OR PRODUCTO(1)='1' OR PRODUCTO(2)='0' OR PRODUCTO(3)='1' then
                       next_state<=S0;  --Si se  selecciona otro producto, o se quita el producto seleccionado, se volverá al estado de reposo
                       end if;
                       
            when S4 => if CUENTA="1101" then
                       next_state<= S9;
                       elsif CUENTA="1100" then
                       next_state<=S8;  --Si el dinero introducido llega a 1.2euro, se pasará al estado de venta del producto
                       elsif PRODUCTO(0)='1' OR PRODUCTO(1)='1' OR PRODUCTO(2)='1' OR PRODUCTO(3)='0' then
                       next_state<=S0;  --Si se  selecciona otro producto, o se quita el producto seleccionado, se volverá al estado de reposo
                       end if;
            
            
            when S5 => if DONE='1' then
                       next_state<=S0;  -- Cuando termina la cuenta del temporizador, se vuelve al estado de reposo
                       end if;
                       
            when S6 => if DONE='1' then
                       next_state<=S0;
                       end if;
                       
            when S7 => if DONE='1' then
                       next_state<=S0;
                       end if;
            
            when S8 => if DONE='1' then
                       next_state<=S0;
                       end if;    
                       
            when S9 => if DONE='1' then
                       next_state<=S0;
                       end if;           
        end case;            
    end process;
    
    ACTUALIZACION_SALIDAS: process(present_state)
    begin
    --VALORES POR DEFECTO DE LAS SALIDAS
        ERROR<='0';
        VENTA<='0';
        DELAY<=(OTHERS=>'0');
        CONT<='0';
        LED<=(OTHERS=>'0');
        
        case present_state is 
            when S0=> LED<=(others=>'0');
                      VENTA<='0';
                      DELAY<=(others=>'0');
                      CONT<='0';
                      ERROR<='0';
            
            --Cuando se selecciona un producto se encenderá su respectivo LED
            when S1=> LED<="0001";
                      VENTA<='0';
                      DELAY<=(others=>'0');
                      CONT<='0';
                      ERROR<='0';
                      
            when S2=> LED<="0010";
                      VENTA<='0';
                      DELAY<=(others=>'0');
                      CONT<='0';
                      ERROR<='0';
            
            when S3=> LED<="0100";
                      VENTA<='0';
                      DELAY<=(others=>'0');
                      CONT<='0';
                      ERROR<='0';
                      
             when S4=> LED<="1000";
                      VENTA<='0';
                      DELAY<=(others=>'0');
                      CONT<='0';
                      ERROR<='0';
            
            --Cuando se esté vendiendo un producto, se cargará el tiempo de venta en el temporizador,
            --se mantendrá encendido el led del producto, se activará el bit de inicio del temporizador,
            --y se activará el bit de vendiendo
            
            when S5=> LED<="0001";
                      VENTA<='1';
                      DELAY<=to_unsigned(DURACION_VENTA, DELAY'length);
                      CONT<='1';
                      ERROR<='0';
            
            when S6=> LED<="0010";
                      VENTA<='1';
                      DELAY<=to_unsigned(DURACION_VENTA, DELAY'length);
                      CONT<='1';
                      ERROR<='0';
            
            when S7=> LED<="0100";
                      VENTA<='1';
                      DELAY<=to_unsigned(DURACION_VENTA, DELAY'length);
                      CONT<='1';
                      ERROR<='0';
                      
            when S8=> LED<="1000";
                      VENTA<='1';
                      DELAY<=to_unsigned(DURACION_VENTA, DELAY'length);
                      CONT<='1';
                      ERROR<='0';
            
            --Cuando se entra en el estado de error, se activa el bit de error, se activa el temporizador con el
            --bit de inicio del temporizador, y se carga en el temporizador el tiempo de error
            when S9=> LED<=(others=>'0');
                      VENTA<='0';
                      DELAY<=to_unsigned(DURACION_ERROR, DELAY'length);
                      CONT<='1';
                      ERROR<='1';            
         end case;    
    end process;
end Behavioral;