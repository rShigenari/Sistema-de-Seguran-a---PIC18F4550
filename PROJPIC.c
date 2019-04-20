
//ROSANGELA MIYEKO SHIGENARI 92334
// CHAVES DE FUNÇÃO:
//  --------CHAVE1--------  --------CHAVE2---------
// |GLCD\LCD ( 1) = OFF   |DIS1    ( 1) = OFF   |
// |RX       ( 2) = ON    |DIS2    ( 2) = OFF   |
// |TX       ( 3) = ON    |DIS3    ( 3) = OFF   |
// |REL1     ( 4) = OFF   |DIS4    ( 4) = OFF   |
// |REL2     ( 5) = OFF   |INFR    ( 5) = OFF   |
// |SCK      ( 6) = OFF   |RESIS   ( 6) = OFF   |
// |SDA      ( 7) = OFF   |TEMP    ( 7) = OFF   |
// |RTC      ( 8) = OFF   |VENT    ( 8) = OFF   |
// |LED1     ( 9) = OFF   |AN0     ( 9) = OFF   |
// |LED2     (10) = OFF   |AN1     (10) = OFF   |
//  --------------------- ----------------------

// --- Ligações entre PIC e LCD ---
sbit LCD_RS at RE2_bit;   // PINO 2 DO PORTD INTERLIGADO AO RS DO DISPLAY
sbit LCD_EN at RE1_bit;   // PINO 3 DO PORTD INTERLIGADO AO EN DO DISPLAY
sbit LCD_D7 at RD7_bit;  // PINO 7 DO PORTD INTERLIGADO AO D7 DO DISPLAY
sbit LCD_D6 at RD6_bit;  // PINO 6 DO PORTD INTERLIGADO AO D6 DO DISPLAY
sbit LCD_D5 at RD5_bit;  // PINO 5 DO PORTD INTERLIGADO AO D5 DO DISPLAY
sbit LCD_D4 at RD4_bit;  // PINO 4 DO PORTD INTERLIGADO AO D4 DO DISPLAY

// Selecionando direção de fluxo de dados dos pinos utilizados para a comunicação com display LCD
sbit LCD_RS_Direction at TRISE2_bit;  // SETA DIREÇÃO DO FLUXO DE DADOS DO PINO 2 DO PORTD
sbit LCD_EN_Direction at TRISE1_bit;  // SETA DIREÇÃO DO FLUXO DE DADOS DO PINO 3 DO PORTD
sbit LCD_D7_Direction at TRISD7_bit;  // SETA DIREÇÃO DO FLUXO DE DADOS DO PINO 7 DO PORTD
sbit LCD_D6_Direction at TRISD6_bit;  // SETA DIREÇÃO DO FLUXO DE DADOS DO PINO 6 DO PORTD
sbit LCD_D5_Direction at TRISD5_bit;  // SETA DIREÇÃO DO FLUXO DE DADOS DO PINO 5 DO PORTD
sbit LCD_D4_Direction at TRISD4_bit;  // SETA DIREÇÃO DO FLUXO DE DADOS DO PINO 4 DO PORTD


unsigned int  uiValor;

unsigned char *ucTexto;
unsigned int iLeituraAD = 0;
unsigned char ucMask[] = {0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};

unsigned char ucHora;       // Armazena Hora.
unsigned char ucMinuto;     // Armazena Minuto.
unsigned char ucSegundo;    // Armazena Segundo.
unsigned char ucDia;        // Armazena Dia.
unsigned char ucMes;        // Armazena Mes.
unsigned char ucAno;        // Armazena Ano.
unsigned char ucDia_Semana; // Armazena Dia da Semana.

int mode = 0; //controla buzzer

// Rotina de convers?o de dados para BCD
void Converte_BCD(unsigned char ucLinha, unsigned char ucColuna,unsigned char ucValor) {
  unsigned char ucValor1, ucValor2;

  ucValor1 = (ucValor >> 4  ) + '0';    // Converte o primeiro nibble em BCD e ap?s em string
  Lcd_Chr(ucLinha,ucColuna,ucValor1);   // Escreve caractere no LCD
  ucValor2 = (ucValor & 0x0F) + '0';    // Converte o segundo nibble em BCD e ap?s isso, em string
  Lcd_Chr_CP(ucValor2);                 // Escreve caractere no LCD
}

void Leitura_RTC() {          // Rotina de leitura do DS1307
   I2C1_Start();              // Inicializa comunica??o i2c
   I2C1_Wr(0xD0);             // End. fixo para DS1307: 1101000X, onde x = 0 ? para grava??o
   I2C1_Wr(0);                // End. onde come?a a programa??o do rel?gio, end dos segundos.
   I2C1_Repeated_Start();     // Issue I2C signal repeated start
   I2C1_Wr(0xD1);             // End. fixo para DS1307: 1101000X, onde x=1 ? para leitura
   ucSegundo = I2C1_Rd(1);    // L? o primeiro byte(segundos),informa que continua lendo
   ucMinuto = I2C1_Rd(1);     // L? o segundo byte(minutos)
   ucHora = I2C1_Rd(1);       // L? o terceiro byte(horas)
   ucDia_Semana = I2C1_Rd(1);
   ucDia = I2C1_Rd(1);
   ucMes = I2C1_Rd(1);
   ucAno = I2C1_Rd(0);        // L? o s?timo byte(ano),encerra as leituras de dados
   I2C1_Stop();               // Finaliza comunica??o I2C
}

