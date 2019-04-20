
_Converte_BCD:

;PROJPIC.c,49 :: 		void Converte_BCD(unsigned char ucLinha, unsigned char ucColuna,unsigned char ucValor) {
;PROJPIC.c,52 :: 		ucValor1 = (ucValor >> 4  ) + '0';    // Converte o primeiro nibble em BCD e ap?s em string
	MOVF        FARG_Converte_BCD_ucValor+0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	RRCF        FARG_Lcd_Chr_out_char+0, 1 
	BCF         FARG_Lcd_Chr_out_char+0, 7 
	RRCF        FARG_Lcd_Chr_out_char+0, 1 
	BCF         FARG_Lcd_Chr_out_char+0, 7 
	RRCF        FARG_Lcd_Chr_out_char+0, 1 
	BCF         FARG_Lcd_Chr_out_char+0, 7 
	RRCF        FARG_Lcd_Chr_out_char+0, 1 
	BCF         FARG_Lcd_Chr_out_char+0, 7 
	MOVLW       48
	ADDWF       FARG_Lcd_Chr_out_char+0, 1 
;PROJPIC.c,53 :: 		Lcd_Chr(ucLinha,ucColuna,ucValor1);   // Escreve caractere no LCD
	MOVF        FARG_Converte_BCD_ucLinha+0, 0 
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        FARG_Converte_BCD_ucColuna+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	CALL        _Lcd_Chr+0, 0
;PROJPIC.c,54 :: 		ucValor2 = (ucValor & 0x0F) + '0';    // Converte o segundo nibble em BCD e ap?s isso, em string
	MOVLW       15
	ANDWF       FARG_Converte_BCD_ucValor+0, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	MOVLW       48
	ADDWF       FARG_Lcd_Chr_CP_out_char+0, 1 
;PROJPIC.c,55 :: 		Lcd_Chr_CP(ucValor2);                 // Escreve caractere no LCD
	CALL        _Lcd_Chr_CP+0, 0
;PROJPIC.c,56 :: 		}
L_end_Converte_BCD:
	RETURN      0
; end of _Converte_BCD

_Leitura_RTC:

;PROJPIC.c,58 :: 		void Leitura_RTC() {          // Rotina de leitura do DS1307
;PROJPIC.c,59 :: 		I2C1_Start();              // Inicializa comunica??o i2c
	CALL        _I2C1_Start+0, 0
;PROJPIC.c,60 :: 		I2C1_Wr(0xD0);             // End. fixo para DS1307: 1101000X, onde x = 0 ? para grava??o
	MOVLW       208
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;PROJPIC.c,61 :: 		I2C1_Wr(0);                // End. onde come?a a programa??o do rel?gio, end dos segundos.
	CLRF        FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;PROJPIC.c,62 :: 		I2C1_Repeated_Start();     // Issue I2C signal repeated start
	CALL        _I2C1_Repeated_Start+0, 0
;PROJPIC.c,63 :: 		I2C1_Wr(0xD1);             // End. fixo para DS1307: 1101000X, onde x=1 ? para leitura
	MOVLW       209
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;PROJPIC.c,64 :: 		ucSegundo = I2C1_Rd(1);    // L? o primeiro byte(segundos),informa que continua lendo
	MOVLW       1
	MOVWF       FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       _ucSegundo+0 
;PROJPIC.c,65 :: 		ucMinuto = I2C1_Rd(1);     // L? o segundo byte(minutos)
	MOVLW       1
	MOVWF       FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       _ucMinuto+0 
;PROJPIC.c,66 :: 		ucHora = I2C1_Rd(1);       // L? o terceiro byte(horas)
	MOVLW       1
	MOVWF       FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       _ucHora+0 
;PROJPIC.c,67 :: 		ucDia_Semana = I2C1_Rd(1);
	MOVLW       1
	MOVWF       FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       _ucDia_Semana+0 
;PROJPIC.c,68 :: 		ucDia = I2C1_Rd(1);
	MOVLW       1
	MOVWF       FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       _ucDia+0 
;PROJPIC.c,69 :: 		ucMes = I2C1_Rd(1);
	MOVLW       1
	MOVWF       FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       _ucMes+0 
;PROJPIC.c,70 :: 		ucAno = I2C1_Rd(0);        // L? o s?timo byte(ano),encerra as leituras de dados
	CLRF        FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       _ucAno+0 
;PROJPIC.c,71 :: 		I2C1_Stop();               // Finaliza comunica??o I2C
	CALL        _I2C1_Stop+0, 0
;PROJPIC.c,72 :: 		}
L_end_Leitura_RTC:
	RETURN      0
