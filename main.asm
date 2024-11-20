;Armazenar uma tabela de caracteres alfanum�ricos (mai�sculas, min�sculas e d�gitos) na mem�ria IRAM do Atmega2560, no padr�o ASCII, a partir do endere�o 0x200. 
;Armazenar tamb�m o c�digo ASCII do espa�o em branco (0x20). Armazenar tamb�m o c�digo correspondente ao comando <ESC> (0x1B).

;DEFININDO VARI�VEIS
.DEF caractere = r16
.DEF flag = r17 ;ponto de parada
.DEF contador = r18
.DEF termo = r19


;CRIANDO TABELA DOS DIGITOS

;carregand os valores nos registradores
inicio:
ldi  caractere,0x30;inicando com o valor 0x30 correspondente ao digito 0
ldi termo,0x1
ldi flag,0xA
ldi r27,0x02 ; apontadores do endere�o incialmente 0x200
ldi r26,0x00

tabelaDigito:
st X,caractere
add caractere,termo
inc contador 
inc r26
cp flag,contador
brne tabelaDigito

;REATRIBUINDO OS VALORES INICIAIS
ldi caractere,0X41 ;codigo A maiusculo
ldi flag,0X1A
ldi contador,0x0

tabelaMaiusculo:
;Criando tabela maiuscula
st X,caractere
add caractere,termo
inc contador 
inc r26
cp flag,contador
brne tabelaMaiusculo

;REATRIBUINDO OS VALORES INICIAIS
ldi caractere,0X61 ;codigo a minusuculo
ldi contador,0x0 ;redefinindo contador

tabelaMinusculo:
;Criando tabela minuscula
st X,caractere
add caractere,termo
inc contador 
inc r26
cp flag,contador
brne tabelaMinusculo

;ARMAZENANDO O ESPA�O EM BRANCO E O ESC
ldi caractere,0X20
st X,caractere
inc r26
ldi caractere,0x1B
st X,caractere

break

 