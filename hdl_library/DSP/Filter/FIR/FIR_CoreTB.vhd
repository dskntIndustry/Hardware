library IEEE;
	use IEEE.std_logic_1164.ALL;
	use IEEE.std_logic_arith.ALL;
	use IEEE.std_logic_unsigned.ALL;

library hdl_library_CommonFunctions;
	use hdl_library_CommonFunctions.MathHelpers.all;

library hdl_library_ClockGenerator;
	use hdl_library_ClockGenerator.all;


library hdl_library_DSP_Filter_FIR;
	use hdl_library_DSP_Filter_FIR.all;

entity FIR_CoreTB is
end entity; --FIR_CoreTB

architecture arch of FIR_CoreTB is

	constant C_FIR_FILTER_ORDER 				: integer;

	constant C_DATA_IN_WIDTH 					: integer;
	constant C_DATA_OUT_WIDTH 					: integer;

	constant C_COEFF_WIDTH 						: integer;


	signal clock 								: std_logic;
	signal enable 								: std_logic;

	signal xn 									: std_logic_vector(C_DATA_IN_WIDTH - 1 downto 0);
	signal xn_nd 								: std_logic;
	
	signal yn 									: std_logic_vector(C_DATA_OUT_WIDTH - 1 downto 0);
	signal yn_valid 							: std_logic;

	signal current_coefficient 					: std_logic_vector(C_COEFF_WIDTH - 1 downto 0);
	signal current_coefficient_address 			: std_logic_vector(log2(C_FIR_FILTER_ORDER) - 1 downto 0);

begin

	dut : entity hdl_library_DSP_Filter_FIR.FIR_Core
	generic map
	(
		C_FIR_FILTER_ORDER 					=> C_FIR_FILTER_ORDER,

		C_DATA_IN_WIDTH 					=> C_DATA_IN_WIDTH,
		C_DATA_OUT_WIDTH 					=> C_DATA_OUT_WIDTH,

		C_COEFF_WIDTH 						=> C_COEFF_WIDTH
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

end architecture; -- arch