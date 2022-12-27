----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.12.2022 18:35:49
-- Design Name: 
-- Module Name: DISPLAY_tb - Behavioral
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



entity Displays_tb is
--  Port ( );
end Displays_tb;

architecture tb of Displays_tb is

    component DISPLAY
        port (cuenta    : in std_logic_vector (3 downto 0);
              clk       : in std_logic;
              error     : in std_logic;
              VENTA     : in std_logic;
              digsel    : out std_logic_vector (7 downto 0);
              segmentos : out std_logic_vector (7 downto 0));
    end component;

    signal cuenta    : std_logic_vector (3 downto 0);
    signal clk      : std_logic:='0';
    signal error     : std_logic;
    signal VENTA      : std_logic;
    signal digsel    : std_logic_vector (7 downto 0);
    signal segmentos : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 10 ns; -- 100 MHZ
   signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : DISPLAY
    port map (cuenta    => cuenta,
              clk       => clk,
              error     => error,
              VENTA      => VENTA,
              digsel    => digsel,
              segmentos => segmentos);

    -- Clock generation
     TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
     clk <= TbClock;

     stimuli : process
    begin
 
       wait for 10ns;
       cuenta<="0111";
        error <= '0';
        VENTA <= '0';
        
    wait for 3ms;
       cuenta<="0000";
       VENTA<='1';
       
         wait for 3ms;
       cuenta<="0000";
       VENTA<='0';
        error <= '1';

        wait for 3ms;
       cuenta<="0000";
       VENTA<='0';
       error <= '0';
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
