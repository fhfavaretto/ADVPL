//Bibliotecas
#Include "Protheus.ch"
 

user function sx6tst()

Local aPars := {}
 
aAdd(aPars, {"MV_X_FABIO01", "C", "DESCRI��O TESTE",        "email@teste.com"} )
aAdd(aPars, {"MV_X_FABIO02", "C", "DESCRI��O TESTE 02",     "www.teste.com"} )
aAdd(aPars, {"MV_X_FABIO03", "C", "DESCRI��O TESTE 03",     "000000;"} )
 
u_zCriaPar(aPars)
 
return


static Function zCriaPar(aPars)
    Local nAtual        := 0
    Local aArea        := GetArea()
    Local aAreaX6        := SX6->(GetArea())
    Default aPars        := {}
     
    DbSelectArea("SX6")
    SX6->(DbGoTop())
     
    //Percorrendo os par�metros e gerando os registros
    For nAtual := 1 To Len(aPars)
        //Se n�o conseguir posicionar no par�metro cria
        If !(SX6->(DbSeek(xFilial("SX6")+aPars[nAtual][1])))
            RecLock("SX6",.T.)
                //Geral
                X6_VAR        :=    aPars[nAtual][1]
                X6_TIPO    :=    aPars[nAtual][2]
                X6_PROPRI    :=    "U"
                //Descri��o
                X6_DESCRIC    :=    aPars[nAtual][3]
                X6_DSCSPA    :=    aPars[nAtual][3]
                X6_DSCENG    :=    aPars[nAtual][3]
                //Conte�do
                X6_CONTEUD    :=    aPars[nAtual][4]
                X6_CONTSPA    :=    aPars[nAtual][4]
                X6_CONTENG    :=    aPars[nAtual][4]
            SX6->(MsUnlock())
        EndIf
    Next
     
    RestArea(aAreaX6)
    RestArea(aArea)
Return
