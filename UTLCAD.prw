#include 'protheus.ch'
#include 'tbiconn.ch'
#include 'parmtype.ch'

//documentação
// https://tdn.totvs.com/display/tec/TButton

User Function UTLCAD()
Local oDgl1 //variavel que recebera a chamada da classe tDialog
local cTituloJanela := "DASBOARD - UPDUO CONSULTORIA"
local oTButton1   
local oTButton2   
local oTButton3   
local oTButton4   
local oTButton5   
local oTButton6   
local oTButton7  
local oTButton8  
local oTButton9  
local oTButton10  
local oTButton11   
local oTButton12   
local oTButton13  
local oTButton14   
local oTButton15   
local oTButton16  
local oTButton17  
local oTButton18  
local oTButton20   
local oTButton19  
local oSay1
local oSay2

oDgl1 := TDialog():New(0,0,800,1280,cTituloJanela,,,,,CLR_BLACK,CLR_WHITE,,,.T.)


oSay1:= TSay():Create(oDgl1,{||'Relatorios'},10,75,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,600,60)
oTButton1 := TButton():New( 30, 50,"Relatorio Vinculo Funcional",oDgl1,{||U_RelUsrF()}, 70,20,,,.F.,.T.,.F.,,.F.,,,.F. )  // Relatorio Vinculo Funcional
oTButton2 := TButton():New( 60, 50,"Relatório de usuários ",oDgl1,{||U_TREPUSER()}, 70,20,,,.F.,.T.,.F.,,.F.,,,.F. )       //Relatório de usuários e seus respectivos acessos.
oTButton3 := TButton():New( 90, 50,"zReport",oDgl1,{||U_zReport()}, 70,20,,,.F.,.T.,.F.,,.F.,,,.F. )                       // zReport - Criação de usuarios
oTButton4 := TButton():New( 120, 50,"Saldo Estoque",oDgl1,{||U_SALDDIFF()}, 70,20,,,.F.,.T.,.F.,,.F.,,,.F. )           //
oTButton5 := TButton():New( 150,50, "",oDgl1,{||}, 70,20,,,.F.,.T.,.F.,,.F.,,,.F. )               //
oTButton6 := TButton():New( 180,50, " ",oDgl1,{|| Mata235()}, 70,20,,,.F.,.T.,.F.,,.F.,,,.F. )        //
oTButton7 := TButton():New( 210,50, " ",oDgl1,{|| U_SQLERP()}, 70,20,,,.F.,.T.,.F.,,.F.,,,.F. )              //
oTButton8 := TButton():New( 240,50, " ",oDgl1,{|| U_SQLERP()}, 70,20,,,.F.,.T.,.F.,,.F.,,,.F. )    //
oTButton9 := TButton():New( 270,50, " ",oDgl1,{|| U_SQLERP()}, 70,20,,,.F.,.T.,.F.,,.F.,,,.F. )     //
oTButton10 := TButton():New(300,50, " ",oDgl1,{|| U_SQLERP()}, 70,20,,,.F.,.T.,.F.,,.F.,,,.F. )            //

oTButton8 := TButton():New( 330,115, "ENCERRAR",oDgl1,{|| oDgl1:End()}, 70,20,,,.F.,.T.,.F.,,.F.,,,.F. )

oSay2:= TSay():Create(oDgl1,{||'Rotinas'},10,195,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,600,60)
oTButton11 := TButton():New( 30, 180,"CHKTOP",oDgl1,{||U_CFG001()}, 70,20,,,.F.,.T.,.F.,,.F.,,,.F. )  // Funcao de atualizacao da estrutura das tabelas (CHKTOP)
oTButton12 := TButton():New( 60, 180,"zAppend",oDgl1,{||U_zAppend()}, 70,20,,,.F.,.T.,.F.,,.F.,,,.F. ) // Função de Append em bloco de uma base para outra
oTButton13 := TButton():New( 90, 180,"Ajusta Estoque",oDgl1,{||U_AjEst()}, 70,20,,,.F.,.T.,.F.,,.F.,,,.F. ) //Função de ajuste de estoque
oTButton14 := TButton():New( 120,180,"EXECFUNC",oDgl1,{||U_EXECFUNC()}, 70,20,,,.F.,.T.,.F.,,.F.,,,.F. )   
oTButton15 := TButton():New( 150,180,"SuperQry",oDgl1,{||U_SuperQry()}, 70,20,,,.F.,.T.,.F.,,.F.,,,.F. )
oTButton16 := TButton():New( 180,180,"TRANSARQ",oDgl1,{|| U_TRANSARQ()}, 70,20,,,.F.,.T.,.F.,,.F.,,,.F. )
oTButton17 := TButton():New( 210,180,"APi Cadastro",oDgl1,{|| U_APiemp()}, 70,20,,,.F.,.T.,.F.,,.F.,,,.F. )  
oTButton18 := TButton():New( 230,180," ",oDgl1,{|| U_SQLERP()}, 70,20,,,.F.,.T.,.F.,,.F.,,,.F. )  
oTButton19 := TButton():New( 250,180," ",oDgl1,{|| U_SQLERP()}, 70,20,,,.F.,.T.,.F.,,.F.,,,.F. )  
oTButton20 := TButton():New( 300,180," ",oDgl1,{|| U_SQLERP()}, 70,20,,,.F.,.T.,.F.,,.F.,,,.F. )  





oDgl1:Activate(,,,.T.) // parametro para ativar a tela marcada como .T. para centralizar no meio


Return




User Function APiemp()

