#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include 'WFMATA120.ch'

Static aSCR := {}

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Modelo de dados genérico usado para qualquer aprovação de documento
no fluig que utilize a alçada SCR

@author Juliane Venteu
@since 16/02/2017
@version 1.0
/*/ 
//-------------------------------------------------------------------
Static Function ModelDef()
Local oStruSCR:= FWFormStruct(1,'SCR', {|cCampo| AllTrim(cCampo) $ "CR_FILIAL|CR_NUM|CR_SOLICIT|CR_EMISSAO|CR_TIPO|CR_APROV|CR_USER|CR_USERORI|CR_GRUPO|CR_ITGRP|CR_TOTAL|CR_OBS"})
Local oModel
	
	// -----------------------------------------------------------------------
	// INCLUSÃO DOS CAMPOS COM A CHAVE DOS USUARIOS NO FLUIG
	// -----------------------------------------------------------------------
	If Empty(aSCR)
		aAdd( aSCR,{'CR_CODSOL'	,'C' , 50 , '@!'	,STR0026	,STR0026	,{}, NIL, Nil, Nil, Nil, 0   } ) // 'Solicitante'
		aAdd( aSCR,{'CR_CODAPR'	,'C' , 50 , '@!'	,STR0027	,STR0027	,{}, NIL, Nil, Nil, Nil, 0   } ) // 'Aprovador'
	EndIf
		
	U_WF120Model(aSCR,"STRUSCR_",oStruSCR)
		
	oModel := MPFormModel():New('WFMAT120', /*bPreValidacao*/, {|oModel| WFVldLibDoc(oModel) }/*bPosValidacao*/, {|oModel|WFLibDoc(oModel)}/*bCommit*/, /*bCancel*/ )
	
	oModel:AddFields( 'SCRMASTER', /*OWNER*/	, oStruSCR)
		
	oModel:GetModel( 'SCRMASTER' ):SetDescription( STR0051 ) // 'Alçada'	
	
	oModel:SetPKIndexOrder(2)
	oModel:SetPrimaryKey( {'CR_TIPO','CR_NUM','CR_USER'} )
	
	//------------------------------------------------------------------
	//	Realiza carga dos campos do mecanismo de atribuição
	//------------------------------------------------------------------
	oModel:SetActivate( { |oModel| WFMecAt( oModel ) } ) 
	
	// -----------------------------------------------------------------------
	// Adiciona a descricao do Modelo de Dados
	// -----------------------------------------------------------------------
	oModel:SetDescription( 'Workflow de Liberação de Documento' )
	
Return oModel

Static Function ViewDef()
Local oModel := ModelDef()
Local oStruSCR:= FWFormStruct(2,'SCR', {|cCampo| AllTrim(cCampo) $ "CR_FILIAL|CR_NUM|CR_SOLICIT|CR_EMISSAO|CR_TIPO|CR_APROV|CR_USER|CR_USERORI|CR_GRUPO|CR_ITGRP|CR_TOTAL|CR_OBS"},,,.T.)
Local oView
	
	U_WF120View(aSCR,'SCR_',oStruSCR)
	
	// -----------------------------------------------------------------------
	// Monta o modelo da interface do formulario
	// -----------------------------------------------------------------------
	oView := FWFormView():New()
	
	oView:SetModel(oModel)		
		
	oView:AddField('VIEW_SCR', oStruSCR,'SCRMASTER')	
	oView:CreateHorizontalBox( 'SCR' ,01 )
	oView:SetOwnerView('VIEW_SCR','SCR')
			
	oView:EnableTitleView('VIEW_SCR' , STR0051 ) // 'Alçada'

	aSCR := {}
Return oView

//-------------------------------------------------------------------
/*/{Protheus.doc} WFVldLibDoc
Valida se o usuario possui saldo dentro dos limites configurados para
o aprovador.

@author Juliane Venteu
@since 16/02/2017
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function WFVldLibDoc(oModel)
Local lRet 		:= .T.
Local cNum		:= oModel:GetValue('SCRMASTER','CR_NUM')
Local cUser		:= oModel:GetValue('SCRMASTER','CR_USER')
Local cTipo		:= oModel:GetValue('SCRMASTER','CR_TIPO')
Local cAprov	:= Iif(oModel:GetWKNextState()=='4','1','2')
Local cFluig	:= Alltrim(cValToChar(oModel:GetWKNumProces()))
Local aAreaSCR 	:= SCR->(GetArea())
Local cSCRFil
Local aSaldo
Local nSaldo

	If cTipo $ 'IC|CT|IR|RV'
		cSCRFil := CnFilCtr(cNum)
	Else
		cSCRFil := xFilial("SCR")
	EndIf
	
	DbSelectArea("SCR")
	SCR->(DbSetOrder(2))
	If SCR->(DbSeek(cSCRFil+cTipo+cNum+cUser)) .And. cAprov == '1' //Valida saldo apenas quando é uma aprovação do documento
		While !Eof() .And. cSCRFil+cTipo+cNum+cUser == SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER)
			If Alltrim(SCR->CR_FLUIG) == cFluig .And. SCR->CR_STATUS == '02' // Verifica se está em aberto 
				// Posiciona o Aprovador
				dbSelectArea("SAK")
				SAK->(dbSetOrder(2))
				SAK->(dbSeek(xFilial("SAK")+cUser))
				dbSelectArea("SCS")
				SCS->(dbSetOrder(2))
				aSaldo 		:= MaSalAlc(SCR->CR_APROV,dDataBase,.T.)
				nSaldo 		:= aSaldo[1]
									
				If nSaldo < SCR->CR_TOTAL
					Help(,,'WFAPR',,"Saldo insuficiente para aprovar esse documento.", 1, 0)						
					lRet := .F.
					Exit
				EndIf
			EndIf
			
			SCR->(DBSkip())
		EndDo
	EndIf
	
RestArea(aAreaSCR)

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} WFLibDoc
Função liberar documento
@author rafael.duram
@since 28/08/2015
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function WFLibDoc(oModel)
Local cNum		:= oModel:GetValue('SCRMASTER','CR_NUM')
Local cUser		:= oModel:GetValue('SCRMASTER','CR_USER')
Local cTipo		:= oModel:GetValue('SCRMASTER','CR_TIPO')
Local cParecer	:= oModel:GetValue('WF1MASTER','WF1_PAREC')
Local cAprov	:= Iif(oModel:GetWKNextState()=='4','1','2')
Local cFluig	:= Alltrim(cValToChar(oModel:GetWKNumProces()))
Local lRet		:= .F.

lRet := U_MTFlgLbDoc(cNum,cUser,cAprov,cTipo,cFluig,cParecer)

Return lRet

//--------------------------------------------------------------------
/*/{Protheus.doc} WFMecAt()
Realiza carga dos campos do mecanismo de atribuição
@author Rafael Duram
@since 24/03/2016
@version 1.0
@return .T.
/*/
//--------------------------------------------------------------------
Static Function WFMecAt(oModel)
Local oFieldSCR 	:= oModel:GetModel("SCRMASTER")
Local cUserSolic	:= ExecBlock("MtUsrSolic", .F., .F., {oFieldSCR:GetValue("CR_TIPO"),oFieldSCR:GetValue("CR_NUM")})
Local cAprov		:= A097UsuApr(oFieldSCR:GetValue("CR_APROV"))

oFieldSCR:LoadValue("CR_CODSOL"  , FWWFColleagueId(cUserSolic) )
oFieldSCR:LoadValue("CR_CODAPR"  , FWWFColleagueId(cAprov)   	)

Return

//--------------------------------------------------------------------
/*/{Protheus.doc} WFAlcPrc()
Cria/Recria processos de aprovação de Worflow Fluig referentes ao
processo de alçadas

