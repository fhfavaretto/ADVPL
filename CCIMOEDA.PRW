#include "Totvs.ch"
#include "Tbiconn.ch"


/*/{Protheus.doc} CCIMOEDA
    Função utilizada para buscar a Cotação da moeda na API do Banco Central
    @type       function
    @author     Fabio Favaretto
    @since      30/07/2021
    @version    1.0
    @sample        
    @url https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/documentacao
 /*/  

User function CCIMOEDA(lCompra)
	Local cBase     := 'https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata'
	Local cUrl      := ''
	Local cGetParms := ''
	Local nTimeOut  := 200
	Local aHeadStr  := {'Content-Type: application/json'}
	Local cHeadGet  := ''
	Local cRet      := ''
	Local aIdMoeda  := getMoedas() //{'USD', 'CHF', 'EUR','YEN'} //ARRAY COM MOEDAS
	Local cDtCot    := '' //MM-DD-AAAA
	Local oJObj     := ''
	Local cJRet     := ''
	//Local cCotacao  := ''
	Local nY        := ''

	Default lCompra := .T.

	//Ajusta Padrão da Data para MM-DD-AAAA - cDtCot := '07-29-2021'
	//cDtCot := DToS(dDataBase-1)
	//cDtCot := SubStr(cDtCot,5,2) + '-' + SubStr(cDtCot,7,2) + '-' + SubStr(cDtCot,1,4)

    cDtCot := getReqDt(dDataBase)

    //RpcSetEnv("30","302030","lvieira","251213","FIN","MATA090",{"SM2"})

	FOR nY := 2 TO LEN(aIdMoeda)
		//[GET] Consulta Dados na Api Olinda
        oJObj   := JsonObject():New()
		cUrl := cBase
		cUrl += "/CotacaoMoedaPeriodoFechamento(codigoMoeda=@idMD,dataInicialCotacao=@dtIniCt,dataFinalCotacao=@dtFinCt)"
		cUrl += "?@idMD='"+aIdMoeda[nY][2]+"'&@dtIniCt='"+cDtCot+"'&@dtFinCt='"+cDtCot
		cUrl += "'&$format=json&$select=cotacaoCompra,cotacaoVenda,dataHoraCotacao,tipoBoletim"

		cRet := HTTPGet( cUrl , cGetParms, nTimeOut, aHeadStr, @cHeadGet )

		cJRet := oJObj:FromJson(cRet)

		If ValType(cJRet) == 'U' //NIL
			//Valida se a Cotação esta liberada para o dia - oJObj:hasProperty("value")
			If Len(oJObj["value"]) > 0

                //cMoeda := aIdMoeda[nY][2]

				//aIdMoeda[nY][3] := 
				//nValorAtu :=

				If lCompra
					aIdMoeda[nY][3] := (oJObj["value"][1]["cotacaoCompra"]) 
				Else
					aIdMoeda[nY][3] := (oJObj["value"][1]["cotacaoVenda"]) 
				EndIf

				/*
				cCotacao  += aIdMoeda[nY] + "|" // USD | 5.54342 | EUR | 6.71582 | BRL | 1
				cCotacao  += nValorAtu  + "|" 
				*/

			EndIf
			FreeObj(oJObj)
		Else
			ConOut("Ocorreu erro no processamento do Json" + CRLF+CRLF + cJRet, ':: Cotação Moeda PTAX - BC API Olinda ::')
		EndIf
	NEXT
    //aMoedaAtual := StrTokArr(cCotacao, '|')
    If Empty(aIdMoeda) == .F.
     DbSelectArea("SM2")
	    If !DbSeek(DtoS(DATE()) )
            RecLock("SM2",.T.)
            SM2->M2_DATA    := DATE() //DATA DA INCLUSÃO
            SM2->M2_DCOTAC  := DToS(DATE()-1) //DATA DE COTAÇÃO
	    Else
            RecLock("SM2",.F.)
	    Endif
			SM2->M2_MOEDA2 := (aIdMoeda[2][3]) //USD
            SM2->M2_MOEDA3 := (aIdMoeda[3][3]) //UFIR  //1.0641              
            SM2->M2_MOEDA4 := (aIdMoeda[4][3]) //EUR 
            SM2->M2_MOEDA5 := (aIdMoeda[5][3]) //CAN
			SM2->M2_MOEDA6 := (aIdMoeda[6][3]) //GBP  //LBR
            If Type("M2_MOEDA7") <> "U"
                SM2->M2_MOEDA7 := (aIdMoeda[7][3]) //CHF 
            EndIf
			
			/*
			aIdMoeda[2][3]
            SM2->M2_MOEDA2 := Val(aMoedaAtual[2]) //USD
            SM2->M2_MOEDA3 := 1.0641              //UFIR  
            SM2->M2_MOEDA4 := Val(aMoedaAtual[6]) //EUR 
            SM2->M2_MOEDA5 := Val(aMoedaAtual[4]) //CHF 
			SM2->M2_MOEDA6 := Val(aMoedaAtual[8]) //YEN 
			*/
            MsUnlock("SM2")
        ConOut("Tabela SM2 -> Moedas atulizado com sucesso.")            
    EndIf
Return





Static Function DeParaMD(cMoedaErp)

    Default cMoedaErp := alltrim(cMoedaErp)

    DO CASE 
        CASE cMoedaErp $ "US$/USD"
            cMoedaRet := "USD"
        CASE cMoedaErp == "CAN"
            cMoedaRet := "CAD"
        CASE cMoedaErp == "LBR"
            cMoedaRet := "GBP"
        CASE cMoedaErp == "IENE"
            cMoedaRet := "JPY"
        CASE cMoedaErp == "CHF"
            cMoedaRet := "CHF"
        CASE cMoedaErp == "EUR"
            cMoedaRet := "EUR"
        OTHERWISE
            cMoedaRet := ""
    ENDCASE

return cMoedaRet




Static Function getReqDt(dDataRef)

    local dDataNew := dDataBase
    local cDataRet := ""
    
    dDataNew := DataValida (dDataRef-1, .F.)
    cDataRet := strZero(month(dDataNew), 2) + "-"+ strZero(day(dDataNew),2)  + "-"+ strZero(year(dDataNew),4)


return cDataRet





Static Function getMoedas()

    local cPrefix as character
    local cSufix  as character
    local aMoedas as array

    aMoedas := {}
    cPrefix := "MV_SIMB"
    cSufix  := "1"
    cParam  := "cPrefix+cSufix"

    while FWSX6Util():ExistsParam( &(cParam) )

        cMoeda := getMv(&(cParam))
        aadd(aMoedas, {cSufix, DeParaMD(cMoeda), 1})
        cSufix := soma1(cSufix)
    enddo
    
return aMoedas