; end of _Leitura_RTC

_Grava_RTC:

;PROJPIC.c,74 :: 		void Grava_RTC(){
;PROJPIC.c,75 :: 		I2C1_Init(100000);     // Iniciliza I2C com frequencia de 100KHz
	MOVLW       20
	MOVWF       SSPADD+0 
	CALL        _I2C1_Init+0, 0
;PROJPIC.c,76 :: 		I2C1_Start();          // Inicializa a comunica??o I2c
	CALL        _I2C1_Start+0, 0
;PROJPIC.c,77 :: 		I2C1_Wr(0xD0);         // End. fixo para DS1307: 1101000X, onde x = 0 ? para grava??o
	MOVLW       208
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;PROJPIC.c,78 :: 		I2C1_Wr(0);            // End. onde come?a a programa??o do rel?gio, end. dos segundos.
	CLRF        FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;PROJPIC.c,79 :: 		I2C1_Wr(0x04);         // Inicializa com 04 segundos.
	MOVLW       4
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;PROJPIC.c,80 :: 		I2C1_Wr(0x12);         // Inicializa com 12 minutos.
	MOVLW       18
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;PROJPIC.c,81 :: 		I2C1_Wr(0x09);         // Inicializa com 09:00hs (formato 24 horas).
	MOVLW       9
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;PROJPIC.c,82 :: 		I2C1_Wr(0x03);         // Inicializa com ter?a
	MOVLW       3
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;PROJPIC.c,83 :: 		I2C1_Wr(0x15);         // Inicializa com dia 15
	MOVLW       21
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;PROJPIC.c,84 :: 		I2C1_Wr(0x07);         // Inicializa com m?s 07
	MOVLW       7
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;PROJPIC.c,85 :: 		I2C1_Wr(0x09);         // Inicializa com ano 09
	MOVLW       9
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;PROJPIC.c,86 :: 		I2C1_Stop();           // Finaliza comunica??o I2C
	CALL        _I2C1_Stop+0, 0
;PROJPIC.c,87 :: 		}
L_end_Grava_RTC:
	RETURN      0
; end of _Grava_RTC

_Encontra_Dia_Semana:

;PROJPIC.c,89 :: 		void Encontra_Dia_Semana() {
;PROJPIC.c,90 :: 		switch (ucDia_Semana) {
	GOTO        L_Encontra_Dia_Semana0
;PROJPIC.c,91 :: 		case 01: ucTexto = "DOMINGO"; break; // Caso dias_semana = 01 ent?o..
L_Encontra_Dia_Semana2:
	MOVLW       ?lstr1_PROJPIC+0
	MOVWF       _ucTexto+0 
	MOVLW       hi_addr(?lstr1_PROJPIC+0)
	MOVWF       _ucTexto+1 
	GOTO        L_Encontra_Dia_Semana1
;PROJPIC.c,92 :: 		case 02: ucTexto = "SEGUNDA"; break; // Caso dias_semana = 02 ent?o..
L_Encontra_Dia_Semana3:
	MOVLW       ?lstr2_PROJPIC+0
	MOVWF       _ucTexto+0 
	MOVLW       hi_addr(?lstr2_PROJPIC+0)
	MOVWF       _ucTexto+1 
	GOTO        L_Encontra_Dia_Semana1
;PROJPIC.c,93 :: 		case 03: ucTexto = "TERCA";   break; // Caso dias_semana = 03 ent?o..
L_Encontra_Dia_Semana4:
	MOVLW       ?lstr3_PROJPIC+0
	MOVWF       _ucTexto+0 
	MOVLW       hi_addr(?lstr3_PROJPIC+0)
	MOVWF       _ucTexto+1 
	GOTO        L_Encontra_Dia_Semana1
;PROJPIC.c,94 :: 		case 04: ucTexto = "QUARTA";  break; // Caso dias_semana = 04 ent?o..
L_Encontra_Dia_Semana5:
	MOVLW       ?lstr4_PROJPIC+0
	MOVWF       _ucTexto+0 
	MOVLW       hi_addr(?lstr4_PROJPIC+0)
	MOVWF       _ucTexto+1 
	GOTO        L_Encontra_Dia_Semana1
;PROJPIC.c,95 :: 		case 05: ucTexto = "QUINTA";  break; // Caso dias_semana = 05 ent?o..
L_Encontra_Dia_Semana6:
	MOVLW       ?lstr5_PROJPIC+0
	MOVWF       _ucTexto+0 
	MOVLW       hi_addr(?lstr5_PROJPIC+0)
	MOVWF       _ucTexto+1 
	GOTO        L_Encontra_Dia_Semana1
;PROJPIC.c,96 :: 		case 06: ucTexto = "SEXTA";   break; // Caso dias_semana = 06 ent?o..
L_Encontra_Dia_Semana7:
	MOVLW       ?lstr6_PROJPIC+0
	MOVWF       _ucTexto+0 
	MOVLW       hi_addr(?lstr6_PROJPIC+0)
	MOVWF       _ucTexto+1 
	GOTO        L_Encontra_Dia_Semana1
;PROJPIC.c,97 :: 		default: ucTexto = "SABADO";         // Se n?o for nenhum desses ent?o...
L_Encontra_Dia_Semana8:
	MOVLW       ?lstr7_PROJPIC+0
	MOVWF       _ucTexto+0 
	MOVLW       hi_addr(?lstr7_PROJPIC+0)
	MOVWF       _ucTexto+1 
;PROJPIC.c,98 :: 		}
	GOTO        L_Encontra_Dia_Semana1
L_Encontra_Dia_Semana0:
	MOVF        _ucDia_Semana+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_Encontra_Dia_Semana2
	MOVF        _ucDia_Semana+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_Encontra_Dia_Semana3
	MOVF        _ucDia_Semana+0, 0 
	XORLW       3
	BTFSC       STATUS+0, 2 
	GOTO        L_Encontra_Dia_Semana4
	MOVF        _ucDia_Semana+0, 0 
	XORLW       4
	BTFSC       STATUS+0, 2 
	GOTO        L_Encontra_Dia_Semana5
	MOVF        _ucDia_Semana+0, 0 
	XORLW       5
	BTFSC       STATUS+0, 2 
	GOTO        L_Encontra_Dia_Semana6
	MOVF        _ucDia_Semana+0, 0 
	XORLW       6
	BTFSC       STATUS+0, 2 
	GOTO        L_Encontra_Dia_Semana7
	GOTO        L_Encontra_Dia_Semana8
L_Encontra_Dia_Semana1:
;PROJPIC.c,99 :: 		}
L_end_Encontra_Dia_Semana:
	RETURN      0
