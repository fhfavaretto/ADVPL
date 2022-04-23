#include "WFMATA311.CH"
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

Static aWF1 := {}
Static aWF2 := {}
Static aWF3 := {}

//-------------------------------------------------------------------
/*/{Protheus.doc} MATA311
Solicitação de transferência 
@author taniel.silva
@since 04/04/2014
@version 1.0
/*/ 
//-------------------------------------------------------------------
User Function WFMATA311()
Local oBrowse := nil

oBrowse := FWMBrowse():New()
oBrowse:SetAlias('SCR')
oBrowse:SetDescription(STR0001)//"Aprovação Solicitação de Transferência"
oBrowse:Activate()

Return NIL

//-------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
Definição do menu
@author antenor.silva
@since 22/01/2014
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE STR0002	ACTION "VIEWDEF.WFMATA311"	OPERATION 3  	ACCESS 0  	//'Incluir'
ADD OPTION aRotina TITLE STR0003 	ACTION "VIEWDEF.WFMATA311"	OPERATION 2	ACCESS 0  	//'Visualizar'
ADD OPTION aRotina TITLE STR0004	ACTION "VIEWDEF.WFMATA311"	OPERATION 4 	ACCESS 0  	//'Alterar'
ADD OPTION aRotina TITLE STR0005 	ACTION "VIEWDEF.WFMATA311"	OPERATION 5  	ACCESS 3	//'Excluir'

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
Local bWhenTrue := { || .T. }

Local nTamFilial	:= 0

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
	aAdd( aWF1,{'WF1_PAREC'	,'M' , 50 , '@!'	,STR0007	,STR0007	,{}			, NIL, bWhenTrue, Nil, Nil, 0  } )//'Parecer'
EndIf

WF311Model(aWF1,"STRU1_",oStru1)

// -----------------------------------------------------------------------
// GERAÇÃO DA SEGUNDA ESTRUTURA
// -----------------------------------------------------------------------
If Empty(aWF2)
	nTamFilial := TamSX3("NNS_FILIAL")[1]+43 // XX8_DESCRI + 3 (" - ")
	aAdd( aWF2,{'WF2_FILIAL'	,'C',nTamFilial				,'@!'		,STR0008 ,STR0008	,{}						,NIL ,bWhenTrue, NIL ,NIL, 0   	} )//'Empresa'
	aAdd( aWF2,{'WF2_DOC'	,'C',TAMSX3("NNS_COD")[1]	,'@!'		,STR0009 ,STR0009	,{}						,NIL ,bWhenTrue, NIL ,NIL, 0   	} )//'Documento'
	aAdd( aWF2,{'WF2_DATA'	,'D',8 						,''			,STR0010 ,STR0010	,{}						,NIL ,bWhenTrue, NIL ,NIL, 0   	} )//'Data'
	aAdd( aWF2,{'WF2_SOLIC'	,'C',TAMSX3("NNS_SOLICT")[1],'@!'		,STR0011 ,STR0011	,{}						,NIL ,bWhenTrue, NIL ,NIL, 0   	} )//'Solicitante'
	aAdd( aWF2,{'WF2_TPDOC'	,'C',TAMSX3("NNS_CLASS")[1]	,'@!'		,STR0014 ,STR0014	,{STR0012,STR0013 }	,NIL ,bWhenTrue, Nil, Nil, 0  	} )//'1=A Classificar'//'2=Classificado'//'Tp.Doc Entr'
	aAdd( aWF2,{'WF2_LOGAPR'	,'M',254						,'@!'		,STR0030 ,STR0030	,{}						,NIL ,NIL		 , NIL ,NIL, 0  	} ) // 'Histórico Niv.Anterior'
EndIf

WF311Model(aWF2,"STRU2_",oStru2)

