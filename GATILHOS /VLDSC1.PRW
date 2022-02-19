#INCLUDE 'TOTVS.CH'
#include 'protheus.ch'
#include 'parmtype.ch'

// autor Fabio Favaretto
// se o produto for igual aos abaixos preenche automaticamente o Centro de custo
// IIF(SUBSTR(aCols[N,2],1,4)=="W000","100301","") W000 = PRODUTO, 100301 = CENTRO DE CUSTO



User Function VLDSC1()
Local cProduto := aCols[N,2]
Local CCentroC 

IF SUBSTR(cProduto,1,4)=="W000"
    CCentroC := "100301"
ELSEIF SUBSTR(cProduto,1,4)=="F000"
    CCentroC := "100302"
end 



RETURN(CCentroC)




