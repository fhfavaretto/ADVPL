#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include 'WFATFA125.ch'

#DEFINE CODIGO	2
#DEFINE CAMPO		1

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Modelo de dados da Solicitação da Baixa do Ativo 
@author Lucas de Oliveira
@since 13/02/2014
@version 1.0	
/*/
//-------------------------------------------------------------------
Static Function ModelDef()
Local oModel		:= MPFormModel():New('WFATFA125' ,/*PreValidacao*/, {|oModel| WATF125Vld(oModel)}, {|oModel| WATF125Grv(oModel)},/*bCancel*/ )
Local oStruSNM	:= FWFormStruct(1,'SNM')
Local aSNMTRB		:= {}
Local nX

oStruSNM:AddField(STR0001, STR0002, "NM_APRVSOL", "C", 1, 1, /* bValid */, /* bWhen */, {'', '1='+STR0003,'2='+STR0004}, .T., /* cFolder */, /* cGroup */, /* aComboValues */, /* nMaxLenCombo */)//"Aprovar?"##"Aprovar solicitação"##"SIM"##"NÃO"
oStruSNM:AddField(STR0005, STR0006, "NM_VORIG1", "N", 16, 2, /* bValid */, /* bWhen */, , .F., /* cFolder */, /* cGroup */, /* aComboValues */, /* nMaxLenCombo */)//"Vlr. Ativo"##"Valor Ativo na moeda 1"
oStruSNM:AddField(STR0007, STR0008, "NM_VRDACM1", "N", 16, 2, /* bValid */ , /* bWhen */, , .F., /* cFolder */, /* cGroup */, /* aComboValues */, /* nMaxLenCombo */)//"Dep. Acumulada"##"Depreciação Acumulada na moeda 1"
oStruSNM:AddField(STR0009, STR0010, "NM_VALATU", "N", 16, 2, /* bValid */, /* bWhen */, , .F., /* cFolder */, /* cGroup */, /* aComboValues */, /* nMaxLenCombo */)//"Vlr. Atual"##"Valor atualizado"

oModel:SetDescription(STR0011)//'Solicitação de Baixa do Ativo'

oModel:AddFields('SNMMASTER',/*cOwner(Pai)*/,oStruSNM)

oModel:GetModel('SNMMASTER'):SetDescription(STR0011)//'Solicitação de Baixa do Ativo'

oModel:SetActivate( {|oModel| WFAT125ACT(oModel) } )

Return oModel


//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Visualizador de dados da Solicitação da Baixa do Ativo
@author Lucas de Oliveira
@since 13/02/2014
@version 1.0	
/*/
//-------------------------------------------------------------------
Static Function ViewDef()
Local oModel		:=	FWLoadModel('WFATFA125')
Local oStruSNMA	:= FWFormStruct(2, 'SNM', {|cCampo| AllTrim(cCampo) $ "NM_APRVSOL|NM_USRAPV|NM_NMUSAPV|NM_HISTREJ"})
Local oStruSNMS	:= FWFormStruct(2, 'SNM', {|cCampo| AllTrim(cCampo) $ "NM_VORIG1|NM_VRDACM1|NM_VALATU|NM_CODIGO|NM_DATSOL|NM_CBASE|NM_ITEM|NM_TIPO|NM_DESCBEM|NM_HISTSOL|NM_USRSOL|NM_NMUSSOL|NM_TIPOSOL|NM_GRUPO|NM_MOTBX|NM_QTDBX|NM_VLRBAIX|NM_VLVENDA|NM_HORSOL|NM_GERANF|NM_SITSOL"})
Local oView
Local nX,nY,nZ
Local aSNMTRB		:=	{}

oStruSNMS:SetNoFolder()
oStruSNMA:SetNoFolder()

oStruSNMA:AddField( 'NM_APRVSOL', '61', STR0001, STR0002, /* aHelp */, 'C', '@!', NIL, '', .T., NIL, NIL, {'', '1='+STR0003,'2='+STR0004}, NIL, NIL, .T., NIL/*, lInsertLine*/ )
oStruSNMS:AddField( 'NM_VORIG1', '80', STR0005, STR0006, /* aHelp */, 'N', '@E 9,999,999,999,999.99', NIL, '', .T., NIL, NIL, , NIL, NIL, .T., NIL/*, lInsertLine*/ )
oStruSNMS:AddField( 'NM_VRDACM1', '81', STR0007, STR0008, /* aHelp */, 'N', '@E 9,999,999,999,999.99', NIL, '', .T., NIL, NIL, , NIL, NIL, .T., NIL/*, lInsertLine*/ )
oStruSNMS:AddField( 'NM_VALATU', '82', STR0009, STR0010, /* aHelp */, 'N', '@E 9,999,999,999,999.99', NIL, '', .T., NIL, NIL, , NIL, NIL, .T., NIL/*, lInsertLine*/ )