FWAlertSuccess("Gatilho Criado", "Api Ativada")

//Gatilhos que serão criados ao confirmar api
aSX7 := {}
aAdd(aSX7,{'A1_CGC', 'A1_NOME', 'u_getCNPJ("SA1",M->A1_CGC)', 'P', 'N', '',0, '', '!EMPTY(M->A1_CGC)'})
aAdd(aSX7,{'A2_CGC', 'A2_NOME', 'u_getCNPJ("SA2",M->A2_CGC)', 'P', 'N', '',0, '', '!empty(M->A2_CGC)'})
aAdd(aSX7,{'A4_CGC', 'A4_NOME', 'u_getCNPJ("SA4",M->A4_CGC)', 'P', 'N', '',0, '', '!empty(M->A4_CGC)'}) 


//Criando os gatilhos
u_zCriaGat(aSX7)

RETURN


//Bibliotecas 
/*/{Protheus.doc} zCriaGat
Função que cria os gatilhos na base
@type function
@author Atilio
@since 22/09/2015
@version 1.0
    @param aSX7, Array, Array com os dados da SX7
    @example
    u_zCriaGat(aSX7)
    @obs Abaixo a estrutura do array:
    SX7:
        [nLinha][01] - Campo
        [nLinha][02] - Conta Domínio
        [nLinha][03] - Regra
        [nLinha][04] - Tipo
        [nLinha][05] - Seek
        [nLinha][06] - Alias
        [nLinha][07] - Ordem
        [nLinha][08] - Chave
        [nLinha][09] - Condição
/*/
 
User Function zCriaGat(aSX7)
    Local aAreaX7 := SX7->(GetArea())
    Local nAtual := 0
    Local lCria := .T.
    Local cTabAux := ""
    Local cSeqAux := ""
     
    DbSelectArea("SX7")
    SX7->(DbSetOrder(1))
    DbSelectArea("SX3")
    SX3->(dbSetOrder(2)) // X3_CAMPO
     
    //Percorrendo os gatilhos
    For nAtual := 1 To Len(aSX7)
        lCria := .T.
         
        //Percorrendo a SX7, verificando se já não existe o campo com a conta domínio e a regra
        SX7->(DbGoTop())
        While ! SX7->(EoF())
            //Se encontrar o gatilho, não será criado
            If    Alltrim(SX7->X7_CAMPO) == Alltrim(aSX7[nAtual][01]) .And.;
                Alltrim(SX7->X7_CDOMIN) == Alltrim(aSX7[nAtual][02]) .And.;
                Alltrim(SX7->X7_REGRA) == Alltrim(aSX7[nAtual][03])
                lCria := .F.
            EndIf
             
            SX7->(DbSkip())
        EndDo
         
        //Se for para criar os dados
        If lCria
            cTabAux := AliasCpo(aSX7[nAtual][01])
            cSeqAux := fSeqSX7(aSX7[nAtual][01])
             
            //Grava a informação
            RecLock("SX7", .T.)
                X7_CAMPO    := aSX7[nAtual][01]
                X7_SEQUENC    := cSeqAux
                X7_REGRA    := aSX7[nAtual][03]
                X7_CDOMIN    := aSX7[nAtual][02]
                X7_TIPO    := aSX7[nAtual][04]
                X7_SEEK    := aSX7[nAtual][05]
                X7_ALIAS    := aSX7[nAtual][06]
                X7_ORDEM    := aSX7[nAtual][07]
                X7_CHAVE    := aSX7[nAtual][08]
                X7_CONDIC    := aSX7[nAtual][09]
                X7_PROPRI    := "U"
                DbCommit()
            SX7->(MsUnlock())
             
            //Se posicionar no campo
            SX3->(DbGoTop())
            If SX3->(DbSeek(aSX7[nAtual][01]))
                //Se o controle de gatilho, estiver em branco
                If Empty(SX3->X3_TRIGGER)
                    RecLock("SX3", .F.)
                        X3_TRIGGER := "S"
                    SX3->(MsUnlock())
                EndIf
            EndIf
             
            //Atualiza o Dicionário
            X31UpdTable(cTabAux)
 
            //Se houve Erro na Rotina
            If __GetX31Error()
                cMsgAux := "Houveram erros na atualização do gatilho "+aSX7[nAtual][01]+" -> "+aSX7[nAtual][02]+", com a regra '"+aSX7[nAtual][03]+"':"+Chr(13)+Chr(10)
                cMsgAux += __GetX31Trace()
                Aviso('Atenção', cMsgAux, {'OK'}, 03)
            EndIf
        EndIf
    Next
     
    RestArea(aAreaX7)
Return
 
/*---------------------------------------------------------------------*
 | Func:  fSeqSX7                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  22/09/2015                                                   |
 | Desc:  Função que pega a próxima sequencia da SX7 conforme campo    |
 *---------------------------------------------------------------------*/
  
Static Function fSeqSX7(cCampo)
    Local aAreaX7 := SX7->(GetArea())
    Local cSequen := "001"
     
    SX7->(DbSetOrder(1))
    SX7->(DbGoTop())
     
    //Se conseguir posicionar no campo
    If SX7->(DbSeek(cCampo))
        //Enquanto houver registros
        While ! SX7->(EoF()) .And. Alltrim(SX7->X7_CAMPO) == Alltrim(cCampo)
            cSequen := SX7->X7_SEQUENC
            SX7->(DbSkip())
        EndDo
         
        cSequen := Soma1(cSequen)
    EndIf
     
    RestArea(aAreaX7)
Return cSequen



