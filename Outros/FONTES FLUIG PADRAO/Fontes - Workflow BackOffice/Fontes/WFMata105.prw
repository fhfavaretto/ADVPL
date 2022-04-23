#include "WFMATA105.CH"
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

Static aWF1 := {}
Static aWF2 := {}
Static aWF3 := {}

User Function WFMATA105()
Local oBrowse := nil
oBrowse := FWMBrowse():New()
oBrowse:setAlias("SCR")
oBrowse:SetDescription(STR0001)//"Aprovação Solicitação de Armazem"
oBrowse:Activate()	
Return

/*/{Protheus.doc} MenuDef
Menu de operações disponiveis na browse 
@author taniel.silva
@since 19/03/2014
@version 1.0
/*/ 
Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE STR0002 ACTION 'VIEWDEF.WFMATA105' OPERATION 2 ACCESS 0//'Visualizar'
ADD OPTION aRotina TITLE STR0003 ACTION 'VIEWDEF.WFMATA105' OPERATION 3 ACCESS 0//'Incluir'
ADD OPTION aRotina TITLE STR0004 ACTION 'VIEWDEF.WFMATA105' OPERATION 4 ACCESS 0//'Alterar'
ADD OPTION aRotina TITLE STR0005 ACTION 'VIEWDEF.WFMATA105' OPERATION 5 ACCESS 0//'Excluir'

Return aRotina

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author guilherme.pimentel

@since 30/09/2015
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
Local oModel 	:= Nil
Local oStru1 	:= FWFormModelStruct():New()
Local oStru2 	:= FWFormModelStruct():New()
Local oStru3 	:= FWFormModelStruct():New()

Local nTamCC		:= 0
Local nTamCCont	:= 0
Local nTamIC		:= 0
Local nTamCV		:= 0
Local nTamFil		:= 0

oStru1:AddTable("   ",{" "}," ")
oStru2:AddTable("   ",{" "}," ")
oStru3:AddTable("   ",{" "}," ")

// -----------------------------------------------------------------------
// ESTRUTURA DO ARRAY
// --> [01] - campo, [02] - tipo, [03] - tamanho, [04] mascara, [05] - descrição, [06] - titulo, [07] - combo, [08] - consulta padrão, [09] - bWhen, [10] - bValid, [11] bInit
// -----------------------------------------------------------------------

// -----------------------------------------------------------------------
// GERAÇÃO DA PRIMEIRA ESTRUTURA
// -----------------------------------------------------------------------
If Empty(aWF1)
	aAdd( aWF1,{'WF1_PAREC'	,'M' , 50 , '@!'	,STR0007	,STR0007	,{}			, NIL, Nil, Nil, Nil, 0   } )//'Parecer'
EndIf

WF105Model(aWF1,"STRU1_",oStru1)

// -----------------------------------------------------------------------
// GERAÇÃO DA SEGUNDA ESTRUTURA
// -----------------------------------------------------------------------
If Empty(aWF2)
	nTamFil := TamSX3("CP_FILIAL")[1]+43 // XX8_DESCRI + 3 (" - ")
	aAdd( aWF2,{'WF2_FILIAL'	,'C',nTamFil					,'@!'							,STR0008	,STR0008 ,NIL	,NIL ,NIL, NIL ,NIL, 0   						} )//'Empresa'
	aAdd( aWF2,{'WF2_DOC'	,'C',TAMSX3("CP_NUM")[1]		,'@!'							,STR0009	,STR0009 ,NIL	,NIL ,NIL, NIL ,NIL, 0   						} )//'Documento'
	aAdd( aWF2,{'WF2_EMIS'	,'D',8 						,''								,STR0010	,STR0010 ,NIL	,NIL ,NIL, NIL ,NIL, 0   						} )//'Emissao'
	aAdd( aWF2,{'WF2_SOLIC'	,'C',TAMSX3("CP_SOLICIT")[1],'@!'							,STR0011 	,STR0011 ,NIL	,NIL ,NIL, NIL ,NIL, 0   						} )//'Solicitante'
	aAdd( aWF2,{'WF2_VLTOT'	,'N',TAMSX3("CR_TOTAL")[1]	,PesqPict("SCR","CR_TOTAL")	,STR0012	,STR0012 ,NIL	,NIL ,NIL, NIL ,NIL, TAMSX3("CR_TOTAL")[2]	} )//'Vl.Total'
	aAdd( aWF2,{'WF2_LOGAPR'	,'M',254						,'@!'							,STR0029	,STR0029	,{}	,NIL ,NIL, NIL ,NIL, 0   						} ) // 'Histórico Niv.Anterior'
