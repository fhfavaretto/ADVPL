/*/{Protheus.doc} zInicio1
Fun��o executada no Programa Inicial, sem precisar usu�rio e senha
@type function
@author Atilio
@since 03/10/2016
@version 1.0
    @example
    u_zInicio1()
/*/
 
User Function updopen1()
    //Cria o MsApp
    MsApp():New('SIGATST') 
    oApp:CreateEnv()
     
    //Seta o tema do Protheus (SUNSET = Vermelho; OCEAN = Azul)
    PtSetTheme("SUNSET")
     
    //Define o programa de inicializa��o 
    oApp:bMainInit:= {|| MsgRun("Configurando ambiente...","Aguarde...",;
        {|| RpcSetEnv("99","01"), }),;
        MATA010(),;
        Final("TERMINO NORMAL")}
     
    //Seta Atributos 
    __lInternet := .T.
    lMsFinalAuto := .F.
    oApp:lMessageBar:= .T. 
    oApp:cModDesc:= 'SIGATST'
     
    //Inicia a Janela 
    oApp:Activate()
Return Nil
 
/*/{Protheus.doc} zInicio2
Fun��o executada no Programa Inicial, utilizando login
@type function
@author Atilio
@since 03/10/2016
@version 1.0
    @example
    u_zInicio2()
/*/
 
User Function updopen2()
    //Cria o MsApp
    MsApp():New('SIGACOM')
    oApp:CreateEnv()
     
    //Seta o tema do Protheus (SUNSET = Vermelho; OCEAN = Azul)
    PtSetTheme("OCEAN")
     
    //Define o programa que ser� executado ap�s o login
    oApp:cStartProg    := 'U_UTLCAD'
     
    //Seta Atributos 
    __lInternet := .T.
     
    //Inicia a Janela 
    oApp:Activate()
Return Nil