// -----------------------------------------------------------------------
// GERAÇÃO DA TERCEIRA ESTRUTURA
// -----------------------------------------------------------------------
If Empty(aWF3)
	nTamFilial := TamSX3("NNT_FILORI")[1]+43 // XX8_DESCRI + 3 (" - ")
	aAdd( aWF3,{'WF3_FILORI'	,'C',nTamFilial				,'@!'							,STR0019	,STR0019	,NIL	,NIL ,bWhenTrue 	,NIL ,NIL, 0   						} )//'Filial Orig'
	aAdd( aWF3,{'WF3_PROD'	,'C',TAMSX3("NNT_PROD")[1]	,'@!'							,STR0015	,STR0015	,NIL	,NIL ,bWhenTrue 	,NIL ,NIL, 0   						} )//'Produto'
	aAdd( aWF3,{'WF3_DESC'	,'C',TAMSX3("NNT_DESC")[1]	,'@!'							,STR0020	,STR0020	,NIL	,NIL ,NIL 			,NIL ,NIL, 0   						} )//'Descricao'
	aAdd( aWF3,{'WF3_LOCAL'	,'C',TAMSX3("NNT_LOCAL")[1]	,'@!'							,STR0016	,STR0016	,NIL	,NIL ,bWhenTrue 	,NIL ,NIL, 0   						} )//'Armaz.Orig'
	aAdd( aWF3,{'WF3_LOCALI'	,'C',TAMSX3("NNT_LOCALI")[1],'@!'							,STR0017	,STR0017	,NIL	,NIL ,bWhenTrue 	,NIL ,NIL, 0   						} )//'Endereco'
	aAdd( aWF3,{'WF3_NSERIE'	,'C',TAMSX3("NNT_NSERIE")[1],'@!'							,STR0021	,STR0021	,NIL	,NIL ,bWhenTrue	,NIL ,NIL, 0   						} )//'N. Serie'
	aAdd( aWF3,{'WF3_NUMLOT'	,'C',TAMSX3("NNT_NUMLOT")[1],'@!'							,STR0022	,STR0022	,NIL	,NIL ,bWhenTrue 	,NIL ,NIL, 0   						} )//'Lote'
	aAdd( aWF3,{'WF3_QUANT'	,'N',TAMSX3("NNT_QUANT")[1]	,PesqPict("NNT","NNT_QUANT"),STR0018	,STR0018	,NIL	,NIL ,bWhenTrue 	,NIL ,NIL, TAMSX3("NNT_QUANT")[2] 	} )//'Quantidade'
	
	aAdd( aWF3,{'WF3_FILDES'	,'C',nTamFilial				,'@!'							,STR0019	,STR0019	,NIL  	,NIL ,bWhenTrue 	,NIL ,NIL, 0   						} )//'Filial Orig'
	aAdd( aWF3,{'WF3_PRODD'	,'C',TAMSX3("NNT_PRODD")[1]	,'@!'							,STR0015	,STR0015	,NIL	,NIL ,bWhenTrue 	,NIL ,NIL, 0   						} )//'Produto'
	aAdd( aWF3,{'WF3_DESCD'	,'C',TAMSX3("NNT_DESCD")[1]	,'@!'							,STR0020	,STR0020	,NIL	,NIL ,NIL 			,NIL ,NIL, 0   						} )//'Descricao'
	aAdd( aWF3,{'WF3_LOCLD'	,'C',TAMSX3("NNT_LOCLD")[1]	,'@!'							,STR0016	,STR0016	,NIL	,NIL ,bWhenTrue 	,NIL ,NIL, 0   						} )//'Armaz.Orig'
	aAdd( aWF3,{'WF3_LOCDES'	,'C',TAMSX3("NNT_LOCDES")[1],'@!'							,STR0017	,STR0017	,NIL	,NIL ,bWhenTrue 	,NIL ,NIL, 0   						} )//'Endereco'
	aAdd( aWF3,{'WF3_SERIE'	,'C',TAMSX3("NNT_SERIE")[1]	,'@!'							,STR0021	,STR0021	,NIL	,NIL ,bWhenTrue 	,NIL ,NIL, 0   						} )//'N. Serie'
	aAdd( aWF3,{'WF3_LOTED'	,'C',TAMSX3("NNT_LOTED")[1]	,'@!'							,STR0022	,STR0022	,NIL	,NIL ,bWhenTrue 	,NIL ,NIL, 0   						} )//'Lote'
	
	aAdd( aWF3,{'WF3_TS'		,'C',TAMSX3("NNT_TS")[1]		,'@!'							,STR0023	,STR0023	,NIL  	,NIL ,bWhenTrue 	,NIL ,NIL, 0   						} )//'TES Saida'
	aAdd( aWF3,{'WF3_TE'		,'C',TAMSX3("NNT_TE")[1]		,'@!'							,STR0024	,STR0024	,NIL  	,NIL ,bWhenTrue 	,NIL ,NIL, 0   						} )//'TES Entrada'
