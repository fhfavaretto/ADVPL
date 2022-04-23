#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'WFFATA600.CH'

//------------------------------------------------------------------------------
/*/{Protheus.doc} WFFATA600

Formulário do workflow de aprovação da Prosposta Comercial.

@sample		WFFATA600()

@param			Nenhum

@return		Nenhum

@author		Serviços - Inovação
@since			26/09/2014
@version		12.0
/*/
//------------------------------------------------------------------------------

User Function WFFATA600()
Return

//------------------------------------------------------------------------------
/*/{Protheus.doc} ModelDef

Fluig - Experiência #2
Modelo de dados do formulário do workflow de aprovação da Prosposta Comercial.

@sample		ModelDef()

@param			Nenhum

@return		oModel		Objeto MPFormModel

@author		Serviços - Inovação
@since			26/09/2014
@version		12.0
/*/
//------------------------------------------------------------------------------

Static Function ModelDef()
Local oStruADY := DefStrModel( 'ADY', {'ADY_PROPOS', 'ADY_OPORTU', 'AD1_DESCRI', 'ADY_ENTIDA', 'A1_NOME', 'ACA_GRPREP', 'ACA_DESCRI', 'ADY_VEND', 'A3_NOME', 'AD1_DATA', 'ADY_STATUS'}, {'ADY_STATUS'} )
Local oStruACA := FWFormModelStruct():New()
Local oStruADZ := DefStrModel( 'ADZ', {'ADZ_ITEM', 'ADZ_PRODUT', 'ADZ_DESCRI', 'ADZ_QTDVEN', 'ADZ_PRCVEN', 'ADZ_PRCTAB', 'ADZ_TOTAL'} )
Local oModel := MPFormModel():New( 'WFFT600', /*bPreValidacao*/, /*bPosValidacao*/, { |oMdl| WFCommit( oMdl ) }, /*bCancel*/ )

oStruACA:AddTable( 'ACA', , STR0004 ) // "Limites para a equipe"

oStruACA:AddField( ;
	STR0010, ; // [01] Titulo do campo
	STR0010, ; // [02] ToolTip do campo
	'TYPE', ;  // [03] Id do Field
	'C', ;     // [04] Tipo do campo
	30, ;      // [05] Tamanho do campo
	0, ;       // [06] Decimal do campo
	{|| .T.}, ; // [07] Code-block de validação do campo
	{|| .T.}, ; // [08] Code-block de validação When do campo
	NIL, ;     // [09] Lista de valores permitido do campo
	.F., ;     // [10] Indica se o campo tem preenchimento obrigatório
	NIL, ;     // [11] Code-block de inicializacao do campo
	NIL, ;     // [12] Indica se trata-se de um campo chave
	NIL, ;     // [13] Indica se o campo pode receber valor em uma operação de update.
	.T.)       // [14] Indica se o campo é virtual

oStruACA:AddField( ;
	STR0011, ; // [01] Titulo do campo
	STR0011, ; // [02] ToolTip do campo
	'PMAX', ;  // [03] Id do Field
	'C', ;     // [04] Tipo do campo
	10, ;       // [05] Tamanho do campo
	0, ;       // [06] Decimal do campo
	{|| .T.}, ; // [07] Code-block de validação do campo
	{|| .T.}, ; // [08] Code-block de validação When do campo
	NIL, ;     // [09] Lista de valores permitido do campo
	.F., ;     // [10] Indica se o campo tem preenchimento obrigatório
	NIL, ;     // [11] Code-block de inicializacao do campo
	NIL, ;     // [12] Indica se trata-se de um campo chave
	NIL, ;     // [13] Indica se o campo pode receber valor em uma operação de update.
	.T.)       // [14] Indica se o campo é virtual

