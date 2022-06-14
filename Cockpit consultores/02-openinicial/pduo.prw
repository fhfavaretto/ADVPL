User Function pduo()
    Local cModulo 	:= 'SIGAESP' //Nome do Módulo que irá fazer a abertura do Smartclient

    MsApp():New(cModulo) //Instancia a aplicação no módulo
    oApp:cInternet := NIL     
    oApp:CreateEnv() //Cria o ambiente que será usando
    PtSetTheme("OCEAN") //Define o nome do tema, se não inserir, será considerado o tema padrão
    oApp:cStartProg    	:= 'U_UTLCAD' //Instancia a função que será executada após a abertura do programa
    oApp:lMessageBar	:= .T. 
    oApp:cModDesc		:= cModulo
    __lInternet 		:= .T.
    lMsFinalAuto 		:= .F.
    oApp:lMessageBar	:= .T. 
    oApp:Activate() //Executa
Return
