/*

Do Case
    Case�Condi��o�
    - Comandos
    - Comandos

Case (condi��o) 
    - Comandos
    - Comandos

Case (condi��o)

Otherwise (n�o obrigat�rio)
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
        msgAlert("Numero � Zero", "Valida Numero")    
End Case


return
