----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.12.2022 17:51:25
-- Design Name: 
-- Module Name: CONTADOR_tb - Behavioral
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


library ieee;
use ieee.std_logic_1164.all;

entity tb_CONTADOR is
end tb_CONTADOR;

architecture tb of tb_CONTADOR is

    component CONTADOR
        port (CLK         : in std_logic;
              diez_cent    : in std_logic;
              veinte_cent : in std_logic;
              cincuenta_cent  : in std_logic;
              un_euro    : in std_logic;
              RESET       : in std_logic;
              ERROR       : in std_logic;
              VENTA        : in std_logic;
              CUENTA      : out std_logic_vector (3 downto 0));
    end component;

    signal CLK         : std_logic;
    signal diez_cent    : std_logic;
    signal veinte_cent : std_logic;
    signal cincuenta_cent  : std_logic;
    signal un_euro    : std_logic;
    signal RESET       : std_logic;
    signal ERROR       : std_logic;
    signal VENTA      : std_logic;
    signal CUENTA      : std_logic_vector (3 downto 0);

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : CONTADOR
    port map (CLK         => CLK,
              diez_cent    => diez_cent,
              veinte_cent => veinte_cent,
              cincuenta_cent  => cincuenta_cent,
              un_euro    => un_euro,
              RESET       => RESET,
              ERROR       => ERROR,
              VENTA        => VENTA,
              CUENTA      => CUENTA);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2;

    -- EDIT: Check that CLK is really your main clock signal
    CLK <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
		 
		
        -- EDIT Add stimuli here
        diez_cent<='0','1' after 50 ns, '0' after 90 ns,'1' after 280 ns;
        veinte_cent<='0','1' after 60 ns, '0' after 100 ns;
        RESET<='1','0' after 110 ns,'1' after 120 ns, '0' after 160 ns, '1' after 200 ns;
        un_euro<='0','1' after 160 ns, '0' after 220 ns;
        cincuenta_cent<='0','1' after 280 ns, '0' after 300 ns;
        VENTA<='0','1' after 320 ns;
        ERROR<='0','1' after 240 ns, '0' after 280 ns;
		
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