; end of _Encontra_Dia_Semana

_Display_LCD:

;PROJPIC.c,101 :: 		void Display_LCD() {
;PROJPIC.c,102 :: 		Lcd_Out(1,1,"(Hora)");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr8_PROJPIC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr8_PROJPIC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;PROJPIC.c,103 :: 		Converte_BCD(1,7,ucHora);     // Convers?o da vari?vel horas para BCD
	MOVLW       1
	MOVWF       FARG_Converte_BCD_ucLinha+0 
	MOVLW       7
	MOVWF       FARG_Converte_BCD_ucColuna+0 
	MOVF        _ucHora+0, 0 
	MOVWF       FARG_Converte_BCD_ucValor+0 
	CALL        _Converte_BCD+0, 0
;PROJPIC.c,104 :: 		Lcd_Chr_CP(':');              // Escreve no display LCD
	MOVLW       58
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;PROJPIC.c,105 :: 		Converte_BCD(1,10,ucMinuto);  // Convers?o da vari?vel minuto para BCD
	MOVLW       1
	MOVWF       FARG_Converte_BCD_ucLinha+0 
	MOVLW       10
	MOVWF       FARG_Converte_BCD_ucColuna+0 
	MOVF        _ucMinuto+0, 0 
	MOVWF       FARG_Converte_BCD_ucValor+0 
	CALL        _Converte_BCD+0, 0
;PROJPIC.c,106 :: 		Lcd_Chr_CP(':');              // Escreve no display LCD
	MOVLW       58
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;PROJPIC.c,107 :: 		Converte_BCD(1,13,ucSegundo); // Convers?o da vari?vel segundo para BCD
	MOVLW       1
	MOVWF       FARG_Converte_BCD_ucLinha+0 
	MOVLW       13
	MOVWF       FARG_Converte_BCD_ucColuna+0 
	MOVF        _ucSegundo+0, 0 
	MOVWF       FARG_Converte_BCD_ucValor+0 
	CALL        _Converte_BCD+0, 0
;PROJPIC.c,108 :: 		Lcd_Out(2,1,"(Data)");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr9_PROJPIC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr9_PROJPIC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;PROJPIC.c,109 :: 		Converte_BCD(2,7,ucDia);      // Convers?o da vari?vel dia para BCD
	MOVLW       2
	MOVWF       FARG_Converte_BCD_ucLinha+0 
	MOVLW       7
	MOVWF       FARG_Converte_BCD_ucColuna+0 
	MOVF        _ucDia+0, 0 
	MOVWF       FARG_Converte_BCD_ucValor+0 
	CALL        _Converte_BCD+0, 0
;PROJPIC.c,110 :: 		Lcd_Chr_CP('/');              // Escreve no display LCD
	MOVLW       47
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;PROJPIC.c,111 :: 		Converte_BCD(2,10,ucMes);     // Convers?o da vari?vel mes para BCD
	MOVLW       2
	MOVWF       FARG_Converte_BCD_ucLinha+0 
	MOVLW       10
	MOVWF       FARG_Converte_BCD_ucColuna+0 
	MOVF        _ucMes+0, 0 
	MOVWF       FARG_Converte_BCD_ucValor+0 
	CALL        _Converte_BCD+0, 0
;PROJPIC.c,112 :: 		Lcd_Chr_CP('/');              // Escreve no display LCD
	MOVLW       47
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;PROJPIC.c,113 :: 		Converte_BCD(2,13,ucAno);     // Convers?o da vari?vel ano para BCD
	MOVLW       2
	MOVWF       FARG_Converte_BCD_ucLinha+0 
	MOVLW       13
	MOVWF       FARG_Converte_BCD_ucColuna+0 
	MOVF        _ucAno+0, 0 
	MOVWF       FARG_Converte_BCD_ucValor+0 
	CALL        _Converte_BCD+0, 0
;PROJPIC.c,114 :: 		Encontra_Dia_Semana();
	CALL        _Encontra_Dia_Semana+0, 0
;PROJPIC.c,115 :: 		Lcd_Out(3,1,ucTexto);         // Mostra dia da semana
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVF        _ucTexto+0, 0 
	MOVWF       FARG_Lcd_Out_text+0 
	MOVF        _ucTexto+1, 0 
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;PROJPIC.c,116 :: 		}
L_end_Display_LCD:
	RETURN      0
