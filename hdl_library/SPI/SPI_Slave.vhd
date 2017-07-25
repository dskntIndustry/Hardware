library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library hdl_library_CommonFunctions;
use hdl_library_CommonFunctions.MathHelpers.all;
--library hdl_library_CommonFunctions;
--use hdl_library_CommonFunctions.CommonFunctions.all;

entity SPI_Slave is
	generic
	(
		--G_SPI_FREQUENCY 				: integer;
		G_SPI_TRANSACTION_SIZE 			: integer
	);
	port
	(
		clock 							: in std_logic;
		enable 							: in std_logic;

		SCLK 							: in std_logic;
		MISO 							: out std_logic;
		MOSI 							: in std_logic;
		SS_n 							: in std_logic;

		ready 							: out std_logic

	);
end entity; --SPI_Slave

architecture arch of SPI_Slave is

	type T_SPI_STATES is (SPI_IDLE, SPI_SERIAL_RECEIVE, SPI_RX_FINISHED);
	signal SPI_current_state 			: T_SPI_STATES := SPI_IDLE;
	signal SPI_next_state 				: T_SPI_STATES;

	signal SPI_bit_counter 				: std_logic_vector(log2(G_SPI_TRANSACTION_SIZE) -1 downto 0) := (others => '0');
	signal SPI_previous_bit_counter 	: std_logic_vector(log2(G_SPI_TRANSACTION_SIZE) -1 downto 0) := (others => '0');
	
	signal SPI_SCLK_bufclock 			: std_logic := '0';
	signal SPI_SCLK_rising				: std_logic := '0';
	signal SPI_SS_n_bufclock 			: std_logic := '0';
	signal SPI_SS_n_falling 			: std_logic := '0';

	signal counter_enable 				: std_logic := '0';
	signal counter_reset 				: std_logic := '0';

	signal received_data				: std_logic_vector(G_SPI_TRANSACTION_SIZE -1  downto 0) := (others => '0');

begin

	Delayer:process(clock)
	begin
		if rising_edge(clock) then
			SPI_SS_n_bufclock <= SS_n;
			SPI_SCLK_bufclock <= SCLK;
		end if;
	end process Delayer; -- Delayer

	SPI_SS_n_falling <= '1' when SPI_SS_n_bufclock = '1' and SS_n = '0' else '0';
	SPI_SCLK_rising <= '1' when SPI_SCLK_bufclock = '0' and SCLK = '1' else '0';

	SPI_States_Updater:process(clock)
	begin
		if rising_edge(clock) then
			if SCLK = '1' then
				SPI_current_state <= SPI_next_state;
			end if;
		end if;
	end process ; -- SPI_States_Updater

	SPI_FSM_logic:process(SPI_current_state, SPI_SS_n_falling, SPI_previous_bit_counter, counter_reset, counter_enable)
	begin
		ready <= '1';
		case(SPI_current_state) is
			
			when SPI_IDLE =>
				--counter_reset <= '1';
				if SPI_SS_n_falling = '1' then
					counter_reset <= '0';
					counter_enable <= '1';
					SPI_next_state <= SPI_SERIAL_RECEIVE;
				end if;
			when SPI_SERIAL_RECEIVE =>
				ready <= '0';
				if SS_n = '1' and SPI_previous_bit_counter = (G_SPI_TRANSACTION_SIZE - 1) then
					counter_enable <= '0';
					SPI_next_state <= SPI_IDLE;
				end if;
			--when SPI_RX_FINISHED =>
			--	counter_reset <= '1';
			--	counter_enable <= '0';
			--	SPI_next_state <= SPI_IDLE;
			when others => report "Unreachable state" severity failure;
		end case;
	end process ; -- SPI_FSM_logic

	SPI_Counter:process(SCLK)
	begin
		if rising_edge(SCLK) then
			if counter_enable = '1' then
				received_data((G_SPI_TRANSACTION_SIZE - 1) - conv_integer(SPI_previous_bit_counter)) <= MOSI;
				SPI_bit_counter <= SPI_bit_counter + 1;
				SPI_previous_bit_counter <= SPI_bit_counter;
			end if;
			if counter_reset = '1' then
				SPI_bit_counter <= (others => '0');
				SPI_previous_bit_counter <= (others => '0');
			end if;
		end if;
	end process SPI_Counter; -- SPI_Counter

end architecture; -- arch