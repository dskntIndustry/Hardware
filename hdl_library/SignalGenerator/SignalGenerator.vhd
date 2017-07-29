library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library hdl_library_CommonFunctions;
use hdl_library_CommonFunctions.MathHelpers.all;
--library hdl_library_CommonFunctions;
--use hdl_library_CommonFunctions.CommonFunctions.all;

entity SignalGenerator is
	generic
	(
		G_CLOCK_FREQUENCY 				: integer;
		G_SIGNAL_OUTPUT_RESOLUTION 		: integer;
		G_SIGNAL_SHAPE 					: integer
	);
	port
	(
		clock 							: in std_logic;
		enable 							: in std_logic;

		output_signal 					: out std_logic_vector(G_SIGNAL_OUTPUT_RESOLUTION - 1 downto 0)

		--ready 							: out std_logic

	);
end entity; --SignalGenerator

architecture arch of SignalGenerator is

	signal i_saw_counter : std_logic_vector(G_SIGNAL_OUTPUT_RESOLUTION - 1 downto 0) := (others => '0');
	signal i_phase_counter : std_logic_vector(G_SIGNAL_OUTPUT_RESOLUTION - 1 downto 0) := (others => '0');

begin

	signal_type_saw: if G_SIGNAL_SHAPE = 0 generate

		saw_counter:process(clock)
		begin
			if rising_edge(clock) then
				if enable = '1' then
					i_saw_counter <= i_saw_counter + 1;
				end if;
				output_signal <= i_saw_counter;
			end if;
		end process saw_counter; -- saw_counter

	end generate signal_type_saw;

	signal_type_sine: if G_SIGNAL_SHAPE = 1 generate

		phase_counter:process(clock)
		begin
			if rising_edge(clock) then
				if enable = '1' then
					i_phase_counter <= i_phase_counter + 1;
				end if;
			end if;
		end process phase_counter; -- phase_counter

		sine_generator:process(clock)
		begin
			if rising_edge(clock) then
				if enable = '1' then
					i_saw_counter <= i_saw_counter + 1;
				end if;
				output_signal <= i_saw_counter;
			end if;
		end process sine_generator; -- saw_counter

	end generate signal_type_sine;

	signal_type_triangle: if G_SIGNAL_SHAPE = 2 generate

	end generate signal_type_triangle;

	signal_type_square: if G_SIGNAL_SHAPE = 3 generate

	end generate signal_type_square;

	signal_type_random: if G_SIGNAL_SHAPE = 4 generate

	end generate signal_type_random;


end architecture; -- arch