; end of _Display_LCD

_main:

;PROJPIC.c,119 :: 		void main(){
;PROJPIC.c,122 :: 		unsigned int Control = 1;  // +++++++ VARIAVEL DE CONTROLE DA COMUNICAÇÃO ++++++++
	MOVLW       1
	MOVWF       main_Control_L0+0 
	MOVLW       0
	MOVWF       main_Control_L0+1 
;PROJPIC.c,125 :: 		ADCON1  = 0x0E;                           //Configura os pinos do PORTB como digitais, e RA0 (PORTA) como analógico
	MOVLW       14
	MOVWF       ADCON1+0 
;PROJPIC.c,127 :: 		TRISD = 0;
	CLRF        TRISD+0 
;PROJPIC.c,128 :: 		TRISC.RC1 = 0;      //PORT C configurado como sa?da            buzzer
	BCF         TRISC+0, 1 
;PROJPIC.c,130 :: 		TRISB =0;            // Define todos os pinos do PORTB como sa?da.
	CLRF        TRISB+0 
;PROJPIC.c,131 :: 		PORTB = 0;           // Colocar todos os pinos em n?vel baixo.             leds
	CLRF        PORTB+0 
;PROJPIC.c,133 :: 		ADCON1 = 0x0F;
	MOVLW       15
	MOVWF       ADCON1+0 
;PROJPIC.c,135 :: 		TRISA.RA4 = 0;      //Display 3
	BCF         TRISA+0, 4 
;PROJPIC.c,136 :: 		TRISA.RA5 = 0;     // Display 4
	BCF         TRISA+0, 5 
;PROJPIC.c,137 :: 		TRISC.RC5 = 0;
	BCF         TRISC+0, 5 
;PROJPIC.c,138 :: 		CMCON = 0X07;                             // Desliga os comparadores.
	MOVLW       7
	MOVWF       CMCON+0 
;PROJPIC.c,141 :: 		Lcd_Init();                               // Inicializa LCD.
	CALL        _Lcd_Init+0, 0
;PROJPIC.c,143 :: 		Lcd_Cmd(_LCD_CLEAR);                      // Apaga display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;PROJPIC.c,144 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);                 // Desliga cursor
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;PROJPIC.c,145 :: 		Grava_RTC();
	CALL        _Grava_RTC+0, 0
;PROJPIC.c,147 :: 		UART1_Init(9600);  // Utiliza bibliotecas do compilador para configuração o Baud rate.
	BSF         BAUDCON+0, 3, 0
	CLRF        SPBRGH+0 
	MOVLW       207
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;PROJPIC.c,149 :: 		while(1){  // SELECIONE A VARIAVEL DE CONTROLE (CONTROL) DECLARADA ACIMA.
L_main9:
;PROJPIC.c,150 :: 		PORTB.RB0=0;         // Todos os pinos do PORTB em 0.
	BCF         PORTB+0, 0 
;PROJPIC.c,151 :: 		PORTB.RB1=0;         // Todos os pinos do PORTB em 0.
	BCF         PORTB+0, 1 
;PROJPIC.c,152 :: 		PORTB.RB2=0;         // Todos os pinos do PORTB em 0.
	BCF         PORTB+0, 2 
;PROJPIC.c,153 :: 		PORTB.RB3=0;         // Todos os pinos do PORTB em 0.
	BCF         PORTB+0, 3 
;PROJPIC.c,154 :: 		PORTB.RB4=0;         // Todos os pinos do PORTB em 0.
	BCF         PORTB+0, 4 
;PROJPIC.c,155 :: 		PORTB.RB5=0;         // Todos os pinos do PORTB em 0.
	BCF         PORTB+0, 5 
;PROJPIC.c,156 :: 		PORTB.RB6=0;         // Todos os pinos do PORTB em 0.
	BCF         PORTB+0, 6 
;PROJPIC.c,157 :: 		PORTB.RB7=0;         // Todos os pinos do PORTB em 0.
	BCF         PORTB+0, 7 
;PROJPIC.c,159 :: 		PORTB.RA5=0;         // Todos os pinos do PORTB em 0.
	BCF         PORTB+0, 5 
;PROJPIC.c,161 :: 		iLeituraAD= ADC_Read(2);         //sensor de temperatura
	MOVLW       2
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _iLeituraAD+0 
	MOVF        R1, 0 
	MOVWF       _iLeituraAD+1 
;PROJPIC.c,162 :: 		iLeituraAD/=2;
	MOVF        R0, 0 
	MOVWF       _iLeituraAD+0 
	MOVF        R1, 0 
	MOVWF       _iLeituraAD+1 
	RRCF        _iLeituraAD+1, 1 
	RRCF        _iLeituraAD+0, 1 
	BCF         _iLeituraAD+1, 7 
;PROJPIC.c,164 :: 		Delay_ms(2);
	MOVLW       6
	MOVWF       R12, 0
	MOVLW       48
	MOVWF       R13, 0
L_main11:
	DECFSZ      R13, 1, 1
	BRA         L_main11
	DECFSZ      R12, 1, 1
	BRA         L_main11
	NOP
;PROJPIC.c,166 :: 		if(iLeituraAD >= 25)
	MOVLW       0
	SUBWF       _iLeituraAD+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main46
	MOVLW       25
	SUBWF       _iLeituraAD+0, 0 
L__main46:
	BTFSS       STATUS+0, 0 
	GOTO        L_main12
;PROJPIC.c,168 :: 		PWM1_Init(5000);
	BSF         T2CON+0, 0, 0
	BCF         T2CON+0, 1, 0
	MOVLW       99
	MOVWF       PR2+0, 0
	CALL        _PWM1_Init+0, 0
;PROJPIC.c,169 :: 		PWM1_Set_Duty(iLeituraAD * 5);
	MOVLW       5
	MULWF       _iLeituraAD+0 
	MOVF        PRODL+0, 0 
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;PROJPIC.c,170 :: 		PWM1_Start();
	CALL        _PWM1_Start+0, 0
;PROJPIC.c,171 :: 		}
	GOTO        L_main13
L_main12:
;PROJPIC.c,174 :: 		PWM1_Stop();
	CALL        _PWM1_Stop+0, 0
;PROJPIC.c,175 :: 		}
L_main13:
;PROJPIC.c,177 :: 		uiValor = iLeituraAD;
	MOVF        _iLeituraAD+0, 0 
	MOVWF       _uiValor+0 
	MOVF        _iLeituraAD+1, 0 
	MOVWF       _uiValor+1 
