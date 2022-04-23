/*

IF ‹condição› (obrigatório)
    - comandos
    - comandos
Elself ‹condição» (Não obrigatórios)
    - comandos
    - comandos
Elself ‹condição› (Não obrigatórios)
    - comandos
    - comandos
Else
(não Obrigatório)
    - comandos
    - comandos
Endif (obrigatorios)



*/

User Function VldVenda()
Local nEstoque := 100
Local nVenda   := 10
Local cEstNeg  := "SIM"

If nEstoque >= nVenda
    msgAlert("Pedido Liberado", "Liberação de pedido")
elseif nVenda > nEstoque .and. cEstNeg == "SIM"
    msgAlert("Saldo Liberado porém estoque insuficiente", "Liberação de pedido")
else 
 msgAlert("Sem Saldo para Liberar o pedido", "Liberação de pedido")
endif

return