@author rd.santos
@since 08/07/2021
@version 1.0
@return NIL
/*/
//--------------------------------------------------------------------
User Function WFAlcPrc()

Local   aSay     := {}
Local   aButton  := {}
Local   aMarcadas:= {}
Local   aMarcados:= {}
Local   cTitulo  := 'ATUALIZAÇÃO DE DICIONÁRIOS E TABELAS'
Local   cDesc1   := 'Esta rotina tem como objetivo criar ou recriar os processos de Workflow'
Local   cDesc2   := 'de aprovação de alçadas no Fluig (ECM).'
Local	cDesc3	 := '' 	
Local   cDesc4   := 'OBS: Esse update deve ser executado em modo exclusivo.  É extremamente'
Local   cDesc5   := 'recomendavél que se faça o BACKUP dos DICIONÁRIOS e BASE DE DADOS antes desta'
Local   cDesc6   := 'atualização, para que caso ocorra eventuais falhas, esse backup possa ser restaurado.'
Local	cDesc7	 := '' 	
Local   lOk      := .F.

Private oMainWnd  := NIL
Private oProcess  := NIL

#IFDEF TOP
    TCInternal( 5, '*OFF' ) // Desliga Refresh no Lock do Top
#ENDIF

__cInterNet := NIL
__lPYME     := .F.

Set Dele On

// Mensagens de Tela Inicial
aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )
aAdd( aSay, cDesc5 )
aAdd( aSay, cDesc6 )
aAdd( aSay, cDesc7 )

// Botoes Tela Inicial
aAdd(  aButton, {  1, .T., { || lOk := .T., FechaBatch() } } )
aAdd(  aButton, {  2, .T., { || lOk := .F., FechaBatch() } } )

FormBatch(  cTitulo,  aSay,  aButton )       


If lOk
	aMarcadas := EscEmpresa() // Filiais marcadas

	aMarcados := EscProcessos() // Processos marcados

	If !Empty( aMarcadas ) .And. !Empty( aMarcados )
		If  ApMsgNoYes('Confirma a atualização das tabelas ?', cTitulo )
			oProcess := MsNewProcess():New( { | lEnd | lOk := UPDProc( @lEnd, aMarcadas, aMarcados ) }, 'Atualizando', 'Aguarde, atualizando ...', .F. )
			oProcess:Activate()

			If lOk
				Final( 'Atualização Concluída.' )
			Else
				Final( 'Atualização não Realizada.' )
			EndIf

		Else
			Final( 'Atualização não Realizada.' )

		EndIf

	Else
		Final( 'Atualização não Realizada.' )

	EndIf

EndIf

Return NIL

//--------------------------------------------------------------------
/*/{Protheus.doc} UPDProc()
Update de atualização dos processos de Workflow

@author rd.santos
@since 08/07/2021
@version 1.0
@return lRet
/*/
//--------------------------------------------------------------------
Static Function UPDProc( lEnd, aMarcadas, aProcessos )
Local   aInfo     := {}
Local   aRecnoSM0 := {}
Local   cAux      := ''
Local   cFile     := ''
Local   cFileLog  := ''
Local   cMask     := 'Arquivos Texto (*.TXT)|*.txt|'
Local   cTexto    := ''
Local   lOpen     := .F.
Local   lRet      := .T.
Local   nI        := 0
Local   nJ		  := 0
Local   nPos      := 0
Local   oDlg      := NIL
Local   oFont     := NIL
Local   oMemo     := NIL

Private aArqUpd   := {}

If ( lOpen := MyOpenSm0Ex() )

	dbSelectArea( 'SM0' )
	dbGoTop()

	While !SM0->( EOF() )
		// So adiciona no aRecnoSM0 se a empresa for diferente
		If aScan( aRecnoSM0, { |x| x[2] == SM0->M0_CODIGO } ) == 0 ;
		   .AND. aScan( aMarcadas, { |x| x[1] == SM0->M0_CODIGO } ) > 0
			aAdd( aRecnoSM0, { Recno(), SM0->M0_CODIGO } )
		EndIf
		SM0->( dbSkip() )
	End

	If lOpens

		For nI := 1 To Len( aRecnoSM0 )

			SM0->( dbGoTo( aRecnoSM0[nI][1] ) )

			RpcSetType(3) //-- Nao consome licensas
			RpcSetEnv( SM0->M0_CODIGO, SM0->M0_CODFIL )
			nModulo := 02 // SIGACOM
			lMsFinalAuto := .F.
			lMsHelpAuto  := .F.

			cTexto += Replicate( '-', 128 ) + CRLF
			cTexto += 'Empresa : ' + SM0->M0_CODIGO + '/' + SM0->M0_NOME + CRLF + CRLF

			oProcess:SetRegua1( 8 )

			For nJ := 1 To Len(aProcessos)
				// Deleta workflow antigo                            
				WfMatDel(aProcessos[nJ])

				// Recria o workflow corretamente 
				WfMatInc(aProcessos[nJ])
			Next nJ 

			
			oProcess:IncRegua1( 'Tabelas de dados - ' + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' )
			oProcess:IncRegua2( 'Atualizando tabelas Workflow') 


			RpcClearEnv()

			If !( lOpen := MyOpenSm0Ex() )
				Exit
			EndIf
			
		Next nI

		If lOpen

			cAux += Replicate( '-', 128 ) + CRLF
			cAux += Replicate( ' ', 128 ) + CRLF
			cAux += 'LOG DA ATUALIZACAO DOS DICIONÁRIOS' + CRLF
			cAux += Replicate( ' ', 128 ) + CRLF
			cAux += Replicate( '-', 128 ) + CRLF
			cAux += CRLF
			cAux += ' Dados Ambiente'        + CRLF
			cAux += ' --------------------'  + CRLF
			cAux += ' Empresa / Filial...: ' + cEmpAnt + '/' + cFilAnt  + CRLF
			cAux += ' Nome Empresa.......: ' + Capital( AllTrim( GetAdvFVal( 'SM0', 'M0_NOMECOM', cEmpAnt + cFilAnt, 1, '' ) ) ) + CRLF
			cAux += ' Nome Filial........: ' + Capital( AllTrim( GetAdvFVal( 'SM0', 'M0_FILIAL' , cEmpAnt + cFilAnt, 1, '' ) ) ) + CRLF
			cAux += ' DataBase...........: ' + DtoC( dDataBase )  + CRLF
			cAux += ' Data / Hora........: ' + DtoC( Date() ) + ' / ' + Time()  + CRLF
			cAux += ' Environment........: ' + GetEnvServer()  + CRLF
			cAux += ' StartPath..........: ' + GetSrvProfString( 'StartPath', '' )  + CRLF
			cAux += ' RootPath...........: ' + GetSrvProfString( 'RootPath', '' )  + CRLF
			cAux += ' Versao.............: ' + GetVersao(.T.)  + CRLF
			cAux += ' Usuario Microsiga..: ' + __cUserId + ' ' +  cUserName + CRLF
			cAux += ' Computer Name......: ' + GetComputerName()  + CRLF

			aInfo   := GetUserInfo()
			If ( nPos    := aScan( aInfo,{ |x,y| x[3] == ThreadId() } ) ) > 0
				cAux += ' '  + CRLF
				cAux += ' Dados Thread' + CRLF
				cAux += ' --------------------'  + CRLF
				cAux += ' Usuario da Rede....: ' + aInfo[nPos][1] + CRLF
				cAux += ' Estacao............: ' + aInfo[nPos][2] + CRLF
				cAux += ' Programa Inicial...: ' + aInfo[nPos][5] + CRLF
				cAux += ' Environment........: ' + aInfo[nPos][6] + CRLF
				cAux += ' Conexao............: ' + AllTrim( StrTran( StrTran( aInfo[nPos][7], Chr( 13 ), '' ), Chr( 10 ), '' ) )  + CRLF
			EndIf
			cAux += Replicate( '-', 128 ) + CRLF
			cAux += CRLF

			cTexto := cAux + cTexto

			cFileLog := MemoWrite( CriaTrab( , .F. ) + '.log', cTexto )

			Define Font oFont Name 'Mono AS' Size 5, 12

			Define MsDialog oDlg Title 'Atualizacao concluida.' From 3, 0 to 340, 417 Pixel // 'Atualizacao concluida.'

			@ 5, 5 Get oMemo Var cTexto Memo Size 200, 145 Of oDlg Pixel
			oMemo:bRClicked := { || AllwaysTrue() }
			oMemo:oFont     := oFont

			Define SButton From 153, 175 Type  1 Action oDlg:End() Enable Of oDlg Pixel // Apaga
			Define SButton From 153, 145 Type 13 Action ( cFile := cGetFile( cMask, '' ), If( cFile == '', .T., ;
			MemoWrite( cFile, cTexto ) ) ) Enable Of oDlg Pixel // Salva e Apaga //'Salvar Como...'

			Activate MsDialog oDlg Center

		EndIf

	EndIf

Else

	lRet := .F.

EndIf

Return lRet

//--------------------------------------------------------------------
/*/{Protheus.doc} EscEmpresa()

