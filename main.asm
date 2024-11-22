;Armazenar uma tabela de caracteres alfanuméricos (maiúsculas, minúsculas e dígitos) na memória IRAM do Atmega2560, no padrão ASCII, a partir do endereço 0x200. 
;Armazenar também o código ASCII do espaço em branco (0x20). Armazenar também o código correspondente ao comando <ESC> (0x1B).

;DEFININDO VARIÁVEIS
.DEF caractere = r16
.DEF flag = r17 ;ponto de parada
.DEF contador = r18
.DEF termo = r19
.DEF input = r20

;DEFININDO AS PORTAS
clr input         ; R20 como 0 para configurar os pinos como entrada
out DDRC, r20    ; Configura todos os pinos de PORTC como entrada
ldi r27,0x03
ldi r26,0x00

;LENDO TABELA INPUT
tabelaInputInicio:
;DEFININDO AS PORTAS
clr input         ; R20 como 0 para configurar os pinos como entrada
out DDRC, r20    ; Configura todos os pinos de PORTC como entrada

tabelaInput:
leitura:
in input,PINC ; Le os valores de pinc e armazena em r20

verficarFimCadeia:
cpi input,0X1B ;verifica se é ESC
breq fimleitura ; Sai da leitura se for esc

verifcarCaractereValido: ; verifica sw o input corresponde a um carctere imprimivel em ascii
cpi input,0X20 ; compara o valor do input com o começo da tabela 
brlo tabelaInputInicio ;retorna a entrada até o caractere ser válido
cpi input,0X7F ;compara a entrada com o final da tabela 
brsh tabelaInputInicio ;se for maior ou igual retorna ao inicio
rjmp verificaArmazenamento

verificaArmazenamento:;Verifica se o limiite do armazenamento chegou
cpi r26,0XFF
brne armazenainput

armazenainput:
st X,input
inc r26
rjmp leitura

fimleitura:
ldi input,0X20
st X,input
inc r26
rjmp tabelaInputInicio

;TAREFA3:determinar o número de caracteres presentes na tabela de sequência de caracteres. 

;1- percorrer a tabela
inicioContaCaracteres:
ldi r27,0x03; endereço inicial da tabela
ldi r26,0x00
clr contador;limpar contador

;2- caso haja um caractere no endereço diferente de epaço somar num contador
;3- caso seja um espaço o passa para o poximo endereço
;4 - armazenar o resultado em memoria
;5- imprimir numa porta de saida




break
 






;CRIANDO TABELA DOS DIGITOS

;carregand os valores nos registradores
inicio:
ldi  caractere,0x30;inicando com o valor 0x30 correspondente ao digito 0
ldi termo,0x1
ldi flag,0xA
ldi r27,0x02 ; apontadores do endereço incialmente 0x200
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

;ARMAZENANDO O ESPAÇO EM BRANCO E O ESC
ldi caractere,0X20
st X,caractere
inc r26
ldi caractere,0x1B
st X,caractere

break

 
