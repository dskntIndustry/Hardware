library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library hdl_library_CommonFunctions;
use hdl_library_CommonFunctions.CommonFunctions.all;

library hdl_library_ClockGenerator;
use hdl_library_ClockGenerator.ClockGenerator.all;

entity SPI_Master is
	generic
	(
		G_CLOCK_FREQUENCY 				: integer;
		G_SPI_FREQUENCY 				: integer;
		
		G_SPI_TRANSACTION_SIZE 			: integer
	);
	port
	(
		clock 							: in std_logic;
		enable 							: in std_logic;

		SCLK 							: out std_logic;
		MISO 							: out std_logic;
		MOSI 							: in std_logic;
		SS_n 							: in std_logic;

		tx_data 						: out std_logic_vector(G_SPI_TRANSACTION_SIZE - 1 downto 0);
		rx_data 						: in std_logic_vector(G_SPI_TRANSACTION_SIZE - 1 downto 0);

		data_valid 						: in std_logic;

		ready 							: out std_logic
	);
end entity; --SPI_Master

architecture arch of SPI_Master is
	signal SCLK_n : std_logic := '0';

begin

	enable <= data_valid;

	SerializeDataToSPI:process(clock)
	begin
		if rising_edge(clock) then
			if enable = '1' then
				MOSI <= rx_data(rx_data'high);
				rx_data <= rx_data(rx_data'high - 1 downto 0) & '0';
			end if;
		end if;
	end process SerializeDataToSPI; -- SerializeDataToSPI

	dut : entity hdl_library_ClockGenerator.ClockGenerator
	generic map
	(
		G_CLOCK_FREQUENCY 					=> G_CLOCK_FREQUENCY,
		G_CLOCK_DIVIDER 					=> G_CLOCK_DIVIDER
	)
	port map
	(
		clock 								=> clock,
		enable 								=> enable,

		clock_output 						=> SCLK,
		clock_output_n 						=> SCLK_n
	);

end architecture; -- arch