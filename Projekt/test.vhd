library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_driver is
    port
    (
        rgb : in std_logic_vector(2 downto 0);      --wartosc koloru do przekazania na piksel
        clk_50 : in std_logic;                      --Zegar dzia³aj¹cy w 50MHz
        vga_r : out std_logic;                      --linia koloru (czerwony)
        vga_g : out std_logic;                      --linia koloru (zielony)
        vga_b : out std_logic;                      --linia koloru (niebieski)
        vga_hs : out std_logic;                     --impuls synchronizacji poziomej
        vga_vs : out std_logic;                     --impuls synchronizacji pionowej
        pix_x : out std_logic_vector(9 downto 0);   --wspolrzednie aktualnie wyswietlanego piksela (x)
        pix_y : out std_logic_vector(8 downto 0)    --wspolrzednie aktualnie wyswietlanego piksela (y)
    );
end vga_driver;

architecture driver_arch of vga_driver is
    signal clk_25 : std_logic; --Zegar dzia³aj¹cy w 25MHz

    --informajce z pdf'a
    --http://antoni.sterna.staff.iiar.pwr.wroc.pl/ucsw/vga_driver.pdf
    signal xcounter : integer range 0 to 799;  
    signal ycounter : integer range 0 to 520;  
begin
    process (clk_50)    --generujemy wewnêtrzny sygna³ 25MHz
    begin
        if rising_edge(clk_50) then
            clk_25 <= not clk_25;
        end if;
    end process;
    
    process (clk_25)
    begin
        if rising_edge(clk_25) then
            if xcounter = 799 then
                xcounter <= 0;
                if ycounter = 520 then
                    ycounter <= 0;
                else
                    ycounter <= ycounter + 1;
                end if;
            else
                xcounter <= xcounter + 1;
            end if;
        end if;
    end process;
    
    --front porch+pulse width
    --"Information cannot be displayed during these times"
    --informacje pobrane z tabeli na stronie 58
    --http://antoni.sterna.staff.iiar.pwr.wroc.pl/ucsw/ug230.pdf
    vga_hs <= '0' when xcounter >= 16 and xcounter < 112 else '1';   --16+96
    vga_vs <= '0' when ycounter >= 10 and ycounter < 12 else '1';    --10+2


    process (xcounter, ycounter, rgb)
    begin
        --dalej lecimy z tabelki
        --trzeba odj¹æ od ca³ego display i policzyæ wartoœci
        if xcounter < 160 or ycounter < 41 then
            vga_r <= '0';
            vga_g <= '0';
            vga_b <= '0';
        else
            vga_r <= rgb(2);
            vga_g <= rgb(1);
            vga_b <= rgb(0);
        end if;
    end process;
    
    process (xcounter)
    begin
        if xcounter >= 160 then
            pix_x <= std_logic_vector(to_unsigned(xcounter - 160, pix_x'length));
        else
        pix_x <= std_logic_vector(to_unsigned(640, pix_x'length));
        end if;
    end process;
    
    process (ycounter)
    begin
        if ycounter >= 41 then
            pix_y <= std_logic_vector(to_unsigned(ycounter - 41, pix_y'length));
        else
            pix_y <= std_logic_vector(to_unsigned(480, pix_y'length));
        end if;
    end process;
end driver_arch;