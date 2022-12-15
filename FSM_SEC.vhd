----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2022 18:20:44
-- Design Name: 
-- Module Name: FSM_SEC - Behavioral
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

entity FSM_SEC is
    Port ( CLK : in STD_LOGIC;                            --Entrada para la señal de reloj 
           RESET : in STD_LOGIC;                          --Entrada para la señal de reset 
           CONT : in STD_LOGIC;                          --Entrada para el bit de inicio del temporizador 
           DELAY : in UNSIGNED (29 downto 0);             --Entrada para el tiempo que se cargará en el temporizador 
           DONE : out STD_LOGIC                           --Salida para el bit de fin de la cuenta 
           
           );
end FSM_SEC;

architecture Behavioral of FSM_SEC is

signal count: unsigned(29 downto 0):=(others=>'0'); --Cuenta del temporizador
signal aux_cont : std_logic:='0'; --Bit auxiliar para el bit de cont
signal aux_done : std_logic:='0';  --Bit auxiliar para gestionar el bit de fin de la cuenta
begin

  process (CLK, RESET)
  begin
    if RESET = '0' then
      count <= (others => '0');
      aux_done<='0'; 
      aux_cont<='0';  
    elsif rising_edge(CLK) then
    --Si la señal de cont se activa, se cargará el temporizador para poder empezar la cuenta atrás
    --La señal de CONT servirá para disparar el temporizador
      if CONT='1' then
        count <= DELAY; --Carga el tiempo
        aux_done<='0';
        aux_cont<='1'; -- Aux_cont pasará a 1 si previamente se ha detectado la señal de cont activa
      end if;
      
      if aux_cont='1' then  -- Mientras aux_cont esté a '1', el temporizador seguirá con la cuenta atrás
         if count /= 0 then  -- Mientras el temporizador esté activo, se decrementará en 1 la cuenta con cada ciclo de reloj
           count <= count - 1;
           aux_done<='0';    -- La señal de fin de la cuenta se mantendrá a '0' mientras la cuenta del temporizador no sea 0
         elsif count=0 then  -- Cuando la cuenta llegue a cero, se activará el bit de fin, y la señal aux_cont volverá a cero
          aux_done<='1';           
           aux_cont<='0';
         end if;
      elsif aux_cont='0' then -- Si aux_cont está a '0', significará que el temporizador está parado y el bit de fin deberá ser '0'
          aux_done<='0';
      end if;
    end if;
  end process;
 
 DONE<=aux_done;
 
  
end Behavioral;