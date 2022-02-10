#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"

/*FUN��O PRINCIPAL / MAIN FUNCTION*/
User Function TRCLIEN()
//VARIAVEIS 
Private oReport  := Nil //NOTA��O POLONESA
Private oSecCab	 := Nil
Private cPerg 	 := "TRCLIEN" //FICAM ARMAZENADAS NA SX1

//Fun��o respons�vel por chamar a pergunta criada na fun��o ValidaPerg, 
//a vari�vel PRIVATE cPerg, � passada.
//Pergunte(cPerg,.T.) // SE TRUE ELE CHAMA A PERGUNTA ASSIM QUE O RELAT�RIO � ACIONADO

//CHAMAMOS AS FUN��ES QUE CONSTRUIR�O O RELAT�RIO
ReportDef() //MONTAR A ESTRUTURA
oReport:PrintDialog() //TRAZER OS DADOS E PRINTA/IMPRIME NA TELA OU EM ARQUIVO OU NA IMPRESSORA O RELAT�RIO

Return 


/*FUN��O RESPONS�VEL PELA ESTRUTURA DO RELAT�RIO*/
Static Function ReportDef()

oReport := TReport():New("CLIENTE","Relat�rio - Clientes",cPerg,{|oReport| PrintReport(oReport)},"Relat�rio de Clientes")

oReport:SetLandscape(.T.) // SIGNIFICA QUE O RELAT�RIO SER� EM PAISAGEM

//TrSection serve para constrole da se��o do relat�rio, neste caso, teremos somente uma
oSecCab := TRSection():New( oReport , "CLIENTES", {"SQL"} )

TRCell():New( oSecCab, "A1_COD", "SA1") 
TRCell():New( oSecCab, "A1_NOME", "SA1")

TRFunction():New(oSecCab:Cell("A1_COD"),,"COUNT",,,,,.F.,.T.,.F.,oSecCab)
Return 


/*FUN��O RESPONS�VEL POR TRAZER OS DADOS*/
Static Function PrintReport(oReport)
Local cAlias := GetNextAlias()


oSecCab:BeginQuery() //Query come�a a ser estruturada no relat�rio
	BeginSql Alias cAlias
		SELECT A1_COD, A1_NOME FROM %table:SA1%
		WHERE %notDel% 
	EndSql	
	/*
	cSQL := "SELECT B1_COD, B1_DESC FROM "+RetsqlName("SB1")
	cSql += " WHERE D_E_L_E_T_ = ' ' "
	*/
oSecCab:EndQuery() //Fim da Query
oSecCab:Print() //� dada a ordem de impress�o, visto os filtros selecionados

(cAlias)->(DbCloseArea())
Return 