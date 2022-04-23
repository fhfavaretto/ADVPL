#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#INCLUDE 'WFFINA667.CH'

//-------------------------------------------------------------------
/* {Protheus.doc} ModelDef
Definição do modelo de Dados para Workflow de Aprovação de Adiantamentos.

@since 16/12/2015
@version 12.1.8
*/
//-------------------------------------------------------------------
Static Function ModelDef()

Local oModel	:= MPFormModel():New('WFFINA667' ,/*PreValidacao*/,{|oModel| WFF667Vld(oModel) },{|oModel| WFF667Grv(oModel) },/*bCancel*/ )
Local oStruFLD	:= FWFormStruct(1 , 'FLD' , { |x| ALLTRIM(x) $ 'FLD_VIAGEM,FLD_ADIANT,FLD_PARTIC,FLD_NOMEPA,FLD_VALOR,FLD_DTSOLI,FLD_JUSTIF,FLD_MOEDA' })
Local lWF667Cpo	:= ExistBlock("WF667Cpo")

oStruFLD:AddField(STR0001, STR0002, 'FLD_APRVSL', 'C', 1, 1, /* bValid */, /* bWhen */, {'', '1='+STR0003,'2='+STR0004}, .T., /* cFolder */, /* cGroup */, /* aComboValues */, /* nMaxLenCombo */)//"Aprovar?"##"Aprovar Prestação"##"SIM"##"NÃO"

oModel:SetDescription(STR0005) //"Solicitação de Viagens"

If lWF667Cpo //Campos adicionais na estrutura do model.
	oStruFLD := ExecBlock("WF667Cpo",.F.,.F.,{'1',oStruFLD})
EndIf

oModel:Addfields("FLDMASTER",/*cOwner*/,oStruFLD)

oModel:GetModel('FLDMASTER'):SetDescription(STR0005) //"Solicitação de Viagens"

Return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef()
// Definição de View do Sistema para Workflow

@author lucas.oliveira
@since 02/09/2015
@version 12.1.7
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
Local oModel		:= FWLoadModel('WFFINA667')
Local oStruFLD	:= FWFormStruct(2, 'FLD', { |x| ALLTRIM(x) $ 'FLD_VIAGEM,FLD_ADIANT,FLD_PARTIC,FLD_NOMEPA,FLD_VALOR,FLD_DTSOLI,FLD_JUSTIF,FLD_MOEDA' })
Local oView		:= Nil
Local nY := 0
Local nX := 0
Local lWF667Cpo	:= ExistBlock("WF667Cpo")

oStruFLD:AddField( 'FLD_APRVSL', '61', STR0001, STR0002, /* aHelp */, 'C', '@!', NIL, '', .T., NIL, NIL, {'', '1='+STR0003,'2='+STR0004}, NIL, NIL, .T., NIL/*, lInsertLine*/ ) //"Aprovar?"##"Aprovar Prestação"##"SIM"##"NÃO"
oStruFLD:SetNoFolder()

oView := FWFormView():New()
oView:SetModel( oModel )

If lWF667Cpo //Campos adicionais na estrutura do view.
	oStruFLD := ExecBlock("WF667Cpo",.F.,.F.,{'2',oStruFLD})
EndIf

oView:AddField('VIEW_FLD', oStruFLD, 'FLDMASTER' )
oView:CreateHorizontalBox( 'SUPERIOR', 100 )
// Relaciona o ID da View com o "box" para exibição
oView:SetOwnerView( 'VIEW_FLD', 'SUPERIOR' )
oView:EnableTitleView('VIEW_FLD',STR0005) //"Solicitação de Viagens"

oView:SetFldHidden( 'FLDMASTER', 'FLD_PARTIC' )

aFLDTRB := FLD->( DbStruct() )

For nX := 1 To Len( aFLDTRB )
	If	!aFLDTRB[nX][1] $ 'FLD_APRVSL|FLD_JUSTIF'
		For nY := 1 To Len( oStruFLD:AFIELDS)
			If oStruFLD:AFIELDS[nY][1] == aFLDTRB[nX][1]
				oStruFLD:SetProperty( aFLDTRB[nX][1] , MVC_VIEW_CANCHANGE, .F.)
			EndIf
		Next nY
	Else
		For nY := 1 To Len( oStruFLD:AFIELDS)
			If oStruFLD:AFIELDS[nY][1] == aFLDTRB[nX][1]
				oStruFLD:SetProperty( aFLDTRB[nX][1] , MVC_VIEW_CANCHANGE, .T.)
			EndIf
		Next nY
	EndIf
