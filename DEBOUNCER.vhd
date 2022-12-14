----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2022 12:10:28
-- Design Name: 
-- Module Name: DEBOUNCER - Behavioral
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
use ieee.std_logic_unsigned.all;

entity DEBOUNCER is
    port (
    CLK    : in std_logic;
	btn_in	: in std_logic;
	btn_out	: out std_logic;
	reset: in std_logic
	);
end DEBOUNCER;

architecture BEHAVIORAL of DEBOUNCER is
    constant CNT_SIZE : integer := 20;
    signal btn_prev   : std_logic := '0';
    signal counter    : std_logic_vector(CNT_SIZE downto 0) := (others => '0');

begin
    process(clk,reset)
    begin
    if (reset='0') then
    btn_out <= '0';
    counter <= (others => '0');
    btn_prev <= '0';
	elsif (CLK'event and CLK='1') then
		if (btn_prev xor btn_in) = '1' then
			counter <= (others => '0');
			btn_prev <= btn_in;
		elsif (counter(CNT_SIZE) = '0') then
			counter <= counter + 1;
        	else
			btn_out <= btn_prev;
		end if;
	   end if;
	
    end process;
end BEHAVIORAL;