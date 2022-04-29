//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "Totvs.ch"

User Function ExcSqlArq()
	Local aArea   := GetArea()
	Local cLinha := ""  
    Local aDados := {}
    Local nTamLinha := 0
    Local nTamArq:= 0
	Local cArqImpor := "C:\temp\QUERY.txt"
	Local nStatus  := 0

    cArqImpor := FWInputBox("Informe o caminho e arquivo (ex: C:\temp\QUERY.txt):", "")

    If Lower(Right(AllTrim(cArqImpor),3)) <> "txt"
        MsgInfo("O arquivo precisa estar no formato TXT","Aten��o")
        cArqImpor := ""
    EndIf

    //Valida arquivo
    If !file(cArqImpor)
        Aviso("Arquivo","Arquivo n�o selecionado ou invalido.",{"Sair"},1)
        Return
    Else     
        //+---------------------------------------------------------------------+
        //| Abertura do arquivo texto                                           |
        //+---------------------------------------------------------------------+
        nHdl := fOpen(cArqImpor)
    
        If nHdl == -1 
            IF FERROR()== 516 
                ALERT("Feche a planilha que gerou o arquivo.")
            EndIF
        EndIf
        
        //+---------------------------------------------------------------------+
        //| Verifica se foi poss�vel abrir o arquivo                            |
        //+---------------------------------------------------------------------+
        If nHdl == -1
            cMsg := "O arquivo de nome "+cArqImpor+" nao pode ser aberto! Verifique os parametros."
            MsgAlert(cMsg,"Atencao!")
            Return
        Endif
        
        //+---------------------------------------------------------------------+
        //| Posiciona no Inicio do Arquivo                                      |
        //+---------------------------------------------------------------------+
        FSEEK(nHdl,0,0)
        
        //+---------------------------------------------------------------------+
        //| Traz o Tamanho do Arquivo TXT                                       |
        //+---------------------------------------------------------------------+
        nTamArq:=FSEEK(nHdl,0,2)
        
        //+---------------------------------------------------------------------+
        //| Posicona novamemte no Inicio                                        |
        //+---------------------------------------------------------------------+
        FSEEK(nHdl,0,0)
        
        //+---------------------------------------------------------------------+
        //| Fecha o Arquivo                                                     |
        //+---------------------------------------------------------------------+
        fClose(nHdl)
        FT_FUse(cArqImpor)  //abre o arquivo 
        FT_FGOTOP()         //posiciona na primeira linha do arquivo      
        nTamLinha := Len(FT_FREADLN()) //Ve o tamanho da linha
        FT_FGOTOP()
        
        //+---------------------------------------------------------------------+
        //| Verifica quantas linhas tem o arquivo                               |
        //+---------------------------------------------------------------------+
        nLinhas := nTamArq/nTamLinha
        nCont   := 0
        ProcRegua(nLinhas)
    
        aDados:={}  
        While !FT_FEOF() //Ler todo o arquivo enquanto n�o for o final dele
           
            nCont++
            IncProc('Importando Linha: ' + Alltrim(Str(nCont)) )
          
            clinha := FT_FREADLN() 

            clinha := RmvChEsp(clinha)
    
			nStatus := TcSqlExec(clinha)

		If (nStatus < 0)
			Alert("Erro - TCSQLError() " + TCSQLError())
		Endif
            
            FT_FSKIP()
        EndDo
        FT_FUse()
        fClose(nHdl)
    EndIf
    
    ProcRegua(len(aDados))

	RestArea(aArea)

Return Nil


Static Function RmvChEsp(cWord)

	//cWord := OemToAnsi(cWord)
	//cWord := FwNoAccent(cWord)
	//cWord := FwCutOff(cWord)
	//cWord := StrTran(cWord, "'", "")
	//cWord := StrTran(cWord, "#", "")
	//cWord := StrTran(cWord, "%", "")
	//cWord := StrTran(cWord, "*", "")
	//cWord := StrTran(cWord, "&", "E")
	//cWord := StrTran(cWord, ">", "")
	//cWord := StrTran(cWord, "<", "")
	//cWord := StrTran(cWord, "!", "")
	//cWord := StrTran(cWord, "@", "")
	//cWord := StrTran(cWord, "$", "")
	//cWord := StrTran(cWord, "(", "")
	//cWord := StrTran(cWord, ")", "")
	//cWord := StrTran(cWord, "_", "")
	//cWord := StrTran(cWord, "=", "")
	//cWord := StrTran(cWord, "+", "")
	//cWord := StrTran(cWord, "{", "")
	//cWord := StrTran(cWord, "}", "")
	//cWord := StrTran(cWord, "[", "")
	//cWord := StrTran(cWord, "]", "")
	//cWord := StrTran(cWord, "/", "")
	//cWord := StrTran(cWord, "?", "")
	//cWord := StrTran(cWord, ".", "")
	//cWord := StrTran(cWord, "\", "")
	//cWord := StrTran(cWord, "|", "")
	//cWord := StrTran(cWord, ":", "")
	//cWord := StrTran(cWord, ";", "")
	//cWord := StrTran(cWord, '"', '')

	cWord := StrTran(cWord, '�', 'o')
	cWord := StrTran(cWord, '�', 'a')
	cWord := StrTran(cWord, '�', 'C')
	cWord := StrTran(cWord, '�', 'c')
	cWord := StrTran(cWord, '�', 'a')
	cWord := StrTran(cWord, '�', 'a')
	cWord := StrTran(cWord, '�', 'a')
	cWord := StrTran(cWord, '�', 'a')
	cWord := StrTran(cWord, '�', 'A')
	cWord := StrTran(cWord, '�', 'A')
	cWord := StrTran(cWord, '�', 'A')
	cWord := StrTran(cWord, '�', 'A')
	cWord := StrTran(cWord, '�', 'e')
	cWord := StrTran(cWord, '�', 'e')
	cWord := StrTran(cWord, '�', 'e')
	cWord := StrTran(cWord, '�', 'E')
	cWord := StrTran(cWord, '�', 'E')
	cWord := StrTran(cWord, '�', 'E')
	cWord := StrTran(cWord, '�', 'O')
	cWord := StrTran(cWord, '�', 'o')
	cWord := StrTran(cWord, '�', 'o')
	cWord := StrTran(cWord, '�', 'O')
	cWord := StrTran(cWord, '�', 'O')
	cWord := StrTran(cWord, '�', 'o')
	cWord := StrTran(cWord, '�', 'O')
	cWord := StrTran(cWord, '�', 'o')
	
	cWord := StrTran(cWord, '�', 'I')
	cWord := StrTran(cWord, '�', 'i')
	cWord := StrTran(cWord, '�', 'I')
	cWord := StrTran(cWord, '�', 'i')
	cWord := StrTran(cWord, '�', 'I')
	cWord := StrTran(cWord, '�', 'i')
	
	cWord := StrTran(cWord, '�', 'U')
	cWord := StrTran(cWord, '�', 'u')
	cWord := StrTran(cWord, '�', 'U')
	cWord := StrTran(cWord, '�', 'u')
	cWord := StrTran(cWord, '�', 'U')
	cWord := StrTran(cWord, '�', 'u')

	cWord := StrTran(cWord, '�', 'N')
	cWord := StrTran(cWord, '�', 'n')

	//cWord := StrTran(cWord, ',', '')
	//cWord := StrTran(cWord, '-', '')
	//cWord := StrTran(cWord, '"', '')
	//cWord := strtran(cWord,""+'"'+"","")

	cWord := UPPER(cWord)

Return cWord