Next nX


Return oView

//-------------------------------------------------------------------
/*/{Protheus.doc} WFFIN667
Modelo de dados da Solicitação de Aprovação de Adiantamentos

IMPORTANTE: O NOME desta função NÃO deve ser alterado

@since 01/09/2015
@version 12.1.7
/*/
//-------------------------------------------------------------------
User Function WFFIN667( cViagem, cPartic,cAdiant, cUser, aUsers )

Local	cViagem		:= PARAMIXB[1]
Local	cPartic		:= PARAMIXB[2]
Local	cAdiant		:= PARAMIXB[3]
Local	cUser		:= PARAMIXB[4]
Local	aUsers		:= PARAMIXB[5]
Local	aRetWF		:= {}
Local	cWFID		:= ""
Local	cUserFluig	:= ""
Local  	nX 			:= 0
Local 	cProcWF		:= "SOLADIANTA"

dbSelectArea( "FLD" )	// Solicitação de Aprovação de Adiantamento
FLD->( dbSetOrder(1) )	// Filial + Viagem + Participante

If FLD->( dbSeek( FWxFilial( "FLD" ) + cViagem + cPartic + cAdiant ) )
	
	cUserFluig	:= FWWFColleagueId(cUser)
	
	DbSelectArea("RD0")
	RD0->(DbSetOrder(1))
	
	For nX := 1 To Len(aUsers)
		If RD0->(DbSeek( xFilial("RD0") + aUsers[nX] ))
			aUsers[nX]	:= FWWFColleagueId(RD0->RD0_USER)
		EndIf
	Next nX
	
	aRetWF	:= StartProcess( cProcWF, cUserFluig, aUsers ) // StartProcess(Codigo do Processo, Usuário responsável)
	cWFID	:= AllTrim( Str( aRetWF[1] ) )
	
	If cWFID != "0" .AND. cWFID != "" .AND. cWFID != NIL
		
		If MoveProcess(cProcWF, Val(cWFID), cUserFluig, aUsers, 2)
			
			BEGIN TRANSACTION
				
				RecLock( "FLD", .F. )
				FLD->FLD_WFKID := cWFID
				FLD->( MsUnLock() )
				
			END TRANSACTION
		Else
			CancelProcess(Val(cWfId),cUserFluig,STR0006)//"Excluido pelo sistema Protheus"
		EndIf
		
	EndIf
	
EndIf

Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} WF667Grv
Função para gravação dos dados modelo de dados da solicitação de aprovação de adiantamento.

@since 21/12/2015
@version 12.1.8
/*/
//-------------------------------------------------------------------
Static Function WFF667Grv(oModel)
Local aArea	 	:= GetArea()
Local oModelFLD	:= oModel:GetModel('FLDMASTER')
Local cViagem		:= oModelFLD:GetValue('FLD_VIAGEM')
Local cPartic 	:= oModelFLD:GetValue('FLD_PARTIC')
Local cAdiant		:= oModelFLD:GetValue('FLD_ADIANT')
Local lReprov		:= oModelFLD:GetValue('FLD_APRVSL') != "1"

FWFormCommit( oModel )

aUser := FWSFLoadUser(oModel:GetWKUser())

If Len(aUser) == 0
	aUser := FWSFLoadUser(oModel:GetWKUserEmail())
EndIf

If Len(aUser) 
	__cUserID := aUser[2]
Endif

If !lReprov
	RecLock("FLD",.F.)
	FLD->FLD_VALAPR := FLD->FLD_VALOR	
	FLD->FLD_DTAPRO := dDataBase
	FLD->FLD_APROV  := __cUserID
	MsUnLock()
EndIf

FI667APGES(cViagem,cPartic,cAdiant,lReprov)

RestArea(aArea)

Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} WF667Vld
Validação da Prestação de Contas.

@since		09/12/2015
@version	12.1.8
/*/
//-------------------------------------------------------------------
Static Function WFF667Vld(oModel)
Local lRet		:= .T.
Local cAprv	:= oModel:GetValue('FLDMASTER', 'FLD_APRVSL')
Local cMotv	:= oModel:GetValue('FLDMASTER', 'FLD_JUSTIF')

//UserException( 'ERRO' )

If cAprv == '2' .AND. cMotv == ''
	lRet := .F.
	Help(" ",1,"WFF667Vld",,STR0007,1,0) //"Campo Motivo da Rejeição não foi preenchido"
Endif

Return lRet
