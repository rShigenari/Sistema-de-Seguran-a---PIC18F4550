#line 1 "C:/Users/aluno/Pictures/PROJPIC_NAOFUNC/PROJPIC.c"
#line 16 "C:/Users/aluno/Pictures/PROJPIC_NAOFUNC/PROJPIC.c"
sbit LCD_RS at RE2_bit;
sbit LCD_EN at RE1_bit;
sbit LCD_D7 at RD7_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D4 at RD4_bit;


sbit LCD_RS_Direction at TRISE2_bit;
sbit LCD_EN_Direction at TRISE1_bit;
sbit LCD_D7_Direction at TRISD7_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD4_bit;


unsigned int uiValor;

unsigned char *ucTexto;
unsigned int iLeituraAD = 0;
unsigned char ucMask[] = {0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};

unsigned char ucHora;
unsigned char ucMinuto;
unsigned char ucSegundo;
unsigned char ucDia;
unsigned char ucMes;
unsigned char ucAno;
unsigned char ucDia_Semana;

int mode = 0;


void Converte_BCD(unsigned char ucLinha, unsigned char ucColuna,unsigned char ucValor) {
 unsigned char ucValor1, ucValor2;

 ucValor1 = (ucValor >> 4 ) + '0';
 Lcd_Chr(ucLinha,ucColuna,ucValor1);
 ucValor2 = (ucValor & 0x0F) + '0';
 Lcd_Chr_CP(ucValor2);
}

void Leitura_RTC() {
 I2C1_Start();
 I2C1_Wr(0xD0);
 I2C1_Wr(0);
 I2C1_Repeated_Start();
 I2C1_Wr(0xD1);
 ucSegundo = I2C1_Rd(1);
 ucMinuto = I2C1_Rd(1);
 ucHora = I2C1_Rd(1);
 ucDia_Semana = I2C1_Rd(1);
 ucDia = I2C1_Rd(1);
 ucMes = I2C1_Rd(1);
 ucAno = I2C1_Rd(0);
 I2C1_Stop();
}

void Grava_RTC(){
 I2C1_Init(100000);
 I2C1_Start();
 I2C1_Wr(0xD0);
 I2C1_Wr(0);
 I2C1_Wr(0x04);
 I2C1_Wr(0x12);
 I2C1_Wr(0x09);
 I2C1_Wr(0x03);
 I2C1_Wr(0x15);
 I2C1_Wr(0x07);
 I2C1_Wr(0x09);
 I2C1_Stop();
}

void Encontra_Dia_Semana() {
 switch (ucDia_Semana) {
 case 01: ucTexto = "DOMINGO"; break;
 case 02: ucTexto = "SEGUNDA"; break;
 case 03: ucTexto = "TERCA"; break;
 case 04: ucTexto = "QUARTA"; break;
 case 05: ucTexto = "QUINTA"; break;
 case 06: ucTexto = "SEXTA"; break;
 default: ucTexto = "SABADO";
 }
}

void Display_LCD() {
 Lcd_Out(1,1,"(Hora)");
 Converte_BCD(1,7,ucHora);
 Lcd_Chr_CP(':');
 Converte_BCD(1,10,ucMinuto);
 Lcd_Chr_CP(':');
 Converte_BCD(1,13,ucSegundo);
 Lcd_Out(2,1,"(Data)");
 Converte_BCD(2,7,ucDia);
 Lcd_Chr_CP('/');
 Converte_BCD(2,10,ucMes);
 Lcd_Chr_CP('/');
 Converte_BCD(2,13,ucAno);
 Encontra_Dia_Semana();
 Lcd_Out(3,1,ucTexto);
}


void main(){

 char ucRead;
 unsigned int Control = 1;


 ADCON1 = 0x0E;

 TRISD = 0;
 TRISC.RC1 = 0;

 TRISB =0;
 PORTB = 0;

 ADCON1 = 0x0F;

 TRISA.RA4 = 0;
 TRISA.RA5 = 0;
 TRISC.RC5 = 0;
 CMCON = 0X07;


 Lcd_Init();

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Grava_RTC();

 UART1_Init(9600);

 while(1){
 PORTB.RB0=0;
 PORTB.RB1=0;
 PORTB.RB2=0;
 PORTB.RB3=0;
 PORTB.RB4=0;
 PORTB.RB5=0;
 PORTB.RB6=0;
 PORTB.RB7=0;

 PORTB.RA5=0;

 iLeituraAD= ADC_Read(2);
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

 if (Control == 0){
 UART1_Write('T');
 lcd_out(1,1,"PIC Send/Receive");
 lcd_out(2,1,"Send = T");
 Delay_ms(50);
 if(UART1_Data_Ready()){
 ucRead = UART1_Read();
 Delay_ms(50);
 if (ucRead == 'S'){
 lcd_out(2,10,"Rec.= ");
 lcd_chr_cp (ucRead);
 }
 }
 }

 if (Control == 1){
 if(UART1_Data_Ready()){
 ucRead = UART1_Read();
 Delay_ms(50);
 if (ucRead == 'M'){
 Lcd_Cmd(_LCD_CLEAR);
 lcd_out(1,1,"SITUACAO : ");
 lcd_out(2,1,"INCENDIO");
 if(!mode){
 PORTC.RC1 = ~PORTC.RC1;
 PORTB.RB0=1;

 PORTB.RB1=1;
 delay_ms(100);
 PORTB.RB2=1;
 delay_ms(100);
 PORTB.RB3=1;
 delay_ms(100);
 PORTB.RB4=1;
 delay_ms(100);
 PORTB.RB5=1;
 delay_ms(100);
 PORTB.RB6=1;
 delay_ms(100);
 PORTB.RB7=1;
 delay_ms(100);
 mode = 1;
 }
 delay_ms(1000);




 }
 if (ucRead == 'N'){

 Lcd_Cmd(_LCD_CLEAR);
 lcd_out(1,1,"SITUACAO");
 lcd_out(2,1,"OK");
 PORTC.RC1 = 1;
 PORTB.RB0=0;
 PORTB.RB1=0;
 PORTB.RB2=0;
 PORTB.RB3=0;
 PORTB.RB4=0;
 PORTB.RB5=0;
 PORTB.RB6=0;
 PORTB.RB7=0;
 mode = 0;
 }
 if (ucRead == 'F'){

 Lcd_Cmd(_LCD_CLEAR);
 Display_LCD();
 Leitura_RTC();
 Delay_ms(200);

 }
 UART1_Write('P');

 Delay_ms(50);
 }
 }
 }
}
