library IEEE;
	use IEEE.std_logic_1164.ALL;
	use IEEE.std_logic_arith.ALL;
	use IEEE.std_logic_unsigned.ALL;

library hdl_library_CommonFunctions;
	use hdl_library_CommonFunctions.MathHelpers.all;
	use hdl_library_CommonFunctions.CommonFunctions.all;

library hdl_library_ClockGenerator;
	use hdl_library_ClockGenerator.all;


library hdl_library_DSP_Filter_FIR;
	use hdl_library_DSP_Filter_FIR.all;

entity FIR_CoreTB is
end entity; --FIR_CoreTB

architecture arch of FIR_CoreTB is

	constant G_CLOCK_FREQUENCY 					: integer := 100E6;

	constant C_FIR_FILTER_ORDER 				: integer := 16;

	constant C_DATA_IN_WIDTH 					: integer := 32;
	constant C_DATA_OUT_WIDTH 					: integer := 32;

	constant C_COEFF_WIDTH 						: integer := 32;

	constant C_MULTIPLIER_DELAY 				: integer := 8;
	constant C_ADDER_DELAY 						: integer := 8;


	signal clock 								: std_logic := '0';
	signal clock_n 								: std_logic := '0';
	signal enable 								: std_logic := '0';

	type T_COEFF_ROM is array(0 to C_FIR_FILTER_ORDER - 1) of std_logic_vector(C_COEFF_WIDTH - 1 downto 0);
	signal coeff_ROM 							: T_COEFF_ROM := (others => (others => '0'));

	signal xn 									: std_logic_vector(C_DATA_IN_WIDTH - 1 downto 0) := (others => '0');
	signal xn_nd 								: std_logic := '0';
	
	signal yn 									: std_logic_vector(C_DATA_OUT_WIDTH - 1 downto 0) := (others => '0');
	signal yn_valid 							: std_logic := '0';

	signal current_coefficient 					: std_logic_vector(C_COEFF_WIDTH - 1 downto 0) := (others => '0');
	signal current_coefficient_address 			: std_logic_vector(log2(C_FIR_FILTER_ORDER) - 1 downto 0) := (others => '0');

	--signal xn 									: std_logic_vector(C_DATA_IN_WIDTH - 1 downto 0) := (others => '0');


begin

	clock <= not clock after (1 sec / G_CLOCK_FREQUENCY) / 2;
	clock_n <= not clock;

	enable <= '1' after 100 ns;

	gen_valid_pulse:process
	begin
		xn_nd <= '0';
		wait_until_rising_edges(clock, 1000);
		xn_nd <= '1';
		wait_until_rising_edges(clock, 1);
	end process; --gen_valid_pulse


	dut : entity hdl_library_DSP_Filter_FIR.FIR_Core
	generic map
	(
		C_FIR_FILTER_ORDER 					=> C_FIR_FILTER_ORDER,

		C_DATA_IN_WIDTH 					=> C_DATA_IN_WIDTH,
		C_DATA_OUT_WIDTH 					=> C_DATA_OUT_WIDTH,

		C_COEFF_WIDTH 						=> C_COEFF_WIDTH,

		C_MULTIPLIER_DELAY 					=> C_MULTIPLIER_DELAY,
		C_ADDER_DELAY 						=> C_ADDER_DELAY
	)
	port map
	(
		clock 								=> clock,
		enable 								=> enable,

		xn 									=> xn,
		xn_nd 								=> xn_nd,

		yn 									=> yn,
		yn_valid 							=> yn_valid,

		current_coefficient 				=> current_coefficient,
		current_coefficient_address 		=> current_coefficient_address


		--ready 								=> ready
	);

	dataGenerator:process(clock)
	begin
		if rising_edge(clock) then
			if xn_nd = '1' then
				xn <= xn + 1;
			end if;
		end if;
	end process dataGenerator; -- dataGenerator

end architecture; -- arch