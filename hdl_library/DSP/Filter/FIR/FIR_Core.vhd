library IEEE;
	use IEEE.std_logic_1164.ALL;
	use IEEE.std_logic_arith.ALL;
	use IEEE.std_logic_unsigned.ALL;

library hdl_library_CommonFunctions;
	use hdl_library_CommonFunctions.MathHelpers.all;


entity FIR_Core is
	generic
	(
		C_FIR_FILTER_ORDER 					: integer;

		C_DATA_IN_WIDTH 					: integer;
		C_DATA_OUT_WIDTH 					: integer;

		C_COEFF_WIDTH 						: integer
	);
	port
	(

		clock 								: in std_logic;
		enable 								: in std_logic;

		xn 									: in std_logic_vector(C_DATA_IN_WIDTH - 1 downto 0);
		xn_nd 								: in std_logic;

		yn 									: out std_logic_vector(C_DATA_OUT_WIDTH - 1 downto 0);
		yn_valid 							: out std_logic;

		current_coefficient 				: in std_logic_vector(C_COEFF_WIDTH - 1 downto 0);
		current_coefficient_address 		: out std_logic_vector(log2(C_FIR_FILTER_ORDER) - 1 downto 0)

	);
end entity ; -- FIR_Core

architecture arch of FIR_Core is



begin


end architecture ; -- arch


