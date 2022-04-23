#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'WFTMKA510.CH'

//------------------------------------------------------------------------------
/*/{Protheus.doc} WFTMKA510

Formulário do workflow de aprovação do TeleAtendimento/ Central de Serviços.

@sample		WFTMKA510()

@param			Nenhum

@return		Nenhum

@author		Serviços - Inovação
@since			26/09/2014
@version		12.0
/*/
//------------------------------------------------------------------------------

User Function WFTMKA510()
Return

//------------------------------------------------------------------------------
/*/{Protheus.doc} ModelDef

Fluig - Experiência #2
Modelo de dados do formulário do workflow de aprovação do TeleAtendimento/ Central de Serviços.

@sample		ModelDef()

@param			Nenhum

@return		oModel		Objeto MPFormModel

@author		Serviços - Inovação
@since			26/09/2014
@version		12.0
/*/
//------------------------------------------------------------------------------

Static Function ModelDef()
Local oModel
Local oStruADE	:= DefStrModel( 'ADE', {'ADE_CODIGO', 'ADE_CODCON', 'ADE_NMCONT', 'ADE_ENTIDA', 'ADE_NMENT', 'ADE_CODSB1', 'ADE_NMPROD', 'ADE_DATA', 'ADE_SEVCOD'} )
Local oStruADF 	:= DefStrModel( 'ADF', {'ADF_ITEM', 'ADF_CODSU9', 'ADF_NMSU9', 'ADF_CODSUQ', 'ADF_NMSUQ', 'ADF_CODSU7', 'ADF_NMSU7', 'ADF_SKWSTA'}, {'ADF_SKWSTA'} )

oModel := MPFormModel():New( 'WFTK510', /*bPreValidacao*/, /*bPosValidacao*/, { |oMdl| WFCommit( oMdl ) }, /*bCancel*/ )