Funcao Generica para escolha de Empresa, montado pelo SM0_ 
Retorna vetor contendo as selecoes feitas.                 
Se nao For marcada nenhuma o vetor volta vazio.   

@author rd.santos
@since 08/07/2021
@version 1.0
@return lRet
/*/
//--------------------------------------------------------------------
Static Function EscEmpresa()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametro  nTipo                           ³
//³ 1  - Monta com Todas Empresas/Filiais      ³
//³ 2  - Monta so com Empresas                 ³
//³ 3  - Monta so com Filiais de uma Empresa   ³
//³                                            ³
//³ Parametro  aMarcadas                       ³
//³ Vetor com Empresas/Filiais pre marcadas    ³
//³                                            ³
//³ Parametro  cEmpSel                         ³
//³ Empresa que sera usada para montar selecao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local   aSalvAmb := GetArea()
Local   aSalvSM0 := {}
Local   aRet     := {}
Local   aVetor   := {}
Local   oDlg     := NIL
Local   oChkMar  := NIL
Local   oLbx     := NIL
Local   oMascEmp := NIL
Local   oButMarc := NIL
Local   oButDMar := NIL
Local   oButInv  := NIL
Local   oSay     := NIL
Local   oOk      := LoadBitmap( GetResources(), 'LBOK' )
Local   oNo      := LoadBitmap( GetResources(), 'LBNO' )
Local   lChk     := .F.
Local   lTeveMarc:= .F.
Local   cVar     := ''
Local   cMascEmp := '??'
Local   cMascFil := '??'

Local   aMarcadas  := {}


If !MyOpenSm0Ex()
	ApMsgStop( 'Não foi possível abrir SM0 exclusivo.' )
	Return aRet
EndIf


dbSelectArea( 'SM0' )
aSalvSM0 := SM0->( GetArea() )
dbSetOrder( 1 )
dbGoTop()

While !SM0->( EOF() )

	If aScan( aVetor, {|x| x[2] == SM0->M0_CODIGO} ) == 0
		aAdd(  aVetor, { aScan( aMarcadas, {|x| x[1] == SM0->M0_CODIGO .and. x[2] == SM0->M0_CODFIL} ) > 0, SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_NOME, SM0->M0_FILIAL } )
	EndIf

	dbSkip()
End

RestArea( aSalvSM0 )

Define MSDialog  oDlg Title '' From 0, 0 To 270, 396 Pixel

oDlg:cToolTip := 'Tela para Múltiplas Seleções de Empresas/Filiais'

oDlg:cTitle := 'Selecione a(s) Empresa(s) para Atualização'

@ 10, 10 Listbox  oLbx Var  cVar Fields Header ' ', ' ', 'Empresa' Size 178, 095 Of oDlg Pixel
oLbx:SetArray(  aVetor )
oLbx:bLine := {|| {IIf( aVetor[oLbx:nAt, 1], oOk, oNo ), ;
aVetor[oLbx:nAt, 2], ;
aVetor[oLbx:nAt, 4]}}
oLbx:BlDblClick := { || aVetor[oLbx:nAt, 1] := !aVetor[oLbx:nAt, 1], VerTodos( aVetor, @lChk, oChkMar ), oChkMar:Refresh(), oLbx:Refresh()}
oLbx:cToolTip   :=  oDlg:cTitle
oLbx:lHScroll   := .F. // NoScroll

@ 112, 10 CheckBox oChkMar Var  lChk Prompt 'Todos'   Message 'Marca / Desmarca Todos' Size 40, 007 Pixel Of oDlg;
on Click MarcaTodos( lChk, @aVetor, oLbx )

@ 123, 10 Button oButInv Prompt '&Inverter'  Size 32, 12 Pixel Action ( InvSelecao( @aVetor, oLbx, @lChk, oChkMar ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message 'Inverter Seleção' Of oDlg

// Marca/Desmarca por mascara
@ 113, 51 Say  oSay Prompt 'Empresa' Size  40, 08 Of oDlg Pixel
@ 112, 80 MSGet  oMascEmp Var  cMascEmp Size  05, 05 Pixel Picture '@!'  Valid (  cMascEmp := StrTran( cMascEmp, ' ', '?' ), cMascFil := StrTran( cMascFil, ' ', '?' ), oMascEmp:Refresh(), .T. ) ;
Message 'Máscara Empresa ( ?? )'  Of oDlg

@ 123, 50 Button oButMarc Prompt '&Marcar' Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .T. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message 'Marcar usando máscara ( ?? )'  Of oDlg 

@ 123, 80 Button oButDMar Prompt '&Desmarcar' Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .F. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message 'Desmarcar usando máscara ( ?? )'  Of oDlg

Define SButton From 111, 125 Type 1 Action ( RetSelecao( @aRet, aVetor ), oDlg:End() ) OnStop 'Confirma a Seleção'  Enable Of oDlg
Define SButton From 111, 158 Type 2 Action ( IIf( lTeveMarc, aRet :=  aMarcadas, .T. ), oDlg:End() ) OnStop 'Abandona a Seleção' Enable Of oDlg
Activate MSDialog  oDlg Center

RestArea( aSalvAmb )
dbSelectArea( 'SM0' )
dbCloseArea()

Return aRet

//--------------------------------------------------------------------
/*/{Protheus.doc} MarcaTodos()

Funcao Auxiliar para marcar/desmarcar todos os itens do
ListBox ativo

@author rd.santos
@since 08/07/2021
@version 1.0
@return lRet
/*/
//--------------------------------------------------------------------
Static Function MarcaTodos( lMarca, aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := lMarca
Next nI

oLbx:Refresh()

Return NIL

//--------------------------------------------------------------------
/*/{Protheus.doc} InvSelecao()

Funcao Auxiliar para inverter selecao do ListBox Ativo

@author rd.santos
@since 08/07/2021
@version 1.0
@return lRet
/*/
//--------------------------------------------------------------------
Static Function InvSelecao( aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := !aVetor[nI][1]
Next nI

oLbx:Refresh()

Return NIL

//--------------------------------------------------------------------
/*/{Protheus.doc} RetSelecao()

Funcao Auxiliar que monta o retorno com as selecoes

@author rd.santos
@since 08/07/2021
@version 1.0
@return lRet
/*/
//--------------------------------------------------------------------
Static Function RetSelecao( aRet, aVetor, lOnlyCode )
Local   nI    	  := 0
Default lOnlyCode := .F.

aRet := {}
For nI := 1 To Len( aVetor )
	If aVetor[nI][1]
		If lOnlyCode
			aAdd( aRet, aVetor[nI][2] )
		Else
			aAdd( aRet, { aVetor[nI][2] , aVetor[nI][3], aVetor[nI][2] +  aVetor[nI][3] } )
		Endif
	EndIf
Next nI

Return NIL

//--------------------------------------------------------------------
/*/{Protheus.doc} MarcaMas()

Funcao para marcar/desmarcar usando mascaras 

@author rd.santos
@since 08/07/2021
@version 1.0
@return lRet
/*/
//--------------------------------------------------------------------
Static Function MarcaMas( oLbx, aVetor, cMascEmp, lMarDes )
Local cPos1 := SubStr( cMascEmp, 1, 1 )
Local cPos2 := SubStr( cMascEmp, 2, 1 )
Local nPos  := oLbx:nAt
Local nZ    := 0

For nZ := 1 To Len( aVetor )
	If cPos1 == '?' .or. SubStr( aVetor[nZ][2], 1, 1 ) == cPos1
		If cPos2 == '?' .or. SubStr( aVetor[nZ][2], 2, 1 ) == cPos2
			aVetor[nZ][1] :=  lMarDes
		EndIf
	EndIf
Next

oLbx:nAt := nPos
oLbx:Refresh()

Return NIL

//--------------------------------------------------------------------
/*/{Protheus.doc} VerTodos()

Funcao auxiliar para verificar se estao todos marcardos ou nao 

@author rd.santos
@since 08/07/2021
@version 1.0
@return lRet
/*/
//--------------------------------------------------------------------
Static Function VerTodos( aVetor, lChk, oChkMar )
Local lTTrue := .T.
Local nI     := 0

For nI := 1 To Len( aVetor )
	lTTrue := IIf( !aVetor[nI][1], .F., lTTrue )
Next nI

lChk := IIf( lTTrue, .T., .F. )
oChkMar:Refresh()

Return NIL

//--------------------------------------------------------------------
/*/{Protheus.doc} MyOpenSM0Ex()

Funcao de processamento abertura do SM0 modo exclusivo 

