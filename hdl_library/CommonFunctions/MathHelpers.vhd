library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

package MathHelpers is

function log2(A : integer) return integer;
function isPow2(A : integer) return boolean;
function max(A, B : integer) return integer;
function max(A, B : std_logic_vector) return std_logic_vector;
function min(A, B : integer) return integer;
function min(A, B : std_logic_vector) return std_logic_vector;
function abs_std_logic_vector(arg: std_logic_vector) return std_logic_vector;

end package MathHelpers;

package body MathHelpers is

	function log2(A : integer) return integer is
	begin
		for I in 1 to 30 loop
			if (2**I >= A) then
				return(I);
			end if;
		end loop;
		return(30);
	end function log2;
	-------------------------------------------------------------------------------

	-- return true if an integer nuber is a power of 2
	function isPow2(x : integer) return boolean is
	begin
		-- Works for up to 32 bit integers
		if
			x = 1 or x = 2 or x = 4 or x = 8 or x = 16 or x = 32 or
			x = 64 or x = 128 or x = 256 or x = 512 or x = 1024 or
			x = 2048 or x = 4096 or x = 8192 or x = 16384 or
			x = 32768 or x = 65536 or x = 131072 or x = 262144 or
			x = 524288 or x = 1048576 or x = 2097152 or
			x = 4194304 or x = 8388608 or x = 16777216 or
			x = 33554432 or x = 67108864 or x = 134217728 or
			x = 268435456 or x = 536870912 or x = 1073741824 
		then
			report "Argument is a power of 2" severity NOTE;
			return true;
		else
			report "Argument is not a power of 2" severity NOTE;
			return false;
		end if;
	end function isPow2;
	-------------------------------------------------------------------------------

	-------------------------------------------------------------------------------
	function max(A, B : integer) return integer is
	begin
		if B > A then
			return B;
		end if;
		return A;
	end function max;
	-------------------------------------------------------------------------------

	-------------------------------------------------------------------------------
	function max(A, B : std_logic_vector) return std_logic_vector is
	begin
		if B > A then
			return B;
		end if;
		return A;
	end function max;
	-------------------------------------------------------------------------------

	-------------------------------------------------------------------------------
	function min(A, B : integer) return integer is
	begin
		if B > A then
			return A;
		end if;
		return B;
	end function min;
	-------------------------------------------------------------------------------

	-------------------------------------------------------------------------------
	function min(A, B : std_logic_vector) return std_logic_vector is
	begin
		if B > A then
			return A;
		end if;
		return B;
	end function min;
	-------------------------------------------------------------------------------

	-------------------------------------------------------------------------------
	function abs_std_logic_vector(arg: std_logic_vector) return std_logic_vector is
	variable Result: signed(arg'length-1 downto 0);
	begin
		Result := signed(arg);
		if Result(Result'left) = '1' then
		  Result := -Result;
		end if;
		return std_logic_vector(Result);
	end function;

end package body MathHelpers;