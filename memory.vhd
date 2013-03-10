library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;

entity memory is
    Generic (
        CONTENTS : string := "scripts/instructions.mif"
        );
    Port ( clk : in  STD_LOGIC;
           a1 : in  STD_LOGIC_VECTOR (12 downto 0);
           wd : in  STD_LOGIC_VECTOR (7 downto 0);
           d1 : out  STD_LOGIC_VECTOR (7 downto 0);
           we : in  STD_LOGIC);
end memory;

architecture Behavioral of memory is

impure function init_mem(mif_file_name : in string) return mem_type14 is
    file mif_file : text open read_mode is mif_file_name;
    variable mif_line : line;
    variable temp_bv : bit_vector(13 downto 0);
    variable temp_mem : mem_type14;
    variable i : integer := 0;
begin
        while not endfile(mif_file) loop
            readline(mif_file, mif_line);
            --if not endfile(mif_file) then
            read(mif_line, temp_bv);
            temp_mem(i) := to_stdlogicvector(temp_bv);
            --end if;
            i := i + 1;
        end loop;
        for j in i to mem_type14'length-1 loop
            temp_mem(j) := (others => '0');
        end loop;
    return temp_mem;
end function;

type memtype is array(0 to 2**12) of std_logic_vector(7 downto 0);

signal mem : memtype := init_mem(CONTENTS);
begin

process(clk, we, a1, mem)
begin

if rising_edge(clk) then
    if we = '1' then
        mem(to_integer(unsigned(a1))) <= wd;
    end if;
end if;

d1 <= mem(to_integer(unsigned(a1)));

end process;
end Behavioral;