@author rd.santos
@since 08/07/2021
@version 1.0
@return lRet
/*/
//--------------------------------------------------------------------
Static Function MyOpenSM0Ex()

Local lOpen := .F.
Local nLoop := 0

For nLoop := 1 To 20
	dbUseArea( .T., , 'SIGAMAT.EMP', 'SM0', .F., .F. )

	If !Empty( Select( 'SM0' ) )
		lOpen := .T.
		dbSetIndex( 'SIGAMAT.IND' )
		Exit
	EndIf

	Sleep( 500 )

Next nLoop

If !lOpen
	ApMsgStop( 'Não foi possível a abertura da tabela ' + ;
		'de empresas de forma exclusiva.', 'ATENÇÃO' ) 
EndIf

Return lOpen

//-------------------------------------------------------------------
/*/{Protheus.doc} WFMATDEL
Deleta os processos de Workflow de Materiais que estiverem desatualizados
@author rd.santos
@since 09/01/2017
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function WFMATDEL(cProcesso)
Local cAlias := GetNextAlias()

DbSelectArea("CPF") // Se a tabela nao existe cria antes do select

#IFDEF TOP
	// Deleta processo da tabela CPF
	BeginSQL Alias cAlias
		SELECT
			CPF_FILIAL, CPF_CODPRC, R_E_C_N_O_
		FROM
			%Table:CPF% CPF	
		WHERE
			CPF.CPF_CODPRC = %Exp:cProcesso% AND
			CPF.CPF_FILIAL = %xFilial:CPF% AND
			CPF.%NotDel%
	EndSQL
	
	While !(cAlias)->(Eof())
		CPF->(DbGoTo((cAlias)->R_E_C_N_O_))
		Reclock("CPF",.F.)
		CPF->(DbDelete())
		CPF->(MsUnlock()) 
		(cAlias)->(dbSkip())
	EndDo
	
	(cAlias)->(dbCloseArea())
	cAlias := GetNextAlias()
	
	DbSelectArea("CPG")
	
	// Deleta processo da tabela CPG
	BeginSQL Alias cAlias
		SELECT
			CPG_FILIAL, CPG_CODPRC, R_E_C_N_O_
		FROM
			%Table:CPG% CPG	
		WHERE
			CPG.CPG_CODPRC = %Exp:cProcesso% AND
			CPG.CPG_FILIAL = %xFilial:CPG% AND
			CPG.%NotDel%
	EndSQL
	
	While !(cAlias)->(Eof())
		CPG->(DbGoTo((cAlias)->R_E_C_N_O_))
		Reclock("CPG",.F.)
		CPG->(DbDelete())
		CPG->(MsUnlock()) 
		(cAlias)->(dbSkip())
	EndDo
	
	(cAlias)->(dbCloseArea())
	cAlias := GetNextAlias()
	
	DbSelectArea("CPS")
	
	// Deleta processo da tabela CPS
	BeginSQL Alias cAlias
		SELECT
			CPS_FILIAL, CPS_CODPRC, R_E_C_N_O_
		FROM
			%Table:CPS% CPS	
		WHERE
			CPS.CPS_CODPRC = %Exp:cProcesso% AND
			CPS.CPS_FILIAL = %xFilial:CPS% AND
			CPS.%NotDel%
	EndSQL
	
	While !(cAlias)->(Eof())
		CPS->(DbGoTo((cAlias)->R_E_C_N_O_))
		Reclock("CPS",.F.)
		CPS->(DbDelete())
		CPS->(MsUnlock()) 
		(cAlias)->(dbSkip())
	EndDo
	
	(cAlias)->(dbCloseArea())
	cAlias := GetNextAlias()
	
	DbSelectArea("CPU")
	
	// Deleta processo da tabela CPU
	BeginSQL Alias cAlias
		SELECT
			CPU_FILIAL, CPU_CODPRC, R_E_C_N_O_
		FROM
			%Table:CPU% CPU	
		WHERE
			CPU.CPU_CODPRC = %Exp:cProcesso% AND
			CPU.CPU_FILIAL = %xFilial:CPU% AND
			CPU.%NotDel%
	EndSQL
	
	While !(cAlias)->(Eof())
		CPU->(DbGoTo((cAlias)->R_E_C_N_O_))
		Reclock("CPU",.F.)
		CPU->(DbDelete())
		CPU->(MsUnlock()) 
		(cAlias)->(dbSkip())
	EndDo
	
	(cAlias)->(dbCloseArea())
#ENDIF

Return NIL