oView := FWFormView():New()
oView:SetModel(oModel)

//oView:AddField('VIEW_SNM',oStruSNM,'SNMMASTER')
oView:AddField('VIEW_SNMS', oStruSNMS,'SNMMASTER' )
oView:AddField('VIEW_SNMA', oStruSNMA,'SNMMASTER' )

oView:CreateFolder('FLD_SNM')
oView:AddSheet('FLD_SNM','FLD_SOL',STR0012)//'Solicitação de Baixa do Ativo'
oView:AddSheet('FLD_SNM','FLD_APR',STR0013)//'Aprovação'

//oView:CreateHorizontalBox( 'SUP_SNM', 100)
oView:CreateHorizontalBox( 'BOX_SOL' ,100, /*owner*/, /*lUsePixel*/, 'FLD_SNM', 'FLD_SOL')
oView:CreateHorizontalBox( 'BOX_APR' ,100, /*owner*/, /*lUsePixel*/, 'FLD_SNM', 'FLD_APR')


//oView:SetOwnerView('VIEW_SNM','SUP_SNM')
oView:SetOwnerView('VIEW_SNMS','BOX_SOL')
oView:SetOwnerView('VIEW_SNMA','BOX_APR')

//oView:EnableTitleView('VIEW_SNM')

aSNMTRB := SNM->( DbStruct() )

For nX := 1 To Len( aSNMTRB )
	If	!aSNMTRB[nX][CAMPO] $ "NM_APRVSOL|NM_HISTREJ"
		For nY := 1 To Len( oStruSNMS:AFIELDS) 
			If oStruSNMS:AFIELDS[nY][CAMPO] == aSNMTRB[nX][CAMPO]
				oStruSNMS:SetProperty( aSNMTRB[nX][CAMPO] , MVC_VIEW_CANCHANGE, .F.)
			EndIf
		Next nY
		
		For nZ	:= 1 To Len(oStruSNMA:AFIELDS)
			If oStruSNMA:AFIELDS[nZ][CAMPO] == aSNMTRB[nX][CAMPO]
				oStruSNMA:SetProperty( aSNMTRB[nX][CAMPO] , MVC_VIEW_CANCHANGE, .F.)
			EndIf
		Next nZ
	EndIf
Next nX

oStruSNMS:SetProperty( 'NM_HISTSOL'	, MVC_VIEW_CANCHANGE, .F.)
oStruSNMS:SetProperty( 'NM_VORIG1'		, MVC_VIEW_CANCHANGE, .F.)
oStruSNMS:SetProperty( 'NM_VRDACM1'	, MVC_VIEW_CANCHANGE, .F.)
oStruSNMS:SetProperty( 'NM_VALATU'		, MVC_VIEW_CANCHANGE, .F.)

Return oView

