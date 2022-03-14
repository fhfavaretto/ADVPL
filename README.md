Framework - LIB
Repositório com os fontes da LIB do Protheus

  _____   _                               _______      _______  _
 |_   _| | |                        /\   |  __ \ \    / /  __ \| |
   | |   | |     _____   _____     /  \  | |  | \ \  / /| |__) | |
   | |   | |    / _ \ \ / / _ \   / /\ \ | |  | |\ \/ / |  ___/| |
  _| |_  | |___| (_) \ V /  __/  / ____ \| |__| | \  /  | |    | |____
 |_____| |______\___/ \_/ \___| /_/    \_\_____/   \/   |_|    |______|

Code Review
Vale lembrar que devemos “ter o cuidado” em alguns itens na verificação e não forçar o desenvolvedor a seguir aos seus processos de desenvolvimento.

Seja sempre imparcial, avalie o código não a pessoa.

Devemos verificar no código:

Alteração efetuada desempenha o papel esperado na correção? Cumpre o requerido na issue?

Aqui vale a experiência de quem está fazendo o code review.
Lógica está correta e clara? É facilmente entendido?

Precisamos evitar problemas para depois, dificultando o debug.
O nome dos arquivos ch’s no include estão em letra minúscula?

Exemplo: #include 'protheus.ch', pq? #linuxthing
Retirar variáveis static tipo ( lIsP12 – lIsP11), somente em fonte da versão 12

Isso elimina condições desnecessárias na versão que estamos.
Respeita o guia de boas práticas desenvolvimento?

Guia de Boas Práticas - ADVPL 
Efetuou a Tipagem das variáveis e parâmetros?

Tipagem de Dados 
Existe código redundante ou duplicado?

Ou seja, tem esta(s) mesma(s) linha(s) em outro lugar no fonte ou no fluxo de execução e poderia ser unificado?
Atenção: não deixe genérico de forma prematura
Efetuou a identação do código?

Hmmmm, sem mais...
O código possui documentação (novos métodos, funções, classes)

ProtheusDOC 
Possui comentário em caso de lógica mais complexas

Às vezes precisa ser complexo, esperamos que esteja explicado!
Cabe teste de unidade e o mesmo foi criado?

Testes automatizados são legais e nunca são demais, a principal qualidade dele é documentar comportamentos
As novas Variáveis, Métodos, Funções foram definidas com Nomes Sugestivos, Consistentes, Legíveis e Claros para o contexto.

Em caso de correções de issues com problemas de performance devemos avaliar:

Se os processos redundantes ou lentos foram otimizados?
Foi evitado ou melhorado o uso de laços de repetições, diminuindo a complexidade da execução?
Utilizar as funções da LIB evitando ou removendo as funções de Infra-Estrutura (MATXATU, MATXFUN...), exemplo:

Utilizar a função FWGetArea e FWRestArea no lugar das funções GetArea e RestArea
Processo Frame
Desenvolvimento
Conferir a lista priorizada das issues no Kanbam e escolher a mais próxima do topo que você conseguir.

Colocar ela em grooming ao começar a análise.

Assim que terminar a análise e começar a codificar, passar a tarefa para codificação e iniciar a subtarefa de codificação

Abrir uma branch a partir da master para armazenar a alteração. As branches devem ser sempre criadas letras minúsculas com o seguinte formato:

Squadrão	Exemplo
issue/sprintxx/codigo_issue	issue/sprint10/dfrm1-1234
Squad Gestão	Exemplo
issue/gaxx/codigo_issue	issue/ga10/dfrm4-1234
xx - Número da sprint

codigo_issue - Código da issue no JIRA

Se for possível, criar um teste automatizado para sua issue. Melhor ainda se você fizer isso antes de codificar.

Ao finalizar a codificação, executar ( se tiver ) todos os testes automatizados relacionados e confira se nenhum quebra. Corrija o que for necessário.

Ainda em finalizar codificação, incluir informações para que o documento Tecnico seja atualizado de forma automatica no tdn.

Clicar em Finalizar Codificação (Doc) e preencher os campos abaixo.

Os campos abaixo foram preenchidos para o exemplo de label 20200908, verificar sempre o fix version e adequar informações.

 Space TDN - PROT – Linha Microsiga Protheus

 Página Pai TDN (Agrupadora) - 558239207 - Manutenção LIB 20200908_P12

 Produto - Nova Nomenclatura - TOTVS Framework

 Linha de Produto - Nova Nomenclatura - Linha Protheus

 Label TDN - framework ; lib_20200908

 Summary - Breve descrição/Título do problema

 Situação/Requisito - Descreva o Problema/Situação da Issue

 Solução TDN - Descreva a Solução da Issue

 Demais informações TDN - Descreva alguma observação ou detalhe importante.

 Assuntos Relacionados TDN - Vincule outros conteúdos complementares

 Comment - Insira um comentário para adicionar no JIRA