//-------------------------------------------------------------------
/*/{Protheus.doc} WFMATINC
Cria/Recria os processos de Workflow de Materiais
@author rd.santos
@since 09/01/2017
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function WFMATINC(cProcesso)
Local aStruCPF := {"CPF_DESPRC","CPF_PROPRI","CPF_MODULO","CPF_MODEL","CPF_VIEW","CPF_STATUS","CPF_MODO","CPF_ATUFOR","CPF_AFLUIG"}
Local aStruCPG := {"CPG_ITEM","CPG_EVENTO","CPG_DESATV","CPG_MECAT","CPG_ATVCOM","CPG_CONSEN","CPG_ATUPRT","CPG_MCPO"}
Local aStruCPS := {"CPS_ITEM","CPS_IDBOX","CPS_NOME","CPS_VISUAL"}
Local aStruCPU := {"CPU_ITEM","CPU_SEQ","CPU_DESATV","CPU_PERRET"}
Local aDadosCPF	:= {}
Local aDadosCPG	:= {}
Local aDadosCPS	:= {}
Local aDadosCPU	:= {}
Local nI	    := 0
Local nJ		:= 0
Local cFilCPF	:= xFilial("CPF")
Local cFilCPG	:= xFilial("CPG")
Local cFilCPS	:= xFilial("CPS")
Local cFilCPU	:= xFilial("CPU")

If cProcesso == "SC"
	Aadd(aDadosCPF,{"Solicitação de Compras","2","02","WFMATA110","WFMATA110","1","1",.F.,"2"})
ElseIf cProcesso == "PC"
	Aadd(aDadosCPF,{"Pedido de Compras","2","02","WFMATA120","WFMATA120","1","1",.F.,"2"})
ElseIf cProcesso == "IP"
	Aadd(aDadosCPF,{"Item de Pedido","2","02","WFMATA120","WFMATA120","1","1",.F.,"2"})
ElseIf cProcesso == "SA"
	Aadd(aDadosCPF,{"Solicitação ao Armazém","2","04","WFMATA105","WFMATA105","1","1",.F.,"2"})
ElseIf cProcesso == "ST"
	Aadd(aDadosCPF,{"Solicitação de Transferência","2","04","WFMATA311","WFMATA311","1","1",.F.,"2"})
ElseIf cProcesso == "CT"
	Aadd(aDadosCPF,{"Contrato","2","69","WFCNTA300","WFCNTA300","1","1",.F.,"2"})
ElseIf cProcesso == "IC"
	Aadd(aDadosCPF,{"Item de Contrato","2","69","WFCNTA300","WFCNTA300","1","1",.F.,"2"})
ElseIf cProcesso == "MD"
	Aadd(aDadosCPF,{"Medicao","2","69","WFCNTA121","WCNTA121","1","1",.F.,"2"})
ElseIf cProcesso == "IM"
	Aadd(aDadosCPF,{"Item de Medição","2","69","WFCNTA121","WFCNTA121","1","1",.F.,"2"})
ElseIf cProcesso == "RV"
	Aadd(aDadosCPF,{"Revisao","2","69","WFCNTA300R","WFCNTA300R","1","1",.F.,"2"})
ElseIf cProcesso == "IR"
	Aadd(aDadosCPF,{"Item de Revisao","2","69","WFCNTA300R","WFCNTA300R","1","1",.F.,"2"})						
Endif

Aadd(aDadosCPG,{"001","1","Início","0",.F.,0,.F.,""})
Aadd(aDadosCPG,{"002","1","Aprovação","3",.F.,0,.F.,"CR_CODAPR"})
Aadd(aDadosCPG,{"003","1","Sol. Info","0",.F.,0,.F.,""})
Aadd(aDadosCPG,{"004","1","Aprovado","0",.F.,0,.T.,""})
Aadd(aDadosCPG,{"005","1","Rejeitado","0",.F.,0,.T.,""})

Aadd(aDadosCPS,{"001","VIEW_SCR","Alçada","3"})
Aadd(aDadosCPS,{"001","VIEW_WF1","Decisão","2"})
Aadd(aDadosCPS,{"001","VIEW_WF2","Informações do Documento","2"})
Aadd(aDadosCPS,{"001","VIEW_WF3","Itens","2"})
Aadd(aDadosCPS,{"001","VIEW_WF4","Histórico Niv.Anterior","2"})
Aadd(aDadosCPS,{"002","VIEW_SCR","Alçada","3"})
Aadd(aDadosCPS,{"002","VIEW_WF1","Decisão","1"})
Aadd(aDadosCPS,{"002","VIEW_WF2","Informações do Documento","2"})
Aadd(aDadosCPS,{"002","VIEW_WF3","Itens","2"})
Aadd(aDadosCPS,{"002","VIEW_WF4","Histórico Niv.Anterior","2"})
Aadd(aDadosCPS,{"003","VIEW_SCR","Alçada","3"})
Aadd(aDadosCPS,{"003","VIEW_WF1","Decisão","2"})
Aadd(aDadosCPS,{"003","VIEW_WF2","Informações do Documento","2"})
Aadd(aDadosCPS,{"003","VIEW_WF3","Itens","2"})
Aadd(aDadosCPS,{"003","VIEW_WF4","Histórico Niv.Anterior","2"})
Aadd(aDadosCPS,{"004","VIEW_SCR","Alçada","3"})
Aadd(aDadosCPS,{"004","VIEW_WF1","Decisão","2"})
Aadd(aDadosCPS,{"004","VIEW_WF2","Informações do Documento","2"})
Aadd(aDadosCPS,{"004","VIEW_WF3","Itens","2"})
Aadd(aDadosCPS,{"004","VIEW_WF4","Histórico Niv.Anterior","2"})
Aadd(aDadosCPS,{"005","VIEW_SCR","Alçada","3"})
Aadd(aDadosCPS,{"005","VIEW_WF1","Decisão","2"})
Aadd(aDadosCPS,{"005","VIEW_WF2","Informações do Documento","2"})
Aadd(aDadosCPS,{"005","VIEW_WF3","Itens","2"})
Aadd(aDadosCPS,{"005","VIEW_WF4","Histórico Niv.Anterior","2"})

Aadd(aDadosCPU,{"001","002","Aprovação",.F.})
Aadd(aDadosCPU,{"002","003","Sol. Info",.F.})
Aadd(aDadosCPU,{"002","004","Aprovado",.F.})
Aadd(aDadosCPU,{"002","005","Rejeitado",.F.})
Aadd(aDadosCPU,{"003","002","Aprovação",.F.})

CPF->(DbSetOrder(1))
If !(CPF->(DBSeek(cFilCPF+cProcesso)))
	For nI:=1 To Len(aDadosCPF)
		Reclock("CPF",.T.)
		CPF->CPF_FILIAL := cFilCPF
		CPF->CPF_CODPRC := cProcesso
		For nJ:=1 To Len(aStruCPF)
			CPF->(Fieldput(FieldPos(aStruCPF[nJ]),aDadosCPF[nI,nJ]))
		Next nJ
		CPF->(MsUnlock())
	Next nI
	
	For nI:=1 To Len(aDadosCPG)
		CPG->(DbSetOrder(1))
		If !(CPG->(DBSeek(cFilCPG+cProcesso+aDadosCPG[nI,1])))
			Reclock("CPG",.T.)
		Else
			Reclock("CPG",.F.)
		EndIf
		CPG->CPG_FILIAL := cFilCPG
		CPG->CPG_CODPRC := cProcesso
		For nJ:=1 To Len(aStruCPG)
			CPG->(Fieldput(FieldPos(aStruCPG[nJ]),aDadosCPG[nI,nJ]))
		Next nJ
		CPG->(MsUnlock())
	Next nI
		
	For nI:=1 To Len(aDadosCPS)
		CPS->(DbSetOrder(1))
		If !(CPS->(DBSeek(cFilCPS+cProcesso+aDadosCPS[nI,1]+aDadosCPS[nI,2])))
			Reclock("CPS",.T.)
		Else
			Reclock("CPS",.F.)
		EndIf
		CPS->CPS_FILIAL := cFilCPS
		CPS->CPS_CODPRC := cProcesso
		For nJ:=1 To Len(aStruCPS)
			CPS->(Fieldput(FieldPos(aStruCPS[nJ]),aDadosCPS[nI,nJ]))
		Next nJ
		CPS->(MsUnlock())
	Next nI
	
	For nI:=1 To Len(aDadosCPU)
		CPU->(DbSetOrder(1))
		If !(CPU->(DBSeek(cFilCPU+cProcesso+aDadosCPU[nI,1]+aDadosCPU[nI,2])))
			Reclock("CPU",.T.)
		Else
			Reclock("CPU",.F.)
		EndIf
		CPU->CPU_FILIAL := cFilCPU
		CPU->CPU_CODPRC := cProcesso
		For nJ:=1 To Len(aStruCPU)
			CPU->(Fieldput(FieldPos(aStruCPU[nJ]),aDadosCPU[nI,nJ]))
		Next nJ
		CPU->(MsUnlock())
	Next nI
EndIf

Return NIL

//--------------------------------------------------------------------
/*/{Protheus.doc} EscProcessos()

Funcao Generica para escolha dos Processos para criar/recriar 
Retorna vetor contendo as selecoes feitas.                 
Se nao For marcada nenhuma o vetor volta vazio.   

@author rd.santos
@since 12/07/2021
@version 1.0
@return lRet
/*/
//--------------------------------------------------------------------
Static Function EscProcessos()
Local   aRet     := {}
Local   oDlg     := NIL
Local   oChkMar  := NIL
Local   oLbx     := NIL
Local   oMascEmp := NIL
Local   oButMarc := NIL
Local   oButDMar := NIL
Local   oButInv  := NIL
Local   oSay     := NIL
Local   oOk      := LoadBitmap( GetResources(), 'LBOK' )
Local   oNo      := LoadBitmap( GetResources(), 'LBNO' )
Local   lChk     := .F.
Local   lTeveMarc:= .F.
Local   cVar     := ''
Local   cMascEmp := '??'
Local   cMascFil := '??'
Local   aVetor	 := {}

Aadd(aVetor,{.F.,"SC","Solicitações de Compra"})
Aadd(aVetor,{.F.,"PC","Pedido de Compra"})
Aadd(aVetor,{.F.,"IP","Item do Pedido"})
Aadd(aVetor,{.F.,"SA","Solicitações ao Armazém"})
Aadd(aVetor,{.F.,"ST","Solicitação de Transferência"})
Aadd(aVetor,{.F.,"CT","Contrato"})
Aadd(aVetor,{.F.,"IC","Item de Contrato"})
Aadd(aVetor,{.F.,"MD","Medição de Contrato"})
Aadd(aVetor,{.F.,"IM","Item de Medição"})
Aadd(aVetor,{.F.,"RV","Revisão de Contrato"})
Aadd(aVetor,{.F.,"IR","Item de Revisão"})


Define MSDialog  oDlg Title '' From 0, 0 To 270, 396 Pixel

oDlg:cToolTip := 'Tela para Seleção dos Processos para Criar/Recriar'

oDlg:cTitle := 'Selecione o(s) Processo(s) para Criar/Recriar'

@ 10, 10 Listbox  oLbx Var  cVar Fields Header ' ', ' ', 'Processo' Size 178, 095 Of oDlg Pixel
oLbx:SetArray(  aVetor )
oLbx:bLine := {|| {IIf( aVetor[oLbx:nAt, 1], oOk, oNo ), ;
aVetor[oLbx:nAt, 2], ;
aVetor[oLbx:nAt, 3]}}
oLbx:BlDblClick := { || aVetor[oLbx:nAt, 1] := !aVetor[oLbx:nAt, 1], VerTodos( aVetor, @lChk, oChkMar ), oChkMar:Refresh(), oLbx:Refresh()}
oLbx:cToolTip   :=  oDlg:cTitle
oLbx:lHScroll   := .F. // NoScroll

@ 112, 10 CheckBox oChkMar Var  lChk Prompt 'Todos'   Message 'Marca / Desmarca Todos' Size 40, 007 Pixel Of oDlg;
on Click MarcaTodos( lChk, @aVetor, oLbx )

@ 123, 10 Button oButInv Prompt '&Inverter'  Size 32, 12 Pixel Action ( InvSelecao( @aVetor, oLbx, @lChk, oChkMar ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message 'Inverter Seleção' Of oDlg

// Marca/Desmarca por mascara
@ 113, 51 Say  oSay Prompt 'Processo' Size  40, 08 Of oDlg Pixel
@ 112, 80 MSGet  oMascEmp Var  cMascEmp Size  05, 05 Pixel Picture '@!'  Valid (  cMascEmp := StrTran( cMascEmp, ' ', '?' ), cMascFil := StrTran( cMascFil, ' ', '?' ), oMascEmp:Refresh(), .T. ) ;
Message 'Máscara Empresa ( ?? )'  Of oDlg

@ 123, 50 Button oButMarc Prompt '&Marcar' Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .T. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message 'Marcar usando máscara ( ?? )'  Of oDlg 

@ 123, 80 Button oButDMar Prompt '&Desmarcar' Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .F. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message 'Desmarcar usando máscara ( ?? )'  Of oDlg

Define SButton From 111, 125 Type 1 Action ( RetSelecao( @aRet, aVetor, .T. ), oDlg:End() ) OnStop 'Confirma a Seleção'  Enable Of oDlg

Define SButton From 111, 158 Type 2 Action ( IIf( lTeveMarc, aRet :=  {} , .T. ),oDlg:End() ) OnStop 'Abandona a Seleção' Enable Of oDlg

Activate MSDialog  oDlg Center

Return aRet

//-------------------------------------------------------------------
/*/{Protheus.doc} A097AprFlg()
Funcao que retorna se a aprovação do processo devera ocorrer apenas pelo Fluig