//-------------------------------------------------------------------
/*/{Protheus.doc} WFATFA125
Cria Workflow de aprovação da solicitação da baixa do ativo no Fluig
@author Lucas de Oliveira
@since 13/02/2014
@version 1.0	
/*/
//-------------------------------------------------------------------
Function WFATFA125( cUserFluig,cCodigoSol )
Local	oBrowse:= FWmBrowse():New()
Local 	nI
Local 	aUsers		:= {}
Local	aRetWF		:= {}
Local	oModel		:= FWLoadModel('WFATFA125')
Local	oModSNM	:= oModel:GetModel('SNMMASTER')

dbSelectArea( "SNM" )
SNM->( dbSetOrder(1) )
If SNM->( dbSeek( xFilial( "SNM" ) + cCodigoSol ) ) // Filial+NM_CODIGO
	oModel:SetOperation(4)
	oModel:Activate()	
	
	cTipo := oModSNM:GetValue("NM_SITSOL")
	
	//FWExecView('Solicitação de Baixa do Ativo','WFATFA125', 4, , { || .T. }, , , )
	
	aRetWF	:= StartProcess( 'SOLBXAT', cUserFluig ) //StartProcess(Codigo do Processo, Usuário responsável)
	cWFID	:=	AllTrim( Str( aRetWF[1] ) )
	
	
	If cWFID != "0" .AND. cWFID != "" .AND. cWFID != Nil
		Begin Transaction
			dbSelectArea( "SNM" )
			SNM->( dbSetOrder(1) )
			SNM->( dbSeek( xFilial( "SNM" ) + cCodigoSol ) )
			
			While SNM->NM_FILIAL == xFilial( "SNM" ) .And. SNM->NM_CODIGO == cCodigoSol
				RecLock( "SNM", .F. )
				SNM->NM_WFID := cWFID
				SNM->( dbSkip() )
				SNM->( MsUnLock() )
			EndDo
		End Transaction
	EndIf
	
EndIf

Return


//-------------------------------------------------------------------
/*/{Protheus.doc} WATF125Vld
Valida o formulário da Solicitação da baixa de ativo
@author Lucas de Oliveira
@since 13/02/2014
@version 1.0	
/*/
//-------------------------------------------------------------------
Function WATF125Vld(oModel)
Local lRet			:= .T.
Local cOpc			:= oModel:GetValue('SNMMASTER' , 'NM_APRVSOL')
Local oModSNM		:= oModel:GetModel('SNMMASTER')

Local cHistRej

If cOpc == ''

	lRet := .F.
	Help(" ",1,"WATF125APV",,STR0014 ,1,0) //"Campo Aprovar? não foi preenchido."

ElseIf cOpc == '2'

	oModSNM:GetStruct():SetProperty('NM_HISTREJ', MODEL_FIELD_OBRIGAT,.T.)
	cHistRej := oModel:GetValue('SNMMASTER' , 'NM_HISTREJ')
	
	If Empty(cHistRej)
		lRet := .F.
		Help(" ",1,"WATF125HIS",,STR0015,1,0) //"Campo Histórico de rejeição não foi preenchido."
	EndIf