EndIf

WF105Model(aWF2,"STRU2_",oStru2)

// -----------------------------------------------------------------------
// GERAÇÃO DA TERCEIRA ESTRUTURA
// -----------------------------------------------------------------------
If Empty(aWF3)
	nTamCC		:= TamSX3("CTT_CUSTO")[1]+TamSX3("CTT_DESC01")[1]+3
	nTamCCont	:= TamSX3("CT1_CONTA")[1]+TamSX3("CT1_DESC01")[1]+3
	nTamIC		:= TamSX3("CTD_ITEM")[1]+TamSX3("CTD_DESC01")[1]+3
	nTamCV		:= TamSX3("CTH_CLVL")[1]+TamSX3("CTH_DESC01")[1]+3
	aAdd( aWF3,{'WF3_ITEM'	,'C',TAMSX3("CP_ITEM")[1]	,'@!'							,STR0013	,STR0013	,NIL	,NIL ,NIL ,NIL ,NIL, 0   						} )//'Item'
	aAdd( aWF3,{'WF3_PROD'	,'C',TAMSX3("CP_PRODUTO")[1],'@!'							,STR0014	,STR0014	,NIL 	,NIL ,NIL ,NIL ,NIL, 0   						} )//'Produto'
	aAdd( aWF3,{'WF3_DESPRD'	,'C',TAMSX3("CP_DESCRI")[1]	,'@!'							,STR0015	,STR0015	,NIL  	,NIL ,NIL ,NIL ,NIL, 0   						} )//'Descricao'
	aAdd( aWF3,{'WF3_QUANT'	,'N',TAMSX3("CP_QUANT")[1]	,PesqPict("SCP","CP_QUANT")	,STR0016	,STR0016	,NIL  	,NIL ,NIL ,NIL ,NIL, TAMSX3("CP_QUANT")[2]   	} )//'Quantidade'
	aAdd( aWF3,{'WF3_DTNES'	,'D',08						,''								,STR0017	,STR0017	,NIL  	,NIL ,NIL ,NIL ,NIL, 0   						} )//'Dt.Necess'
	aAdd( aWF3,{'WF3_LOCAL'	,'C',TAMSX3("CP_LOCAL")[1]	,'@!'							,STR0018	,STR0018	,NIL  	,NIL ,NIL ,NIL ,NIL, 0   						} )//'Armazem'
	aAdd( aWF3,{'WF3_CC'		,'C',nTamCC					,'@!'							,STR0019	,STR0019	,NIL  	,NIL ,NIL ,NIL ,NIL, 0   						} )//'C. Custo'
	aAdd( aWF3,{'WF3_CCONT'	,'C',nTamCCont				,'@!'							,STR0020 	,STR0020	,NIL  	,NIL ,NIL ,NIL ,NIL, 0   						} )//'C.Contabil'
	aAdd( aWF3,{'WF3_IC'		,'C',nTamIC					,'@!'							,STR0021	,STR0021	,NIL  	,NIL ,NIL ,NIL ,NIL, 0   						} )//'It.Contab.'
	aAdd( aWF3,{'WF3_CV'		,'C',nTamCV					,'@!'							,STR0022	,STR0022	,NIL  	,NIL ,NIL ,NIL ,NIL, 0   						} )//'C. Valor'
	aAdd( aWF3,{'WF3_OBS'	,'C',TAMSX3("CP_OBS")[1]		,'@!'							,STR0023	,STR0023	,NIL  	,NIL ,NIL ,NIL ,NIL, 0   						} )//'Observacao'
EndIf

WF105Model(aWF3,"STRU3_",oStru3)

// -----------------------------------------------------------------------
// Construção do modelo
// -----------------------------------------------------------------------
oModel := FWLoadModel("WFLIBDOC")