@param cTpAprov

@author rd.santos
@since 23/09/2015
@version 1.0
@return lAprovFlg
/*/
//-------------------------------------------------------------------

User Function A097AprFlg()
Local lAprovFlg := .F.
Local aAreaAnt	:= GetArea()
Local aAreaCPF	:= CPF->(GetArea())
Local cTpAprov  := Iif(Len(ParamIxb)>0,ParamIxb[1],"")

dbSelectArea("CPF")
dbSetOrder(1)

If CPF->(DbSeek(xFilial('CPF')+cTpAprov)) .And. CPF->CPF_AFLUIG == "1"
	lAprovFlg := .T.
Endif

RestArea(aAreaCPF)
RestArea(aAreaAnt)

Return lAprovFlg

//-------------------------------------------------------------------
/*/{Protheus.doc} MTSoliCAT
Geração do processo geral de compras

@author taniel.silva
@param cTipoDoc
@param cNumDoc
@param cAlias

@since 08/04/2014
@version P12
@return Nil
/*/
//-------------------------------------------------------------------
User Function MTSoliCAT()
Local lFluig	:= SuperGetMV("MV_APWFECM",.F.,"2") == "1" .And. !Empty(AllTrim(GetNewPar("MV_ECMURL",""))) .And. FWWFFluig()
Local cNivel	:= ""
Local aNextTask	:= {}
Local cSCRFil	:= ""
Local cSolicit	:= ""
Local cUsrApr	:= ""
Local cTipoDoc	:= Iif(Len(ParamIxb)>0,ParamIxb[1],"")
Local cNumDoc	:= Iif(Len(ParamIxb)>1,ParamIxb[2],"")
Local cAlias	:= Iif(Len(ParamIxb)>2,ParamIxb[3],"")
Local cCampo	:= Iif(Len(ParamIxb)>3,ParamIxb[4],"")
Local cUserSolic:= Iif(Len(ParamIxb)>4,ParamIxb[5],RetCodUsr())
Local lGeraNivel:= Iif(Len(ParamIxb)>5,ParamIxb[6],.F.)

If lFluig

	If lGeraNivel // Gera documento independente do nivel	
		cSolicit := FWWFColleagueId(cUserSolic)
		cUsrApr  := FWWFColleagueId(A097UsuApr(SCR->CR_APROV))
		aNextTask := {2,cSolicit,{cUsrApr}}
		StartProcess(cTipoDoc,cSolicit,{cSolicit},,,,,aNextTask,.T.)
	Else
		If cTipoDoc $ 'IC|CT|IR|RV'
			cSCRFil := CnFilCtr(cNumDoc)
		Else
			cSCRFil := xFilial("SCR")
		EndIf

		SCR->(DbSetOrder(1))
		If SCR->(DbSeek(cSCRFil+cTipoDoc+PadR(cNumDoc,TamSX3("CR_NUM")[1])))
			cNivel := A097FstNiv(SCR->CR_GRUPO,cTipoDoc,cNumDoc)
			While SCR->(!Eof()) .And.  SCR->CR_FILIAL+SCR->CR_NUM == cSCRFil+PadR(cNumDoc,TamSX3("CR_NUM")[1])
				If SCR->CR_NIVEL==cNivel
					cSolicit := FWWFColleagueId(cUserSolic)
					cUsrApr  := FWWFColleagueId(A097UsuApr(SCR->CR_APROV))
					aNextTask := {2,cSolicit,{cUsrApr}}
					StartProcess(cTipoDoc,cSolicit,{cSolicit},,,,,aNextTask,.T.)
				Endif
				SCR->(DbSkip())
			EndDo
		EndIf
	Endif
EndIf

Return nil

//--------------------------------------------------------------------
/*/{Protheus.doc} MtUsrSolic()
Retorna o código do Usuário solicitante de acordo com o tipo da alçada posicionada
@author rd.santos
@Param cTipo:	Tipo do documento
@Param cNum:	Numero do documento
@since 13/10/2015
@version 1.0
@return cRet
/*/
//--------------------------------------------------------------------
User Function MtUsrSolic()

Local cRet 	:= ""
Local nTamCt 	:= TamSx3("CN9_NUMERO")[1]
Local nTamRv 	:= TamSx3("CN9_REVISA")[1]
Local nTamMd	:= TamSx3("CND_NUMMED")[1]

Local cTipo		:= Iif(Len(ParamIxb)>0,ParamIxb[1],"")
Local cNum		:= Iif(Len(ParamIxb)>1,ParamIxb[2],"")

If cTipo == "SC"
 	SC1->(DbSetOrder(1))
 	If SC1->(DbSeek(xFilial("SC1")+Padr(cNum,TamSx3("C1_NUM")[1]))) .And. !Empty(SC1->C1_USER)
		cRet := SC1->C1_USER
	Endif
Elseif cTipo $ "IP|PC"
	SC7->(DbSetOrder(1))
 	If SC7->(DbSeek(xFilial("SC7")+Padr(cNum,TamSx3("C7_NUM")[1]))) .And. !Empty(SC7->C7_USER)
		cRet := SC7->C7_USER
	Endif
Elseif cTipo $ "CT|IC"
	CN9->(DbSetOrder(1))
	If CN9->(DbSeek(xFilial("CN9")+Padr(cNum,nTamCt)))
		If CN9->(FieldPos('CN9_USERGA')) > 0
			cRet := RetCodUsr(FWLeUserlg("CN9_USERGA"))
		ElseIf CN9->(FieldPos('CN9_USERGI')) > 0
			cRet := RetCodUsr(FWLeUserlg("CN9_USERGI"))
		ElseIf !Empty(CN9->CN9_LOGUSR)
			cRet := CN9->CN9_LOGUSR
		EndIf
	EndIf

Elseif cTipo $ "RV|IR"
	CN9->(DbSetOrder(1))
	If CN9->(DbSeek(xFilial("CN9")+Padr(cNum,nTamCt)+Substr(cNum,nTamCt+1,nTamRv)))
		If CN9->(FieldPos('CN9_USERGA')) > 0
			cRet := RetCodUsr(FWLeUserlg("CN9_USERGA"))
		ElseIf CN9->(FieldPos('CN9_USERGI')) > 0
			cRet := RetCodUsr(FWLeUserlg("CN9_USERGI"))
		ElseIf !Empty(CN9->CN9_LOGUSR)
			cRet := CN9->CN9_LOGUSR
		EndIf
	EndIf

Elseif cTipo $ "MD|IM"
	CND->(DbSetOrder(4))
	If CND->(DbSeek(xFilial("CND")+Padr(cNum,nTamMd)))
		If (GetRemoteType() == -1)
			If CND->(FieldPos('CND_USERGI')) > 0
				cRet := RetCodUsr(FWLeUserlg("CND_USERGI"))
			EndIf
		Else
			If CND->(FieldPos('CND_USERGA')) > 0
				cRet := RetCodUsr(FWLeUserlg("CND_USERGA"))
			ElseIf CND->(FieldPos('CND_USERGI')) > 0
				cRet := RetCodUsr(FWLeUserlg("CND_USERGI"))
			EndIf
		EndIf
	Else
		CN9->(DbSetOrder(1))
		If CN9->(DbSeek(xFilial("CN9")+CND->CND_CONTRA+CND->CND_REVISA))
			If CN9->(FieldPos('CN9_USERGA')) > 0
				cRet := RetCodUsr(FWLeUserlg("CN9_USERGA"))
			ElseIf CN9->(FieldPos('CN9_USERGI')) > 0
				cRet := RetCodUsr(FWLeUserlg("CN9_USERGI"))
			ElseIf !Empty(CN9->CN9_LOGUSR)
				cRet := CN9->CN9_LOGUSR
			EndIf
		EndIf
	EndIf

ElseIf cTipo $ "SA"
	SCP->(DbSetOrder(1))
	If SCP->(DbSeek(xFilial("SCP")+Padr(cNum,TamSx3("CP_NUM")[1]))) .And. !Empty(SCP->CP_USER)
		cRet := SCP->CP_USER
	Endif
ElseIf cTipo == "ST"
 	NNS->(DbSetOrder(1))
 	If NNS->(DbSeek(xFilial("NNS")+Padr(cNum,TamSx3("NNS_COD")[1]))) .And. !Empty(NNS->NNS_SOLICT)
		cRet := AllTrim(NNS->NNS_SOLICT)
 	Elseif Valtype(M->NNS_SOLICT) == "C" .And. !Empty(M->NNS_SOLICT)
		cRet := AllTrim(M->NNS_SOLICT)	
	Endif
Endif

If Empty(cRet)
	cRet := A097UsuApr(SCR->CR_APROV)
Endif

Return cRet

//-------------------------------------------------------------------
/*/{Protheus.doc} MTFlgLbDoc
Liberação genérica de processos do Fluig

