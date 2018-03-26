library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity image1 is
    port
    (
        x : in std_logic_vector(9 downto 0);
        y : in std_logic_vector(8 downto 0);
        rgb : out std_logic_vector(2 downto 0)
    );
end image1;

architecture image1_arch of image1 is
    signal xint : integer range 0 to 640;
    signal yint : integer range 0 to 480;
begin
    process (x, y)
    begin        rgb(2) <= '0';
        rgb(1) <= '0';
        rgb(0) <= '1';
    end process;
    
    xint <= to_integer(unsigned(x));
    yint <= to_integer(unsigned(y));
end image1_arch;