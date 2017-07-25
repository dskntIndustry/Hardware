library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--library hdl_library_CommonFunctions;
--use hdl_library_CommonFunctions.CommonFunctions.all;
library hdl_library_CommonFunctions;
use hdl_library_CommonFunctions.MathHelpers.all;

entity ClockGenerator is
	generic
	(
		G_CLOCK_FREQUENCY 				: integer;
		G_CLOCK_DIVIDER 				: integer
	);
	port
	(
		clock 							: in std_logic;
		enable 							: in std_logic;

		clock_output					: out std_logic;
		clock_output_n 					: out std_logic
	);
end entity; --ClockGenerator

architecture arch of ClockGenerator is
	signal i_counter 					: std_logic_vector(log2(G_CLOCK_DIVIDER) downto 0) := (others => '0');
	signal i_clock_output 				: std_logic := '0';
	signal i_index 						: integer := 0;
begin


	PowerOF2: if (isPow2(G_CLOCK_DIVIDER) = true) and (G_CLOCK_FREQUENCY/G_CLOCK_DIVIDER > 1) generate
		
		--i_index <= log2(G_CLOCK_FREQUENCY/G_CLOCK_DIVIDER);

		pow2_divider:process(clock)
		begin
			if rising_edge(clock) then
				if enable = '1' then
					i_counter <= i_counter + 1;
				else
					i_clock_output <= '0';
				end if;
				i_clock_output <= i_counter(log2(G_CLOCK_DIVIDER));
			end if;
		end process pow2_divider;
	end generate PowerOF2;

	clock_output <= i_clock_output;
	clock_output_n <= not i_clock_output;


	NotPowerOF2: if (isPow2(G_CLOCK_DIVIDER) = false) and (G_CLOCK_FREQUENCY/G_CLOCK_DIVIDER > 1) generate
		
		clock_counter:process(clock)
		begin
			if rising_edge(clock) then
				if enable = '1' then
					i_counter <= i_counter + 1;
					if i_counter = (G_CLOCK_DIVIDER) - 1 then
						i_clock_output <= not i_clock_output;
						i_counter <= (others => '0');
					end if;
				else
					i_clock_output <= '0';
				end if;
			end if;
		end process clock_counter; -- clock_counter

	end generate NotPowerOF2;

end architecture; -- arch