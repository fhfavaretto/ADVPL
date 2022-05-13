      

**Parâmetros SmartClient** 

  

  

O Smart Client (SmartClient), pode receber (Parâmetros de Inicialização), assim como o Application Server (AppServer). 

  

  

-   -Q (Quiet) – Indica que o TOTVS Smart Client (SmartClient), não deverá mostrar o Splash (Imagem de Apresentação) e a tela de identificação de Parâmetros Iniciais, necessita ser acompanhada da (Cláusula –P);  
    

  

-   -P (Main Program) – Identifica o Programa (APO) Inicial;  
    

  

-   -E (Environment) – Nome da Seção de Environment, no (Ini do Server), que será utilizada, para definições gerais;  
    

  

-   -C (Connection) – Nome da Seção de Conexão, que será utilizada, para a conexão ao TOTVS Application Server (AppServer);

  

  

-   -M (AllowMultiSession) – Permite múltiplas instâncias (Cópias) do TOTVS Smart Client (SmartClient), na mesma máquina.  
      
    
-   L (TOTVS Smart Client (SmartClient) Log File) – Para Não Conformidades, que ocorram no TOTVS Smart Client (TotvsSmartClient), (Antes que este possa se conectar ao TOTVS Application Server (AppServer), é gerado um Arquivo de Log, no diretório de execução do TOTVS Smart Client (SmartClient).Este arquivo tem o nome definido pelo nome do executável (SmartClient), mais um Caracter de Underline (_), mais o Nome da Máquina em que o Smart Client (SmartClient) está sendo executado com a extensão (.LOG).Esta opção permite informar um nome específico para a geração deste Arquivo de Log, visando automatizações específicas que necessitem saber quando uma Não Conformidade, ocorreu no Smart Client (SmartClient). Por exemplo: Impossibilidade de Conexão;  
    

  

Exemplo: 1. C:\PROTHEUS12\BIN\SMARTCLIENT\ SMARTCLIENT.EXE –Q –P=Sigacom –E=Environment -M;