EndIf

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} WATF125Grv
Grava aprovação da Solicitação da baixa de ativo
@author Lucas de Oliveira
@since 13/02/2014
@version 1.0	
/*/
//-------------------------------------------------------------------
Function WATF125Grv(oModel)
Local aArea		:= GetArea()
Local cAssunto
Local lRet 		:= .F.
Local nI       	:= 0
Local eMailApv	:= ""
Local cAprov	 	:= ""
Local cMensagem	:= ""
Local cEmailUsr	:= ""
Local cMailID    	:= " "
Local cCodSol    	:= "" 
Local dDtApvRej	:= dDataBase
Local dHrApvRej	:= StrTran( Left( Time(), 5), ':', '' )
Local cObs			:= oModel:GetValue('SNMMASTER' , 'NM_HISTREJ')
Local cOpc		 	:= oModel:GetValue('SNMMASTER' , 'NM_APRVSOL')
Local cCodApvRej 	:= oModel:GetValue('SNMMASTER' , 'NM_CDHREJ')
Local cUsrSol	 	:= oModel:GetValue('SNMMASTER' , 'NM_USRSOL')
Local cCDAPROV   	:= oModel:GetValue('SNMMASTER' , 'NM_USRAPV')
Local cCodSol 	:= oModel:GetValue('SNMMASTER' , 'NM_CODIGO') 

dbSelectArea( "SNM" )
SNM->( dbSetOrder(1) )


If SNM->( dbSeek( xFilial("SNM") + cCodSol ) )
	
	cCodSol 	:= oModel:GetValue('SNMMASTER' , 'NM_CODIGO') 
	cWFID		:= SNM->NM_WFID
	
	If cOpc == '1'  // Aprovar
		
		lLiberou := ATFA126Grava( 3, .T. )	//FUNCAO QUE IRA FAZER A BAIXA E DEMAIS PROCESSOS
		
		If lLiberou
			
			dbSelectArea( "SNM" )
			SNM->( dbSetOrder(1) )
			SNM->( dbSeek( xFilial( "SNM" ) + cCodSol ) )
			
			While SNM->(!EOF()) .AND. xFilial( "SNM" ) + cCodSol == SNM->NM_FILIAL + SNM->NM_CODIGO
				RecLock( "SNM", .F. )							
				SNM->NM_USRAPV	:=	cCDAPROV
				SNM->NM_DTAPVRE	:=	dDtApvRej
				SNM->NM_HRAPVRE	:=	dHrApvRej
				SNM->NM_CDHREJ 	:=	cCodApvRej
				SNM->NM_SITSOL	:=	"2"							
				SNM->( MsUnlock() )							
				SNM->( dbSkip() )
			EndDo
			lRet := .T.
		EndIf
		
	ElseIf cOpc == '2' // Rejeitar
							
		dbSelectArea( "SNM" )
		SNM->( dbSetOrder(1) )
		SNM->( dbSeek( xFilial("SNM") + cCodSol ) )					
						
		While SNM->(!EOF()) .AND. xFilial( "SNM" ) + cCodSol == SNM->NM_FILIAL + SNM->NM_CODIGO
			RecLock( "SNM", .F. )
			SNM->NM_USRAPV	:= cCDAPROV
			SNM->NM_DTAPVRE	:= dDtApvRej
			SNM->NM_HRAPVRE	:= dHrApvRej
			SNM->NM_CDHREJ 	:= cCodApvRej
			SNM->NM_SITSOL	:= "3"
			MSMM( SNM->NM_CDHREJ, , , cObs, 1, , ,"SNM", "NM_CDHREJ" )	
			SNM->( MsUnlock() )						
			SNM->( dbSkip() )
		EndDo
		lRet := .T.
	EndIf
EndIf


Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} WFAT125ACT
Inicialização padrão dos campos virtuais do workflow
@author Lucas de Oliveira
@since 13/02/2014
@version 1.0	
/*/
//-------------------------------------------------------------------
Function WFAT125ACT(oModel)
Local nRet := 0
Local aArea := GetArea()
Local nValOrig := 0
Local nValDepr := 0
Local nValAltu := 0
Local oModelSNM := oModel:GetModel('SNMMASTER')
SN3->(dbSetOrder(1))
If SN3->(dbSeek( xFilial("SN3") + SNM->NM_CBASE + SNM->NM_ITEM + SNM->NM_TIPO ))
	nValOrig := SN3->N3_VORIG1
	nValDepr := SN3->N3_VRDACM1
	nValAltu := nValOrig - nValDepr

	oModelSNM:LoadValue("NM_VORIG1",nValOrig)
	oModelSNM:LoadValue("NM_VRDACM1",nValDepr)
	oModelSNM:LoadValue("NM_VALATU",nValAltu)
	
EndIf

RestArea(aArea)
Return nRet

