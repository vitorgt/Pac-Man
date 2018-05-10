-- *************************************************
-- JOGO : PacMan
-- INSTRUCOES:
-- As teclas W movimenta o pacman para cima ,S  para baixo
-- A tecla D movimeta o pacman para o lado direito e o A para o lado esquerdo
-- *************************************************
library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY notepad IS

	PORT(
		clkvideo, clk, reset  : IN	STD_LOGIC;		
		videoflag	: out std_LOGIC;
		vga_pos		: out STD_LOGIC_VECTOR(15 downto 0);
		vga_char		: out STD_LOGIC_VECTOR(15 downto 0);
		
		key			: IN 	STD_LOGIC_VECTOR(7 DOWNTO 0)	-- teclado
		
		);

END  notepad ;

ARCHITECTURE a OF notepad IS

	-- Escreve na tela
	SIGNAL VIDEOE      : STD_LOGIC_VECTOR(7 DOWNTO 0);
	-- Contador de tempo

	-- Pacman
	SIGNAL pacmanpos   : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL pacmanposa  : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL pacmanchar  : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL pacmancor   : STD_LOGIC_VECTOR(3 DOWNTO 0);

	-- Fantasma
	SIGNAL fantasma1_pos     : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL fantasma1_posa     : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL Fantasma_char   : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL fantasma1_cor    : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL INC_horizontal     : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL INC_vertical     : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL SINAL	    : STD_LOGIC_vector(1 DOWNTO 0);
	
	SIGNAL fantasma2_pos     : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL fantasma2_posa     : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL fantasma2_cor    : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL SINAL2	    : STD_LOGIC_vector(1 DOWNTO 0);
	
	SIGNAL fantasma3_pos     : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL fantasma3_posa     : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL fantasma3_cor    : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL SINAL3	    : STD_LOGIC_vector(2 DOWNTO 0);
	
	SIGNAL mapa : STD_LOGIC_VECTOR(1199 DOWNTO 0);
	SIGNAL MAPA_CHAR : STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	--Mapa
	SIGNAL LABIRINTO	 :	STD_LOGIC_VECTOR(1199 downto 0);
	SIGNAL YOU_WIN : STD_LOGIC_VECTOR(1199 DOWNTO 0);
	
	SIGNAL DELAY1      : STD_LOGIC_VECTOR(31 DOWNTO 0);
	--Delay da Fantasma
	SIGNAL DELAY2      : STD_LOGIC_VECTOR(31 DOWNTO 0); --fantasma 1
	SIGNAL DELAY3      : STD_LOGIC_VECTOR(31 DOWNTO 0); --fantasma 2
	SIGNAL DELAY4      : STD_LOGIC_VECTOR(31 DOWNTO 0); --fantasma 3

	SIGNAL pacmanestado : STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	SIGNAL Pontuacao 		: std_logic_vector(1199 downto 0);
	--Estados da Bolinha;
	SIGNAL F1_ESTADO     : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL F2_ESTADO     : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL F3_ESTADO     : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN

PROCESS (clk, reset)
	
	BEGIN
		
	IF RESET = '1' THEN
		LABIRINTO <= "111111111111111111111111111111111111111111111000000000000000000000000000000111111111101111111111110110111111111111011111111110111111111111011011111111111101111111111000000011000001100000110000000111111111111101101101111111111011011011111111111111110110110111111111101101101111111111111000011000000000000000000110000111111111101111101111110110111111011111011111111110111110111111011011111101111101111111111000000000000001100000000000000111111111101111101101111111111011011111011111111110111110110111111111101101111101111111111011111011000000000000110111110111111111100000000001111111111000000000011111111110111110110111111111101101111101111111111000000000011111111110000000000111111111101111101101111111111011011111011111111110111110110000000000001101111101111111111011111011111101101111110111110111111111100000001111110110111111000000011111111110111110110000011000001101111101111111111011111011011111111110110111110111111111101111101101111111111011011111011111111110000000000000000000000000000001111111111011111011111101101111110111110111111111101111101111110110111111011111011111111110111110111111011011111101111101111111111000000000000001100000000000000111111111111111111111111111111111111111111111";
		Pontuacao <= "111111111111111111111111111111111111111111111000000000000000000000000000000111111111101111111111110110111111111111011111111110111111111111011011111111111101111111111000000011000001100000110000000111111111111101101101111111111011011011111111111111110110110111111111101101101111111111111000011000000000000000000110000111111111101111101111110110111111011111011111111110111110111111011011111101111101111111111000000000000001100000000000000111111111101111101101111111111011011111011111111110111110110111111111101101111101111111111011111011000000000000110111110111111111100000000001111111111000000000011111111110111110110111111111101101111101111111111000000000011111111110000000000111111111101111101101111111111011011111011111111110111110110000000000001101111101111111111011111011111101101111110111110111111111100000001111110110111111000000011111111110111110110000011000001101111101111111111011111011011111111110110111110111111111101111101101111111111011011111011111111110000000000000000000000000000001111111111011111011111101101111110111110111111111101111101111110110111111011111011111111110111110111111011011111101111101111111111000000000000001100000000000000111111111111111111111111111111111111111111111";
		Pacmanchar <= "00000011";
		Pacmancor <= x"B"; -- 1010 verde
		pacmanpos <= x"00DB";
		DELAY1 <= x"00000000";
		pacmanestado <= x"00";
		
	ELSIF (clk'event) and (clk = '1') THEN
		CASE pacmanestado IS
			WHEN x"00" => -- Estado movimenta Sapo segundo Teclado
			
				CASE key IS
					WHEN x"73" => -- (S) BAIXO
						IF (pacmanpos < 1159 AND LABIRINTO(conv_integer(pacmanpos) + 40) = '0') THEN   -- nao esta' na ultima linha
							pacmanpos <= pacmanpos + x"28";
							pacmanchar <= "00000111";
						END IF;
					WHEN x"77" => -- (W) CIMA
						IF (pacmanpos > 39 AND LABIRINTO(conv_integer(pacmanpos) - 40) = '0') THEN   -- nao esta' na primeira linha
							pacmanpos <= pacmanpos - x"28";
							pacmanchar <= "00000110";
						END IF;
					WHEN x"61" => -- (A) ESQUERDA
						IF (NOT((conv_integer(pacmanpos) MOD 40) = 0) AND LABIRINTO(conv_integer(pacmanpos) - 1) = '0') THEN   -- nao esta' na extrema esquerda
							pacmanpos <= pacmanpos - x"01";
							pacmanchar <= "00000101";
						END IF;
					WHEN x"64" => -- (D) DIREITA
						IF (NOT((conv_integer(pacmanpos) MOD 40) = 39) AND LABIRINTO(conv_integer(pacmanpos) + 1) = '0') THEN   -- nao esta' na extrema direita
							pacmanpos <= pacmanpos + x"01";
							pacmanchar <= "00000011";
						END IF;
					WHEN OTHERS =>
				END CASE;
				pacmanestado <= x"01";
				pontuacao(conv_integer(pacmanpos)) <= '1';
			
			WHEN x"01" => -- Delay para movimentar Pacman
			 
				IF DELAY1 >= x"00001FFF" THEN
					DELAY1 <= x"00000000";
					pacmanestado <= x"00";
				ELSE
					DELAY1 <= DELAY1 + x"01";
				END IF;
				
			WHEN OTHERS =>
		END CASE;
	END IF;

END PROCESS;

--Fantasma 1
PROCESS (clk, reset)

BEGIN
		
	IF RESET = '1' THEN
		Fantasma_char <= "00000100";
		fantasma1_cor <= "1001"; -- 1001 Vermelho
		fantasma1_pos <= x"002D"; --fantas 1 pos inicial
		INc_vertical <= x"28";
		INc_horizontal <= x"01";
		SINAL <= "00";	
		DELAY2 <= x"00000000";
		F1_ESTADO <= x"00";
		
	ELSIF (clk'event) and (clk = '1') THEN
				CASE F1_ESTADO iS
					WHEN x"00" =>
						-- INCREMENTA O FANTASMA 1
							IF (SINAL = "00") THEN 
								fantasma1_pos <= fantasma1_pos + inc_vertical;
							ELSif(SINAL = "01") then
								fantasma1_pos <= fantasma1_pos + INC_horizontal; 
							elsIF(SINAL = "10")THEN
								fantasma1_pos <= fantasma1_pos - inc_vertical;
							ELSE
								fantasma1_pos <= fantasma1_pos - inc_horizontal;
							END IF;
							F1_ESTADO  <= x"01";
					WHEN x"01" =>
						IF(fantasma1_pos = x"02FD") THEN
							SINAL <= "01";
						ELSIF(fantasma1_pos = x"0303")THEN
							sinal <= "10";
						ELSif(fantasma1_pos = x"0033") THEN
							sinal <= "11";
						ELSIF(fantasma1_pos = x"002D")THEN
							sinal <= "00";
						END IF;		
						F1_ESTADO  <= x"FF";

					WHEN x"FF" =>  -- Delay da Fantasma 1
						IF DELAY2 >= x"0000FFFF" THEN 
							DELAY2 <= x"00000000";
							F1_ESTADO  <= x"00";
						ELSE
							DELAY2 <= DELAY2 + x"01";
						END IF;
					WHEN OTHERS =>
						F1_ESTADO <= x"00";
					
				END CASE;		
	END IF;
	
END PROCESS;

--Fantassma 2
PROCESS (clk, reset)

BEGIN
		
	IF RESET = '1' THEN
		fantasma2_cor <= x"B"; -- 1001 Vermelho
		fantasma2_pos <= x"01C6"; --fantas 2 pos inicial
		SINAL2 <= "00";	
		DELAY3 <= x"00000000";
		F2_ESTADO <= x"00";
		
	ELSIF (clk'event) and (clk = '1') THEN
				CASE F2_ESTADO iS
					WHEN x"00" =>
						-- INCREMENTA O FANTASMA 1
							IF (SINAL2 = "00") THEN 
								fantasma2_pos <= fantasma2_pos + inc_horizontal;
							ELSif(SINAL2 = "01") then
								fantasma2_pos <= fantasma2_pos + INC_vertical; 
							elsIF(SINAL2 = "10")THEN
								fantasma2_pos <= fantasma2_pos - inc_horizontal;
							ELSE
								fantasma2_pos <= fantasma2_pos - inc_vertical;
							END IF;
							F2_ESTADO  <= x"01";
					WHEN x"01" =>
						IF(fantasma2_pos = x"01D1") THEN
							SINAL2 <= "01";
						ELSIF(fantasma2_pos = x"0299")THEN
							sinal2 <= "10";
						ELSif(fantasma2_pos = x"028E") THEN
							sinal2 <= "11";
						ELSIF(fantasma2_pos = x"01C6")THEN
							sinal2 <= "00";
						END IF;		
						F2_ESTADO  <= x"FF";

					WHEN x"FF" =>  -- Delay da Fantasma 1
						IF DELAY3 >= x"00005FFF" THEN 
							DELAY3 <= x"00000000";
							F2_ESTADO  <= x"00";
						ELSE
							DELAY3 <= DELAY3 + x"01";
						END IF;
					WHEN OTHERS =>
						F2_ESTADO <= x"00";
					
				END CASE;		
	END IF;
	
END PROCESS;

--Fantassma 3
PROCESS (clk, reset)
BEGIN
		
	IF RESET = '1' THEN
		fantasma3_cor <= x"6"; -- 6 cyan
		fantasma3_pos <= x"0386"; --fantas 3 pos inicial
		SINAL3 <= "000";	
		DELAY4 <= x"00000000";
		F3_ESTADO <= x"00";
		
	ELSIF (clk'event) and (clk = '1') THEN
				CASE F3_ESTADO iS
					WHEN x"00" =>
						-- INCREMENTA O FANTASMA 1
							IF (SINAL3 = "000") THEN 
								fantasma3_pos <= fantasma3_pos - inc_horizontal;
							ELSif(SINAL3 = "001") then
								fantasma3_pos <= fantasma3_pos + inc_vertical;
							elsIF(SINAL3 = "010")THEN
								fantasma3_pos <= fantasma3_pos - inc_horizontal;
							elsIF(SINAL3 = "011")THEN
								fantasma3_pos <= fantasma3_pos + inc_vertical;
							elsIF(SINAL3 = "100")THEN
								fantasma3_pos <= fantasma3_pos + inc_horizontal;
							elsIF(SINAL3 = "101")THEN
								fantasma3_pos <= fantasma3_pos - inc_vertical;
							elsIF(SINAL3 = "110")THEN
								fantasma3_pos <= fantasma3_pos - inc_horizontal;
							ELSE
								fantasma3_pos <= fantasma3_pos - inc_vertical;
							END IF;
							F3_ESTADO  <= x"01";
					WHEN x"01" =>
						IF(fantasma3_pos = x"037B") THEN
							SINAL3 <= "001";
						ELSIF(fantasma3_pos = x"03F3")THEN
							sinal3 <= "010";
						ELSif(fantasma3_pos = x"03ED") THEN
							sinal3 <= "011";
						ELSIF(fantasma3_pos = x"0465")THEN
							sinal3 <= "100";
						ELSIF(fantasma3_pos = x"0482")THEN
							sinal3 <= "101";
						ELSIF(fantasma3_pos = x"040A")THEN
							sinal3 <= "110";
						ELSIF(fantasma3_pos = x"0404")THEN
							sinal3 <= "111";
						ELSIF(fantasma3_pos = x"038C")THEN
							sinal3 <= "000";
						END IF;		
						F3_ESTADO  <= x"FF";

					WHEN x"FF" =>  -- Delay da Fantasma 3
						IF DELAY4 >= x"00004FFF" THEN 
							DELAY4 <= x"00000000";
							F3_ESTADO  <= x"00";
						ELSE
							DELAY4 <= DELAY4 + x"01";
						END IF;
					WHEN OTHERS =>
						F3_ESTADO <= x"00";
					
				END CASE;		
	END IF;
	
END PROCESS;

---- Escreve na Tela
PROCESS (clkvideo, reset)
	variable indice : integer := 0;
	variable position :integer := 0;
	variable curRENT_POS : std_logic_vector(15 downto 0);
	variable aux : boolean := TRUE;
	variable over_char : std_logic_vector(7 downto 0);
	variable over_pos : std_logic_vector(15 downto 0);
	variable over_pos2 : std_logic_vector(15 downto 0);
BEGIN
	IF RESET = '1' THEN
		VIDEOE <= x"01";
		videoflag <= '0';
		pacmanposa <= x"0000";
		Fantasma1_posa <= x"002D";
		CURRENT_POS := x"0000";
		over_char := "00001000";
		over_pos := x"021A";
		over_pos2 := x"0242";
		MAPA_CHAR <= "00000011";
		YOU_WIN <= "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111110000000000000000000000000000000000100000100000000000000000000000000000000100000001000000000000000000100010000000010000000100000000100001010101010100000000010001000000000011000101010010010000000001000100000000001010010101001001000000000100010000000000100101010100100100000000010001000000000010001101010000010000000001000100000000001000010101000001000000000100010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111100111100001000000000000000000000000010010010010000100000000000000000000000001001001001000010000000000000000000000000100100100100001000000000000000000000000010010010010001010000000000000000000000001001001111000101000000000000000000000000000000000000100010000000000000000000000000000000000010001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
		MAPA      <= "111111111111111111111111111111111111111110001000000000000000000000000000000100011000101111111111110110111111111111010001100010111111111111011011111111111101000110001000000011000001100000110000000100011000111101101101111111111011011011110001100011110110110111111111101101101111000110001000011000000000000000000110000100011000101111101111110110111111011111010001100010111110111111011011111101111101000110001000000000000001100000000000000100011000101111101101111111111011011111010001100010111110110111111111101101111101000110001011111011000000000000110111110100011000100000000001111111111000000000010001100010111110110111111111101101111101000110001000000000011111111110000000000100011000101111101100000000000011011111010001100010111110110000011000001101111101000110001011111011111101101111110111110100011000100000001111110110111111000000010001100010111110110000011000001101111101000110001011111011011111111110110111110100011000101111101101111111111011011111010001100010000000000000000000000000000001000110001011111011111101101111110111110100011000101111101111110110111111011111010001100010111110111111011011111101111101000110001000000000000001100000000000000100011111111111111111111111111111111111111111";
		
	ELSIF (clkvideo'event) and (clkvideo = '1') THEN
		
		CASE VIDEOE IS	
		WHEN x"00" =>
			for I in 0 to 1199 loop
				indice := I;
				exit when pontuacao(I) = '0';
			end loop;
			IF(pontuacao(indice) = '0') THEN
				VIDEOE <= x"01";
			ELSE
				VIDEOE <= x"AF";
			END IF;
		WHEN x"01" => --apaga pacman
			IF(pacmanpos = pacmanposa) THEN
				VIDEOE <= x"05";
			ELSE
				vga_char(15 downto 12) <= "0000";
				vga_char(11 downto 8) <= "0000";
				vga_char(7 downto 0) <= "00000000";
				vga_pos(15 downto 0)	<= pacmanposa;
				videoflag <= '1';
				VIDEOE <= x"02";
			END IF;
		WHEN x"02" =>
			videoflag <= '0';
			VIDEOE <= x"03";
		WHEN x"03" => -- Desenha o Pacman
			if(pacmanpos = fantasma1_pos or pacmanpos = fantasma2_pos or pacmanpos = fantasma3_pos)THEN
				videoe <= x"fd";
			ELSE
				vga_char(15 downto 12) <= "0000";
				vga_char(11 downto 8) <= pacmancor;
				vga_char(7 downto 0) <= pacmanchar;
			
				vga_pos(15 downto 0)	<= pacmanpos;
			
				pacmanposa <= pacmanpos;
				videoflag <= '1';
				VIDEOE <= x"04";
			end if;
		WHEN x"04" =>
			videoflag <= '0';
			VIDEOE <= x"05";
		WHEN x"05" => --apaga o fantasma 1
				IF(fantasma1_pos = fantasma1_posa) THEN
					VIDEOE <= x"09";
				ELSE
					IF(pontuacao(conv_integer(fantasma1_pos)) = '0') THEN
						vga_char(15 downto 12) <= "0000";
						vga_char(11 downto 8) <= x"B";
						vga_char(7 downto 0) <= x"20";
						vga_pos(15 downto 0)	<= fantasma1_posa;
					ELSE
						vga_char(15 downto 12) <= "0000";
						vga_char(11 downto 8) <= x"0";
						vga_char(7 downto 0) <= "00000000";
						vga_pos(15 downto 0)	<= fantasma1_posa;
					END IF;
					videoflag <= '1';
					VIDEOE <= x"06";
				END IF;
		WHEN x"06" =>
			videoflag <= '0';
			VIDEOE <= x"07";
		WHEN x"07" => --desenha o fantasma 1
			IF(pacmanpos = fantasma1_pos or pacmanpos = fantasma2_pos or pacmanpos = fantasma3_pos)THEN
				videoe <= x"fd";
			ELSE
				vga_char(15 downto 12) <= "0000";
				vga_char(11 downto 8) <= x"9";
				vga_char(7 downto 0) <= fantasma_char;
				vga_pos(15 downto 0)	<= fantasma1_pos;
				
				fantasma1_posa <= fantasma1_pos;
				videoflag <= '1';
				VIDEOE <= x"08";
				end if;
		WHEN x"08" =>
			videoflag <= '0';
			VIDEOE <= x"09";
		WHEN x"09" => --apaga o fantasma 2
			IF(fantasma2_pos = fantasma2_posa) THEN
				VIDEOE <= x"0C";
			ELSE
				IF(pontuacao(conv_integer(fantasma2_pos)) = '0') THEN
					vga_char(15 downto 12) <= "0000";
					vga_char(11 downto 8) <= x"B";
					vga_char(7 downto 0) <= x"20";
					vga_pos(15 downto 0)	<= fantasma2_posa;
				ELSE
					vga_char(15 downto 12) <= "0000";
					vga_char(11 downto 8) <= x"0";
					vga_char(7 downto 0) <= "00000000";
					vga_pos(15 downto 0)	<= fantasma2_posa;
				END IF;
					videoflag <= '1';
					VIDEOE <= x"0A";
			END IF;
		WHEN x"0A" =>
			videoflag <= '0';
			VIDEOE <= x"0B";
		WHEN x"0B" => --desenha o fantasma 2
			IF(pacmanpos = fantasma1_pos or pacmanpos = fantasma2_pos or pacmanpos = fantasma3_pos)THEN
				videoe <= x"fd";	
			ELSE
				vga_char(15 downto 12) <= "0000";
				vga_char(11 downto 8) <= x"B";
				vga_char(7 downto 0) <= fantasma_char;
				vga_pos(15 downto 0)	<= fantasma2_pos;
				
				fantasma2_posa <= fantasma2_pos;
				videoflag <= '1';
				VIDEOE <= x"0C";
			end if;
		WHEN x"0C" =>
			videoflag <= '0';
			VIDEOE <= x"0D";	
		WHEN x"0D" => --apaga o fantasma 3
			IF(fantasma3_pos = fantasma3_posa) THEN
				VIDEOE <= x"10";
			ELSE
				IF(pontuacao(conv_integer(fantasma3_pos)) = '0') THEN
					vga_char(15 downto 12) <= "0000";
					vga_char(11 downto 8) <= x"B";
					vga_char(7 downto 0) <= x"20";
					vga_pos(15 downto 0)	<= fantasma3_posa;
				ELSE
					vga_char(15 downto 12) <= "0000";
					vga_char(11 downto 8) <= x"0";
					vga_char(7 downto 0) <= "00000000";
					vga_pos(15 downto 0)	<= fantasma3_posa;
				END IF;
					videoflag <= '1';
					VIDEOE <= x"0E";
			END IF;
		WHEN x"0E" =>
			videoflag <= '0';
			VIDEOE <= x"0F";
		WHEN x"0F" => --desenha o fasntasma 3
			IF(pacmanpos = fantasma1_pos or pacmanpos = fantasma2_pos or pacmanpos = fantasma3_pos)THEN
				videoe <= x"fd";
			ELSE
				vga_char(15 downto 12) <= "0000";
				vga_char(11 downto 8) <= x"E";
				vga_char(7 downto 0) <= fantasma_char;
				vga_pos(15 downto 0)	<= fantasma3_pos;
	
				fantasma3_posa <= fantasma3_pos;
				videoflag <= '1';
				VIDEOE <= x"10";
			end if;
		WHEN x"10" =>
			videoflag <= '0';
			VIDEOE <= x"00";	
		WHEN x"fd" => --escreve game over
				vga_char(15 downto 12) <= "0000";
				vga_char(11 downto 8) <= x"9";
				vga_char(7  DOwnTO 0) <= over_char;
				vga_pos(15 downto 0) <= over_pos;
				videoflag <= '1';
				over_pos := over_pos + x"01";
				over_char := over_char + x"01";
				if(over_pos = x"021E")THEN
					VIDEOE <= x"CC"; -- chama cf
				ELSE
					videoe <= x"CB"; -- chama fd
				END IF;
		WHEN x"CF" =>
			vga_char(15 downto 12) <= "0000";
			vga_char(11 downto 8) <= x"9";
			vga_char(7  DOwnTO 0) <= over_char;
			vga_pos(15 downto 0) <= over_pos2;
			videoflag <= '1';
			over_pos2 := over_pos2 + x"01";
			over_char := over_char + x"01";
			if(over_pos2 = x"0246")THEN
				VIDEOE <= x"fa";
			ELSE
				videoe <= x"CC";
			END IF;
		WHEN x"CB" =>
			videoflag <= '0';
			VIDEOE <= x"fd";
		WHEN x"CC" =>
			videoflag <= '0';
			VIDEOE <= x"CF";
		WHEN x"AF" => --desenhe you win
			if(position = 1200) then
				videoe <= x"fa";
			else
				vga_char(15 downto 12) <= "0000";
				if(you_WIN(position) = '0') then
					vga_char(11 downto 8) <= x"b";
				else
					vga_char(11 downto 8) <= x"0";
				end if;
					vga_char(7 downto 0) <= "00000011";
					vga_pos(15 downto 0)	<= CURRENT_POS;
					videoflag <= '1';
					position := position + 1;
					curRENT_POS := curRENT_POS + x"01";
					vidEOE <= x"Bf";
			end if;
		WHEN x"Bf" =>
			videoflag <= '0';
			VIDEOE <= x"AF";
		WHEN OTHERS =>
			videoflag <= '0';	
		END CASE;
	END IF;
END PROCESS;

END a;
