#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "Fileio.ch"

#Define STR_PULA		Chr(13)+Chr(10)

/*


Fabio Favaretto - Upduo Consultoria


Fonte para gravar log de usuário, função, data e hora no servidor, no
deve ser utilizado dentro de outras funções ou pontos de entrada, caso
não encontre a pasta logs dentro de protheus_data, será gravado dentro 
da pasta system, gerando o arquivo "logacesso.txt".

Utilização dentro de fontes: U_GerLogUsr() 

*/
User Function GerLogUsr()
	Local aArea   := GetArea()
	Local nHandle := 0
    Local cPasta  := ""

    If File("\logs")
        cPasta := "\logs"
    Else
        cPasta := "\system"
    EndIf

	nHandle := fOpen(cPasta+"\logacesso.txt",FO_READWRITE)
	IF nHandle == -1
		nHandle := FCreate(cPasta+"\logacesso.txt",FO_READWRITE)
		FSeek(nHandle, 0, 2)         	// Posiciona no fim do arquivo
		FWrite(nHandle, "Data: "+ DtoC(Date()) +"-"+ Time() +" - Função: "+ FunName() +" - Usuário: "+ RetCodUsr() +"-"+ UsrFullName(RetCodUsr())+STR_PULA)
		fclose(nHandle)
	Else
		nHandle := fOpen(cPasta+"\logacesso.txt",FO_READWRITE)
		IF nHandle == -1
			MsgStop('Erro de abertura : FERROR '+str(ferror(),4))
		Else
			FSeek(nHandle, 0, 2)         // Posiciona no fim do arquivo
			FWrite(nHandle, "Data: "+ DtoC(Date()) +"-"+ Time() +" - Função: "+ FunName() +" - Usuário: "+ RetCodUsr() +"-"+ UsrFullName(RetCodUsr())+STR_PULA) 		// Insere texto no arquivo
			fclose(nHandle)
		EndIf
	EndIf

	RestArea(aArea)

Return Nil