// -----------------------------------------------------------------------
// Adiciona ao modelo uma estrutura de formulário de edição por campo
// -----------------------------------------------------------------------
oModel:AddFields( 'WF1MASTER', 'SCRMASTER', oStru1, /*bPreValidacao*/, /*bPosValidacao*/, {||WF105Load1()})
oModel:AddFields( 'WF2DETAIL', 'WF1MASTER', oStru2, /*bPreValidacao*/, /*bPosValidacao*/, {||WF105Load2()})
oModel:AddGrid(   'WF3DETAIL', 'WF2DETAIL', oStru3, /* bLinePre*/		, /* bLinePost */ , /* bPre*/	, /* bLinePost */ , {||WF105Load3()})

// -----------------------------------------------------------------------
// Adiciona a descricao do Modelo de Dados
// -----------------------------------------------------------------------
oModel:SetDescription( STR0024 )//'Workflow de Solicitação ao Armazém'

// -----------------------------------------------------------------------
// Adiciona a descricao do Componente do Modelo de Dados
// -----------------------------------------------------------------------
oModel:GetModel( 'WF1MASTER' ):SetDescription( STR0025 )//'Decisão'
oModel:GetModel( 'WF2DETAIL' ):SetDescription( STR0028 )//'Informações do Documento'
oModel:GetModel( 'WF3DETAIL' ):SetDescription( STR0026 )//'Itens'

oModel:GetModel("WF1MASTER"):SetOnlyQuery(.T.)
oModel:GetModel("WF2DETAIL"):SetOnlyQuery(.T.)
oModel:GetModel("WF3DETAIL"):SetOnlyQuery(.T.)


// -----------------------------------------------------------------------
// Adiciona a descricao do Componente do Modelo de Dados
// -----------------------------------------------------------------------
oModel:GetModel( 'WF3DETAIL' ):SetOptional(.T.)

// -----------------------------------------------------------------------
// Impede a exclusão de novas linhas
// -----------------------------------------------------------------------
oModel:GetModel("WF3DETAIL"):SetNoDeleteLine(.T.)

Return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} WF105Model
Função para adicionar dinamicamente os campos na estrutura

@param aCampos Estrutura dos campos que serão adicionados
@param cStru Descrição da estrutura onde os campos serão adicionados
@param oStru Objeto referente a estrutura

@author guilherme.pimentel

@since 30/09/2015
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function WF105Model(aCampos,cStru,oStru)
Local nCampo := 1
Local cCampo := ''

For nCampo := 1 To Len(aCampos)
	//cCampo := cStru + aCampos[nCampo][01]
	//-- Adiciona campos header do filtro de busca de fornecedor 
	oStru:AddField(aCampos[nCampo][05]		,;	// 	[01]  C   Titulo do campo
				 	aCampos[nCampo][06]		,;	// 	[02]  C   ToolTip do campo
				 	aCampos[nCampo][01]		,;	// 	[03]  C   Id do Field
				 	aCampos[nCampo][02]		,;	// 	[04]  C   Tipo do campo
				 	aCampos[nCampo][03]		,;	// 	[05]  N   Tamanho do campo
				 	aCampos[nCampo][12]		,;	// 	[06]  N   Decimal do campo
				 	aCampos[nCampo][10]		,;	// 	[07]  B   Code-block de validação do campo
				 	aCampos[nCampo][09]		,;	// 	[08]  B   Code-block de validação When do campo
				 	aCampos[nCampo][07]		,;	//	[09]  A   Lista de valores permitido do campo
				 	.F.						,;	//	[10]  L   Indica se o campo tem preenchimento obrigatório
				 	aCampos[nCampo][11]		,;	//	[11]  B   Code-block de inicializacao do campo
				 	NIL						,;	//	[12]  L   Indica se trata-se de um campo chave
				 	.F.						,;	//	[13]  L   Indica se o campo pode receber valor em uma operação de update.
				 	.F.						)	// 	[14]  L   Indica se o campo é virtual
Next nCampo

Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author jose.eulalio

@since 01/04/2014
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
Local oModel	:= ModelDef()
Local oView
// Cria a estrutura a ser usada na View
Local oStru1	:= FWFormViewStruct():New()
Local oStru2	:= FWFormViewStruct():New()
Local oStru3	:= FWFormViewStruct():New()
Local nCampo  := 0

WF105View(aWF1,'WF1_',oStru1)
WF105View(aWF2,'WF2_',oStru2)
WF105View(aWF3,'WF3_',oStru3)

