--------------------------------------------------------------------------------
-- RELOGIO DE XADREZ
-- Authors: Alexius Maliuk Dias e Felipe Cruz Valiati
--------------------------------------------------------------------------------
library IEEE;
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
    signal enj1, enj2   :   std_logic   :=      '0';
    signal tickj1, tickj2   :   std_logic_vector(15 downto 0);
    
begin

    -- INSTANCIACAO DOS CONTADORES
    contador1 : entity work.temporizador port map ( 
        clock       =>  clock,
        reset       =>  reset,
        load        =>  load,
        en          =>  enj1,
        init_time   =>  init_time,
        cont        =>  tickj1
    );
    contador2 : entity work.temporizador port map ( 
        clock       =>  clock,
        reset       =>  reset,
        load        =>  load,
        en          =>  enj2,
        init_time   =>  init_time,
        cont        =>  tickj2
    );
    -- PROCESSO DE TROCA DE ESTADOS
    process (clock, reset)
        begin
            if reset = '1' then
                EA  <=  IDLE;
            end if;

            if clock'event and clock = '1' then
                EA  <=  PE;
                contj1 <= tickj1;
                contj2 <= tickj2;
            end if;
        end process;

    -- PROCESSO PARA DEFINIR O PROXIMO ESTADO
    process(EA,j1, j2) --<<< Nao esqueca de adicionar os sinais da lista de sensitividade
        begin
            case EA is
                when IDLE =>  
                    if j1 = '1' then
                        PE   <= j1Play;
                        enj1 <= '1';
                        enj2 <= '0';
                    elsif j2 = '1' then
                        PE   <= j2Play;
                        enj1 <= '0';
                        enj2 <= '1';
                    else
                        PE   <= IDLE;
                        enj1 <= '0';
                        enj2 <= '0';
                    end if;
                when j1Play =>
                    if j1 = '1' then
                        PE   <=  j2Play;
                        enj2 <= '1';
                        enj1 <= '0';
                    else
                        PE  <=  j1Play;
                        enj2 <= '0';
                        enj1 <= '1';
                    end if;
                when j2Play =>
                    if j2 = '1' then
                        PE  <=  j1Play;
                        enj2 <= '0';
                        enj1 <= '1';
                    else
                        PE  <=  j2Play;
                        enj2 <= '1';
                        enj1 <= '0';
                    end if;
                when others =>
                        PE  <= IDLE;
            end case;
        end process;

    -- ATRIBUICAO COMBINACIONAL DOS SINAIS INTERNOS E SAIDAS - Dica: faca uma maquina de Moore, desta forma os sinais dependem apenas do estado atual!!
    process(EA, tickj1, tickj2)
    begin
        winj1   <=  '0';
        winj2   <=  '0';

        case EA is
            when IDLE =>
                winj1   <=  '0';
                winj2   <=  '0';
            when j1Play =>
                if tickj1 = x"0000" then
                    winj2 <= '1';
                    winj1 <= '0';
                end if;
            when j2Play =>
                if tickj2 = x"0000" then
                    winj2 <= '0';
                    winj1 <= '1';
                end if;
            when others =>
                winj1   <=  '0';
                winj2   <=  '0';
        end case;
    end process;
end relogio_xadrez;