EndIf

WF311Model(aWF3,"STRU3_",oStru3)

// -----------------------------------------------------------------------
// Construção do modelo
// -----------------------------------------------------------------------
oModel := FWLoadModel("WFLIBDOC")

// -----------------------------------------------------------------------
// Adiciona ao modelo uma estrutura de formulário de edição por campo
// -----------------------------------------------------------------------
oModel:AddFields( 'WF1MASTER', 'SCRMASTER', oStru1, /*bPreValidacao*/, /*bPosValidacao*/, {|| WF311Load1() }/*bCarga*/ )
oModel:AddFields( 'WF2DETAIL', 'WF1MASTER', oStru2, /*bPreValidacao*/, /*bPosValidacao*/, {|| WF311Load2() }/*bCarga*/ )
oModel:AddGrid(   'WF3DETAIL', 'WF2DETAIL', oStru3, /* bLinePre*/		, /* bLinePost */ , /* bPre*/	, /* bLinePost */ , {||WF311Load3()})

oModel:GetModel( 'WF1MASTER' ):SetOnlyQuery(.T.)
oModel:GetModel( 'WF2DETAIL' ):SetOnlyQuery(.T.)
oModel:GetModel( 'WF3DETAIL' ):SetOnlyQuery(.T.)

oModel:GetModel( 'WF3DETAIL' ):SetOptional(.T.)

// -----------------------------------------------------------------------
// Adiciona a descricao do Modelo de Dados
// -----------------------------------------------------------------------
oModel:SetDescription( STR0025 )//'Workflow de Transferencia de Materiais'

// -----------------------------------------------------------------------
// Adiciona a descricao do Componente do Modelo de Dados
// -----------------------------------------------------------------------
oModel:GetModel( 'WF1MASTER' ):SetDescription( STR0029 )//'Decisão'
oModel:GetModel( 'WF2DETAIL' ):SetDescription( STR0026 )//'Informações do Documento'
oModel:GetModel( 'WF3DETAIL' ):SetDescription( STR0027 )//'Itens'

// -----------------------------------------------------------------------
// Impede a exclusão de novas linhas
// -----------------------------------------------------------------------
oModel:GetModel("WF3DETAIL"):SetNoDeleteLine(.T.)

Return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} WF311Model
Função para adicionar dinamicamente os campos na estrutura

@param aCampos Estrutura dos campos que serão adicionados
@param cStru Descrição da estrutura onde os campos serão adicionados
@param oStru Objeto referente a estrutura

@author guilherme.pimentel

@since 30/09/2015
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function WF311Model(aCampos,cStru,oStru)
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
				 	.F.							,;	//	[10]  L   Indica se o campo tem preenchimento obrigatório
				 	aCampos[nCampo][11]		,;	//	[11]  B   Code-block de inicializacao do campo
				 	Nil							,;	//	[12]  L   Indica se trata-se de um campo chave
				 	.F.							,;	//	[13]  L   Indica se o campo pode receber valor em uma operação de update.
				 	.F.							)	// 	[14]  L   Indica se o campo é virtual
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

