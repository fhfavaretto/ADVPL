//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "Totvs.ch"

//Constantes
#Define STR_PULA		Chr(13)+Chr(10)

User Function RelUsrF()

	Local wnrel
	Local cString   := "SRA"
	Local titulo    := "Relatorio Vinculo Funcional"
	Local NomeProg  := "RelUsrF"
	Local Tamanho   := "M"

	PRIVATE aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }

	wnrel:=SetPrint(cString,NomeProg,"",@titulo,"", "", "",.F.,.F.,.F.,Tamanho,,.F.)

	If nLastKey <> 27
		SetDefault(aReturn,cString)
		If nLastKey <> 27
			RptStatus({|lEnd| U_TestRel(@lEnd,wnRel,cString,Tamanho,NomeProg)},titulo)
		EndIf
	EndIf

Return

User Function TestRel(lEnd,WnRel,cString,Tamanho,NomeProg)
	Local aArea    := GetArea()
	LOCAL cabec1,cabec2
	LOCAL cRodaTxt := oemtoansi("Rodapé")
	Local nCntImpr
	Local nTipo
	Local cFilialx := ""
	Local n := 0
	Local x := 0
	Local nQtdUsr := 0
	Local nQtdMdt := 0
	Local nTotUsr := 0
	Local nTotMdt := 0
	Local cModulos := ""
	Local cUsSVin  := ""
	Local cUsrRes  := ""
	Local cUsrAdm  := "000000"

	Private nLinEnc := 0
	Private cQryAux := ""
	Private cMat    := ""
	Private aUsuarios := {} //FWSFALLUSERS(,{"USR_NOME","USR_CODFUNC","USR_FILIAL"}) //AllUsers()
	Private aModulo := {}

	nCntImpr := 0
	li := 80
	m_pag := 1

//³ Inicializa os codigos de caracter Comprimido da impressora ³
	nTipo := 15

	cQryAux := ""
	cQryAux += "SELECT * FROM SYS_USR su JOIN SYS_USR_VINCFUNC suv ON su.USR_ID  = suv.USR_ID AND suv.D_E_L_E_T_ =' ' /*JOIN SYS_USR_MODULE sum2 on sum2.USR_ID  = su.USR_ID AND sum2.D_E_L_E_T_ =' '*/ WHERE su.D_E_L_E_T_ =' ' "		+ STR_PULA
	cQryAux := ChangeQuery(cQryAux)
	TCQuery cQryAux New Alias "QRY"

	While !QRY->(EOF())

		If !Empty(QRY->USR_CODFUNC) .AND. QRY->USR_MSBLQL == "2"

			If !Empty(cMat)
				cMat += ","
			EndIf

			cMat += "'"+QRY->USR_CODFUNC+"'"

		ElseiF Empty(QRY->USR_CODFUNC) .AND. QRY->USR_MSBLQL == "2"

			If !Empty(cUsSVin)
				cUsSVin += ","
			EndIf

			If Len(cUsSVin) > 84 .AND. Len(cUsSVin) <= 99
				cUsSVin += STR_PULA
				cUsSVin += IIf(QRY->USR_ID $ cUsrAdm,"",QRY->USR_ID)
			Else
				cUsSVin += IIf(QRY->USR_ID $ cUsrAdm,"",QRY->USR_ID)
			End


		Else

			StrTran(cMat,",","",Len(cMat)-1)

		EndIf

		//USR_ID,USR_NOME,USR_MSBLQL,USR_FILIAL,USR_CODFUNC
		aAdd(aUsuarios,{QRY->USR_ID, QRY->USR_NOME, QRY->USR_MSBLQL, QRY->USR_FILIAL, QRY->USR_CODFUNC,{}})

		QRY->(DbSkip())

	End



	For n := 1 to Len(aUsuarios)

		aModulo := {}

		cQryAux := ""
		cQryAux += "SELECT * FROM SYS_USR su JOIN SYS_USR_VINCFUNC suv ON su.USR_ID  = suv.USR_ID AND suv.D_E_L_E_T_ =' ' JOIN SYS_USR_MODULE sum2 on sum2.USR_ID  = su.USR_ID AND sum2.D_E_L_E_T_ =' ' WHERE su.D_E_L_E_T_ =' ' AND su.USR_ID = '"+aUsuarios[n,1]+"' "		+ STR_PULA
		cQryAux := ChangeQuery(cQryAux)

		If Select("QRY2") > 0
			QRY2->(DbCloseArea())
		EndIf

		TCQuery cQryAux New Alias "QRY2"

		While !QRY2->(EOF())

			aAdd(aModulo,{QRY2->USR_CODMOD,QRY2->USR_ACESSO})

			QRY2->(DbSkip())

		End

		aUsuarios[n,6] := aModulo

	Next

