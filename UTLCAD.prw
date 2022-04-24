#include 'protheus.ch'
#include 'tbiconn.ch'
#include 'parmtype.ch'

//documentação
// https://tdn.totvs.com/display/tec/TButton

User Function UPDUO()
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
oTButton17 := TButton():New( 210,180," ",oDgl1,{|| U_SQLERP()}, 70,20,,,.F.,.T.,.F.,,.F.,,,.F. )  
oTButton18 := TButton():New( 230,180," ",oDgl1,{|| U_SQLERP()}, 70,20,,,.F.,.T.,.F.,,.F.,,,.F. )  
oTButton19 := TButton():New( 250,180," ",oDgl1,{|| U_SQLERP()}, 70,20,,,.F.,.T.,.F.,,.F.,,,.F. )  
oTButton20 := TButton():New( 300,180," ",oDgl1,{|| U_SQLERP()}, 70,20,,,.F.,.T.,.F.,,.F.,,,.F. )  





oDgl1:Activate(,,,.T.) // parametro para ativar a tela marcada como .T. para centralizar no meio


Return




