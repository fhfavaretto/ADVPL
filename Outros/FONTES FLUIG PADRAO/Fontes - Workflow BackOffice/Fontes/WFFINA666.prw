#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#INCLUDE 'WFFINA666.CH'

//-------------------------------------------------------------------
/* {Protheus.doc} ModelDef
Definição do modelo de Dados para Workflow de aprovação da solicitação de viagem

@since 31/08/2015
@version 1.0
*/
//-------------------------------------------------------------------
Static Function ModelDef()

Local oModel	:= MPFormModel():New('WFFINA666' ,/*PreValidacao*/,{|oModel| WFF666Vld(oModel) },{|oModel| WFF666Grv(oModel) },/*bCancel*/ )
Local oStruFW3 := FWFormStruct( 1, 'FW3')
Local oStruFW4 := FWFormStruct( 1, 'FW4' )

oStruFW3:AddField(STR0005, STR0006, 'FW3_APRVSL', 'C', 1, 1, /* bValid */, /* bWhen */, {'', '1='+STR0007,'2='+STR0008}, .T., /* cFolder */, /* cGroup */, /* aComboValues */, /* nMaxLenCombo */)//"Aprovar?"##"Aprovar Prestação"##"SIM"##"NÃO"

oModel:SetDescription(STR0009) //"Solicitação de Viagens"

oModel:Addfields("FW3MASTER",/*cOwner*/,oStruFW3)
oModel:AddGrid( 'FW4DETAIL', 'FW3MASTER',oStruFW4,/*bPreValidacao*/ , /*bPosValidacao*/ , /*bPreVal*/ , /*bPosVal*/ , /*BLoad*/ )
oModel:SetRelation( 'FW4DETAIL', { { 'FW4_FILIAL', 'xFilial( "FW4" )' }, { 'FW4_SOLICI', 'FW3_SOLICI' } }, FW4->( IndexKey( 1 ) ) )

oModel:GetModel('FW3MASTER'):SetDescription(STR0009) //"Solicitação de Viagens"
oModel:GetModel('FW4DETAIL'):SetNoInsertLine( .T. )
oModel:GetModel('FW4DETAIL'):SetNoUpdateLine( .T. )
oModel:GetModel('FW4DETAIL'):SetNoDeleteLine( .T. )


Return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef()
// Definição de View do Sistema para Workflow

@since 02/09/2015
@version 12.1.7
/*/
//-------------------------------------------------------------------
Static Function ViewDef()
Local oModel   := FWLoadModel( 'WFFINA666' )
Local oStruFW3 := FWFormStruct( 2, 'FW3' )
Local oStruFW4 := FWFormStruct( 2, 'FW4' )
Local oView := Nil
Local nY := 0
Local nX := 0

oStruFW3:AddField( 'FW3_APRVSL', '61', STR0005, STR0006, /* aHelp */, 'C', '@!', NIL, '', .T., NIL, NIL, {'', '1='+STR0007,'2='+STR0008}, NIL, NIL, .T., NIL/*, lInsertLine*/ ) //"Aprovar?"##"Aprovar Prestação"##"SIM"##"NÃO"

oStruFW3:SetNoFolder()
oStruFW4:SetNoFolder()

oView := FWFormView():New()
oView:SetModel( oModel )

oView:AddField('VIEW_FW3', oStruFW3, 'FW3MASTER' )
oView:AddGrid('VIEW_FW4',oStruFW4, 'FW4DETAIL' )

oView:CreateHorizontalBox( 'SUPERIOR', 35 )
oView:CreateHorizontalBox( 'INFERIOR', 40 )

// Relaciona o ID da View com o "box" para exibição
oView:SetOwnerView( 'VIEW_FW3', 'SUPERIOR' )
oView:SetOwnerView( 'VIEW_FW4', 'INFERIOR' )

oView:EnableTitleView('VIEW_FW3',STR0009) //"Solicitação de Viagens"
oView:EnableTitleView('VIEW_FW4',STR0003) //'Serviços'

oView:SetFldHidden( 'FW3MASTER', 'FW3_CODORI' )
oView:SetFldHidden( 'FW3MASTER', 'FW3_CODDES' )
oView:SetFldHidden( 'FW3MASTER', 'FW3_CLIENT' )
oView:SetFldHidden( 'FW3MASTER', 'FW3_LOJA' )
oView:SetFldHidden( 'FW3MASTER', 'FW3_USER' )
oView:SetFldHidden( 'FW3MASTER', 'FW3_WFKID ' )

oView:SetFldHidden( 'FW4DETAIL', 'FW4_SOLICI' )


oView:SetNoDeleteLine('VIEW_FW4')
oView:SetNoInsertLine('VIEW_FW4')

aFW3TRB := FW3->( DbStruct() )

For nX := 1 To Len( aFW3TRB )
	If	!aFW3TRB[nX][1] $ 'FW3_APRVSL|FW3_MOTVFL'
		For nY := 1 To Len( oStruFW3:AFIELDS)
			If oStruFW3:AFIELDS[nY][1] == aFW3TRB[nX][1]
				oStruFW3:SetProperty( aFW3TRB[nX][1] , MVC_VIEW_CANCHANGE, .F.)
			EndIf
		Next nY
	Else
		For nY := 1 To Len( oStruFW3:AFIELDS)
			If oStruFW3:AFIELDS[nY][1] == aFW3TRB[nX][1]
				oStruFW3:SetProperty( aFW3TRB[nX][1] , MVC_VIEW_CANCHANGE, .T.)
			EndIf
		Next nY
	EndIf
