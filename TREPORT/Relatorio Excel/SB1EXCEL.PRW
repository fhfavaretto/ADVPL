#INCLUDE 'protheus.ch'
#include 'topconn.ch'

User Function SB1EXCEL()
Local aDados := { } // array que armazena dos dados da tabela de produtos
Local aCabec := { } // array que armazenar o conteudo do cabeçario
Local cQuery := " " // variavel que armazenará a query

aCabec = {"FILIAL","CODIGO","CODIGO","TIPO"}


cQuery = "SELECT B1_FILIAL, B1_COD, B1_DESC, B1_TIPO FROM "+RetSqlName("SB1")+" AS SB1"
cQuery = "WHERE D_E_L_E_T_ = ' ' "


TCQUERY cQuery new Alias "SB1"

IF SELECT("SB1") > 0
SB1->(DBCLOSEAREA())
endif


WHILE !SB1->(EOF())//ENQUANTO NÃO CHEGAR AO FINAL DO ARQUIVO CONTINUE LENDO

    Aadd(aDados, {SB1->B1_FILIAL,SB1->B1_COD,SB1->B1_DESC,SB1->B1_TIPO})

SB1->(DBSKIP())
ENDDO

SB1->(DBCLOSEAREA())

DlgToExcel({{"ARRAY","RELATORIO PRODUTOS",aCabec,aDados}})

RETURN 
