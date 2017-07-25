library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library hdl_library_CommonFunctions;
use hdl_library_CommonFunctions.CommonFunctions.all;


entity ClockGeneratorTB is
end entity; --ClockGenerator

architecture tb of ClockGeneratorTB is

	constant G_CLOCK_FREQUENCY 				: integer := 512;
	constant G_BASE_FREQUENCY 				: integer := 12E6;
	constant G_CLOCK_DIVIDER 				: integer := 10;

	signal clock 							: std_logic := '0';
	signal clock_n 							: std_logic := '0';

	signal enable 							: std_logic := '0';

	signal clock_output 					: std_logic := '0';
	signal clock_output_n 					: std_logic := '0';

begin

	clock <= not clock after (1 sec / G_CLOCK_FREQUENCY) / 2;
	clock_n <= not clock;

	--Test:process
	--begin
		enable <= '1';
	--end process; --Test

	dut : entity work.ClockGenerator
	generic map
	(
		G_CLOCK_FREQUENCY 					=> G_CLOCK_FREQUENCY,
		G_CLOCK_DIVIDER 					=> G_CLOCK_DIVIDER
	)
	port map
	(
		clock 								=> clock,
		enable 								=> enable,

		-- module clock output
		clock_output 						=> clock_output,
		clock_output_n 						=> clock_output_n
	);

end architecture; -- tb