//³ Monta os Cabecalhos                                          ³
	titulo:= oemtoansi("Lista de Usuarios")
	cabec1:= oemtoansi("FILIAL  MATRICULA  NOME                                         USUARIO    STATUS    MODULOS              ")
	cabec2:=""

/*
	For n := 1 to Len(aUsuarios)


		If !Empty(Right(aUsuarios[n][1][22],6)) .AND. aUsuarios[n][1][17] == .F.

			If !Empty(cMat)
				cMat += ","
			EndIf

			cMat += "'"+Right(aUsuarios[n][1][22],6)+"'"

		ElseiF Empty(Right(aUsuarios[n][1][22],6)) .AND. aUsuarios[n][1][17] == .F.

			If !Empty(cUsSVin)
				cUsSVin += ","
			EndIf

			If Len(cUsSVin) > 84 .AND. Len(cUsSVin) <= 99
				cUsSVin += STR_PULA
				cUsSVin += IIf(aUsuarios[n][1][1] $ cUsrAdm,"",aUsuarios[n][1][1])
			Else
				cUsSVin += IIf(aUsuarios[n][1][1] $ cUsrAdm,"",aUsuarios[n][1][1])
			End


		Else

			StrTran(cMat,",","",Len(cMat)-1)

		EndIf

	Next

	If Right(cMat,1) == ","
		StrTran(cMat,",","",Len(cMat)-1)
	EndIf

	If Right(cUsSVin,1) == ","
		StrTran(cUsSVin,",","",Len(cUsSVin)-1)
	EndIf
*/

	If Empty(cMat)
		cMat := "' '"
	EndIF

	//Montando consulta de dados
	cQryAux := ""
	cQryAux += "SELECT RA_FILIAL FILIAL, RA_MAT MATRICULA, SUBSTR(RA_NOMECMP,1,50) NOME, '      ' USUARIO, CASE WHEN RA_SITFOLH = ' ' THEN 'NORMAL' WHEN RA_SITFOLH = 'A' "		+ STR_PULA
	cQryAux += "THEN 'AFASTADO' WHEN RA_SITFOLH = 'F' THEN 'FERIAS' ELSE 'DEMITIDO' END STATUS  FROM "+RetSqlName("SRA")+" SRA010 WHERE RA_MAT IN("+cMat+") "		+ STR_PULA
	cQryAux += "AND SRA010.D_E_L_E_T_=' ' ORDER BY 1,3 "		+ STR_PULA
	cQryAux := ChangeQuery(cQryAux)

	//Executando consulta e setando o total da régua
	TCQuery cQryAux New Alias "QRY_AUX"

	QRY_AUX->(dbGoTop())

	SetRegua(LastRec())

	If !Empty(QRY_AUX->RA_MAT)


		While !QRY_AUX->(Eof())

			IncRegua()

			If Li > 60
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
				@ Li,0 PSAY __PrtThinLine()
			Endif

			nCntImpr++
			Li++

			nQtdUsr++
			nTotUsr++
			cModulos := ""

			nLinEnc := aScan(aUsuarios, {|x| AllTrim(x[4])+AllTrim(x[5]) == QRY_AUX->(FILIAL+MATRICULA) })

			If QRY_AUX->STATUS == "DEMITIDO"

				If !Empty(cUsrRes)
					cUsrRes += ","
				EndIf

				cUsrRes += IIF( nLinEnc >  0, Right(aUsuarios[nLinEnc][5],6), "")

				If Right(cUsrRes,1) == ","
					StrTran(cUsrRes,",","",Len(cUsrRes)-1)
				EndIf

			EndIf

			If nLinEnc > 0

				For x := 1 to LEN(aUsuarios[nLinEnc][6])

					Do Case
					Case "SIGAATF"  $ Upper(aUsuarios[nLinEnc][6][x][1]) .AND. Upper(aUsuarios[nLinEnc][6][x][2]) == "T"
						cModulos += "ATF"
						If !Empty(cModulos)
							cModulos += ","
						EndIf

					Case "SIGACOM"  $ Upper(aUsuarios[nLinEnc][6][x][1]) .AND. Upper(aUsuarios[nLinEnc][6][x][2]) == "T"
						cModulos += "COM"
						If !Empty(cModulos)
							cModulos += ","
						EndIf

					Case "SIGAFAT"  $ Upper(aUsuarios[nLinEnc][6][x][1]) .AND. Upper(aUsuarios[nLinEnc][6][x][2]) == "T"
						cModulos += "FAT"
						If !Empty(cModulos)
							cModulos += ","
						EndIf

					Case "SIGAFIN"  $ Upper(aUsuarios[nLinEnc][6][x][1]) .AND. Upper(aUsuarios[nLinEnc][6][x][2]) == "T"
						cModulos += "FIN"
						If !Empty(cModulos)
							cModulos += ","
						EndIf

					Case "SIGAPON"  $ Upper(aUsuarios[nLinEnc][6][x][1]) .AND. Upper(aUsuarios[nLinEnc][6][x][2]) == "T"
						cModulos += "PON"
						If !Empty(cModulos)
							cModulos += ","
						EndIf

					Case "SIGACTB"  $ Upper(aUsuarios[nLinEnc][6][x][1]) .AND. Upper(aUsuarios[nLinEnc][6][x][2]) == "T"
						cModulos += "CTB"
						If !Empty(cModulos)
							cModulos += ","
						EndIf

					Case "SIGAMDT"  $ Upper(aUsuarios[nLinEnc][6][x][1]) .AND. Upper(aUsuarios[nLinEnc][6][x][2]) == "T"
						cModulos += "MDT"
						If !Empty(cModulos)
							cModulos += ","
						EndIf

					Case "SIGAGCT"  $ Upper(aUsuarios[nLinEnc][6][x][1]) .AND. Upper(aUsuarios[nLinEnc][6][x][2]) == "T"
						cModulos += "GCT"
						If !Empty(cModulos)
							cModulos += ","
						EndIf

					Case "SIGAPMS"  $ Upper(aUsuarios[nLinEnc][6][x][1]) .AND. Upper(aUsuarios[nLinEnc][6][x][2]) == "T"
						cModulos += "PMS"
						If !Empty(cModulos)
							cModulos += ","
						EndIf

					Case "SIGATAF"  $ Upper(aUsuarios[nLinEnc][6][x][1]) .AND. Upper(aUsuarios[nLinEnc][6][x][2]) == "T"
						cModulos += "TAF"
					EndCase

				Next

			EndIf

			If "MDT" $ cModulos
				nQtdMdt++
				nTotMdt++
			EndIf

			If AllTrim(cModulos) == "MDT"
				nTotUsr--
			EndIf


			If Empty(cFilialx)
				cFilialx := QRY_AUX->FILIAL
			ElseIf QRY_AUX->FILIAL <> cFilialx
				cFilialx := QRY_AUX->FILIAL
				@ Li,10 PSAY "Quantidade de usuarios: " + IIf(nQtdUsr > 0,AllTrim(Str(nQtdUsr)),"") + IIf(nQtdMdt > 0, " - Quantidade Medicina: "+AllTrim(Str(nQtdMdt)),"")
				Li++
				Li++
				nQtdUsr := 0
				nQtdMdt := 0
			EndIf

			@ Li,01 PSAY QRY_AUX->FILIAL
			@ Li,08 PSAY QRY_AUX->MATRICULA
			@ Li,16 PSAY QRY_AUX->NOME

			If nLinEnc > 0
				@ Li,66 PSAY aUsuarios[nLinEnc][1]
			Else
				@ Li,66 PSAY Space(10)
			EndIf

			@ Li,75 PSAY QRY_AUX->STATUS

			If Right(AllTrim(cModulos),1) == ","
				cModulos := Substr(AllTrim(cModulos),1,len(AllTrim(cModulos))-1)
			EndIf

			@ Li,85 PSAY cModulos

			If Li > 115
				Li:=115
			Endif

			dbSkip()

		EndDO

	Else

		LeFunc()

	EndIf

	Li++
	@ Li,10 PSAY "Quantidade de usuarios: " + IIf(nQtdUsr > 0,AllTrim(Str(nQtdUsr)),"") /*+ IIf(nQtdMdt > 0, " - Quantidade Medicina: "+AllTrim(Str(nQtdMdt)),"")*/
	Li++
	Li++
	//@ Li,10 PSAY "Total de usuarios: " + IIf(nTotUsr > 0,AllTrim(Str(nTotUsr)),"") /*+ IIf(nTotMdt > 0, " - Total Medicina: "+AllTrim(Str(nTotMdt)),"")*/

	Li++
	Li++
	@ Li,1 PSAY "Modulos: "
	Li++
	@ Li,1 PSAY "ATF = Ativo Fixo"
	Li++
	@ Li,1 PSAY "COM = Compras"
	Li++
	@ Li,1 PSAY "FAT = Faturamento"
	Li++
	@ Li,1 PSAY "FIN = Financeiro"
	Li++
	@ Li,1 PSAY "PON = Ponto Eletronico"
	Li++
	@ Li,1 PSAY "CTB = Contabilidade"
	Li++
	@ Li,1 PSAY "MDT = Medicina e Seg. do Trabalho"
	Li++
	@ Li,1 PSAY "GCT = Gestao de Contratos"
	Li++
	@ Li,1 PSAY "PMS = Gestao de Projetos"
	Li++
	@ Li,1 PSAY "EIC = Easy Import Control"
	Li++
	@ Li,1 PSAY "TAF = Automacao Fiscal"
	Li++
	Li++

	//@ Li, 1 PSAY "Usuarios Vinculo de Funcinario: " + cUsSVin
	Li++
	//@ Li, 1 PSAY "Usuarios de Funcinario Demitidos: " + cUsrRes


	If li != 115
		Roda(nCntImpr,cRodaTxt,Tamanho)
	EndIf

	Set Device to Screen
	If aReturn[5] = 1
		Set Printer To
		dbCommitAll()
		OurSpool(wnrel)
	Endif

	QRY_AUX->(DbCloseArea())
	QRY->(DbCloseArea())

	RestArea(aArea)

	MS_FLUSH()