// -----------------------------------------------------------------------
// Monta o modelo da interface do formulario
// -----------------------------------------------------------------------
oView := FWLoadView("WFLIBDOC")

// -----------------------------------------------------------------------
// Define qual o Modelo de dados será utilizado
// -----------------------------------------------------------------------
oView:SetModel(oModel)

oView:AddField('VIEW_WF1', oStru1	,'WF1MASTER')
oView:AddField('VIEW_WF2', oStru2	,'WF2DETAIL')
oView:AddGrid( 'VIEW_WF3', oStru3	,'WF3DETAIL')

oView:CreateHorizontalBox( 'WF1' ,29 )
oView:CreateHorizontalBox( 'WF2' ,30 )
oView:CreateHorizontalBox( 'WF3' ,40 )

oView:SetOwnerView('VIEW_WF1','WF1')
oView:SetOwnerView('VIEW_WF2','WF2')
oView:SetOwnerView('VIEW_WF3','WF3')
// -----------------------------------------------------------------------
// Adiciona a descricao do Componente do Modelo de Dados
// -----------------------------------------------------------------------
oModel:GetModel( 'SCRMASTER' ):SetDescription( STR0027 )//'Alçada'
oModel:GetModel( 'WF1MASTER' ):SetDescription( STR0025 )//'Decisão'
oModel:GetModel( 'WF2DETAIL' ):SetDescription( STR0028 )//'Informações do Documento'
oModel:GetModel( 'WF3DETAIL' ):SetDescription( STR0026 )//'Itens'

oView:EnableTitleView('VIEW_WF1' , STR0025 )//'Decisão'
oView:EnableTitleView('VIEW_WF2' , STR0028 )//'Informações do Documento'
oView:EnableTitleView('VIEW_WF3' , STR0026 )//'Itens'

aWF1 := {}
aWF2 := {}
aWF3 := {}

Return oView 

//-------------------------------------------------------------------
/*/{Protheus.doc} WF105View
Função para adicionar dinamicamente os campos na view

@param aCampos Estrutura dos campos que serão adicionados
@param cStru Descrição da estrutura onde os campos serão adicionados
@param oStru Objeto referente a estrutura

@author guilherme.pimentel

@since 30/09/2015
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function WF105View(aCampos,cStru,oStru)
Local nCampo := 0
Local cCampo := ''
Local lAltCampo 	:= .T.

For nCampo := 1 To Len(aCampos)
	//--> [01] - campo, [02] - tipo, [03] - tamanho, [04] mascara, [05] - descrição, [06] - titulo, [07] - combo, [08] - consulta padrão, [09] - bWhen, [10] - bValid, [11] bInit
	//cCampo := cStru + aCampos[nCampo][01]
	lAltCampo := Iif(aCampos[nCampo,1] $ 'WF1_PAREC|WF1_SITUAC',.T.,.F.)
	cOrdem := StrZero(nCampo,2)
	//-- Adiciona campos header do filtro de busca de fornecedor 
	oStru:AddField(aCampos[nCampo][01]		,;	// [01]  C   Nome do Campo
					cOrdem						,;	// [02]  C   Ordem
					aCampos[nCampo][05] 		,;	// [03]  C   Titulo do campo
					aCampos[nCampo][06] 		,;	// [04]  C   Descricao do campo
					{}							,;	// [05]  A   Array com Help
					aCampos[nCampo][02]		,;	// [06]  C   Tipo do campo
					aCampos[nCampo][04]		,;	// [07]  C   Picture
					NIL							,;	// [08]  B   Bloco de Picture Var
					aCampos[nCampo][08]		,;	// [09]  C   Consulta F3
					lAltCampo					,;	// [10]  L   Indica se o campo é alteravel
					NIL							,;	// [11]  C   Pasta do campo
					NIL							,;	// [12]  C   Agrupamento do campo
					aCampos[nCampo][07]		,;	// [13]  A   Lista de valores permitido do campo (Combo)
					2							,;	// [14]  N   Tamanho maximo da maior opção do combo
					NIL							,;	// [15]  C   Inicializador de Browse
					.F.							,;	// [16]  L   Indica se o campo é virtual
					NIL							,;	// [17]  C   Picture Variavel
					.F.							)	// [18]  L   Indica pulo de linha após o campo
Next nCampo

Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} WF105Load1
Load do Modelo temporário WF1 

@author guilherme.pimentel

@since 01/10/2015
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function WF105Load1()
Return {{""},0}

//-------------------------------------------------------------------
/*/{Protheus.doc} WF105Load2
Load do Modelo temporário WF2 