oStruACA:AddField( ;
	STR0012, ; // [01] Titulo do campo
	STR0012, ; // [02] ToolTip do campo
	'VMAX', ;  // [03] Id do Field
	'C', ;     // [04] Tipo do campo
	14, ;      // [05] Tamanho do campo
	0, ;       // [06] Decimal do campo
	{|| .T.}, ; // [07] Code-block de validação do campo
	{|| .T.}, ; // [08] Code-block de validação When do campo
	NIL, ;     // [09] Lista de valores permitido do campo
	.F., ;     // [10] Indica se o campo tem preenchimento obrigatório
	NIL, ;     // [11] Code-block de inicializacao do campo
	NIL, ;     // [12] Indica se trata-se de um campo chave
	NIL, ;     // [13] Indica se o campo pode receber valor em uma operação de update.
	.T.)       // [14] Indica se o campo é virtual

oModel:AddFields( 'ADYMASTER', /*cOwner*/, oStruADY, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
oModel:AddGrid( 'ACAGRID', 'ADYMASTER', oStruACA, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
oModel:AddGrid( 'ADZGRID', 'ADYMASTER', oStruADZ, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )

oModel:SetDescription( STR0001 ) // "Aprovação da Proposta Comercial"

oModel:GetModel( 'ADYMASTER' ):SetDescription( STR0002 ) // "Proposta" 
oModel:GetModel( 'ACAGRID' ):SetDescription( STR0004 ) // "Limites para a equipe" 
oModel:GetModel( 'ADZGRID' ):SetDescription( STR0003 ) // "Itens" 

oModel:SetPrimaryKey({'ADY_PROPOS'})

Return oModel

//------------------------------------------------------------------------------
/*/{Protheus.doc} ViewDef

Fluig - Experiência #2
Interface do formulário do workflow de aprovação da Prosposta Comercial.

@sample		ViewDef()

@param			Nenhum

@return		oView		Objeto FWFormView

@author		Serviços - Inovação
@since			26/09/2014
@version		12.0
/*/
//------------------------------------------------------------------------------

Static Function ViewDef()
Local oModel   := FWLoadModel( 'WFFATA600' )
Local oStruADY := DefStrView( 'ADY', {'ADY_PROPOS', 'ADY_OPORTU', 'AD1_DESCRI', 'ADY_ENTIDA', 'A1_NOME', 'ACA_GRPREP', 'ACA_DESCRI', 'ADY_VEND', 'A3_NOME', 'AD1_DATA', 'ADY_STATUS'}, {'ADY_STATUS'} )
Local oStruACA := FWFormViewStruct():New() //DefStrView( 'ACA', {'ACA_PACRMX', 'ACA_VACRMX', 'ACA_PDSCMX', 'ACA_VDSCMX'} )
Local oStruADZ := DefStrView( 'ADZ', {'ADZ_ITEM', 'ADZ_PRODUT', 'ADZ_DESCRI', 'ADZ_QTDVEN', 'ADZ_PRCVEN', 'ADZ_PRCTAB', 'ADZ_TOTAL'} )
Local oView := FWFormView():New()

oStruACA:AddField( ;
	'TYPE', ;  // [01] Campo
	'001', ;   // [02] Ordem
	STR0010, ; // [03] Titulo
	STR0010, ; // [04] Descricao
	NIL, ;    // [05] Help
	'GET', ;   // [06] Tipo do campo   COMBO, Get ou CHECK
	'', ;      // [07] Picture
	NIL, ;     // [08] PictVar
	'', ;     // [09] F3
	.F., ;    // [10] Editavel
	NIL, ;    // [11] Folder
	NIL, ;    // [12] Group
	NIL, ;    // [13] Lista Combo
	0, ;      // [14] Tam Max Combo
	'', ;     // [15] Inic. Browse
	.T.)      // [16] Virtual

oStruACA:AddField( ;
	'PMAX', ;      // [01] Campo
	'002', ;       // [02] Ordem
	STR0011, ;     // [03] Titulo
	STR0011, ;     // [04] Descricao
	NIL, ;        // [05] Help
	'GET', ;      // [06] Tipo do campo   COMBO, Get ou CHECK
	'', ; // [07] Picture
	NIL, ;        // [08] PictVar
	'', ;         // [09] F3
	.F., ;  			// [10] Editavel
	NIL, ;        // [11] Folder
	NIL, ;        // [12] Group
	NIL, ;        // [13] Lista Combo
	0, ;          // [14] Tam Max Combo
	'', ;         // [15] Inic. Browse
	.T.)          // [16] Virtual

oStruACA:AddField( ;
	'VMAX', ;                // [01] Campo
	'003', ;                // [02] Ordem
	STR0012, ;               // [03] Titulo
	STR0012, ;               // [04] Descricao
	NIL, ;                  // [05] Help
	'GET', ;                // [06] Tipo do campo   COMBO, Get ou CHECK
	'', ; // [07] Picture
	NIL, ;                  // [08] PictVar
	'', ;                  // [09] F3
	.F., ;  						// [10] Editavel
	NIL, ;                // [11] Folder
	NIL, ;                // [12] Group
	NIL, ;                // [13] Lista Combo
	0, ;                  // [14] Tam Max Combo
	'', ;                // [15] Inic. Browse
	.T.)                 // [16] Virtual

oView:SetModel( oModel )

oView:AddField( 'VIEW_ADY', oStruADY, 'ADYMASTER' )
oView:AddGrid( 'VIEW_ACA', oStruACA, 'ACAGRID' )
oView:AddGrid( 'VIEW_ADZ', oStruADZ, 'ADZGRID' )

oView:CreateHorizontalBox( 'BOX_ADY', 20 )
oView:CreateHorizontalBox( 'BOX_ACA', 10 )
oView:CreateHorizontalBox( 'BOX_ADZ', 70 )

oView:SetOwnerView( 'VIEW_ADY', 'BOX_ADY' )
oView:SetOwnerView( 'VIEW_ACA', 'BOX_ACA' )
oView:SetOwnerView( 'VIEW_ADZ', 'BOX_ADZ' )

oView:EnableTitleView( 'VIEW_ADY', STR0006 ) // "Analise os descontos ou acréscimos concedidos nesta proposta"
oView:EnableTitleView( 'VIEW_ACA' )
oView:EnableTitleView( 'VIEW_ADZ', STR0005 ) // "Itens desta proposta"

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
Local oModelADY
Local cParams := ''
Local cStatus
Local aUser

If oModel:GetOperation() == MODEL_OPERATION_UPDATE

	oModelADY := oModel:GetModel( 'ADYMASTER' )
	
	cStatus := oModelADY:GetValue( 'ADY_STATUS' )
	
	If  cStatus $ '12'
		lOk := .T.
		
		aUser := FWSFLoadUser(oModel:GetWKUserEmail())
		
		If !Empty(aUser)
			cParams := aUser[2]
		EndIf

		cParams += '|' + If(cStatus == '1', 'S', 'N') 
		
		BEGIN TRANSACTION
			A600ATProp(Trim(oModelADY:GetValue( 'ADY_PROPOS' )), cParams, oModel:GetWKNumProces())
		END TRANSACTION
		
	Else
		oModel:SetErrorMessage( , , , , , STR0013) // "Status inválido"
	EndIf
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

@author	Serviços - Inovação
@since		26/09/2014
@version	12.0               
/*/
//------------------------------------------------------------------------------

Static Function DefStrModel( cAlias, aFields, aRequired )
Local nI
Local aArea		:= GetArea()
Local aAreaSX3	:= SX2->( GetArea() )
Local aAreaSIX	:= SX3->( GetArea() )
Local aAreaSX2	:= SIX->( GetArea() )
Local bValid	:= {|| .T.}
Local bWhen		:= {|| .T.}
Local bRelac	:= NIL
Local cType
Local nSize
Local nDecimal
Local cX2Nome	:= ""
Local cX2Chave	:= ""
Local cX2Unico	:= ""
Local aSX2Info	:= {}

DEFAULT aRequired := {}

oStruct := FWFormModelStruct():New()

//-------------------------------------------------------------------
// Tabela
//-------------------------------------------------------------------
aSX2Info    := FwSX2Util():GetSX2Data(cAlias /*cAlias*/, {"X2_CHAVE","X2_UNICO"} /*aFields*/, /*lQuery*/)
cX2Nome		:= FwSX2Util():GetX2Name(cAlias, /*lSeekByFile*/)
cX2Chave	:= aSX2Info[01,02]
cX2Unico	:= aSX2Info[02,02]

If Empty(cX2Unico)
	SIX->( dbSetOrder( 1 ) )
	SIX->( dbSeek( cAlias ) )
	oStruct:AddTable(cX2Nome,;							// [01] Alias da tabela
	                 StrTokArr(SIX->CHAVE, '+'),;		// [02] Array com os campos que correspondem a primary key
	                 cX2Chave)							// [03] Descrição da tabela
Else
	oStruct:AddTable(cX2Nome,;							// [01] Alias da tabela
	                 StrTokArr(cX2Unico, '+'),;			// [02] Array com os campos que correspondem a primary key
	                 cX2Chave)							// [03] Descrição da tabela
EndIf
//-------------------------------------------------------------------
// Campos
//-------------------------------------------------------------------
SX3->( dbSetOrder( 2 ) )
For nI := 1 To Len(aFields)
	If SX3->( dbSeek( aFields[nI] ) )

		If aFields[nI] $ 'ADZ_TOTAL|ADZ_PRCVEN|ADZ_PRCTAB'
			cType := 'C'
			nSize := 14
			nDecimal := 0
		Else
			cType := SX3->X3_TIPO
			nSize := SX3->X3_TAMANHO
			nDecimal := SX3->X3_DECIMAL
		EndIf

		oStruct:AddField(AllTrim(X3Titulo()),;							// [01] Titulo do campo
		                 AllTrim(X3Descric()),;							// [02] ToolTip do campo
		                 AllTrim(aFields[nI]),;							// [03] Id do Field
		                 cType,;										// [04] Tipo do campo
		                 nSize,;										// [05] Tamanho do campo
		                 nDecimal,;										// [06] Decimal do campo
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

		ElseIf aFields[nJ] == 'ADY_STATUS'
			Aadd(aCombo,'1=' + STR0008) //"Aprovada"
			Aadd(aCombo,'2=' + STR0007)	//"Reprovada"
		EndIf

		bPictVar := FwBuildFeature( STRUCT_FEATURE_PICTVAR, SX3->X3_PICTVAR )

		cGSC     := IIf( Empty( X3Cbox() ) , IIf( SX3->X3_TIPO == 'L', 'CHECK', 'GET' ) , 'COMBO' )

		oStruct:AddField( ;
		AllTrim( SX3->X3_CAMPO  )    , ;                // [01] Campo
		StrZero(nJ,3)                , ;                // [02] Ordem
		AllTrim( X3Titulo()  )       , ;                // [03] Titulo
		AllTrim( X3Descric() )       , ;                // [04] Descricao
		NIL                          , ;                // [05] Help
		cGSC                         , ;                // [06] Tipo do campo   COMBO, Get ou CHECK
		SX3->X3_PICTURE              , ;                // [07] Picture
		bPictVar                     , ;                // [08] PictVar
		SX3->X3_F3                   , ;                // [09] F3
		Ascan(aEditable, AllTrim( SX3->X3_CAMPO  )) > 0, ;  // [10] Editavel
		NIL               , ;                // [11] Folder
		NIL               , ;                // [12] Group
		aCombo                       , ;                // [13] Lista Combo
		nMaxLenCb                    , ;                // [14] Tam Max Combo
		SX3->X3_INIBRW               , ;                // [15] Inic. Browse
		( SX3->X3_CONTEXT == 'V' )     )                // [16] Virtual

	EndIf
Next

RestArea( aAreaSX3 )
RestArea( aArea )

Return oStruct