Depois conclua a operação para adicionar as informações no Jira e criar o DT no TDN.

Nesse momento irá criar a documentação em rascunho no TDN

Confira as boas práticas na codificação, altere o que for necessário. Rode de novo os testes.
Crie um PR para a master com o seguinte título: TICKET 9999999 | ISSUE 99999 - DESCRICAO
O texto do PR deve seguir esse template:
Ticket 0000000 | ISSUE DFRM1-00000

Problema: Descrição do problema.

Correção: Descriação da correção.

A liberação desta correção será realizada futuramente através do pacote de LIB versão AAAAMMDD, qual contemple os fontes abaixo relacionado(s):

fonte.prw

Este procedimento padrão é aplicável a liberação de correções e/ou melhorias de componentes nativos da LIB de Framework do sistema.

Caso de teste:

Descrição dos casos de teste
Finalizar subtarefa de codificação. Registrar o tempo na subtarefa.
Adicionar comentário na issue principal com o texto do PR, adicionando o link do PR.
Conferir as labels e pontuações registradas e alterar conforme necessário.
Finalizar a codificação na issue principal.
QA
Assumir a tarefa no Jira e iniciar Teste Integrado

Verificar preenchimento do Labels/Rótulo. No campo Labels, preencher com as seguintes opções – FRAME_??? E FW_ORI_???

Assunto - Sendo as opções disponíveis ao digitar FRAME_

FRAME_ANTECIPA
FRAME_APOIO
FRAM_APWEBWIZARD
FRAME_ATUSX
FRAME_AUDIT
FRAME_AUDITTRAIL
FRAME_AUTENTICACAO
FRAME_BANCOCONHECIMENTO
FRAME_BASEDADOS
Regra:

FW_ORI_BUG: Quando o problema passou a acontecer após alguma mexida de outro analista e é possível de ser rastreada.
FW_ORI_INOV: Quando o problema passou a acontecer após a implementação de alguma inovação.
FW_ORI_PAST: Quando o problema está na Lib há muito tempo e não pode ser rastreado ou ainda, é um problema decorrente da migração para o dicionário no banco.
Verificar se o pull request possui a primeira aprovação de code review.

Preencher ou conferir o campo Fix Version

Rebase da issue

    git checkout master
    git pull
    git submodule update
    git checkout nome_da_branch
    git pull e depois git submodule update
    git rebase master
    caso ocorrer erro - git rebase --abort
    git push -f
Gerar patch

Em Azure Devops, opção Pipeline- All escolher em qual versão irá testar, no exemplo Lobo, ADVPLFramework-CI-64-Gera Lib Without Tests and Analytics, Run Pipeline, em branch/tag escolher o numero da issue que irá testar e clicar em Run.

Para geração da lib para releases superiores a 33, utilizar o pipeline do harpia (Build Harpia)

Obs- para 32 - ADVPLFramework-CI-32-Gera Lib Without Tests and Analytics

Aguardar geração do patch, que demora por volta de 10m.

Em Pipeline – Recents, procurar sua execução, clicar em related- 1published e realizar o download do pacote.

Anexar Evidência de testes

Encerrar Issue Pai e Filhas

Adicionar texto padrão:

00/00/0000 - Submetido ao processo de verificação e validação de teste - Aprovado.

Cancelar a tarefa de Documentação caso não haja documentação para aquela issue.

Na issue em teste, opção “Edit” alterar campo Status pacote para Pacote-Gerado, antes de encerrar a issue.

Verificar notas de release

Issue tipo manutenção - Verificar as informações do documento em rascunho e publicar no tdn. Issue tipo story e estiver com o rótulo FRAME_RELEASENOTES - Incluir documentação manual do TDN, utilizando o template Documento Técnico (New).

Obs- Incluir rótulo framespdev na página do TDN.

Em caso de impossibilidade de acesso ao Azure Devops
 - Avisar o restante do time sobre a impossibilidade de acesso ao repositório;
 - Avaliar se existe dependência entre as alterações que possam gerar problemas no momento de merge;
 - Trabalhar com as versões locais até que o serviço seja restabelecido;
 - Quando o serviço for restabelecido, realizar primeiramente o merge da sua branch local com a master ou branch alvo (inovação, por exemplo) para evitar problemas no momento da subida da branch.