@author guilherme.pimentel

@since 01/10/2015
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function WF105Load2()
Local aAux 	:= {}
Local aLoad 	:= {}
Local cLogApr	:= WF105LogApr()

//Posiciona solicitação
dbSelectArea("SCP")
SCP->(dbSetOrder(1))
SCP->(dbSeek(xFilial("SCP")+Substr(SCR->CR_NUM,1,TamSX3("CP_NUM")[1])))

Aadd(aAux,SCP->CP_FILIAL+Iif(FWModeAccess("SCP")=="C",""," - "+FWFilialName(,SCP->CP_FILIAL)))//xFilial()+' - '+FWFilialName(,xFilial()) )
Aadd(aAux,SCP->CP_NUM)
Aadd(aAux,SCP->CP_EMISSAO)
Aadd(aAux,SCP->CP_SOLICIT)
Aadd(aAux,SCR->CR_TOTAL)
aAdd(aAux,cLogApr)

aLoad := {aAux,0}

Return aLoad

//--------------------------------------------------------------------
/*/{Protheus.doc} WF105Load3(oModel)
Carregar modelo com os documentos com alcadas
@author José Eulálio
@since 10/04/2014
@version 1.0
@return aLoad
/*/
//--------------------------------------------------------------------
Static Function WF105Load3()
Local cNum			:= ""
Local cEmissao	:= ""
Local cTipo		:= ""
Local cGrupo		:= ""
Local cItGrp		:= ""
Local cUser		:= ""
Local cUserOri	:= ""
Local cTipo		:= 'SA'
Local cNumSCP		:= SCP->CP_NUM
Local nI			:= 0

Local lAprSCEC	:= SuperGetMv("MV_APRSAEC",.F.,.F.)

Local oModel  	:= FWLoadModel('WFMATA105')
Local oModelWF3	:= oModel:GetModel('WF3DETAIL')
Local aStruct		:= {}	
Local aLoad 		:= {}
local aAux  		:= {}

// -----------------------------------------------------------------------
// Query que retorna valores para Grid da SCP, levando em conta o Rateio e aprovadores
// -----------------------------------------------------------------------
If lAprSCEC

	BeginSQL Alias "LOADTMP"
		SELECT SCP.CP_NUM,
			SCP.CP_ITEM CP_ITEM,
	    	SCP.CP_PRODUTO CP_PRODUTO,
	    	SCP.CP_DESCRI CP_DESCRI,
	    	SCP.CP_QUANT * (ISNULL(SGS.GS_PERC,100) / 100) CP_QUANT,
	    	SCP.CP_DATPRF CP_DATPRF,
	    	SCP.CP_LOCAL CP_LOCAL,
	    	ISNULL(SGS.GS_CC,SCP.CP_CC) CP_CC,
	    	ISNULL(SGS.GS_CONTA,SCP.CP_CONTA) CP_CONTA,
	    	ISNULL(SGS.GS_ITEMCTA,SCP.CP_ITEMCTA) CP_ITEMCTA,
	    	ISNULL(SGS.GS_CLVL,SCP.CP_CLVL) CP_CLVL,
	    	SCP.CP_OBS CP_OBS,
	    	SCP.R_E_C_N_O_
		FROM %Table:DBM% DBM //Atualizar tabela
		JOIN %Table:SCP% SCP ON //Atualizar tabela
		    SCP.%NotDel% AND
		    SCP.CP_FILIAL = %xFilial:SCP% AND
		    SCP.CP_NUM = DBM.DBM_NUM AND
		    SCP.CP_ITEM = DBM.DBM_ITEM
		LEFT JOIN %Table:SGS% SGS ON //Atualizar tabela
		    SGS.%NotDel% AND
		    SGS.GS_FILIAL = %xFilial:SGS% AND
		    SGS.GS_SOLICIT = SCP.CP_NUM AND
		    SGS.GS_ITEMSOL = SCP.CP_ITEM AND
		    SGS.GS_ITEM = DBM.DBM_ITEMRA
		WHERE DBM.%NotDel% AND
		    DBM.DBM_FILIAL = %xFilial:DBM% AND
		    DBM.DBM_TIPO = %Exp:SCR->CR_TIPO% AND
		    DBM.DBM_NUM = %Exp:SCR->CR_NUM% AND
		    DBM.DBM_GRUPO = %Exp:SCR->CR_GRUPO% AND
		    DBM.DBM_ITGRP = %Exp:SCR->CR_ITGRP% AND
		    DBM.DBM_USER = %Exp:SCR->CR_USER% AND
		    DBM.DBM_USEROR = %Exp:SCR->CR_USERORI%
		ORDER BY
			SCP.CP_ITEM 
	EndSQL
	
