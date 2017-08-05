library IEEE;
	use IEEE.std_logic_1164.ALL;
	use IEEE.std_logic_arith.ALL;
	use IEEE.std_logic_unsigned.ALL;

library hdl_library_ClockGenerator;
	use hdl_library_ClockGenerator.all;

entity MimasTop is
	port
	(
		clock 								: in std_logic;

		status_led 							: out std_logic;
		top_clock_output 					: out std_logic
	);
end entity; --MimasTop

architecture arch of MimasTop is
	
	constant G_CLOCK_FREQUENCY 				: integer := 512;
	constant G_BASE_FREQUENCY 				: integer := 12E6;
	constant G_CLOCK_DIVIDER 				: integer := 10;

	signal enable 							: std_logic := '1';

	signal clock_output 					: std_logic := '0';
	signal clock_output_n 					: std_logic := '0';

begin

	status_led <= '1';


	clock_generator : entity hdl_library_ClockGenerator.ClockGenerator
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
	top_clock_output <= clock_output;

end architecture; -- arch

