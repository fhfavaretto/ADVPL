#include "protheus.ch"
#INCLUDE "TOPCONN.CH"

User Function AfterLogin()
    //-----------------------------------------
    //Realiza a alimentação da tabela SM2 com
    //a ptax do dia útil anterior
    //------------------------------------------
     U_CCIMOEDA(.F.) // .T. para COMPRAR
                    //  .F. para VENDA
Return