Else
	
	BeginSQL Alias "LOADTMP"
	SELECT SCP.CP_NUM,
		SCP.CP_ITEM CP_ITEM,
	    SCP.CP_PRODUTO CP_PRODUTO,
	    SCP.CP_DESCRI CP_DESCRI,
	    SCP.CP_QUANT  CP_QUANT,
	    SCP.CP_DATPRF CP_DATPRF,
	    SCP.CP_LOCAL CP_LOCAL,
	    ISNULL(SGS.GS_CC,SCP.CP_CC) CP_CC,
	    ISNULL(SGS.GS_CONTA,SCP.CP_CONTA) CP_CONTA,
	    ISNULL(SGS.GS_ITEMCTA,SCP.CP_ITEMCTA) CP_ITEMCTA,
	    ISNULL(SGS.GS_CLVL,SCP.CP_CLVL) CP_CLVL,
	    SCP.CP_OBS CP_OBS,
	    SCP.R_E_C_N_O_
	FROM %Table:SCP% SCP //Atualizar tabela
	LEFT JOIN %Table:SGS% SGS ON //Atualizar tabela
	    SGS.%NotDel% AND
	    SGS.GS_FILIAL = %xFilial:SGS% AND
	    SGS.GS_SOLICIT = SCP.CP_NUM AND
	    SGS.GS_ITEMSOL = SCP.CP_ITEM 
	WHERE SCP.%NotDel% AND
		SCP.CP_FILIAL = %xFilial:SCP% AND
		SCP.CP_NUM = %Exp:cNumSCP%
	ORDER BY SCP.CP_NUM,
		SCP.CP_ITEM	
	EndSQL

EndIf

TCSetField("LOADTMP","CP_DATPRF","D",8,0)

// -----------------------------------------------------------------------
// De/para entre os campos do Select e os que estão no modelo
// -----------------------------------------------------------------------
aAdd(aStruct,"CP_ITEM")
aAdd(aStruct,"CP_PRODUTO")
aAdd(aStruct,"CP_DESCRI")
aAdd(aStruct,"CP_QUANT")
aAdd(aStruct,"CP_DATPRF")
aAdd(aStruct,"CP_LOCAL")
aAdd(aStruct,"CP_CC")
aAdd(aStruct,"CP_CONTA")
aAdd(aStruct,"CP_ITEMCTA")
aAdd(aStruct,"CP_CLVL")
aAdd(aStruct,"CP_OBS")

// -----------------------------------------------------------------------
// Popula modelo SCPDETAIL com os valores da query
// -----------------------------------------------------------------------
While !LOADTMP->(EOF())
	aAux := {}
	cNum	:= AllTrim(LOADTMP->CP_NUM)  
	cItem	:= AllTrim(LOADTMP->CP_ITEM)	
		
   If SCP->(dbSeek(xFilial("SCP")+ cNum + cItem ) )		
		For nI := 1 To Len(aStruct)
			If aStruct[nI] $ "CP_CC|CP_CONTA|CP_ITEMCTA|CP_CLVL" .And. aStruct[nI] <> 'CP_ITEM'
				Aadd( aAux, Rtrim(LOADTMP->(&(aStruct[nI]))) + WF105Descr(aStruct[nI],LOADTMP->(&(aStruct[nI]))) )		
			Else
				Aadd( aAux, LOADTMP->(&(aStruct[nI])))
			Endif
		Next nI
				
		aAdd(aLoad,{LOADTMP->R_E_C_N_O_,aClone(aAux)})
	EndIf		
	LOADTMP->(DbSkip())
End
   