void Grava_RTC(){
   I2C1_Init(100000);     // Iniciliza I2C com frequencia de 100KHz
   I2C1_Start();          // Inicializa a comunica??o I2c
   I2C1_Wr(0xD0);         // End. fixo para DS1307: 1101000X, onde x = 0 ? para grava??o
   I2C1_Wr(0);            // End. onde come?a a programa??o do rel?gio, end. dos segundos.
   I2C1_Wr(0x04);         // Inicializa com 04 segundos.
   I2C1_Wr(0x12);         // Inicializa com 12 minutos.
   I2C1_Wr(0x09);         // Inicializa com 09:00hs (formato 24 horas).
   I2C1_Wr(0x03);         // Inicializa com ter?a
   I2C1_Wr(0x15);         // Inicializa com dia 15
   I2C1_Wr(0x07);         // Inicializa com m?s 07
   I2C1_Wr(0x09);         // Inicializa com ano 09
   I2C1_Stop();           // Finaliza comunica??o I2C
}

void Encontra_Dia_Semana() {
   switch (ucDia_Semana) {
      case 01: ucTexto = "DOMINGO"; break; // Caso dias_semana = 01 ent?o..
      case 02: ucTexto = "SEGUNDA"; break; // Caso dias_semana = 02 ent?o..
      case 03: ucTexto = "TERCA";   break; // Caso dias_semana = 03 ent?o..
      case 04: ucTexto = "QUARTA";  break; // Caso dias_semana = 04 ent?o..
      case 05: ucTexto = "QUINTA";  break; // Caso dias_semana = 05 ent?o..
      case 06: ucTexto = "SEXTA";   break; // Caso dias_semana = 06 ent?o..
      default: ucTexto = "SABADO";         // Se n?o for nenhum desses ent?o...
   }
}

void Display_LCD() {
   Lcd_Out(1,1,"(Hora)");
   Converte_BCD(1,7,ucHora);     // Convers?o da vari?vel horas para BCD
   Lcd_Chr_CP(':');              // Escreve no display LCD
   Converte_BCD(1,10,ucMinuto);  // Convers?o da vari?vel minuto para BCD
   Lcd_Chr_CP(':');              // Escreve no display LCD
   Converte_BCD(1,13,ucSegundo); // Convers?o da vari?vel segundo para BCD
   Lcd_Out(2,1,"(Data)");
   Converte_BCD(2,7,ucDia);      // Convers?o da vari?vel dia para BCD
   Lcd_Chr_CP('/');              // Escreve no display LCD
   Converte_BCD(2,10,ucMes);     // Convers?o da vari?vel mes para BCD
   Lcd_Chr_CP('/');              // Escreve no display LCD
   Converte_BCD(2,13,ucAno);     // Convers?o da vari?vel ano para BCD
   Encontra_Dia_Semana();
   Lcd_Out(3,1,ucTexto);         // Mostra dia da semana
}


