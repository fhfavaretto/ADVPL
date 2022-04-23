#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"                                                      

User Function SQLEXCEL()
Local cAlias := GetNextAlias() //Declarei meu ALIAS

Private aCabec := {} //ARRAY DO CABE�ALHO
Private aDados := {} //ARRAY QUE ARMAZENAR� OS DADOS

Private cPerg 	 := "TRFOR" //VARI�VEL QUE ARMAZENA O NOME DO GRUPO DE PERGUNTAS

//Fun��o que cria as perguntas/filtros que iremos usar no relat�rio, na SX1
ValidPerg() 

//Fun��o respons�vel por chamar a pergunta criada na fun��o ValidaPerg, a vari�vel PRIVATE cPerg, � passada.
Pergunte(cPerg,.T.)


//COME�O A MINHA CONSULTA SQL
BeginSql Alias cAlias
		SELECT E2_PREFIXO, E2_NUM, A2_COD,A2_NOME, E2_VALOR FROM %table:SE2% SE2
		INNER JOIN %table:SA2% SA2 ON SE2.E2_FORNECE = SA2.A2_COD AND E2_LOJA = A2_LOJA  
		WHERE E2_FORNECE BETWEEN %exp:(MV_PAR01)% AND %exp:(MV_PAR02)%  //FILTRO WHERE
		AND SE2.%notdel% AND SA2.%notdel%  
EndSql //FINALIZO A MINHA QUERY
	
//CABE�ALHO
aCabec := {"PREFIXO","TITULO","CODFORNECEDOR","NOMEFORNECEDOR","VALORDOTITULO"}

While !(cAlias)->(Eof())

	aAdd(aDados,{E2_PREFIXO,E2_NUM, A2_COD, A2_NOME, E2_VALOR})
	
	(cAlias)->(dbSkip()) //PASSAR PARA O PR�XIMO REGISTRO                                     
enddo

//JOGO TODO CONTE�DO DO ARRAY PARA O EXCEL
DlgtoExcel({{"ARRAY","Relat�rio de t�tulos a pagar", aCabec, aDados}})
	                                          
(cAlias)->(dbClosearea())	

return



/*/{Protheus.doc} ValidPerg
FUN��O RESPONS�VEL POR CRIAR AS PERGUNTAS NA SX1 
@type function
@author Fabio Favaretto
@since 24/06/2019
@version 1.0
/*/Static Function ValidPerg()
	Local aArea  := SX1->(GetArea())
	Local aRegs := {}
	Local i,j

	aadd( aRegs, { cPerg,"01","Fornecedor de ?","Fornecedor de ?","Fornecedor de ?","mv_ch1","C", 6,0,0,"G","","mv_par01","","","mv_par01"," ","",""," ","","","","","","","","","","","","","","","","","","SA2"          } )
	aadd( aRegs, { cPerg,"02","Fornecedor ate ?","Fornecedor ate ?","Fornecedor ate ?","mv_ch2","C", 6,0,0,"G","","mv_par02","","","mv_par02"," ","",""," ","","","","","","","","","","","","","","","","","","SA2"       } )

	DbselectArea('SX1')
	SX1->(DBSETORDER(1))
	For i:= 1 To Len(aRegs)
		If ! SX1->(DBSEEK( AvKey(cPerg,"X1_GRUPO") +aRegs[i,2]) )
			Reclock('SX1', .T.) //FUn��o utilizada para gravar dados em um arquivo/tabela
			FOR j:= 1 to SX1->( FCOUNT() )
				IF j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				ENDIF
			Next j
			SX1->(MsUnlock())
		Endif
	Next i 
	RestArea(aArea) 
Return(cPerg)