@author rd.santos
@param cNum		Numero do Documento a Liberar
@param cUser		Codigo do Usuario Responsavel
@param cAprov		Situacao da aprovacao
@param cTipo		Tipo do Processo
@param cFluig		Codigo do Processo do Fluig
@param cParecer	Parecer informado na aprovacao
@param oModelCT	Modelo do contrato para aprovação de revisões

@since 13/10/2015
@version P12
@return lRet
/*/
//-------------------------------------------------------------------

User Function MTFlgLbDoc(cNum,cUser,cAprov,cTipo,cFluig,cParecer,oModelCT)
Local lRet 		:= .F.
Local lLock		:= .F.
Local cChave	:= ""
Local cSCRFil	:= ""
Local nX		:= 0	 
Local cLocKey	:= "WFAPR"+cUser+cFluig

Private aFluigIR	:= {}

Default oModelCT	:= NIL

cNum := PADR(cNum,TAMSX3('CR_NUM')[1],' ')
cUser := AllTrim(cUser)

If cTipo $ 'IC|CT|IR|RV'
	cSCRFil := CnFilCtr(cNum)
Else
	cSCRFil := xFilial("SCR")
EndIf

While lLock == .F. .And. nX < 3
	If (lLock := LockByName(cLocKey,.F.,.F.))
		DbSelectArea("SCR")
		SCR->(DbSetOrder(2))
		If SCR->(DbSeek(cSCRFil+cTipo+cNum+cUser)) .And. cAprov != '0'
			While !Eof() .And. cSCRFil+cTipo+cNum+cUser == SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER)
				If AllTrim(SCR->CR_FLUIG) == cFluig .And. (SCR->CR_STATUS == '03' .Or. SCR->CR_STATUS == '06') // Verifica se já foi aprovado e finaliza
					lRet := .T.
					Exit
				ElseIf Alltrim(SCR->CR_FLUIG) == cFluig .And. SCR->CR_STATUS == '02' // Verifica se está em aberto
					Begin Transaction
						If !Empty(cParecer) // Verifica se foi informado parecer na aprovação
							RecLock("SCR",.F.)
							SCR->CR_OBS := cParecer
							SCR->(MsUnlock())
						Endif
						If cAprov == '1' // Aprovado
							// Libera documento
							If cTipo $ "CT|IC|RV|IR|MD|IM"
								If cTipo $ "MD|IM" // Posiciona a medição
									DbSelectArea("CND")
									CND->(DbSetOrder(4))
									CND->(MsSeek(xFilial("CND")+Substr(cNum,1,TamSX3("CND_NUMMED")[1])))
								Endif
								lRet := GCTAlcEnt(oModelCT,MODEL_OPERATION_UPDATE,4,cTipo,cNum)
								If lRet .And. cTipo $ "MD|IM" .AND. MtGLastDBM(cTipo,cNum) .AND. SuperGetMV("MV_CNMDEAT",.F.,.F.)
									CN121Encerr(.T.)
								EndIf
							Else
								A097ProcLib(SCR->(Recno()),2,,,,,dDataBase)
							Endif
							lRet := .T.
						Elseif cAprov == '2' // Rejeitado
							If cTipo $ "CT|IC|RV|IR|MD|IM"
								lRet := CnRejDoc(SCR->CR_TIPO)
							Else
								If cTipo $ "PC|ST"
									Do Case															
										Case SCR->CR_TIPO == "PC"
											cChave := xFilial("SC7")+Substr(SCR->CR_NUM,1,TamSX3("C7_NUM")[1])
																		
										Case SCR->CR_TIPO == "ST"
											cChave := xFilial("NNS")+Substr(SCR->CR_NUM,1,TamSX3("NNS_COD")[1])
									EndCase
								Endif
								MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,,SCR->CR_APROV,,SCR->CR_GRUPO,,,,dDataBase,cParecer}, dDataBase ,7,,,,,,,cChave)
								lRet := .T.
							Endif
						Endif
					End Transaction
					Exit
				ElseIf Alltrim(SCR->CR_FLUIG) == cFluig .And. SCR->CR_STATUS <> '02' .And. SCR->CR_STATUS <> '01' // Verifica se já foi movimentado
					lRet := .T.
				Endif
				SCR->(DbSkip())
			EndDo
		EndIf
	Else
		nX++
		If nX >= 3
			lRet := .F.
			Help('',1,'WFAPR',,'O processo'+' '+cFluig+' '+'já está em execução por outra transação, favor aguardar alguns minutos e tentar novamente.')
			Conout('O processo'+' '+cFluig+' '+'já está em execução por outra transação, favor aguardar alguns minutos e tentar novamente.')
		Else				
			Sleep(1000)
		Endif
	EndIf
EndDo

If lLock
	UnLockByName(cLocKey,.F.,.F.)
EndIf


Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} CnAlcFlg(cNumDoc,cNumRev,cTipo)
Função para aglutinação de SCRs por aprovador/grupo e gera alçada nos Fluig

Parametros:
cNumDoc	Número do documento.
cNumRev	Número da revisão.
aTipo		Array dos tipos de documento 'CT','IC','RV','IR','MD','IM' pesquisados

@return	lRet
@author 	Israel Escorizza
@since 		09/03/2016

@version 	1.0
/*/
//-------------------------------------------------------------------
User Function CnAlcFlg()
Local lRet		:= .T.
Local aArea		:= GetArea()
Local aRows		:= FWSaveRows()
Local aReg		:= {}
Local aAprov	:= CnListaScr(cNumDoc,cNumRev,{cTipo},,)
Local nLenApr	:= Len(aAprov)
Local cGrpAtu	:= Iif( nLenApr > 0 , aAprov[1][3] , "")
Local cAprAtu	:= Iif( nLenApr > 0 , aAprov[1][4] , "")
Local cDocApr	:= ""
Local nX		:= 1
Local cNumDoc	:= Iif(Len(ParamIxb)>0,ParamIxb[1],"")
Local cNumRev	:= Iif(Len(ParamIxb)>1,ParamIxb[2],"")
Local cTipo		:= Iif(Len(ParamIxb)>2,ParamIxb[3],"")

While lRet .And. nX <= nLenApr
	If cGrpAtu != aAprov[nX][3] .Or. cAprAtu != aAprov[nX][4]
		//- Função que inicia processo do fluig e atualiza CR_FLUIG
		lRet := U_CnGerAlcFl(cTipo,AllTrim(cNumDoc+cNumRev),aReg,cDocApr)

		//- Atualiza Campos para continuidade do processo
		cGrpAtu := aAprov[nX][3]
		cAprAtu := aAprov[nX][4]
		cDocApr := ""
		aReg	 := {}
	EndIf

	aAdd(aReg,aAprov[nX][1])
	cDocApr+= aAprov[nX][2]
	If nX < nLenApr
		cDocApr+=", "
	EndIf

	nX++
