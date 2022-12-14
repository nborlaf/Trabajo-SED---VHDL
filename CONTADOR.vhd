----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2022 12:52:44
-- Design Name: 
-- Module Name: CONTADOR - Behavioral
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
use ieee.std_logic_arith.all;

entity CONTADOR is
    Port ( CLK : in STD_LOGIC;          -- Entrada de la se�al de reloj 
           diez_cent : in STD_LOGIC;     -- Entrada para la se�al de 10 cents 
           veinte_cent : in STD_LOGIC;  -- Entrada para la se�al de 20 cents 
           cincuenta_cent : in STD_LOGIC;   -- Entrada para la se�al de 50 cents 
           un_euro : in STD_LOGIC;     -- Entrada para la se�al de 1 euro 
           RESET : in STD_LOGIC;        -- Entrada para la se�al de RESET 
           ERROR : in STD_LOGIC;        -- Entrada para el bit de error de la m�quina 
           VENTA : in STD_LOGIC;      -- Entrada para el bit de venta de la m�quina
           CUENTA : out STD_LOGIC_VECTOR (3 downto 0));  -- Salida con el valor de la cuenta del dinero introducido
end CONTADOR;

architecture Behavioral of CONTADOR is

signal cuenta_aux : unsigned(4 downto 0):=(others=>'0'); -- Se�al para realizar la suma del dinero, con un bit m�s que la salida para evitar desbordamientos

begin

    process(CLK, RESET)
    begin  
    --Cuando la se�al de RESET se active, la se�al intermedia cuenta_aux y la salida 
    --cuenta pasar�n a cero
        if RESET='0' then
            cuenta_aux<="00000";          
        elsif rising_edge(CLK)then 
        --Si el bit de error o de venta est� activo, la cuenta del dinero se reiniciar� a cero      
            if ERROR='1' then
                cuenta_aux<="00000";
            elsif VENTA='1' then
                cuenta_aux<="00000";              
            else
            --Si la se�al de 10cents est� activa, se le sumar� 1 unidad a la cuenta 
                if diez_cent='1' then
                  cuenta_aux<=cuenta_aux+"00001";
                end if;
            --Si la se�al de 20cents est� activa, se le sumaran 2 unidades a la cuenta  
                if veinte_cent='1' then
                  cuenta_aux<=cuenta_aux+"00010";
                end if;
            --Si la se�al de 50cents est� activa, se le sumaran 5 unidades a la cuenta     
                if cincuenta_cent='1' then
                  cuenta_aux<=cuenta_aux+"00101";
                end if;
            --Si la se�al de 1euro est� activa, se le sumaran 10 unidades a la cuenta   
                if un_euro='1' then
                  cuenta_aux<=cuenta_aux+"01010";                
                end if;
            end if;
       end if;
    end process;
    
 --La cuenta de salida podr� ir de 0 a 12, si la suma en cuenta_aux es mayor, la salida tomar� el valor 13 (1101)   
    with cuenta_aux select
        CUENTA<="0000" when "00000",
                "0001" when "00001",
                "0010" when "00010",
                "0011" when "00011",
                "0100" when "00100",
                "0101" when "00101",
                "0110" when "00110",
                "0111" when "00111",
                "1000" when "01000",
                "1001" when "01001",
                "1010" when "01010",
                "1011" when "01011",
                "1100" when "01100",
                "1101" when others;
end Behavioral;