WF311View(aWF1,'WF1_',oStru1)
WF311View(aWF2,'WF2_',oStru2)
WF311View(aWF3,'WF3_',oStru3)

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
oModel:GetModel( 'WF1MASTER' ):SetDescription( STR0029 )//'Decisão'
oModel:GetModel( 'WF2DETAIL' ):SetDescription( STR0026 )//'Informações do Documento'
oModel:GetModel( 'WF3DETAIL' ):SetDescription( STR0027 )//'Itens'

oView:EnableTitleView('VIEW_WF1' , STR0029 )//'Decisão'
oView:EnableTitleView('VIEW_WF2' , STR0026 )//'Informações do Documento'
oView:EnableTitleView('VIEW_WF3' , STR0027 )//'Itens'

aWF1 := {}
aWF2 := {}
aWF3 := {}

Return oView 

//-------------------------------------------------------------------
/*/{Protheus.doc} WF120View
Função para adicionar dinamicamente os campos na view

@param aCampos Estrutura dos campos que serão adicionados
@param cStru Descrição da estrutura onde os campos serão adicionados
@param oStru Objeto referente a estrutura

@author guilherme.pimentel

@since 30/09/2015
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function WF311View(aCampos,cStru,oStru)
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
					NIL							,;	// [14]  N   Tamanho maximo da maior opção do combo
					NIL							,;	// [15]  C   Inicializador de Browse
					.F.							,;	// [16]  L   Indica se o campo é virtual
					NIL							,;	// [17]  C   Picture Variavel
					.F.							)	// [18]  L   Indica pulo de linha após o campo
Next nCampo

Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} WF311Load1
Load do Modelo temporário WF1 

@author guilherme.pimentel

@since 01/10/2015
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function WF311Load1()
Return {{""},0}

//-------------------------------------------------------------------
/*/{Protheus.doc} WF311Load2
Load do Modelo temporário WF2 

@author guilherme.pimentel

@since 01/10/2015
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function WF311Load2()
Local aAux    := {}
Local aLoad   := {}
Local cLogApr := WF311LogApr()
Local oModel  := NIL
Local oModelNNS := NIL

DbSelectArea("NNS")
NNS->(DbSetOrder(1))

If NNS->(DbSeek(xFilial("NNS")+PadR(SCR->CR_NUM,TamSX3("NNS_COD")[1]) ))
	aAdd(aAux,NNS->NNS_FILIAL+Iif(FWModeAccess("NNS")=="C",""," - "+FWFilialName(,NNS->NNS_FILIAL)))
	Aadd(aAux,NNS->NNS_COD)
	Aadd(aAux,NNS->NNS_DATA)
	Aadd(aAux,NNS->NNS_SOLICT)
	Aadd(aAux,NNS->NNS_CLASS)
Else
	oModel    := FWModelActive()
	oModelNNS := oModel:GetModel("NNSMASTER")
	aAdd(aAux,xFilial("NNS")+Iif(FWModeAccess("NNS")=="C",""," - "+FWFilialName(,NNS->NNS_FILIAL)))
	Aadd(aAux,oModelNNS:GetValue("NNS_COD"))
	Aadd(aAux,oModelNNS:GetValue("NNS_DATA"))
	Aadd(aAux,oModelNNS:GetValue("NNS_SOLICT"))
	Aadd(aAux,oModelNNS:GetValue("NNS_CLASS"))
EndIf

aAdd(aAux,cLogApr)
aLoad := {aAux,0}

Return aLoad

