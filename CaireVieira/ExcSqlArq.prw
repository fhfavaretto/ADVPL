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

    //Valida arquivo
    If !file(cArqImpor)
        Aviso("Arquivo","Arquivo não selecionado ou invalido.",{"Sair"},1)
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
        //| Verifica se foi possível abrir o arquivo                            |
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
        While !FT_FEOF() //Ler todo o arquivo enquanto não for o final dele
           
            nCont++
            IncProc('Importando Linha: ' + Alltrim(Str(nCont)) )
          
            clinha := FT_FREADLN() 
    
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
