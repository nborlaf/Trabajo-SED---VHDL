----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2022 12:14:27
-- Design Name: 
-- Module Name: EDGEDTCTR - Behavioral
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
entity EDGEDTCTR is
 port (
 CLK : in std_logic;       --Entrada del reloj 
 sync_in : in std_logic;   --Entrada síncrona 
 edge : out std_logic;     --Flanco de salida
 reset: in std_logic       --Señal de reset
 );
end EDGEDTCTR;
architecture BEHAVIORAL of EDGEDTCTR is
 signal sreg : std_logic_vector(2 downto 0);
begin
 process (CLK, reset)
 begin
 --Cuando la señal de reset se activa, se limpian los bits del registro
 if (reset='0') then
 sreg<="000";
 elsif rising_edge(CLK) then
 --Con cada flanco de reloj los bits del registro avanzarán una posición, 
 --y la señal de la entrada del detector pasará al bit 0 del registro
 sreg <= sreg(1 downto 0) & sync_in;
 end if;
 end process;
 
 edge<= '0' when reset='0' else  --Si se activa el RESET, la salida se limpiará también
        '1' when sreg="100" else --Se activa la salida cuando se detecta un flanco negativo
        '0';
end BEHAVIORAL;