;PROJPIC.c,178 :: 		Delay_ms(2);
	MOVLW       6
	MOVWF       R12, 0
	MOVLW       48
	MOVWF       R13, 0
L_main14:
	DECFSZ      R13, 1, 1
	BRA         L_main14
	DECFSZ      R12, 1, 1
	BRA         L_main14
	NOP
;PROJPIC.c,179 :: 		PORTD = ucMask[uiValor%10];
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _uiValor+0, 0 
	MOVWF       R0 
	MOVF        _uiValor+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       _ucMask+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_ucMask+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       PORTD+0 
;PROJPIC.c,180 :: 		PORTA.RA5 = 1;
	BSF         PORTA+0, 5 
;PROJPIC.c,181 :: 		Delay_ms(2);
	MOVLW       6
	MOVWF       R12, 0
	MOVLW       48
	MOVWF       R13, 0
L_main15:
	DECFSZ      R13, 1, 1
	BRA         L_main15
	DECFSZ      R12, 1, 1
	BRA         L_main15
	NOP
;PROJPIC.c,182 :: 		PORTA.RA5 = 0;
	BCF         PORTA+0, 5 
;PROJPIC.c,183 :: 		uiValor/=10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _uiValor+0, 0 
	MOVWF       R0 
	MOVF        _uiValor+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       _uiValor+0 
	MOVF        R1, 0 
	MOVWF       _uiValor+1 