LOADTMP->(dbCloseArea())

Return aLoad

//-------------------------------------------------------------------
/*/{Protheus.doc} WF105Descr
Função que retorna a descrição dos campos de conta contabil 

@author Rafael Duram Santos
@since 19/11/2015
@version 1.0
/*/
//-------------------------------------------------------------------

Static function WF105Descr(cCampo,cChave)
Local aArea	:= GetArea()
Local cDescr	:= ""

If !Empty(cChave)
	cDescr += " - "
	If cCampo == "CP_CC" //CTT
		cDescr += Posicione("CTT",1,xFilial("CTT")+cChave,"CTT_DESC01")
	Elseif cCampo == "CP_CONTA" //CT1
		cDescr += Posicione("CT1",1,xFilial("CT1")+cChave,"CT1_DESC01")
	Elseif cCampo == "CP_ITEMCTA" //CTD
		cDescr += Posicione("CTD",1,xFilial("CTD")+cChave,"CTD_DESC01")
	Elseif cCampo == "CP_CLVL" //CTH
		cDescr += Posicione("CTH",1,xFilial("CTH")+cChave,"CTH_DESC01")
	Endif
Endif

RestArea(aArea)

Return Rtrim(cDescr)


//-------------------------------------------------------------------
/*/{Protheus.doc} WF105LogApr()
Função que retorna o histórico de aprovação da SCR

@author rafael.duram
@since 04/08/2016
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function WF105LogApr()
Local aArea		:= GetArea()
Local aAreaSCR	:= SCR->(GetArea())
Local aAreaSAL	:= SAL->(GetArea())
Local aSaveLines	:= FwSaveRows()

Local cDoc 		:= SCR->CR_NUM
Local cNivel 		:= SCR->CR_NIVEL
Local cTmpAlias	:= GetNextAlias()
Local cRet			:= ""


//Query que retorna as aprovações referentes aos níveis anteriores ao atual
BeginSQL Alias cTmpAlias
	SELECT	SCR.CR_NUM		CR_NUM,
			SCR.CR_NIVEL	CR_NIVEL,
			SCR.CR_USER		CR_USER,
			SCR.CR_DATALIB	CR_DATALIB,
	   		SCR.CR_STATUS	CR_STATUS,
	   		SCR.CR_GRUPO	CR_GRUPO,
	   		SCR.R_E_C_N_O_	RECSCR

	FROM 	%Table:SCR% SCR

	WHERE	SCR.%NotDel% AND
			SCR.CR_FILIAL = %xFilial:SCR% AND
			SCR.CR_NUM 	= %Exp:cDoc% AND
			SCR.CR_NIVEL 	< %Exp:cNivel%

	ORDER BY SCR.CR_NUM, SCR.CR_NIVEL
EndSQL

TCSetField(cTmpAlias,"CR_DATALIB","D",8,0)

//- Monta estrutura do log de aprovação
While !(cTmpAlias)->(EOF())
	cRet += 	AllTrim((cTmpAlias)->CR_GRUPO)	+' - '+	AllTrim(Posicione("SAL",1,xFilial("SAL")+(cTmpAlias)->CR_GRUPO,"AL_DESC"))	+' | '
	cRet += 	AllTrim((cTmpAlias)->CR_NIVEL)	+' | '
	cRet += 	AllTrim((cTmpAlias)->CR_USER)	+' - '+	AllTrim(UsrFullName((cTmpAlias)->CR_USER))	+' | '
	cRet +=	AllTrim(x3CboxToArray("CR_STATUS")[1][Val((cTmpAlias)->CR_STATUS)])	+' | '
	cRet += 	Alltrim(DToc((cTmpAlias)->CR_DATALIB))

	//- Posiciona na tabela fisica para obter valor do Memo Observação
	SCR->(MsGoto((cTmpAlias)->RECSCR))
	If !Empty(SCR->CR_OBS)
		cRet +=	CRLF + 'Obs: ' + AllTrim(SCR->CR_OBS) + CRLF
	EndIf

	cRet +=	CRLF
	(cTmpAlias)->( DbSkip() )
End

(cTmpAlias)->( DbCloseArea() )

FWRestRows(aSaveLines)
RestArea(aAreaSAL)
RestArea(aAreaSCR)
RestArea(aArea)
Return cRet

