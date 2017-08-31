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

		C_COEFF_WIDTH 						: integer;

		C_MULTIPLIER_DELAY 					: integer;
		C_ADDER_DELAY 						: integer
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

	type T_samples_RAM is array (0 to C_FIR_FILTER_ORDER-1) of std_logic_vector(C_DATA_IN_WIDTH - 1 downto 0);
	signal samples_RAM 						: T_samples_RAM := (others => (others => '0'));

	signal product 							: std_logic_vector((xn'length + current_coefficient'length - 1) downto 0) := (others => '0');
	signal sum 								: std_logic_vector((xn'length - 1) downto 0) := (others => '0');

begin

	-- 8 clock cycles latency
	signed_multiplier : entity work.signed_multiplier
		port map
		(
			A 			=> X"12345678",
			B 			=> X"00000001",

			P 			=> product,

			CLK 		=> clock
		);

	-- 8 clock cycles latency
	signed_adder : entity work.signed_adder
		port map
		(
			A 			=> X"12345678",
			B 			=> X"00000001",

			S 			=> sum,

			CLK 		=> clock
		);

		sequencer:process(clock)
		begin
			if rising_edge(clock) then
				if xn_nd = '1' then
					shift_samples_RAM : for i in 0 to C_FIR_FILTER_ORDER - 1 loop
						samples_RAM(i+1) <= samples_RAM(i);
					end loop ; -- shift_samples_RAM
					samples_RAM(0) <= xn;
				end if;
			end if;
		end process sequencer; -- sequencer


end architecture ; -- arch


