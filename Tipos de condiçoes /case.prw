/*

Do Case
    Case‹Condição›
    - Comandos
    - Comandos

Case (condição) 
    - Comandos
    - Comandos

Case (condição)

Otherwise (não obrigatório)
    - Comandos
    - Comandos

EndCase 
*/


User Function Do_Case()
Local nNumero := 10

Do case
    case nNumero > 0
        MsgAlert("Numero Positivo", "Valida Numero")
    case nNumero < 0
        msgAlert("Numero Negativo", "Valida Numero")
    otherwise
        msgAlert("Numero é Zero", "Valida Numero")    
End Case


return
