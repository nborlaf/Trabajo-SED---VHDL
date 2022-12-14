----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2022 11:59:17
-- Design Name: 
-- Module Name: Sincro - Behavioral
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
entity Sincro is
 port (
 clk : in std_logic;
 sincro_in : in std_logic;
 sincro_out : out std_logic;
 reset: in std_logic
 );
end Sincro;
architecture BEHAVIORAL of Sincro is
 signal sreg : std_logic_vector(1 downto 0); --Registro de 2 bits
begin
 process (CLK,reset)
 begin
 --CUANDO LA SEÑAL DE RESET SE ACTIVA, SE LIMPIAN LA SALIDA Y
 --LOS VALORES DEL REGISTRO
 if (reset='0') then
 sincro_out <= '0';
 sreg <="00";
 elsif rising_edge(CLK) then
 --CON CADA CICLO DE RELOJ LA SEÑAL ASÍNCRONA DE LA ENTRADA PASA AL REGISTRO,
 --EL SEGUNDO BIT DEL REGISTRO PASA A LA SALIDA, Y EL PRIMER BIT PASA A SER 
 --EL SEGUNDO BIT DEL REGISTRO
 sincro_out <= sreg(1);
 sreg <= sreg(0) & sincro_in;
 end if;
 end process;
end BEHAVIORAL;