Return



Static Function LeFunc()
	Local x := 0

	IncRegua()

	If Li > 60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
		@ Li,0 PSAY __PrtThinLine()
	Endif

	nCntImpr++
	Li++

	nQtdUsr++
	nTotUsr++
	cModulos := ""

	//nLinEnc++

	For nLinEnc := 1 to Len(aUsuarios)

		//If nLinEnc > 0

		For x := 1 to LEN(aUsuarios[nLinEnc][6])

			Do Case
			Case "SIGAATF"  $ Upper(aUsuarios[nLinEnc][6][x][1]) .AND. Upper(aUsuarios[nLinEnc][6][x][2]) == "T"
				cModulos += "ATF"
				If !Empty(cModulos)
					cModulos += ","
				EndIf

			Case "SIGACOM"  $ Upper(aUsuarios[nLinEnc][6][x][1]) .AND. Upper(aUsuarios[nLinEnc][6][x][2]) == "T"
				cModulos += "COM"
				If !Empty(cModulos)
					cModulos += ","
				EndIf

			Case "SIGAFAT"  $ Upper(aUsuarios[nLinEnc][6][x][1]) .AND. Upper(aUsuarios[nLinEnc][6][x][2]) == "T"
				cModulos += "FAT"
				If !Empty(cModulos)
					cModulos += ","
				EndIf

			Case "SIGAFIN"  $ Upper(aUsuarios[nLinEnc][6][x][1]) .AND. Upper(aUsuarios[nLinEnc][6][x][2]) == "T"
				cModulos += "FIN"
				If !Empty(cModulos)
					cModulos += ","
				EndIf

			Case "SIGAPON"  $ Upper(aUsuarios[nLinEnc][6][x][1]) .AND. Upper(aUsuarios[nLinEnc][6][x][2]) == "T"
				cModulos += "PON"
				If !Empty(cModulos)
					cModulos += ","
				EndIf

			Case "SIGACTB"  $ Upper(aUsuarios[nLinEnc][6][x][1]) .AND. Upper(aUsuarios[nLinEnc][6][x][2]) == "T"
				cModulos += "CTB"
				If !Empty(cModulos)
					cModulos += ","
				EndIf

			Case "SIGAMDT"  $ Upper(aUsuarios[nLinEnc][6][x][1]) .AND. Upper(aUsuarios[nLinEnc][6][x][2]) == "T"
				cModulos += "MDT"
				If !Empty(cModulos)
					cModulos += ","
				EndIf

			Case "SIGAGCT"  $ Upper(aUsuarios[nLinEnc][6][x][1]) .AND. Upper(aUsuarios[nLinEnc][6][x][2]) == "T"
				cModulos += "GCT"
				If !Empty(cModulos)
					cModulos += ","
				EndIf

			Case "SIGAPMS"  $ Upper(aUsuarios[nLinEnc][6][x][1]) .AND. Upper(aUsuarios[nLinEnc][6][x][2]) == "T"
				cModulos += "PMS"
				If !Empty(cModulos)
					cModulos += ","
				EndIf

			Case "SIGAEIC"  $ Upper(aUsuarios[nLinEnc][6][x][1]) .AND. Upper(aUsuarios[nLinEnc][6][x][2]) == "T"
				cModulos += "EIC"
				If !Empty(cModulos)
					cModulos += ","
				EndIf

			Case "SIGATAF"  $ Upper(aUsuarios[nLinEnc][6][x][1]) .AND. Upper(aUsuarios[nLinEnc][6][x][2]) == "T"
				cModulos += "TAF"
			EndCase

		Next

		//EndIf
