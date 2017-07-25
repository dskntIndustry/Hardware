library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity SPI_MasterTB is
end entity; --SPI_MasterTB

architecture tb of SPI_MasterTB is

	constant G_CLOCK_FREQUENCY 				: integer := 100E6;
	constant G_CLOCK_DIVIDER 				: integer := 100;

	constant G_SPI_TRANSACTION_SIZE 		: integer := 32;

	--declarations
	signal clock 							: std_logic := '0';
	signal clock_n 							: std_logic := '0';

	signal enable 							: std_logic := '0';

	signal clock_divider1 					: integer := 1000;
	signal clock_output1 					: std_logic := '0';

begin

	clock <= not clock after (1 sec / G_CLOCK_FREQUENCY) / 2;
	clock_n <= not clock;

	Test:process
	begin
		wait for 100 ns;
		enable <= '1';
		wait for 10 us;
		enable <= '0';
		wait for 1 ms;
	end process; --Test

	dut : entity work.SPI_Master
	generic map
	(
		G_CLOCK_FREQUENCY 					=> G_CLOCK_FREQUENCY,
		G_SPI_FREQUENCY 					=> G_SPI_FREQUENCY,
		
		G_SPI_TRANSACTION_SIZE 				=> G_SPI_TRANSACTION_SIZE
	)
	port map
	(
		clock 								=> clock,
		enable 								=> enable
	);

end architecture; -- tb