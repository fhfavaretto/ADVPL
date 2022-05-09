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
        MsgInfo("O arquivo precisa estar no formato TXT","Atenзгo")
        cArqImpor := ""
    EndIf

    //Valida arquivo
    If !file(cArqImpor)
        Aviso("Arquivo","Arquivo nгo selecionado ou invalido.",{"Sair"},1)
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
        //| Verifica se foi possнvel abrir o arquivo                            |
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
        While !FT_FEOF() //Ler todo o arquivo enquanto nгo for o final dele
           
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

	cWord := StrTran(cWord, '°', 'o')
	cWord := StrTran(cWord, 'Є', 'a')
	cWord := StrTran(cWord, 'З', 'C')
	cWord := StrTran(cWord, 'з', 'c')
	cWord := StrTran(cWord, 'г', 'a')
	cWord := StrTran(cWord, 'б', 'a')
	cWord := StrTran(cWord, 'а', 'a')
	cWord := StrTran(cWord, 'в', 'a')
	cWord := StrTran(cWord, 'Г', 'A')
	cWord := StrTran(cWord, 'Б', 'A')
	cWord := StrTran(cWord, 'А', 'A')
	cWord := StrTran(cWord, 'В', 'A')
	cWord := StrTran(cWord, 'й', 'e')
	cWord := StrTran(cWord, 'и', 'e')
	cWord := StrTran(cWord, 'к', 'e')
	cWord := StrTran(cWord, 'И', 'E')
	cWord := StrTran(cWord, 'Й', 'E')
	cWord := StrTran(cWord, 'К', 'E')
	cWord := StrTran(cWord, 'Х', 'O')
	cWord := StrTran(cWord, 'х', 'o')
	cWord := StrTran(cWord, 'ф', 'o')
	cWord := StrTran(cWord, 'Ф', 'O')
	cWord := StrTran(cWord, 'У', 'O')
	cWord := StrTran(cWord, 'у', 'o')
	cWord := StrTran(cWord, 'Т', 'O')
	cWord := StrTran(cWord, 'т', 'o')
	
	cWord := StrTran(cWord, 'Н', 'I')
	cWord := StrTran(cWord, 'н', 'i')
	cWord := StrTran(cWord, 'П', 'I')
	cWord := StrTran(cWord, 'п', 'i')
	cWord := StrTran(cWord, 'М', 'I')
	cWord := StrTran(cWord, 'м', 'i')
	
	cWord := StrTran(cWord, 'Ъ', 'U')
	cWord := StrTran(cWord, 'ъ', 'u')
	cWord := StrTran(cWord, 'Ь', 'U')
	cWord := StrTran(cWord, 'ь', 'u')
	cWord := StrTran(cWord, 'Щ', 'U')
	cWord := StrTran(cWord, 'щ', 'u')

	cWord := StrTran(cWord, 'С', 'N')
	cWord := StrTran(cWord, 'с', 'n')

	//cWord := StrTran(cWord, ',', '')
	//cWord := StrTran(cWord, '-', '')
	//cWord := StrTran(cWord, '"', '')
	//cWord := strtran(cWord,""+'"'+"","")

	cWord := UPPER(cWord)

Return cWord
