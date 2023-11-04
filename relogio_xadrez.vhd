--------------------------------------------------------------------------------
-- RELOGIO DE XADREZ
-- Authors: Alexius Maliuk Dias e Felipe Cruz Valiati
--------------------------------------------------------------------------------
library IEEE;
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library work;

entity relogio_xadrez is
    port( 
        j1, j2, clock, load, reset  :   in  std_logic;
        init_time                   :   in  std_logic_vector(7 downto 0);
        contj1, contj2              :   out std_logic_vector(15 downto 0);
        winj1, winj2                :   out std_logic
    );
end relogio_xadrez;

architecture relogio_xadrez of relogio_xadrez is
    -- DECLARACAO DOS ESTADOS
    type states is (IDLE, j1Play, j2Play);
    signal EA, PE : states; --EA = Estado Atual // PE = Próximo Estado
    signal enj1, enj2   :   std_logic;
    
begin

    -- INSTANCIACAO DOS CONTADORES
    contador1 : entity work.temporizador port map ( 
        clock       => clock,
        reset       =>  reset,
        load        =>  load,
        en          =>  enj1,
        init_time   =>  init_time,
        cont        =>  contj1
    );
    contador2 : entity work.temporizador port map ( 
        clock       =>  clock,
        reset       =>  reset,
        load        =>  load,
        en          =>  enj2,
        init_time   =>  init_time,
        cont        =>  contj1
    );
    -- PROCESSO DE TROCA DE ESTADOS
    process (clock, reset)
        begin
            
            

        end process;

    -- PROCESSO PARA DEFINIR O PROXIMO ESTADO
    process ( ) --<<< Nao esqueca de adicionar os sinais da lista de sensitividade
        begin
            case EA is
                
                --COMPLETAR O CASE PARA CADA UM DOS ESTADOS DA SUA MAQUINA

            end case;
        end process;

    
    -- ATRIBUICAO COMBINACIONAL DOS SINAIS INTERNOS E SAIDAS - Dica: faca uma maquina de Moore, desta forma os sinais dependem apenas do estado atual!!
    

end relogio_xadrez;