void main(){

   char ucRead;        // Variavel para armazenar o dado lido.
   unsigned int Control = 1;  // +++++++ VARIAVEL DE CONTROLE DA COMUNICAÇÃO ++++++++
                              // LEMBRE DE ALTERAR ESSA VARIAVE TAMBEM NO ARDUINO

   ADCON1  = 0x0E;                           //Configura os pinos do PORTB como digitais, e RA0 (PORTA) como analógico
   
   TRISD = 0;
   TRISC.RC1 = 0;      //PORT C configurado como sa?da            buzzer
   
   TRISB =0;            // Define todos os pinos do PORTB como sa?da.
   PORTB = 0;           // Colocar todos os pinos em n?vel baixo.             leds

   ADCON1 = 0x0F;

   TRISA.RA4 = 0;      //Display 3
   TRISA.RA5 = 0;     // Display 4
   TRISC.RC5 = 0;
   CMCON = 0X07;                             // Desliga os comparadores.

   // Config. LCD no modo 4 bits
   Lcd_Init();                               // Inicializa LCD.

   Lcd_Cmd(_LCD_CLEAR);                      // Apaga display
   Lcd_Cmd(_LCD_CURSOR_OFF);                 // Desliga cursor
   Grava_RTC();

   UART1_Init(9600);  // Utiliza bibliotecas do compilador para configuração o Baud rate.

   while(1){  // SELECIONE A VARIAVEL DE CONTROLE (CONTROL) DECLARADA ACIMA.
     PORTB.RB0=0;         // Todos os pinos do PORTB em 0.
     PORTB.RB1=0;         // Todos os pinos do PORTB em 0.
     PORTB.RB2=0;         // Todos os pinos do PORTB em 0.
     PORTB.RB3=0;         // Todos os pinos do PORTB em 0.
     PORTB.RB4=0;         // Todos os pinos do PORTB em 0.
     PORTB.RB5=0;         // Todos os pinos do PORTB em 0.
     PORTB.RB6=0;         // Todos os pinos do PORTB em 0.
     PORTB.RB7=0;         // Todos os pinos do PORTB em 0.
     
      PORTB.RA5=0;         // Todos os pinos do PORTB em 0.

    iLeituraAD= ADC_Read(2);         //sensor de temperatura
        iLeituraAD/=2;

      Delay_ms(2);

      if(iLeituraAD >= 25)
      {
         PWM1_Init(5000);
         PWM1_Set_Duty(iLeituraAD * 5);
         PWM1_Start();
      }
      else
      {
          PWM1_Stop();
      }

      uiValor = iLeituraAD;
      Delay_ms(2);
      PORTD = ucMask[uiValor%10];
      PORTA.RA5 = 1;
      Delay_ms(2);
      PORTA.RA5 = 0;
      uiValor/=10;
      PORTD = ucMask[uiValor%10];
      PORTA.RA4 = 1;
      Delay_ms(2);
      PORTA.RA4 = 0;
      Delay_ms(2);

     if (Control == 0){   // O PIC (Control = 0) envia um caracter e o Arduino responde com outro caracter.
       UART1_Write('T');
       lcd_out(1,1,"PIC Send/Receive");
       lcd_out(2,1,"Send = T");
       Delay_ms(50);
       if(UART1_Data_Ready()){  // Verifica se o dado enviado foi recebido no buffer
         ucRead = UART1_Read(); // Lê o dado da serial.
         Delay_ms(50);   // Pausa de 100ms.
         if (ucRead == 'S'){
          lcd_out(2,10,"Rec.= ");
          lcd_chr_cp (ucRead);
          }
       }
     }

     if (Control == 1){   // O PIC (Control = 0) envia um caracter e o Arduino responde com outro caracter.
       if(UART1_Data_Ready()){  // Verifica se o dado enviado foi recebido no buffer
         ucRead = UART1_Read(); // Lê o dado da serial.
         Delay_ms(50);   // Pausa de 100ms.
         if (ucRead == 'M'){
                     Lcd_Cmd(_LCD_CLEAR);                      //Limpa display
            lcd_out(1,1,"SITUACAO : ");
            lcd_out(2,1,"INCENDIO");
            if(!mode){
               PORTC.RC1 = ~PORTC.RC1;   //invers?o de estado do buzzer
               PORTB.RB0=1;         // Todos os pinos do PORTB em 0.

               PORTB.RB1=1;         // Todos os pinos do PORTB em 0.
               delay_ms(100);   //delay de 1000 milisegundos
               PORTB.RB2=1;         // Todos os pinos do PORTB em 0.
               delay_ms(100);   //delay de 1000 milisegundos
               PORTB.RB3=1;         // Todos os pinos do PORTB em 0.
               delay_ms(100);   //delay de 1000 milisegundos
               PORTB.RB4=1;         // Todos os pinos do PORTB em 0.
               delay_ms(100);   //delay de 1000 milisegundos
               PORTB.RB5=1;         // Todos os pinos do PORTB em 0.
               delay_ms(100);   //delay de 1000 milisegundos
               PORTB.RB6=1;         // Todos os pinos do PORTB em 0.
               delay_ms(100);   //delay de 1000 milisegundos
               PORTB.RB7=1;         // Todos os pinos do PORTB em 0.
               delay_ms(100);   //delay de 1000 milisegundos
               mode = 1;
            }
            delay_ms(1000);   //delay de 1000 milisegundos




         }
         if (ucRead == 'N'){

            Lcd_Cmd(_LCD_CLEAR);                      //Limpa display
            lcd_out(1,1,"SITUACAO");
            lcd_out(2,1,"OK");
               PORTC.RC1 = 1;   //invers?o de estado
               PORTB.RB0=0;         // Todos os pinos do PORTB em 0.
                PORTB.RB1=0;         // Todos os pinos do PORTB em 0.
               PORTB.RB2=0;         // Todos os pinos do PORTB em 0.
               PORTB.RB3=0;         // Todos os pinos do PORTB em 0.
               PORTB.RB4=0;         // Todos os pinos do PORTB em 0.
               PORTB.RB5=0;         // Todos os pinos do PORTB em 0.
               PORTB.RB6=0;         // Todos os pinos do PORTB em 0.
               PORTB.RB7=0;         // Todos os pinos do PORTB em 0.
               mode = 0;
         }
          if (ucRead == 'F'){          //sitema desligado

             Lcd_Cmd(_LCD_CLEAR);                      //Limpa display
             Display_LCD();  // Escreve no display lcd o valor
             Leitura_RTC();  // Efetua leitura de segundo, minuto e horas do DS1307
             Delay_ms(200);  // Delay de 200 milisegundos

         }
       UART1_Write('P');
      // lcd_out(2,9,"Send = P");
       Delay_ms(50);
       }
     }
   }
}