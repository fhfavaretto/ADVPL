/*

IF �condi��o� (obrigat�rio)
    - comandos
    - comandos
Elself �condi��o� (N�o obrigat�rios)
    - comandos
    - comandos
Elself �condi��o� (N�o obrigat�rios)
    - comandos
    - comandos
Else
(n�o Obrigat�rio)
    - comandos
    - comandos
Endif (obrigatorios)



*/

User Function VldVenda()
Local nEstoque := 100
Local nVenda   := 10
Local cEstNeg  := "SIM"

If nEstoque >= nVenda
    msgAlert("Pedido Liberado", "Libera��o de pedido")
elseif nVenda > nEstoque .and. cEstNeg == "SIM"
    msgAlert("Saldo Liberado por�m estoque insuficiente", "Libera��o de pedido")
else 
 msgAlert("Sem Saldo para Liberar o pedido", "Libera��o de pedido")
endif

return