oModel:AddFields( 'ADEMASTER', /*cOwner*/, oStruADE, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
oModel:AddGrid( 'ADFDETAIL', 'ADEMASTER', oStruADF, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )

oModel:SetDescription( STR0001 ) // "Aprovação do Atendimento"
oModel:GetModel( 'ADEMASTER' ):SetDescription( STR0002 ) // "Atendimento" 
oModel:GetModel( 'ADFDETAIL' ):SetDescription( STR0003 ) // "Itens" 

oModel:SetRelation("ADFDETAIL",{{"ADF_FILIAL","xFilial('ADF')"},{"ADF_CODIGO","ADE_CODIGO"}},ADF->( IndexKey(1)))


oModel:SetPrimaryKey({'ADE_CODIGO'})


Return oModel

//------------------------------------------------------------------------------
/*/{Protheus.doc} ViewDef

Fluig - Experiência #2
Interface do formulário do workflow de aprovação do TeleAtendimento/ Central de Serviços.

@sample		ViewDef()

@param			Nenhum

@return		oView		Objeto FWFormView

@author		Serviços - Inovação
@since			26/09/2014
@version		12.0
/*/
//------------------------------------------------------------------------------

Static Function ViewDef()
Local oModel   := FWLoadModel( 'WFTMKA510' )
Local oStruADE := DefStrView( 'ADE', {'ADE_CODIGO', 'ADE_CODCON', 'ADE_NMCONT', 'ADE_ENTIDA', 'ADE_NMENT', 'ADE_CODSB1', 'ADE_NMPROD', 'ADE_DATA', 'ADE_SEVCOD'} )
Local oStruADF := DefStrView( 'ADF', {'ADF_ITEM', 'ADF_CODSU9', 'ADF_NMSU9', 'ADF_CODSUQ', 'ADF_NMSUQ', 'ADF_CODSU7', 'ADF_NMSU7', 'ADF_SKWSTA'}, {'ADF_SKWSTA'} )
Local oView

oView := FWFormView():New()

oView:SetModel( oModel )

oView:AddField( 'VIEW_ADE', oStruADE, 'ADEMASTER' )
oView:AddGrid(  'VIEW_ADF', oStruADF, 'ADFDETAIL' )

oView:CreateHorizontalBox( 'SUPERIOR', 30 )
oView:CreateHorizontalBox( 'INFERIOR', 70 )

oView:SetOwnerView( 'VIEW_ADE', 'SUPERIOR' )
oView:SetOwnerView( 'VIEW_ADF', 'INFERIOR' )

Return oView

//------------------------------------------------------------------------------
/*/	{Protheus.doc} WFCommit

Bloco de transacao durante o commit do model. 

@sample	WFCommit(oModel)

@param		ExpO1 - Modelo de dados

@return	ExpL  - Verdadeiro / Falso

@author	Serviços - Inovação
@since		26/09/2014
@version	12.0               
/*/
//------------------------------------------------------------------------------

Static Function WFCommit(oModel)
Local aArea := GetArea()
Local lOk := .F.
Local oModelADE
Local oModelADF
Local cParams := ''
Local aUser
Local cStatus := ''
Local oModel	:= FWModelActive()

If oModel:GetOperation() == MODEL_OPERATION_UPDATE

	lOk := .T.

	oModelADE := oModel:GetModel( 'ADEMASTER' )
	oModelADF := oModel:GetModel( 'ADFDETAIL' )
	
	cStatus := oModelADF:GetValue('ADF_SKWSTA')
	cStatus := Iif(cStatus == '1', 'S', 'N')
	
	cParams += "<STATUS>"	+ cStatus 								+ "</STATUS>" 	//status da tarefa no ECM
	cParams += "<OBS></OBS>"		//observacao apos aprovaacao ou reprovacao
	cParams += "<CODADE>"	+ oModelADE:GetValue('ADE_CODIGO')	+ "</CODADE>" 	//codigo do chamado
	cParams += "<CODITEM>"	+ oModelADF:GetValue('ADF_ITEM') 	+	"</CODITEM>"	//item do chamado
	
	// pesquisa por e-mail
	aUser := FWSFLoadUser(oModel:GetWKUserEmail())
	
	cParams += "<USER>" 		//codigo do usuario
	If !Empty(aUser)
		cParams += aUser[2]
	EndIf
	cParams += "</USER>"
	
	BEGIN TRANSACTION
	TkEcmWFRet(oModel:GetWKDef(), cParams, oModel:GetWKNumProces())
	END TRANSACTION
	
EndIf

RestArea( aArea )

Return lOk

//------------------------------------------------------------------------------
/*/	{Protheus.doc} DefStrModel

Monta estrutura do model. 

@sample	DefStrModel( cAlias, aFields, aRequired )

@param		ExpC1 - Alias da tabela
			ExpA1 - Campos
			ExpA2 - Campos obrigatórios

@return	ExpL  - Verdadeiro / Falso

@author	CRM/Faturamento  Ermerson.silva
@since		27/12/2017
@version	12.0               
/*/
//------------------------------------------------------------------------------

Static Function DefStrModel( cAlias, aFields, aRequired )
Local nI
Local aArea    := GetArea()
Local aAreaSX3 := SX2->( GetArea() )
Local aAreaSIX := SX3->( GetArea() )
Local aAreaSX2 := SIX->( GetArea() )
Local bValid   := {|| .T.}
Local bWhen    := {|| .T.}
Local bRelac   := NIL
Local cX2Nome  := ""
Local cX2Chave := ""
Local cX2Unico := ""
Local aSX2Info := {}

DEFAULT aRequired := {}

oStruct := FWFormModelStruct():New()

//-------------------------------------------------------------------
// Tabela
//-------------------------------------------------------------------
aSX2Info    := FwSX2Util():GetSX2Data(cAlias /*cAlias*/, {"X2_CHAVE","X2_UNICO"} /*aFields*/, /*lQuery*/)
cX2Nome		:= FwSX2Util():GetX2Name(cAlias /*cAlias*/, /*lSeekByFile*/)
cX2Chave	:= aSX2Info[01,02]
cX2Unico	:= aSX2Info[02,02]
 
If Empty(cX2Unico)
	SIX->( dbSetOrder( 1 ) )
	SIX->( dbSeek( cAlias ) )
	oStruct:AddTable(cX2Chave, StrTokArr(SIX->CHAVE, '+'), cX2Nome)
Else
	oStruct:AddTable(cX2Chave, StrTokArr(cX2Unico, '+'), cX2Nome)
EndIf

//-------------------------------------------------------------------
// Campos
//-------------------------------------------------------------------
SX3->( dbSetOrder( 2 ) )
For nI := 1 To Len(aFields)
	If SX3->( dbSeek( aFields[nI] ) )
		oStruct:AddField(AllTrim(X3Titulo()),;							// [01] Titulo do campo
		                 AllTrim(X3Descric()),;							// [02] ToolTip do campo
		                 AllTrim(aFields[nI]),;							// [03] Id do Field
		                 SX3->X3_TIPO,;									// [04] Tipo do campo
		                 SX3->X3_TAMANHO,;								// [05] Tamanho do campo
		                 SX3->X3_DECIMAL,;								// [06] Decimal do campo
		                 bValid,;										// [07] Code-block de validação do campo
		                 bWhen,;										// [08] Code-block de validação When do campo
		                 StrTokArr(AllTrim(X3CBox()), ';'),;			// [09] Lista de valores permitido do campo
		                 Ascan(aRequired, AllTrim(aFields[nI])) > 0,;	// [10] Indica se o campo tem preenchimento obrigatório
		                 bRelac,;										// [11] Code-block de inicializacao do campo
		                 NIL,;											// [12] Indica se trata-se de um campo chave
		                 NIL,;											// [13] Indica se o campo pode receber valor em uma operação de update.
		                 (SX3->X3_CONTEXT == 'V'))						// [14] Indica se o campo é virtual
	EndIf
Next

RestArea(aAreaSX2)
RestArea(aAreaSX3)
RestArea(aAreaSIX)
RestArea(aArea)
aSize(aAreaSX2,0)
aSize(aAreaSX3,0)
aSize(aAreaSIX,0)
aSize(aArea,0)
FreeObj(aSX2Info)
Return oStruct

//------------------------------------------------------------------------------
/*/	{Protheus.doc} DefStrView

Monta estrutura da view. 

@sample	DefStrView( cAlias, aFields, aEditable )

@param		ExpC1 - Alias da tabela
			ExpA1 - Campos
			ExpA2 - Campos editáveis

@return	ExpL  - Verdadeiro / Falso

@author	Serviços - Inovação
@since		26/09/2014
@version	12.0               
/*/
//------------------------------------------------------------------------------

Static Function DefStrView( cAlias, aFields, aEditable )
Local nI
Local nJ
Local aArea     := GetArea()
Local aAreaSX3  := SX3->( GetArea() )
Local oStruct   := FWFormViewStruct():New()
Local aCombo    := {}
Local nInitCBox := 0
Local nMaxLenCb := 0
Local aAux      := {}
Local cGSC      := ''

DEFAULT aEditable := {}

//-------------------------------------------------------------------
// Campos
//-------------------------------------------------------------------
SX3->( dbSetOrder( 2 ) )

For nJ := 1 To Len(aFields)
	If SX3->( dbSeek( aFields[nJ] ) )

		aCombo := {}

		If !Empty( X3Cbox() )

			nInitCBox := 0
			nMaxLenCb := 0

			aAux := RetSX3Box( X3Cbox() , @nInitCBox, @nMaxLenCb, SX3->X3_TAMANHO )

			For nI := 1 To Len( aAux )
				aAdd( aCombo, aAux[nI][1] )
			Next nI

		EndIf

		bPictVar := FwBuildFeature( STRUCT_FEATURE_PICTVAR, SX3->X3_PICTVAR )

		cGSC     := IIf( Empty( X3Cbox() ) , IIf( SX3->X3_TIPO == 'L', 'CHECK', 'GET' ) , 'COMBO' )

		oStruct:AddField( ;
		AllTrim( SX3->X3_CAMPO  )    , ;                	// [01] Campo
		SX3->X3_ORDEM                , ;                	// [02] Ordem
		AllTrim( X3Titulo()  )       , ;                	// [03] Titulo
		AllTrim( X3Descric() )       , ;                	// [04] Descricao
		NIL                          , ;                	// [05] Help
		cGSC                         , ;                	// [06] Tipo do campo   COMBO, Get ou CHECK
		SX3->X3_PICTURE              , ;                	// [07] Picture
		bPictVar                     , ;                	// [08] PictVar
		SX3->X3_F3                   , ;                	// [09] F3
		Ascan(aEditable, AllTrim( SX3->X3_CAMPO  )) > 0, ;  // [10] Editavel
		SX3->X3_FOLDER               , ;                	// [11] Folder
		SX3->X3_FOLDER               , ;                	// [12] Group
		aCombo                       , ;                	// [13] Lista Combo
		nMaxLenCb                    , ;                	// [14] Tam Max Combo
		SX3->X3_INIBRW               , ;                	// [15] Inic. Browse
		( SX3->X3_CONTEXT == 'V' )     )                	// [16] Virtual

	EndIf
Next

RestArea( aAreaSX3 )
RestArea( aArea )

Return oStruct
