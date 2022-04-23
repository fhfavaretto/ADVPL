#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include 'WFPCOA530.ch'

#DEFINE CODIGO	2
#DEFINE CAMPO		1


//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Modelo de dados da Solicitação de Contingência
@author Lucas de Oliveira
@since 23/07/2014
@version 1.0	
/*/
//-------------------------------------------------------------------
Static Function ModelDef()
Local oModel		:= MPFormModel():New('WFPCOA530' ,/*PreValidacao*/, {|oModel| WPCO530Vld(oModel)}, {|oModel| WPCO530Grv(oModel)},/*bCancel*/ )
Local oStruALI	:= FWFormStruct(1,'ALI')
Local aALITRB		:= {}
Local nX

oStruALI:AddField(STR0001/*"Aprovar?"*/, STR0002/*"Aprovar solicitação"*/, "ALI_APROV", "C", 1, 1, /* bValid */, /* bWhen */, {"", "1="+ STR0003/*SIM*/,"2="+ STR0004/*NÃO*/}, .T., /* cFolder */, /* cGroup */, /* aComboValues */, /* nMaxLenCombo */)
oModel:SetDescription(STR0005) //"Solicitação de Contingência"
oModel:AddFields("ALIMASTER",/*cOwner(Pai)*/,oStruALI)
oModel:GetModel("ALIMASTER"):SetDescription(STR0005) //"Solicitação de Contingência"
oModel:SetPrimaryKey( { "ALI_IDALI" } )
oModel:SetPKIndexOrder(6)

Return oModel


//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Visualizador de dados da Solicitação de Contingência
@author Lucas de Oliveira
@since 23/07/2014
@version 1.0	
/*/
//-------------------------------------------------------------------
Static Function ViewDef()
Local oModel		:=	FWLoadModel('WFPCOA530')
Local oStruALIC	:=	FWFormStruct(2,'ALI', {|cCampo| AllTrim(cCampo) $ "ALI_CDCNTG|ALI_SOLIC|ALI_NOMSOL|ALI_DTSOLI|ALI_DTVALI|ALI_CODBLQ|ALI_STATUS|ALI_MEMO|ALI_PROCESSO|ALI_LOTEID|ALI_HORA|ALI_IDALI"})
Local oStruALIA	:=	FWFormStruct(2,'ALI', {|cCampo| AllTrim(cCampo) $ "ALI_USER|ALI_NOME|ALI_APROV"})
Local oView
Local nX

oStruALIC:SetNoFolder()
oStruALIA:SetNoFolder()

oStruALIA:AddField( 'ALI_APROV', '25', STR0001/*'Aprovar?'*/, STR0006/*'Aprovar ou Reprovar a solicitação'*/, /* aHelp */, 'C', '@!', NIL, '', .T., NIL, NIL, {"", "1="+ STR0003/*SIM*/, "2="+ STR0004/*NÃO*/}, NIL, NIL, .T., NIL/*, lInsertLine*/ )

oView := FWFormView():New()
oView:SetModel(oModel)

oView:AddField('VIEW_ALIC',oStruALIC,'ALIMASTER')
oView:AddField('VIEW_ALIA',oStruALIA,'ALIMASTER')

oView:CreateFolder('FLD_ALI')
oView:AddSheet('FLD_ALI','FLD_CON',STR0005) //"Solicitação de Contingência"
oView:AddSheet('FLD_ALI','FLD_APR',STR0007) //"Aprovação"

oView:CreateHorizontalBox( 'BOX_CON' ,100, /*owner*/, /*lUsePixel*/, 'FLD_ALI', 'FLD_CON')
oView:CreateHorizontalBox( 'BOX_APR' ,100, /*owner*/, /*lUsePixel*/, 'FLD_ALI', 'FLD_APR')

oView:SetOwnerView('VIEW_ALIC','BOX_CON')
oView:SetOwnerView('VIEW_ALIA','BOX_APR')

oView:SetFldHidden('VIEW_ALIC','ALI_IDALI')

oStruALIC:SetProperty( 'ALI_CODBLQ'	, MVC_VIEW_CANCHANGE, .F.)
oStruALIC:SetProperty( 'ALI_MEMO'		, MVC_VIEW_CANCHANGE, .F.)

Return oView


//-------------------------------------------------------------------
/*/{Protheus.doc} WFPCOA530
Cria Workflow de aprovação da solicitação de contingência no Fluig
@author Lucas de Oliveira
@since 23/07/2014
@version 1.0	
/*/
//-------------------------------------------------------------------
Function WFPCOA530( cCdUsrP, cCdUsrF, cCdCntg, cIdALI )
Local	oBrowse	:= FWmBrowse():New()   
Local 	nI 
Local	lRet		:= .F.
Local 	aUsers		:= {}
Local	cWFID
Local	aRetWF		:= {}
Local	oModel		:= FWLoadModel('WFPCOA530')

