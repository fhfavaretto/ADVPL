#include "protheus.ch"
#INCLUDE "TOPCONN.CH"

//Documentação PE Afterlogin
//@https://tdn.totvs.com/pages/viewpage.action?pageId=6815186
User Function AfterLogin()

	If Substr(GetMv("MV_Parametro01"),1,6) < Substr(DtoS(Date()),1,6) //dDataBase //20211229

		U_zEvGestJob() //1 job que roda 1 vez por mes
		// criar parametro que valida ultima data executado
		//criar validação de tempo a ser executado
		PutMv("MV_Parametro01",DtoS(Date()))

	EndIf
    //Documentação Função Dow Converte uma data para um número indicativo do dia da semana.
    //@https://tdn.totvs.com/pages/viewpage.action?pageId=23889346
	If Dow(Date()) == 2 .AND. StoD(GetMv("MV_parametro02")) < Date() //31/12/2021

		zEvGtJob2()     //2 job que roda uma vez a cada 7 dias
		// criar parametro que valida ultima data executado
		//criar validação de tempo a ser executado

		PutMv("MV_parametro02",DtoS(Date()))

	EndIf


    







Return