//-------------------------------------------------------------------
/*/{Protheus.doc} WF311Load3
Load do Modelo temporário WF3 

@author guilherme.pimentel

@since 01/10/2015
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function WF311Load3()
Local aAux		:= {}
Local aLoad	:= {}
Local aStruct	:= {}
Local cCodNNS	:= NNS->NNS_COD
Local nX		:= 0

BeginSQL Alias "LOADTMP"
	
	SELECT *
	FROM %Table:NNT% NNT //Atualizar tabela
	JOIN %Table:NNS% NNS ON //Atualizar tabela
	    NNS.%NotDel% AND
	    NNS.NNS_FILIAL = %xFilial:NNS% AND
	    NNS.NNS_COD = NNT.NNT_COD
	WHERE NNT.%NotDel% AND
		NNT.NNT_FILIAL = %xFilial:NNT% AND
		NNT.NNT_COD = %Exp:cCodNNS%
		
EndSQL

//TCSetField("LOADTMP","CP_DATPRF","D",8,0)

// -----------------------------------------------------------------------
// De/para entre os campos do Select e os que estão no modelo
// -----------------------------------------------------------------------
aAdd(aStruct,'NNT_FILORI')
aAdd(aStruct,'NNT_PROD')
aAdd(aStruct,'NNT_DESC')
aAdd(aStruct,'NNT_LOCAL')
aAdd(aStruct,'NNT_LOCALI')
aAdd(aStruct,'NNT_NSERIE')
aAdd(aStruct,'NNT_NUMLOT')
aAdd(aStruct,'NNT_QUANT')

aAdd(aStruct,'NNT_FILDES')
aAdd(aStruct,'NNT_PRODD')
aAdd(aStruct,'NNT_DESCD')
aAdd(aStruct,'NNT_LOCLD')
aAdd(aStruct,'NNT_LOCDES')
aAdd(aStruct,'NNT_SERIE')
aAdd(aStruct,'NNT_LOTED')
aAdd(aStruct,'NNT_TS')	
aAdd(aStruct,'NNT_TE')

// -----------------------------------------------------------------------
// Popula modelo SCPDETAIL com os valores da query
// -----------------------------------------------------------------------
While !LOADTMP->(EOF())
	aAux := {}
		
	For nX := 1 To Len(aStruct)		
		If aStruct[nX] $ 'NNT_FIL'
			Aadd( aAux, LOADTMP->(&(aStruct[nX]))+  Iif(FWModeAccess("NNT")=="C",""," - "+FWFilialName(,LOADTMP->(&(aStruct[nX])))))
		ElseIf aStruct[nX] == 'NNT_DESC'			
			Aadd( aAux, LOADTMP->(Posicione("SB1",1,xFilial("SB1")+LOADTMP->NNT_PROD,"B1_DESC")))
		ElseIf aStruct[nX] == 'NNT_DESCD'
			Aadd( aAux, LOADTMP->(Posicione("SB1",1,xFilial("SB1")+LOADTMP->NNT_PRODD,"B1_DESC")))
		Else
			Aadd( aAux, LOADTMP->(&(aStruct[nX])))
		EndIf
	Next nX
			
	aAdd(aLoad,{0,aClone(aAux)})
	
	LOADTMP->(DbSkip())
End
   
LOADTMP->(dbCloseArea())

Return aLoad

//-------------------------------------------------------------------
/*/{Protheus.doc} WF311LogApr()
Função que retorna o histórico de aprovação da SCR

@author rafael.duram
@since 04/08/2016
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function WF311LogApr()
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
	SELECT	SCR.CR_NUM			CR_NUM,
			SCR.CR_NIVEL		CR_NIVEL,
			SCR.CR_USER		CR_USER,
			SCR.CR_DATALIB	CR_DATALIB,
	   		SCR.CR_STATUS		CR_STATUS,
	   		SCR.CR_GRUPO		CR_GRUPO,
	   		SCR.CR_OBS			CR_OBS,
	   		SCR.R_E_C_N_O_

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
	SCR->(MsGoto((cTmpAlias)->R_E_C_N_O_))
	If !Empty(SCR->CR_OBS)
		cRet +=	CRLF + 'Obs: ' + AllTrim(SCR->CR_OBS) + CRLF
	EndIf

	cRet +=	CRLF
	(cTmpAlias)->( DbSkip() )
End

FWRestRows(aSaveLines)
RestArea(aAreaSAL)
RestArea(aAreaSCR)
RestArea(aArea)
Return cRet