dbSelectArea( "ALI" )
ALI->( dbSetOrder(1) )
If ALI->( dbSeek( xFilial( "ALI" ) + cCdCntg + cCdUsrP ) ) // ALI_FILIAL + ALI_CDCNTG + ALI_USER
	
	oModel:SetOperation(4)
	oModel:Activate()
	
	aRetWF	:= StartProcess('SOLCONT', cCdUsrF) // StartProcess(Codigo do Processo ,Usuário Solicitante, Usuário responsável)
	cWFID	:= AllTrim( Str( aRetWF[1] ) )
	
	If cWFID != "0" .AND. cWFID != "" .AND. cWFID != Nil
		Begin Transaction
			DbSelectArea("ALI")
			ALI->( dbSetOrder(6) )
			If ALI->( dbSeek( xFilial( "ALI" ) + cIdALI ) )
				RecLock("ALI", .F.)
				ALI->ALI_PROCWF := cWFID
				MSUnlock()
				lRet := .T.
			EndIf
		End Transaction		
	EndIf

EndIf

Return lRet


//-------------------------------------------------------------------
/*/{Protheus.doc} WPCO530Vld
Valida o formulário da Solicitação de Contingência
@author Lucas de Oliveira
@since 23/07/2014
@version 1.0	
/*/
//-------------------------------------------------------------------
Function WPCO530Vld(oModel)
Local lRet		:= .F.
Local cOpc		:= oModel:GetValue('ALIMASTER' , 'ALI_APROV')
Local cCDCNTG	:= AllTrim(oModel:GetValue('ALIMASTER', 'ALI_CDCNTG')) 
Local cCODBLQ	:= AllTrim(oModel:GetValue('ALIMASTER', 'ALI_CODBLQ'))
Local cUsuario:= AllTrim(oModel:GetValue('ALIMASTER', 'ALI_USER'))
Local lLibera	:= If(oModel:GetValue('ALIMASTER' , 'ALI_APROV') == "1", .T., .F.) // Obtem a resposta do Aprovador.

If cOpc == ""
	Help(" ", 1, "WPCO530APV", , STR0008, 1, 0) //"O campo 'Aprovar?' não foi preenchido."
Else
	dbSelectArea( "ALI" )
	ALI->( DbSetorder( 1 ) )
	//If ALI->(DbSeek(PadR(cFilMail, Len(xFilial())) + cCDCNTG + cUsuario))
	If ALI->( dbSeek( xFilial( "ALI" ) + cCDCNTG + cUsuario ) ) // ALI_FILIAL + ALI_CDCNTG + ALI_USER
		If ALI->ALI_STATUS $ "03/05"
			Help(" ", 1, "WPCO530APV", , STR0009, 1, 0) //"Solicitação de contingencia ja liberada!"
		ElseIf ALI->ALI_STATUS == "01"
			Help(" ", 1, "WPCO530APV", , STR0010, 1, 0) //"Solicitação de contingencia aguardando liberacao de nivel anterior!"
		ElseIf ALI->ALI_STATUS $ "04/06"
			Help(" ", 1, "WPCO530APV", , STRoo11, 1, 0) //"Solicitação de contingencia ja cancelada!"
		EndIf 
	Else
		Help(" ", 1, "WATF125APV", , STR0012 + cCDCNTG + STR0013, 1, 0) //"RETORNO - Contingencia "###" não encontrada"
	Endif
	lRet := .T.
EndIf  

Return lRet


//-------------------------------------------------------------------
/*/{Protheus.doc} WPCO530Grv
Grava retorno da aprovação/rejeição da solicitação de contingência
@author Lucas de Oliveira
@since 23/07/2014
@version 1.0	
/*/
//-------------------------------------------------------------------
Function WPCO530Grv(oModel) 
Local cCDCNTG		:= AllTrim(oModel:GetValue('ALIMASTER', 'ALI_CDCNTG'))
Local cCODBLQ		:= AllTrim(oModel:GetValue('ALIMASTER', 'ALI_CODBLQ'))
Local cUsuario	:= AllTrim(oModel:GetValue('ALIMASTER', 'ALI_USER'))
Local lLibera		:= If(oModel:GetValue('ALIMASTER' , 'ALI_APROV') == "1", .T., .F.) // Obtem a resposta do Aprovador.

If lLibera
	//"Liberando contingencia "
	PCOA500GER(.T., cCODBLQ, cUsuario)
Else
	//"Cancelando contingencia "
	PCOA530ALC(6, cCODBLQ,,.T., cUsuario) //Rejeitando liberação se resposta negativa	
EndIf		                                                               				

Return .T.
