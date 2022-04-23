#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include 'WFFINA677.ch'

#DEFINE CAMPO	1

//-------------------------------------------------------------------
/* {Protheus.doc} ModelDef
Definição do modelo de Dados

@since 31/08/2015
@version 1.0
*/
//-------------------------------------------------------------------
Static Function ModelDef()

Local oModel	:= MPFormModel():New('WFFINA677' ,/*PreValidacao*/,{|oModel| WFF677Vld(oModel) },{|oModel| WFF677Grv(oModel) },/*bCancel*/ )
Local oStruFLF	:= FWFormStruct(1,'FLF', {|cCampo| AllTrim(cCampo) $ 'FLF_FILIAL|FLF_MOTVFL|FLF_VIAGEM|FLF_TDESP1|FLF_PRESTA|FLF_PARTIC|FLF_TDESP2|FLE_PARTIC|FLF_TDESP3|FLF_TVLRE1|FLF_TVLRE2|FLF_TVLRE3|FLF_TIPO|FLF_NOMEPA'})
Local oStruFLE	:= FWFormStruct(1,'FLE')
Local lWF677CPO	:= ExistBlock("WF677CPO")

oStruFLF:AddField(STR0001, STR0002, 'FLF_APRVSOL', 'C', 1, 1, /* bValid */, /* bWhen */, {'', '1='+STR0003,'2='+STR0004}, .T., /* cFolder */, /* cGroup */, /* aComboValues */, /* nMaxLenCombo */)//"Aprovar?"##"Aprovar Prestação"##"SIM"##"NÃO"

oModel:SetDescription(STR0005) //"Prestação de Contas"

If lWF677CPO //Campos adicionais na estrutura do model.
	oStruFLF := ExecBlock("WF677CPO",.F.,.F.,{'1',oStruFLF})
EndIf

oModel:Addfields("FLFMASTER",/*cOwner*/,oStruFLF)
oModel:AddGrid("FLEDETAIL","FLFMASTER" ,oStruFLE)

oModel:SetRelation('FLEDETAIL', { { 'FLE_FILIAL', 'xFilial("FLE")' }, { 'FLE_TIPO', 'FLF_TIPO' }, { 'FLE_PRESTA', 'FLF_PRESTA' }, { 'FLE_PARTIC', 'FLF_PARTIC' } }, FLE->(IndexKey(1)) )

oModel:GetModel('FLFMASTER'):SetDescription(STR0005) //"Prestação de Contas"
oModel:GetModel('FLEDETAIL'):SetNoInsertLine( .T. )
oModel:GetModel('FLEDETAIL'):SetNoUpdateLine( .T. )
oModel:GetModel('FLEDETAIL'):SetNoDeleteLine( .T. )

oModel:SetPrimaryKey( {'FLF_TIPO','FLF_PRESTA','FLF_PARTIC'} )

Return oModel

//-------------------------------------------------------------------
/* {Protheus.doc} ViewDef
Definição do interface

@since 31/08/2015
@version 1.0
*/
//-------------------------------------------------------------------
Static Function ViewDef()
Local oModel	:= FWLoadModel('WFFINA677')
Local oStruFLF	:= FWFormStruct( 2, 'FLF', {|cCampo| AllTrim(cCampo) $ 'FLF_FILIAL|FLF_MOTVFL|FLF_VIAGEM|FLF_TDESP1|FLF_TDESP2|FLF_TDESP3|FLF_TVLRE1|FLF_TVLRE2|FLF_TVLRE3|FLF_TIPO|FLF_PRESTA|FLF_PARTIC|FLF_NOMEPA'})
Local oStruFLE	:= FWFormStruct( 2, 'FLE')
Local oView		:= Nil
Local aFLFTRB 	:= {}
Local nX		:= 0
Local nY		:= 0
Local lWF677CPO	:= ExistBlock("WF677CPO")

oStruFLF:AddField( 'FLF_APRVSOL', '61', STR0001, STR0002, /* aHelp */, 'C', '@!', NIL, '', .T., NIL, NIL, {'', '1='+STR0003,'2='+STR0004}, NIL, NIL, .T., NIL/*, lInsertLine*/ ) //"Aprovar?"##"Aprovar Prestação"##"SIM"##"NÃO"

oStruFLF:SetNoFolder()
oStruFLE:SetNoFolder()

oView := FWFormView():New()
oView:SetModel(oModel)

If lWF677CPO //Campos adicionais na estrutura da view.
	oStruFLF := ExecBlock("WF677CPO",.F.,.F.,{'2',oStruFLF})
EndIf

oView:AddField('View_FLF', oStruFLF,'FLFMASTER' )
oView:AddGrid( 'View_FLE', oStruFLE,'FLEDETAIL' )

oView:CreateHorizontalBox( 'Pai'  ,50)
oView:CreateHorizontalBox( 'Filho',50)

oView:SetOwnerView('View_FLF','Pai')
oView:SetOwnerView('View_FLE','Filho')

oView:SetFldHidden( 'FLFMASTER', 'FLF_PARTIC' )
oView:SetFldHidden( 'FLEDETAIL', 'FLE_TIPO' )
oView:SetFldHidden( 'FLEDETAIL', 'FLE_PRESTA' )
oView:SetFldHidden( 'FLEDETAIL', 'FLE_PARTIC' )
oView:SetFldHidden( 'FLEDETAIL', 'FLE_LA' )

