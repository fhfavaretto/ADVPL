User Function pduo()
    Local cModulo 	:= 'SIGAESP' //Nome do M�dulo que ir� fazer a abertura do Smartclient

    MsApp():New(cModulo) //Instancia a aplica��o no m�dulo
    oApp:cInternet := NIL     
    oApp:CreateEnv() //Cria o ambiente que ser� usando
    PtSetTheme("OCEAN") //Define o nome do tema, se n�o inserir, ser� considerado o tema padr�o
    oApp:cStartProg    	:= 'U_UTLCAD' //Instancia a fun��o que ser� executada ap�s a abertura do programa
    oApp:lMessageBar	:= .T. 
    oApp:cModDesc		:= cModulo
    __lInternet 		:= .T.
    lMsFinalAuto 		:= .F.
    oApp:lMessageBar	:= .T. 
    oApp:Activate() //Executa
Return