Next nX


Return oView

//-------------------------------------------------------------------
/* {Protheus.doc} WFF666Vld
Validação da solicitação de viagem

@since		04/11/2015
@version	12.1.8	
*/
//-------------------------------------------------------------------
Static Function WFF666Vld(oModel)
Local lRet		:= .T.
Local cAprv	:= oModel:GetValue('FW3MASTER', 'FW3_APRVSL')
Local cMotv	:= oModel:GetValue('FW3MASTER', 'FW3_MOTVFL')

If cAprv == '2' .AND. cMotv == ''
	lRet := .F.
	Help(" ",1,"WFF666Vld",,STR0004,1,0) //"Campo Motivo da Rejeição não foi preenchido"
Endif

Return lRet

//-------------------------------------------------------------------
/* {Protheus.doc} WFFIN666
Cria Workflow de aprovação da solicitação de viagem

IMPORTANTE: O NOME desta função NÃO deve ser alterado

@since		26/11/2015
@version	12.1.9
*/
//-------------------------------------------------------------------
User Function WFFIN666(cChvFW3, cUser, aUsersX)
Local cChvFW3		:= PARAMIXB[1]
Local cUser			:= PARAMIXB[2]
Local aUsersX		:= PARAMIXB[3]
Local aRetWF		:= {}
Local cWFID			:= ""
Local cUserFluig	:= ""
Local nX			:= 0
Local aUsers		:= {}

DbSelectArea("FW3")
FW3->(dbSetOrder(1)) //FW3_FILIAL+FW3_SOLICI

If FW3->(DbSeek(cChvFW3))
	cUserFluig	:= FWWFColleagueId(cUser)
	
	DbSelectArea("RD0")
	RD0->(DbSetOrder(1))
	
	For nX := 1 To Len(aUsersX)
		If RD0->(DbSeek( xFilial("RD0") + aUsersX[nX] ))
			cUsX := FWWFColleagueId(RD0->RD0_USER)
			If Valtype(cUsX) == 'C'
				aAdd(aUsers,cUsX)
			EndIf
		EndIf
	Next nX
	
	aRetWF		:= StartProcess( 'SOLVIAJ1  ', cUserFluig, aUsers ) // StartProcess(Codigo do Processo, Usuário responsável)
	cWFID		:= AllTrim( Str( aRetWF[1] ) )
	
	If cWFID != "0" .AND. cWFID != "" .AND. cWFID != NIL
		
		If MoveProcess("SOLVIAJ1  ", Val(cWFID), cUserFluig, aUsers, 2)
			
			BEGIN TRANSACTION
				
				RecLock( "FW3", .F. )
				FW3->FW3_WFKID  := cWFID
				FW3->( MsUnLock() )
				
			END TRANSACTION
		Else
			CancelProcess(Val(cWfId),cUserFluig,STR0001)//"Excluido pelo sistema Protheus"
		EndIf
		
	EndIf
	
EndIf

Return

//-------------------------------------------------------------------
/* {Protheus.doc} WFF666Grv
Realiza a Gravação da Prestação de Contas.

@since		04/11/2015
@version	12.1.8
*/
//-------------------------------------------------------------------
Static Function WFF666Grv(oModel)
Local aArea	 	:= GetArea()
Local cFilFW3 	:= oModel:GetValue('FW3MASTER','FW3_FILIAL')
Local cId	 		:= oModel:GetValue('FW3MASTER','FW3_SOLICI')
Local cMotv		:= oModel:GetValue('FW3MASTER','FW3_MOTVFL')
Local cUser		:= oModel:GetValue('FW3MASTER','FW3_USER')
Local lAprov		:= oModel:GetValue('FW3MASTER','FW3_APRVSL') == "1"
Local aUser		:= {}
Local aSubist		:= {}
Local cNomApr		:= ''
Local cTpAprov	:= ''
Local cAliasTrb2	:= GetNextAlias()

aUser := FWSFLoadUser(oModel:GetWKUser())

If Len(aUser) == 0
	aUser := FWSFLoadUser(oModel:GetWKUserEmail())
EndIf

DbSelectArea("RD0")

BeginSql Alias cAliasTrb2
	SELECT	RD0_CODIGO, RD0_NOME
	FROM	%table:RD0% RD0
	WHERE	RD0.RD0_FILIAL = %xFilial:RD0%
   			AND RD0.RD0_USER = %exp:aUser[2]%
   			AND RD0.%notDel%
   	ORDER BY RD0_CODIGO
EndSql

__cUserID	:= (cAliasTrb2)->RD0_CODIGO
cUsername	:= aUser[3]
cNomApr	:= (cAliasTrb2)->RD0_NOME

RD0->(DbSetOrder(1))
If RD0->(DbSeek( xFilial("RD0") + cUser ))
		
	If __cUserID == RD0->RD0_APROPC
		cTpAprov := 'O'
	ElseIf __cUserID == RD0->RD0_APSUBS
		cTpAprov := 'S'
		aAdd(aSubist, __cUserID)
		aAdd(aSubist, cNomApr)
	EndIf
EndIf

If lAprov
	cStatus := '5'
Else
	cStatus := '2'
EndIf

RecLock("FW3",.F.)
	FW3->FW3_MOTVFL := cMotv
	FW3->FW3_STATUS := cStatus 
MsUnlock()

If Select(cAliasTrb2) > 0
	(cAliasTrb2)->(DbCloseArea())
EndIf

RestArea(aArea)

Return .T.
