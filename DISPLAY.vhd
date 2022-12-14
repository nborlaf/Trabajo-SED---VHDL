----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2022 13:00:55
-- Design Name: 
-- Module Name: DISPLAY - Behavioral
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

entity DISPLAY is
  PORT(cuenta : IN std_logic_vector(3 DOWNTO 0);
    clk: IN std_logic;
    error: IN std_logic;
    VENTA : IN std_logic;
    digsel : OUT std_logic_vector(7 DOWNTO 0);
    segmentos : OUT std_logic_vector(7 DOWNTO 0) --teniendo en cuenta el punto del display será vector de 8 bits
    );
end DISPLAY;

architecture Behavioral of DISPLAY is
    signal numero : integer;
    signal cifra: natural range 0 to 7 :=0;
     signal show: natural range 0 to 18 :=0;
     signal clk_counter: natural range 0 to 20000 :=0;
begin
   process(clk)
    begin
        --Periodo 1.6 ms-> clk_counter=160000
       if rising_edge(clk) then
         clk_counter<=clk_counter + 1;
       
         if cifra > 7 then
            cifra<=0;
         end if;
         
          --periodo/8 = 0.2 ms -> clk_counter=20000
         if clk_counter>=20000 then
            clk_counter<=0;
            cifra<=cifra +1;
         end if;
       end if;

    end process;
   
   --Activar display, cada display se iluminará durante 1/8 ciclo, es decir 2ms
   process(cifra)
     begin
     numero <= to_integer(unsigned(cuenta));
      if numero<=10 then --entre 0€ a 1.2€
         case cifra is
           when 0=>digsel <="11111110";
           when 1=>digsel <="11111101";
           when 2=>digsel <="11111011";
           when others=>digsel<="11111111";
         end case;
       end if;
         
      
      if error='1' then --FAIL
         case cifra is
           when 4=>digsel <="11101111";
           when 5=>digsel <="11011111";
           when 6=>digsel <="10111111";
           when 7=>digsel <="01111111";
           when others=>digsel<="11111111";
         end case;
      end if;
      
       if VENTA='1' then --SOLd
         case cifra is
           when 4=>digsel <="11101111";
           when 5=>digsel <="11011111";
           when 6=>digsel <="10111111";
           when 7=>digsel <="01111111";
           when others=>digsel<="11111111";
         end case;
      end if;
   
   end process;
   
   --Indicar en cada caso qué números o letras se mostrarán en los displays
   process(cifra)
     begin
       if numero=0 then --0€
        case cifra is
           when 0=>show<=0;
           when 1=>show<=0;--nº 0
           when 2=>show<=17; --nºcero con punto
           when others=>show<=19;--no muestra nada en display
         end case;
        end if;
        
        if numero=1 then --0.1€
        case cifra is
           when 0=>show<=0;
           when 1=>show<=1;--nº 1
           when 2=>show<=17;--nºcero con punto
           when others=>show<=19;--no muestra nada en display
         end case;
        end if;
        
        if numero=2 then --0.2€
        case cifra is
           when 0=>show<=0;
           when 1=>show<=2;-- nº 2
           when 2=>show<=17;--nºcero con punto
           when others=>show<=19;--no muestra nada en display
         end case;
        end if;
        
        if numero=3 then --0.3€
        case cifra is
           when 0=>show<=0;
           when 1=>show<=3;--nº 3
           when 2=>show<=17;--nºcero con punto
           when others=>show<=19;--no muestra nada en display
         end case;
        end if;
        
        if numero=4 then --0.4€
        case cifra is
           when 0=>show<=0;
           when 1=>show<=4;-- nº4
           when 2=>show<=17;--nºcero con punto
           when others=>show<=19;--no muestra nada en display
         end case;
        end if;
        
        if numero=5 then --0.5€
        case cifra is
           when 0=>show<=0;
           when 1=>show<=5;--nº5
           when 2=>show<=17;--nºcero con punto
           when others=>show<=19;--no muestra nada en display
         end case;
        end if;
        
        if numero=6 then --0.6€
        case cifra is
           when 0=>show<=0;
           when 1=>show<=6;--nº6
           when 2=>show<=17;--nºcero con punto
           when others=>show<=19;--no muestra nada en display
         end case;
        end if;
        
        if numero=7 then --0.7€
        case cifra is
           when 0=>show<=0;
           when 1=>show<=7;--nº7
           when 2=>show<=17;--nºcero con punto
           when others=>show<=19;--no muestra nada en display
         end case;
        end if;
        
        if numero=8 then --0.8€
        case cifra is
           when 0=>show<=0;
           when 1=>show<=8;--nº8
           when 2=>show<=17;--nºcero con punto
           when others=>show<=19;--no muestra nada en display
         end case;
        end if;
        
        if numero=9 then --0.9€
        case cifra is
           when 0=>show<=0;
           when 1=>show<=9;--nº9
           when 2=>show<=17;--nºcero con punto
           when others=>show<=19;--no muestra nada en display
         end case;
        end if;
        
        if numero=10 then --1.0€
        case cifra is
           when 0=>show<=0;
           when 1=>show<=0;
           when 2=>show<=18;--nº uno con punto
           when others=>show<=19;--no muestra nada en display
         end case;
        end if;
        
         if numero=11 then --1.1€
        case cifra is
           when 0=>show<=0;
           when 1=>show<=1;
           when 2=>show<=18;--nº uno con punto
           when others=>show<=19;--no muestra nada en display
         end case;
        end if;
        
         if numero=12 then --1.2€
        case cifra is
           when 0=>show<=0;
           when 1=>show<=2;
           when 2=>show<=18;--nº uno con punto
           when others=>show<=19;--no muestra nada en display
         end case;
        end if;
        
         if error='1' then --FAIL
        case cifra is
           when 4=>show<=12;--L
           when 5=>show<=16;--I
           when 6=>show<=14;--A
           when 7=>show<=11;--F
           when others=>show<=18;--no muestra nada en display
         end case;
        end if;
        
        if VENTA='1' then --Producto vendido
        case cifra is
         --SoLD
           when 4=>show<=10;--d
           when 5=>show<=12;--L
           when 6=>show<=13;--O
           when 7=>show<=15;--S
           when others=>show<=18;--no muestra nada en display
         end case;
        end if;
        
   end process;
  
   --Activar los segmentos del display
   process(show)
     begin
      case show is
       when 0=>segmentos<="10000001"; --0
       when 1=>segmentos<="11001111"; --1
       when 2=>segmentos<="10010010"; --2
       when 3=>segmentos<="10000110"; --3
       when 4=>segmentos<="11001100"; --4
       when 5=>segmentos<="10100100"; --5
       when 6=>segmentos<="10100000"; --6
       when 7=>segmentos<="10001111"; --7
       when 8=>segmentos<="10000000"; --8
       when 9=>segmentos<="10000100"; --9
       when 10=>segmentos<="11000010"; --d
       when 11=>segmentos<="10111000"; --F
       when 12=>segmentos<="11110001"; --L
       when 13=>segmentos<="10000001"; --O
       when 14=>segmentos<="10001000"; --A
       when 15=>segmentos<="10100100"; --S
       when 16=>segmentos<="11111001"; --I
       when 17=>segmentos<="00000001"; --0.   nº 0 con punto
       when 18=>segmentos<="01001111"; --1.  nº 1 con punto
       when 19=>segmentos<="11111111"; --No se muestra nada
       when others=>segmentos<="11111111"; 
     end case;
   end process;


end Behavioral;