;PROJPIC.c,184 :: 		PORTD = ucMask[uiValor%10];
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       _ucMask+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_ucMask+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       PORTD+0 
;PROJPIC.c,185 :: 		PORTA.RA4 = 1;
	BSF         PORTA+0, 4 
;PROJPIC.c,186 :: 		Delay_ms(2);
	MOVLW       6
	MOVWF       R12, 0
	MOVLW       48
	MOVWF       R13, 0
L_main16:
	DECFSZ      R13, 1, 1
	BRA         L_main16
	DECFSZ      R12, 1, 1
	BRA         L_main16
	NOP
;PROJPIC.c,187 :: 		PORTA.RA4 = 0;
	BCF         PORTA+0, 4 
;PROJPIC.c,188 :: 		Delay_ms(2);
	MOVLW       6
	MOVWF       R12, 0
	MOVLW       48
	MOVWF       R13, 0
L_main17:
	DECFSZ      R13, 1, 1
	BRA         L_main17
	DECFSZ      R12, 1, 1
	BRA         L_main17
	NOP
;PROJPIC.c,190 :: 		if (Control == 0){   // O PIC (Control = 0) envia um caracter e o Arduino responde com outro caracter.
	MOVLW       0
	XORWF       main_Control_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main47
	MOVLW       0
	XORWF       main_Control_L0+0, 0 
L__main47:
	BTFSS       STATUS+0, 2 
	GOTO        L_main18
;PROJPIC.c,191 :: 		UART1_Write('T');
	MOVLW       84
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;PROJPIC.c,192 :: 		lcd_out(1,1,"PIC Send/Receive");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr10_PROJPIC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr10_PROJPIC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;PROJPIC.c,193 :: 		lcd_out(2,1,"Send = T");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr11_PROJPIC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr11_PROJPIC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;PROJPIC.c,194 :: 		Delay_ms(50);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main19:
	DECFSZ      R13, 1, 1
	BRA         L_main19
	DECFSZ      R12, 1, 1
	BRA         L_main19
	NOP
	NOP
;PROJPIC.c,195 :: 		if(UART1_Data_Ready()){  // Verifica se o dado enviado foi recebido no buffer
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main20
;PROJPIC.c,196 :: 		ucRead = UART1_Read(); // Lê o dado da serial.
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       main_ucRead_L0+0 
;PROJPIC.c,197 :: 		Delay_ms(50);   // Pausa de 100ms.
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main21:
	DECFSZ      R13, 1, 1
	BRA         L_main21
	DECFSZ      R12, 1, 1
	BRA         L_main21
	NOP
	NOP
;PROJPIC.c,198 :: 		if (ucRead == 'S'){
	MOVF        main_ucRead_L0+0, 0 
	XORLW       83
	BTFSS       STATUS+0, 2 
	GOTO        L_main22
;PROJPIC.c,199 :: 		lcd_out(2,10,"Rec.= ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       10
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr12_PROJPIC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr12_PROJPIC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;PROJPIC.c,200 :: 		lcd_chr_cp (ucRead);
	MOVF        main_ucRead_L0+0, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;PROJPIC.c,201 :: 		}
L_main22:
;PROJPIC.c,202 :: 		}
L_main20:
;PROJPIC.c,203 :: 		}
L_main18:
;PROJPIC.c,205 :: 		if (Control == 1){   // O PIC (Control = 0) envia um caracter e o Arduino responde com outro caracter.
	MOVLW       0
	XORWF       main_Control_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main48
	MOVLW       1
	XORWF       main_Control_L0+0, 0 
L__main48:
	BTFSS       STATUS+0, 2 
	GOTO        L_main23
;PROJPIC.c,206 :: 		if(UART1_Data_Ready()){  // Verifica se o dado enviado foi recebido no buffer
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main24
;PROJPIC.c,207 :: 		ucRead = UART1_Read(); // Lê o dado da serial.
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       main_ucRead_L0+0 
;PROJPIC.c,208 :: 		Delay_ms(50);   // Pausa de 100ms.
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main25:
	DECFSZ      R13, 1, 1
	BRA         L_main25
	DECFSZ      R12, 1, 1
	BRA         L_main25
	NOP
	NOP
;PROJPIC.c,209 :: 		if (ucRead == 'M'){
	MOVF        main_ucRead_L0+0, 0 
	XORLW       77
	BTFSS       STATUS+0, 2 
	GOTO        L_main26
;PROJPIC.c,210 :: 		Lcd_Cmd(_LCD_CLEAR);                      //Limpa display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;PROJPIC.c,211 :: 		lcd_out(1,1,"SITUACAO : ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr13_PROJPIC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr13_PROJPIC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;PROJPIC.c,212 :: 		lcd_out(2,1,"INCENDIO");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr14_PROJPIC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr14_PROJPIC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;PROJPIC.c,213 :: 		if(!mode){
	MOVF        _mode+0, 0 
	IORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_main27
;PROJPIC.c,214 :: 		PORTC.RC1 = ~PORTC.RC1;   //invers?o de estado do buzzer
	BTG         PORTC+0, 1 
;PROJPIC.c,215 :: 		PORTB.RB0=1;         // Todos os pinos do PORTB em 0.
	BSF         PORTB+0, 0 
;PROJPIC.c,217 :: 		PORTB.RB1=1;         // Todos os pinos do PORTB em 0.
	BSF         PORTB+0, 1 
;PROJPIC.c,218 :: 		delay_ms(100);   //delay de 1000 milisegundos
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_main28:
	DECFSZ      R13, 1, 1
	BRA         L_main28
	DECFSZ      R12, 1, 1
	BRA         L_main28
	DECFSZ      R11, 1, 1
	BRA         L_main28
	NOP
;PROJPIC.c,219 :: 		PORTB.RB2=1;         // Todos os pinos do PORTB em 0.
	BSF         PORTB+0, 2 
;PROJPIC.c,220 :: 		delay_ms(100);   //delay de 1000 milisegundos
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_main29:
	DECFSZ      R13, 1, 1
	BRA         L_main29
	DECFSZ      R12, 1, 1
	BRA         L_main29
	DECFSZ      R11, 1, 1
	BRA         L_main29
	NOP
;PROJPIC.c,221 :: 		PORTB.RB3=1;         // Todos os pinos do PORTB em 0.
	BSF         PORTB+0, 3 
;PROJPIC.c,222 :: 		delay_ms(100);   //delay de 1000 milisegundos
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_main30:
	DECFSZ      R13, 1, 1
	BRA         L_main30
	DECFSZ      R12, 1, 1
	BRA         L_main30
	DECFSZ      R11, 1, 1
	BRA         L_main30
	NOP
;PROJPIC.c,223 :: 		PORTB.RB4=1;         // Todos os pinos do PORTB em 0.
	BSF         PORTB+0, 4 
;PROJPIC.c,224 :: 		delay_ms(100);   //delay de 1000 milisegundos
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_main31:
	DECFSZ      R13, 1, 1
	BRA         L_main31
	DECFSZ      R12, 1, 1
	BRA         L_main31
	DECFSZ      R11, 1, 1
	BRA         L_main31
	NOP
;PROJPIC.c,225 :: 		PORTB.RB5=1;         // Todos os pinos do PORTB em 0.
	BSF         PORTB+0, 5 
;PROJPIC.c,226 :: 		delay_ms(100);   //delay de 1000 milisegundos
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_main32:
	DECFSZ      R13, 1, 1
	BRA         L_main32
	DECFSZ      R12, 1, 1
	BRA         L_main32
	DECFSZ      R11, 1, 1
	BRA         L_main32
	NOP
;PROJPIC.c,227 :: 		PORTB.RB6=1;         // Todos os pinos do PORTB em 0.
	BSF         PORTB+0, 6 
;PROJPIC.c,228 :: 		delay_ms(100);   //delay de 1000 milisegundos
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_main33:
	DECFSZ      R13, 1, 1
	BRA         L_main33
	DECFSZ      R12, 1, 1
	BRA         L_main33
	DECFSZ      R11, 1, 1
	BRA         L_main33
	NOP
;PROJPIC.c,229 :: 		PORTB.RB7=1;         // Todos os pinos do PORTB em 0.
	BSF         PORTB+0, 7 
;PROJPIC.c,230 :: 		delay_ms(100);   //delay de 1000 milisegundos
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_main34:
	DECFSZ      R13, 1, 1
	BRA         L_main34
	DECFSZ      R12, 1, 1
	BRA         L_main34
	DECFSZ      R11, 1, 1
	BRA         L_main34
	NOP
;PROJPIC.c,231 :: 		mode = 1;
	MOVLW       1
	MOVWF       _mode+0 
	MOVLW       0
	MOVWF       _mode+1 
;PROJPIC.c,232 :: 		}
L_main27:
;PROJPIC.c,233 :: 		delay_ms(1000);   //delay de 1000 milisegundos
	MOVLW       11
	MOVWF       R11, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       93
	MOVWF       R13, 0
L_main35:
	DECFSZ      R13, 1, 1
	BRA         L_main35
	DECFSZ      R12, 1, 1
	BRA         L_main35
	DECFSZ      R11, 1, 1
	BRA         L_main35
	NOP
	NOP
;PROJPIC.c,238 :: 		}
L_main26:
;PROJPIC.c,239 :: 		if (ucRead == 'N'){
	MOVF        main_ucRead_L0+0, 0 
	XORLW       78
	BTFSS       STATUS+0, 2 
	GOTO        L_main36
;PROJPIC.c,241 :: 		Lcd_Cmd(_LCD_CLEAR);                      //Limpa display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;PROJPIC.c,242 :: 		lcd_out(1,1,"SITUACAO");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr15_PROJPIC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr15_PROJPIC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;PROJPIC.c,243 :: 		lcd_out(2,1,"OK");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr16_PROJPIC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr16_PROJPIC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;PROJPIC.c,244 :: 		PORTC.RC1 = 1;   //invers?o de estado
	BSF         PORTC+0, 1 
;PROJPIC.c,245 :: 		PORTB.RB0=0;         // Todos os pinos do PORTB em 0.
	BCF         PORTB+0, 0 
;PROJPIC.c,246 :: 		PORTB.RB1=0;         // Todos os pinos do PORTB em 0.
	BCF         PORTB+0, 1 
;PROJPIC.c,247 :: 		PORTB.RB2=0;         // Todos os pinos do PORTB em 0.
	BCF         PORTB+0, 2 
;PROJPIC.c,248 :: 		PORTB.RB3=0;         // Todos os pinos do PORTB em 0.
	BCF         PORTB+0, 3 
;PROJPIC.c,249 :: 		PORTB.RB4=0;         // Todos os pinos do PORTB em 0.
	BCF         PORTB+0, 4 
;PROJPIC.c,250 :: 		PORTB.RB5=0;         // Todos os pinos do PORTB em 0.
	BCF         PORTB+0, 5 
;PROJPIC.c,251 :: 		PORTB.RB6=0;         // Todos os pinos do PORTB em 0.
	BCF         PORTB+0, 6 
;PROJPIC.c,252 :: 		PORTB.RB7=0;         // Todos os pinos do PORTB em 0.
	BCF         PORTB+0, 7 
;PROJPIC.c,253 :: 		mode = 0;
	CLRF        _mode+0 
	CLRF        _mode+1 
;PROJPIC.c,254 :: 		}
L_main36:
;PROJPIC.c,255 :: 		if (ucRead == 'F'){          //sitema desligado
	MOVF        main_ucRead_L0+0, 0 
	XORLW       70
	BTFSS       STATUS+0, 2 
	GOTO        L_main37
;PROJPIC.c,257 :: 		Lcd_Cmd(_LCD_CLEAR);                      //Limpa display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;PROJPIC.c,258 :: 		Display_LCD();  // Escreve no display lcd o valor
	CALL        _Display_LCD+0, 0
;PROJPIC.c,259 :: 		Leitura_RTC();  // Efetua leitura de segundo, minuto e horas do DS1307
	CALL        _Leitura_RTC+0, 0
;PROJPIC.c,260 :: 		Delay_ms(200);  // Delay de 200 milisegundos
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       119
	MOVWF       R13, 0
L_main38:
	DECFSZ      R13, 1, 1
	BRA         L_main38
	DECFSZ      R12, 1, 1
	BRA         L_main38
	DECFSZ      R11, 1, 1
	BRA         L_main38
;PROJPIC.c,262 :: 		}
L_main37:
;PROJPIC.c,263 :: 		UART1_Write('P');
	MOVLW       80
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;PROJPIC.c,265 :: 		Delay_ms(50);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main39:
	DECFSZ      R13, 1, 1
	BRA         L_main39
	DECFSZ      R12, 1, 1
	BRA         L_main39
	NOP
	NOP
;PROJPIC.c,266 :: 		}
L_main24:
;PROJPIC.c,267 :: 		}
L_main23:
;PROJPIC.c,268 :: 		}
	GOTO        L_main9
;PROJPIC.c,269 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