oView:SetNoDeleteLine('View_FLE')
oView:SetNoInsertLine('View_FLE')

aFLFTRB := FLF->( DbStruct() )

For nX := 1 To Len( aFLFTRB )
	If	!aFLFTRB[nX][CAMPO] $ 'FLF_APRVSOL|FLF_MOTVFL'
		For nY := 1 To Len( oStruFLF:AFIELDS)
			If oStruFLF:AFIELDS[nY][CAMPO] == aFLFTRB[nX][CAMPO]
				oStruFLF:SetProperty( aFLFTRB[nX][CAMPO] , MVC_VIEW_CANCHANGE, .F.)
			EndIf
		Next nY
	Else
		For nY := 1 To Len( oStruFLF:AFIELDS)
			If oStruFLF:AFIELDS[nY][CAMPO] == aFLFTRB[nX][CAMPO]
				oStruFLF:SetProperty( aFLFTRB[nX][CAMPO] , MVC_VIEW_CANCHANGE, .T.)
			EndIf
		Next nY
	EndIf
Next nX

Return oView

//-------------------------------------------------------------------
/* {Protheus.doc} WFFIN677
Cria Workflow de aprovação da prestação de contas no Fluig

IMPORTANTE: O NOME desta função NÃO deve ser alterado

@since		31/08/2015
@version	12.1.7
*/
//-------------------------------------------------------------------
User Function WFFIN677(cChvFLF, cUser, aUsers)
Local cChvFLF		:= PARAMIXB[1]
Local cUser			:= PARAMIXB[2]
Local aUsers		:= PARAMIXB[3]
Local aRetWF		:= {}
Local cWFID			:= ""
Local cUserFluig	:= ""
Local nX			:= 0
Local cProcWFP		:= "APVPRESTCO"


DbSelectArea("FLF")
FLF->(dbSetOrder(1)) //FLF_FILIAL+FLF_TIPO+FLF_PRESTA+FLF_PARTIC

If FLF->(DbSeek(cChvFLF))

	cUserFluig	:= FWWFColleagueId(cUser)
	
	DbSelectArea("RD0")
	RD0->(DbSetOrder(1))
	
	For nX := 1 To Len(aUsers)
		If RD0->(DbSeek( xFilial("RD0") + aUsers[nX] ))
			aUsers[nX]	:= FWWFColleagueId(RD0->RD0_USER)
		EndIf
	Next nX
	
	aRetWF		:= StartProcess( cProcWFP , cUserFluig, aUsers ) // StartProcess(Codigo do Processo, Usuário responsável)
	cWFID		:= AllTrim( Str( aRetWF[1] ) )
	
	If cWFID != "0" .AND. cWFID != "" .AND. cWFID != NIL
		
		If MoveProcess(cProcWFP , Val(cWFID), cUserFluig, aUsers, 2)
		
			BEGIN TRANSACTION
			
				RecLock( "FLF", .F. )
				FLF->FLF_WFKID  := cWFID
				FLF->( MsUnLock() )
			
			END TRANSACTION
		Else	
			CancelProcess(Val(cWfId),cUserFluig,STR0009)//"Excluido pelo sistema Protheus"
		EndIf
		
	EndIf
	
EndIf

Return

//-------------------------------------------------------------------
/* {Protheus.doc} WFF677Grv
Realiza a Gravação da Prestação de Contas.

@since		04/11/2015
@version	12.1.8
*/
//-------------------------------------------------------------------
Static Function WFF677Grv(oModel)
Local aArea	 	:= GetArea()
Local cFilFLF 	:= oModel:GetValue('FLFMASTER','FLF_FILIAL')
Local cTpFLF 		:= AllTrim(oModel:GetValue('FLFMASTER','FLF_TIPO'))
Local cPrtaFLF 	:= oModel:GetValue('FLFMASTER','FLF_PRESTA')
Local cParTFLF 	:= AllTrim(oModel:GetValue('FLFMASTER','FLF_PARTIC'))
Local cMotv		:= oModel:GetValue('FLFMASTER','FLF_MOTVFL')
Local cAprv		:= Iif(oModel:GetValue('FLFMASTER','FLF_APRVSOL') == "1", "A","R")
Local aUser		:= {}
Local cNomApr		:= ''
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

__cUserID	:= AllTrim((cAliasTrb2)->RD0_CODIGO)
cUsername	:= aUser[3]
cNomApr		:= (cAliasTrb2)->RD0_NOME

F677APRGRV(cAprv, '', {}, cTpFLF, cPrtaFLF, cParTFLF, "1"/*cSeq*/, cMotv, '2',oModel)

If Select(cAliasTrb2) > 0
	(cAliasTrb2)->(DbCloseArea())
EndIf

RestArea(aArea)

Return .T.

//-------------------------------------------------------------------
/* {Protheus.doc} WFF677Vld
Validação da Prestação de Contas.

@author	Kaique Schiller
@since		04/11/2015
@version	12.1.8
	
*/
//-------------------------------------------------------------------
Static Function WFF677Vld(oModel)
Local lRet		:= .T.
Local cAprv	:= oModel:GetValue('FLFMASTER', 'FLF_APRVSOL')
Local cMotv	:= oModel:GetValue('FLFMASTER', 'FLF_MOTVFL')

If cAprv == '2' .AND. cMotv == ''
	lRet := .F.
	Help(" ",1,"WFF677Vld",,STR0008,1,0) //"Campo Motivo da Rejeição não foi preenchido"
Endif

Return lRet
