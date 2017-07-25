library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library hdl_library_CommonFunctions;
use hdl_library_CommonFunctions.MathHelpers.all;

library hdl_library_CommonFunctions;
use hdl_library_CommonFunctions.CommonFunctions.all;

library hdl_library_ClockGenerator;
use hdl_library_ClockGenerator.all;

entity SPI_SlaveTB is
end entity; --SPI_SlaveTB

architecture tb of SPI_SlaveTB is

	constant G_CLOCK_FREQUENCY 				: integer := 100E6;
	constant G_CLOCK_DIVIDER 				: integer := 100;

	constant G_SPI_TRANSACTION_SIZE 		: integer := 32;

	--declarations
	signal clock 							: std_logic := '0';
	signal clock_n 							: std_logic := '0';

	signal SCLK								: std_logic := '0';
	signal MISO								: std_logic := '0';
	signal MOSI								: std_logic := '0';
	signal SS_n								: std_logic := '0';

	signal enable 							: std_logic := '0';
	signal ready 							: std_logic := '0';

	signal clock_divider1 					: integer := 1000;
	signal clock_output 					: std_logic := '0';
	signal clock_output_n 					: std_logic := '0';
	--signal clock_counter 					: std_logic_vector(log2(G_CLOCK_FREQUENCY/G_SPI_FREQUENCY) - 1 downto 0) := (others => '0');

	signal data 							: std_logic_vector(G_SPI_TRANSACTION_SIZE -1  downto 0) := X"A0B0C0D0";

begin

	clock <= not clock after (1 sec / G_CLOCK_FREQUENCY) / 2;
	clock_n <= not clock;

	

	Test:process
	begin
		wait_until_rising_edges(clock, 1000);
		SS_n <= '1';
		enable <= '1';
		wait_until_rising_edges(clock, 1000);
		SS_n <= '0';
		wait for (1 sec / (G_CLOCK_FREQUENCY/G_CLOCK_DIVIDER))*(2*G_SPI_TRANSACTION_SIZE);
		SS_n <= '1';
		wait for 20 us;
		wait_until_rising_edges(clock, 1000);
		SS_n <= '1';
		enable <= '1';
		wait_until_rising_edges(clock, 1000);
		SS_n <= '0';
		wait for (1 sec / (G_CLOCK_FREQUENCY/G_CLOCK_DIVIDER))*(2*G_SPI_TRANSACTION_SIZE);
		SS_n <= '1';
		wait for 10 us;
		report "End of test"
		severity FAILURE;

	end process; --Test

	clock_generator : entity hdl_library_ClockGenerator.ClockGenerator
	generic map
	(
		G_CLOCK_FREQUENCY 				=> G_CLOCK_FREQUENCY,
		G_CLOCK_DIVIDER 				=> G_CLOCK_DIVIDER
	)
	port map
	(
		clock 							=> clock,
		enable 							=> enable,

		clock_output					=> SCLK,
		clock_output_n 					=> clock_output_n
	);

	--SLCK_generator:process(clock)
	--begin
	--	if rising_edge(clock) then
	--		if enable = '1' then
	--			clock_counter <= clock_counter + 1;
	--			if clock_counter = (G_CLOCK_FREQUENCY/G_SPI_FREQUENCY) -1 then
	--				clock_counter <= (others => '0');
	--				SCLK <= not SCLK;
	--			end if;
	--		end if;
	--	end if;
	--end process SLCK_generator; -- SLCK_generator

	MOSI_generator:process(SCLK)
	begin
		--if rising_edge(clock) then
			if enable = '1' then
				if rising_edge(SCLK) and SS_n = '0' then
					MOSI <= data(data'high);
					data <= data(data'high-1 downto 0) & '1';
					--data <= data(data'high-1 downto 0) & data(data'high);
				end if;
			end if;
		--end if;
	end process MOSI_generator; -- SLCK_generator

	dut : entity work.SPI_Slave
	generic map
	(
--		G_CLOCK_FREQUENCY 					=> G_CLOCK_FREQUENCY,
--		G_BASE_FREQUENCY 					=> G_BASE_FREQUENCY,
--		G_SPI_FREQUENCY 					=> G_SPI_FREQUENCY,

		G_SPI_TRANSACTION_SIZE 				=> G_SPI_TRANSACTION_SIZE
	)
	port map
	(
		clock 								=> clock,
		enable 								=> enable,

		SCLK 								=> SCLK,
		MISO 								=> MISO,
		MOSI 								=> MOSI,
		SS_n 								=> SS_n,

		ready 								=> ready
	);

end architecture; -- tb