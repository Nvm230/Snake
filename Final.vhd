library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.SnakePackage.all;
use IEEE.NUMERIC_STD.ALL;

entity SnakeGameSystem is
    Port (

        reset : in STD_LOGIC;
        start_button : in STD_LOGIC;
        left_button : in STD_LOGIC;
        right_button : in STD_LOGIC;
        pause_button : in STD_LOGIC;
        score_output : out IntArray(0 to 3);  -- Asumiendo que IntArray es un array de 4 elementos
        snake_display : out STD_LOGIC_VECTOR (7 downto 0)  -- Ejemplo de cómo podrías querer visualizar la serpiente o algo similar
    );
end SnakeGameSystem;

architecture Structural of SnakeGameSystem is

    -- Signal declarations
    signal clock : std_logic;
    signal snake_x, snake_y : IntArray(0 to 15);
    signal apple_position : std_logic_vector(5 downto 0);
    signal score : IntArray(3 downto 0);
    signal random_num : std_logic_vector(5 downto 0);
    signal ssd_anodes: std_logic_vector(3 downto 0);
    signal ssd_cathodes : std_logic_vector(6 downto 0);
    signal pause_button1 : bit;
    signal anodes: std_logic_vector(3 downto 0);
    signal anodes1: std_logic_vector(7 downto 0);
    signal cathodes : std_logic_vector(6 downto 0);
    signal cathodes1 : std_logic_vector(7 downto 0);
signal counter0 : std_logic_vector(10 downto 0);
signal counter1 : std_logic_vector(2 downto 0);  -- 3 bits, indexado de 2 a 0
signal counter2 : std_logic_vector(3 downto 0);  -- 4 bits, indexado de 3 a 0

    -- Component Declarations
    component Snake
        port (
            clock : in std_logic;
            SNAKEX : out IntArray;
            SNAKEY : out IntArray;
            ResetButton : in std_logic;
            StartButton : in std_logic;
            RightButton : in std_logic;
            LeftButton : in std_logic;
            Apple : out std_logic_vector;
            Pause : in std_logic;
            Score : out IntArray
        );
    end component;

component SSD
    port (
        clock : in std_logic;
        anodes : out std_logic_vector(3 downto 0); -- Esto debería ser para 7 bits si se conecta a una señal de 7 bits
        cathodes : out std_logic_vector(6 downto 0);
        Score : in IntArray
    );
end component;


    component Random
        port (
            clock : in std_logic;
            random_num : out std_logic_vector
        );
    end component;

    component ClockDivider
   Port ( clock : in  STD_LOGIC;
           counter0 : out  STD_LOGIC_vector(10 downto 0);
			  counter2 : out std_logic_vector(3 downto 0);
			  counter1 : out std_logic_vector(2 downto 0));
end component;

    component Display
       Port ( clock : in STD_LOGIC;
			  CATHODES : out STD_LOGIC_VECTOR(7 downto 0);
			  ANODES : out STD_LOGIC_VECTOR(7 downto 0);
			  SSDanodes  : out STD_LOGIC_VECTOR(3 downto 0);
			  SSDcathodes : out STD_LOGIC_VECTOR(6 downto 0);
			  ResetButton : in std_logic ;
			  StartButton : in std_logic ;
			  RightButton : in std_logic ;
			  LeftButton : in std_logic ;
			  Pause : in bit);
    end component;

    -- Component Instantiations
    begin
    
  
    
    SSD_Display : SSD port map (
    clock => clock,
    anodes => anodes, -- Esta señal debe ser std_logic_vector(6 downto 0)
    cathodes => cathodes,
    Score => score
);

    
        GameLogic : Snake port map (
            clock => clock,
            SNAKEX => snake_x,
            SNAKEY => snake_y,
            ResetButton => reset,
            StartButton => start_button,
            RightButton => right_button,
            LeftButton => left_button,
            Apple => apple_position,
            Pause => pause_button,
            Score => score
        );

        RandomGenerator : Random port map (
            clock => clock,
            random_num => random_num
        );

       ClockGenerator : ClockDivider port map (
    clock => clock,
    counter0 => counter0,
    counter1 => counter1,
    counter2 => counter2
);
       -- Para el display de SSD
ScoreDisplay : SSD port map (
    clock => clock,
    anodes => ssd_anodes,  -- Asegúrate de que esto es correcto
    cathodes => ssd_cathodes,
    Score => score
);

-- Para otro display que podría estar usando 'anodes'
MainDisplay : Display port map (
    clock => clock,
    CATHODES => cathodes1,  -- Asegúrate de que las conexiones son correctas
    ANODES => anodes1,      -- Verifica que 'anodes' aquí está correctamente utilizado
    SSDanodes => ssd_anodes,
    SSDcathodes => ssd_cathodes,
    ResetButton => reset,
    StartButton => start_button,
    RightButton => right_button,
    LeftButton => left_button,
    Pause => pause_button1
);

end Structural;