EndDo

//- Função que inicia processo do fluig e atualiza CR_FLUIG
If lRet
	lRet := U_CnGerAlcFl(cTipo,AllTrim(cNumDoc+cNumRev),aReg,cDocApr) //-Chamada da função
EndIf

FWRestRows(aRows)
RestArea(aArea)
Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} CnGerAlcFl()
Função que efetiva a alçada no fluig, atualizando o campo CR_FLUIG das
SCRs aglutinadas

Parametros:

@return	lRet
@author 	Israel Escorizza
@since 		09/03/2016

@version 	1.0
/*/
//-------------------------------------------------------------------
User Function CnGerAlcFl(cTipo,cNumDoc,aReg,cAglut)
Local aArea		:= GetArea()
Local aRows		:= FWSaveRows()
Local aNextTask	:= {}
Local lFluig	:= SuperGetMV("MV_APWFECM",.F.,"2") == "1" .And. !Empty(AllTrim(GetNewPar("MV_ECMURL",""))) .And. FWWFFluig()
Local lRet 		:= .T.
Local cUser		:= ""
Local cProcess	:= ""
Local cCodUser	:= ""
Local cCodAprov	:= ""
Local cFilSav	:= ""
Local nX		:= 1	

If Len(aReg) > 0
	dbSelectArea('SCR')
	SCR->(dbGoTo(aReg[1]))
Endif

If lFluig .And. Len(aReg) > 0 .And. SCR->CR_STATUS == '02'
	SetScrAglu(cAglut) //- Define variavel estatica	

	cUser		:= ExecBlock("MtUsrSolic", .F., .F., {SCR->CR_TIPO,SCR->CR_NUM})
	cCodUser	:= FWWFColleagueId(cUser)
	cCodAprov	:= FWWFColleagueId(A097UsuApr(SCR->CR_APROV))

	If cTipo $ 'CT|IC|RV|IR'
		cFilSav	:= cFilAnt
		cFilAnt	:= CnFilCtr(SCR->CR_NUM)
	EndIf

	aNextTask 	:= {2,cCodUser,{cCodAprov}}
	StartProcess(cTipo,cCodUser,{cCodUser},,,,,aNextTask,.T.)
	cProcess	:= SCR->CR_FLUIG

	For nX := 2 To Len(aReg)
		SCR->(dbGoTo(aReg[nX]))
		Reclock("SCR",.F.)
		SCR->CR_FLUIG := cProcess
		MsUnlock()
	Next nX
Else
	lRet := .F.
EndIf

If !Empty(cFilSav)
	cFilAnt := cFilSav
EndIf
FWRestRows(aRows)
RestArea(aArea)
Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} CnVerAgFlg(cScrNum)
Função que verifica se Documento possui vinculo com aglutinação do fluig
@return	aRet
				[1] lRet	 	- Logico que define se existe aglutinação (.T./.F.)
				[2] cCrFluig 	- Valor do grupo de aprovação, quando este existir

@author 	Israel Escorizza
@since 		10/03/2016
@version 	1.0
/*/
//-------------------------------------------------------------------
User Function CnVerAgFlg()
Local aRet		:= {}
Local aArea		:= GetArea()
Local aRows		:= FWSaveRows()
Local cWhere	:= ""
Local lRet 		:= .F.
Local nNumLen	:= 0
Local cScrTip	:= Iif(Len(ParamIxb)>0,ParamIxb[1],SCR->CR_TIPO)
Local cScrNum	:= Iif(Len(ParamIxb)>1,ParamIxb[2],SCR->CR_NUM)
Local cScrFlg	:= Iif(Len(ParamIxb)>2,ParamIxb[3],SCR->CR_FLUIG)

DO 	CASE
	CASE cScrTip $ "CT|IC"
		 nNumLen	:= TAMSX3('CN9_NUMERO')[1]
	CASE cScrTip $ "RV|IR"
		 nNumLen	:= TAMSX3('CN9_NUMERO')[1]+TAMSX3('CN9_REVISA')[1]
	CASE cScrTip $ "MD|IM"
		 nNumLen	:= TAMSX3('CND_NUMMED')[1]
ENDCASE

cScrNum := LEFT(cScrNum,nNumLen)
If !Empty(cScrFlg)
	cWhere  := "CR_FLUIG = '"+cScrFlg+"'"

	If Len(CnListaScr(cScrNum,Nil,{cScrTip},cWhere,Nil)) > 1
		lRet := .T.
	EndIf
EndIf

aRet := {lRet,cScrFlg}

FWRestRows(aRows)
RestArea(aArea)
Return aRet

//-------------------------------------------------------------------
/*/{Protheus.doc} CnClrAgFlg(cFlgApr)
Função para remover vinculo de aglutinação dos SCRs e remover aprovação
no Fluig.

@return	lRet
@author 	Israel Escorizza
@since 		10/03/2016
@version 	1.0
/*/
//-------------------------------------------------------------------
User Function CnClrAgFlg()
Local lRet 		:= .T.
Local aArea		:= GetArea()
Local aRows		:= FWSaveRows()
Local aList		:= {}
Local cWhere	:= ""
Local nX		:= 1
Local cFlgApr	:= Iif(Len(ParamIxb)>0,ParamIxb[1],"")

If !Empty(cFlgApr)
	cWhere  := "CR_FLUIG = '"+cFlgApr+"'"
	aList := CnListaScr(,,,cWhere,)

	dbSelectArea('SCR')

	If !Empty(aList)
		For nX := 1 to Len(aList)
			SCR->(dbGoTo(aList[nX][1]))
			RecLock('SCR',.F.)
			SCR->CR_FLUIG := ""
			MsUnlock()
		Next nX
	EndIf

	//- Cancela aprovação no Fluig
	CancelProcess(Val(cFlgApr),FWWFUserID(Val(cFlgApr))," cancelado por aprovação Protheus.",.F.)
EndIf

FWRestRows(aRows)
RestArea(aArea)
Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} CNFlgVldSt(oModel)
Valida situação de processos do Fluig do modulo GCT e carrega o oModelCT

@since 24/11/2015
@version P12
@return lRet
/*/
//-------------------------------------------------------------------
User Function CNFlgVldSt(oModel,oModelCT)

Local cNum		:= PADR(oModel:GetValue('SCRMASTER','CR_NUM'),TAMSX3('CR_NUM')[1],' ')
Local cUser		:= AllTrim(oModel:GetValue('SCRMASTER','CR_USER'))
Local cTipo		:= oModel:GetValue('SCRMASTER','CR_TIPO')
Local cFluig	:= Alltrim(cValToChar(oModel:GetWKNumProces()))
Local cRev		:= ""
Local cNumero	:= ""
Local cSCRFil	:= ""
Local lAchou	:= .F.

Default oModel	:= NIL
Default oModelCT:= NIL

If cTipo $ "CT|IC|RV|IR"
	cNumero := Substr(oModel:GetValue('SCRMASTER','CR_NUM'),1,TamSX3("CN9_NUMERO")[1])
	If cTipo $ "RV|IR"
		cRev := Substr(oModel:GetValue('SCRMASTER','CR_NUM'),Len(cNumero)+1,TamSX3("CN9_REVISA")[1])
	Endif
	cSCRFil := CnFilCtr(cNumero)
Elseif cTipo $ "MD|IM"
	cNumero := Substr(oModel:GetValue('SCRMASTER','CR_NUM'),1,TamSX3("CND_NUMMED")[1])
	DbSelectArea("CND")
	CND->(DbSetOrder(4))
	CND->(MsSeek(xFilial("CND")+cNumero))
	cNumero := CND->CND_CONTRA
	cRev	 := CND->CND_REVISA
	cSCRFil := xFilial('SCR')
Endif

//Posiciona a alçada
DbSelectArea("SCR")
SCR->(DbSetOrder(2))
If SCR->(DbSeek(cSCRFil+cTipo+cNum+cUser))
	While !Eof() .And. cSCRFil+cTipo+cNum+cUser == SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER)
		If Alltrim(SCR->CR_FLUIG) == cFluig
			lAchou := .T.
			Exit
		Endif
		SCR->(dbSkip())
	EndDo
Endif

Return lAchou