/*
		If "MDT" $ cModulos
			nQtdMdt++
			nTotMdt++
		EndIf

		If AllTrim(cModulos) == "MDT"
			nTotUsr--
		EndIf
*/

		//If Empty(cFilialx)
		//	cFilialx := QRY_AUX->FILIAL
		//ElseIf QRY_AUX->FILIAL <> cFilialx
		//	cFilialx := QRY_AUX->FILIAL
		//	@ Li,10 PSAY "Quantidade de usuarios: " + IIf(nQtdUsr > 0,AllTrim(Str(nQtdUsr)),"") /*+ IIf(nQtdMdt > 0, " - Quantidade Medicina: "+AllTrim(Str(nQtdMdt)),"")*/
		//	Li++
		//	Li++
		//	nQtdUsr := 0
		//	nQtdMdt := 0
		//EndIf

		@ Li,01 PSAY aUsuarios[nLinEnc][4] //QRY_AUX->FILIAL
		@ Li,08 PSAY aUsuarios[nLinEnc][5] //QRY_AUX->MATRICULA
		@ Li,16 PSAY aUsuarios[nLinEnc][2] //QRY_AUX->NOME

		If nLinEnc > 0
			@ Li,66 PSAY aUsuarios[nLinEnc][1]
		Else
			@ Li,66 PSAY Space(10)
		EndIf

		@ Li,75 PSAY " " //QRY_AUX->STATUS

		If Right(AllTrim(cModulos),1) == ","
			cModulos := Substr(AllTrim(cModulos),1,len(AllTrim(cModulos))-1)
		EndIf

		@ Li,85 PSAY cModulos

		If Li > 115
			Li:=115
		Endif

Return Nil
