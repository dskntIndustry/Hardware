library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library hdl_library_CommonFunctions;
use hdl_library_CommonFunctions.MathHelpers.all;

library hdl_library_ClockGenerator;
use hdl_library_ClockGenerator.all;

library hdl_library_SignalGenerator;
use hdl_library_SignalGenerator.all;

entity SignalGeneratorTB is
end entity; --SignalGeneratorTB

architecture tb of SignalGeneratorTB is

	constant G_CLOCK_FREQUENCY 				: integer := 100E6;
	constant G_CLOCK_DIVIDER 				: integer := 100;

	constant G_SIGNAL_OUTPUT_RESOLUTION 	: integer := 16;

	constant G_SIGNAL_SHAPE_TYPES 			: integer := 4;

	constant SIGNAL_TYPE_SAW 				: integer := 0;
	constant SIGNAL_TYPE_SINE 				: integer := 1;
	constant SIGNAL_TYPE_TRIANGLE 			: integer := 2;
	constant SIGNAL_TYPE_SQUARE 			: integer := 3;
	constant SIGNAL_TYPE_RANDOM 			: integer := 3;


	--declarations
	signal clock 							: std_logic := '0';
	signal clock_n 							: std_logic := '0';

	signal enable 							: std_logic := '0';
	signal ready 							: std_logic := '0';

	signal clock_divider1 					: integer := 1000;
	signal clock_output 					: std_logic := '0';
	signal clock_output_n 					: std_logic := '0';

--	signal signal_shape 					: std_logic_vector(log2(G_SIGNAL_SHAPE_TYPES) - 1 downto 0);
	signal output_signal 					: std_logic_vector(G_SIGNAL_OUTPUT_RESOLUTION - 1 downto 0);


begin

	clock <= not clock after (1 sec / G_CLOCK_FREQUENCY) / 2;
	clock_n <= not clock;

	enable <= '1';

	dut : entity hdl_library_SignalGenerator.SignalGenerator
	generic map
	(
		G_CLOCK_FREQUENCY 					=> G_CLOCK_FREQUENCY,
		G_SIGNAL_OUTPUT_RESOLUTION 			=> G_SIGNAL_OUTPUT_RESOLUTION,
		G_SIGNAL_SHAPE 						=> SIGNAL_TYPE_SAW
	)
	port map
	(
		clock 								=> clock,
		enable 								=> enable,

		output_signal 						=> output_signal

		--ready 								=> ready
	);

end architecture; -- tb