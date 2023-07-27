library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FIR_Filter is
    generic(
        FILTER_TAPS  : integer := 60; -- How many multiplications have this FIR
        INPUT_WIDTH  : integer range 8 to 25 := 24; -- Width bits of the INPUTS 
        COEFF_WIDTH  : integer range 8 to 18 := 16; -- Width bits of the Coeff 
        OUTPUT_WIDTH : integer range 8 to 43 := 24 -- Width bits of the OUTPUT (can be less then INPUT_WIDTH + COEFF_WIDTH)
    );
    port (
        i_clk       : in STD_LOGIC;
        i_reset_n   : in STD_LOGIC;
        i_data_i    : in std_logic_vector(INPUT_WIDTH - 1 downto 0);
        o_data_o    : out std_logic_vector(OUTPUT_WIDTH - 1 downto 0)
    );
end entity FIR_Filter;

architecture Behavioral of FIR_Filter is

    constant MAC_WIDTH : integer := COEFF_WIDTH+INPUT_WIDTH;
    
    ------------------------------------------------------------------------------------------- Registers
    type input_registers is array(0 to FILTER_TAPS-1) of signed(INPUT_WIDTH-1 downto 0); -- First Register for Broadcast input data
    signal areg_s  : input_registers := (others=>(others=>'0'));

    type mult_registers is array(0 to FILTER_TAPS-1) of signed(MAC_WIDTH-1 downto 0); -- Registers after mult with coeff 
    signal mreg_s : mult_registers := (others=>(others=>'0'));

    type dsp_registers is array(0 to FILTER_TAPS-1) of signed(MAC_WIDTH-1 downto 0); -- Registers after each DSP adder 
    signal preg_s : dsp_registers := (others=>(others=>'0'));

    type coeff_registers is array(0 to FILTER_TAPS-1) of signed(COEFF_WIDTH-1 downto 0);  -- Registers between ROM and mult
    signal breg_s : coeff_registers := (others=>(others=>'0'));

    signal dout_s : std_logic_vector(MAC_WIDTH-1 downto 0);
    signal sign_s : signed(MAC_WIDTH-INPUT_WIDTH-COEFF_WIDTH+1 downto 0) := (others=>'0'); -- ???????????

    

    ------------------------------------------------------------------------------------------- ROM Coefficients
    type coefficients is array (0 to FILTER_TAPS-1) of signed(COEFF_WIDTH-1 downto 0);
    signal coeff_s: coefficients :=( 
    -- 500Hz Blackman LPF
    x"0000", x"0001", x"0005", x"000C", 
    x"0016", x"0025", x"0037", x"004E", 
    x"0069", x"008B", x"00B2", x"00E0", 
    x"0114", x"014E", x"018E", x"01D3", 
    x"021D", x"026A", x"02BA", x"030B", 
    x"035B", x"03AA", x"03F5", x"043B", 
    x"047B", x"04B2", x"04E0", x"0504", 
    x"051C", x"0528", x"0528", x"051C", 
    x"0504", x"04E0", x"04B2", x"047B", 
    x"043B", x"03F5", x"03AA", x"035B", 
    x"030B", x"02BA", x"026A", x"021D", 
    x"01D3", x"018E", x"014E", x"0114", 
    x"00E0", x"00B2", x"008B", x"0069", 
    x"004E", x"0037", x"0025", x"0016", 
    x"000C", x"0005", x"0001", x"0000");



begin
    
    -- Coefficient formatting
    Coeff_Array: for i in 0 to FILTER_TAPS-1 generate
        Coeff: for n in 0 to COEFF_WIDTH-1 generate
            Coeff_Sign: if n > COEFF_WIDTH-2 generate
                breg_s(i)(n) <= coeff_s(i)(COEFF_WIDTH-1);
            end generate;
            Coeff_Value: if n < COEFF_WIDTH-1 generate
                breg_s(i)(n) <= coeff_s(i)(n);
            end generate;
        end generate;
    end generate;

    -- Connect the last Register to OUTPUT
    o_data_o <= std_logic_vector(preg_s(0)(MAC_WIDTH-2 downto MAC_WIDTH-OUTPUT_WIDTH-1));         


    process(i_clk)
    begin

    if rising_edge(i_clk) then

        if (i_reset_n = '0') then
            for i in 0 to FILTER_TAPS-1 loop -- Reset all Registers
                areg_s(i) <=(others=> '0');
                mreg_s(i) <=(others=> '0');
                preg_s(i) <=(others=> '0');
            end loop;

        elsif (i_reset_n = '1') then        
            for i in 0 to FILTER_TAPS-1 loop
                for n in 0 to INPUT_WIDTH-1 loop
                    if n > INPUT_WIDTH-2 then
                        areg_s(i)(n) <= i_data_i(INPUT_WIDTH-1); 
                    else
                        areg_s(i)(n) <= i_data_i(n);              
                    end if;
                end loop;
                
                if (i < FILTER_TAPS-1) then
                    mreg_s(i) <= areg_s(i)*breg_s(i);         
                    preg_s(i) <= mreg_s(i) + preg_s(i+1);

                elsif (i = FILTER_TAPS-1) then
                    mreg_s(i) <= areg_s(i)*breg_s(i); 
                    preg_s(i)<= mreg_s(i);
                end if;
            end loop; 
        end if;

    end if;
    end process;
    
end architecture Behavioral;