;Armazenar uma tabela de caracteres alfanuméricos (maiúsculas, minúsculas e dígitos) na memória IRAM do Atmega2560, no padrão ASCII, a partir do endereço 0x200. 
;Armazenar também o código ASCII do espaço em branco (0x20). Armazenar também o código correspondente ao comando <ESC> (0x1B).

;DEFININDO VARIÁVEIS
.DEF caractere = r16
.DEF flag = r17 ;ponto de parada
.DEF contador = r18
.DEF termo = r19
.DEF input = r20
.DEF somaCaractere = r21
.DEF comparador = r22

;TAREFA 2
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
brsh aparicaoCaractereInicio;tabelaInputInicio ;se for maior ou igual retorna ao inicio
rjmp verificaArmazenamento

verificaArmazenamento:;Verifica se o limiite do armazenamento chegou
cpi r26,0XFF
brne armazenainput

armazenainput:
st X,input
inc r26
rjmp leitura

fimleitura:
ldi input,0X20 ; tribui o espaço em branco
st X,input ; armazena o espaço em branco 
inc r26
rjmp tabelaInputInicio

;TAREFA3:determinar o número de caracteres presentes na tabela de sequência de caracteres. 

;1- percorrer a tabela
inicioContaCaracteres:
ldi r27,0x03; endereço inicial da tabela
ldi r26,0x00
ldi somaCaractere,0xFF; R21 como FF para configurar os pinos como saída
out DDRD, somaCaractere; Configura todos os pinos de PORTD como saída
clr contador;limpar contador
clr caractere;limpar r16
clr somaCaractere;limpar somaCaractere

contaCaracteres:
ld caractere,X; 1 - armazenar valor do caracter na tabela num registrador
cpi caractere,0X20;2- cericar se caractere é um espaço em branco
breq espacoEmBranco; ignora o espaço
cpi caractere,0X00;Verifica se o espaço está vazio caso esteja significa q a tabela já foi preenchida 
breq imprimirCaractere ;caso chegue no fim da tabele direciona até a impressão
inc somaCaractere ;se for um caractere valido acrescenta um no contador de soma
sts 0X401,somaCaractere;armazena valor da soma no endereço


espacoEmBranco:;3-caso caractere seja igual ao espaço em branco,verifique o proximo
inc r26
rjmp contaCaracteres

imprimirCaractere:;5- imprimir numa porta de saida
out PORTD,somaCaractere


; TAREFA 4: ler um novo byte correspondente a um caractere em uma porta de entrada e contar o número de vezes que o caractere está presente na tabela de sequência de caracteres
; Armazenar o resultado no endereço de memória 0x402. Verificar se o caractere de entrada é válido. Caso o caractere disponibilizado na entrada não seja válido, 
;ler um novo caractere em loop até a entrada apresentar um caractere válido.

aparicaoCaractereInicio:
clr contador ; limpa contador      
ldi input,0xFF; R21 como FF para configurar os pinos como saída
out DDRD, input; Configura todos os pinos de PORTD como saída
ldi r27,0X03;definindo os endereços da tabela
ldi r26,0X00

aparicaoCaractere:
;1- LER BYTE DE ENTRADA
clr input
out DDRC, input ;define pinc como entrada
in input,PINC ;armazena input em r20
;2- VERIFICAR SE É VALIDO
validacaoEntrada:
cpi input,0X20
brlo caractereInvalido ;retorna a entrada até o caractere ser válido
cpi input,0X7F ;compara a entrada com o final da tabela 
brsh caractereInvalido;tabelaInputInicio ;se for maior ou igual retorna ao inicio
;3 - (SE VALIDO) CONTAR NUMERO DE VEZES Q APAREE NA TABELA
comparacao:
ld comparador,X ;3.1 - armazenar o valor da tabela caractere num registrador
cpi comparador,0X00 ;Verifica se chegou ao fim da tabela
breq imprimiComparacao
cp comparador,input ;3.2 compara com o valor de input
breq aparicao;3.3- Se o comparador for igual direciona a aparicao
inc r26;3-4 Se não for igual continua a verificar até chegar no fim da tabela
rjmp comparacao

aparicao:;3.4 - incrementa variavel de aparicoes
inc contador
inc r26
rjmp comparacao
;4- ARMAZENAR RESULTADO NA MEMÓRIA(0X402)
armazenaComparacao:
sts 0X402,contador
;5 - LIBERA NA PORTA DE SAIDA
imprimiComparacao:
out PORTD,contador
clr r26; reinicia o percorrer da tabela

;(SE NÃO) LER NOVAMENTE(PASSO 1)
caractereInvalido:
rjmp aparicaoCaractere


 
; TAREFA 1 CRIANDO TABELA DOS DIGITOS

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

 
