# Tarefas a serem executadas antes da migração

1) Backup a frio da pasta TOTVS ou TOTVS12
    **Obs**.: Para ter sucesso nesta tarefa, todos os serviços deverão estar parados.
	<BR>
	
2) Backup do Banco de dados Full Completo.
    **Obs**.: Agendar backup full do banco de dados.
	<BR>
	
3) Atualizar o license server para a versão 3.0 em diante
	- https://suporte.totvs.com/portal/p/10098/download#000006/368/TFINSTALL/
	<BR>
4) Colocar a pasta com os itens necessarios para atualização no servidor.
	* APPSERVER
	* DBACESS
	* RPO
	* HELPS
	* MENUS
	* DICIONARIO DE DADOS
	* SMARTCLIENT 
	
# Tarefas a serem executadas durante a migração

		

1) Copiar todos os arquivos do license server novo sobrescrevendo o antigo **mantendo somente o arquivo .ini**
**Obs - 1**.:Renomear pasta atual, para que a instalação uma nova pasta com a estrutura correta.
**Obs - 2**.:Confirmar nome do serviço e portas na no arquivo de backup
		
2) Copiar todos os arquivos do Appserver novo sobrescrevendo o antigo mantendo somente o arquivo .ini		

3) Colocar o novo RPO da release no lugar do antigo RPO, corrigindo o nome dele para TTTM120.RPO

4) Copiar todos os arquivos do DBACCESS novo sobrescrevendo o antigo mantendo somente o arquivo .ini
  
5) Colocar os arquivos do dicionário de dados completo na systemload, apagando o antigo conteudo		
   
6) Colocar os arquivos do dicionário de dados completo na systemload, apagando o antigo conteudo
		
7) Copiar todos os arquivos do Smartclient novo sobrescrevendo o antigo mantendo somente o arquivo .ini

8) Rodar o script de limpeza na pasta TOTVS OU TOTVS12, Rodar na raiz pelo CMD como administrator
	**del /s TOTVSP*.* .lcx *.prt *.idx *.cdx *.ind *.int *.lck *.##r *.log *.tmp *.bak *.TSK *.pif SC.dbf .rel *.FCS sc.txt sc*.mem sc*.log sc*.dtc sc*.cdx special.key sxh.* SXP*.* SXO*.* sigaadv.bmi hhtrg.* *.wfm *.val *.DMP *.#db**
		
		
9) Executar UPDDISTR, conforme documentação abaixo.
		
	[Como executar](https://centraldeatendimento.totvs.com/hc/pt-br/articles/360042296533-MP-FIS-Procedimento-UPDDISTR)

Quais são os erros críticos mais comuns em migrações de versão?

Ambiente
Protheus - AppServer - Todas as versões

Solução
Durante migrações de versão e de release, podem ocorrer erros críticos, que impedem a continuação da migração até que sejam corrigidos. Abaixo listamos os erros críticos mais comuns e suas correções:

O campo <campo> da chave de indice <alias> ordem # registro <# registro>, nao existe no SX3 da empresa <empresa>
1. Abra via APSDU o arquivo SIX da empres
2. Identifique a chave de indice que está gerando o erro
3. Exclua o índice referente a tabela com erro

O gatilho <campo> seqüência 000 está duplicado
1. Abra via APSDU o arquivo SX7 da empresa.
2. Indexe o arquivo pelo campo X7_CAMPO.
3. Localize o gatilho e exclua o registro duplicado.

A chave de índice <alias> ordem 0 registro <recno> esta duplicado
1. Abra via APSDU o arquivo SIX da empresa.
2. Indexe o arquivo pelo campo INDICE.
3. Verifique se o conteúdo da chave de índice do erro não existe em índices de ordem inferior da tabela.
4. Exclua o índice duplicado.

O arquivo <alias> esta duplicado no SX2
1. Abra via APSDU o arquivo SX2 da empresa.
2. Indexe o arquivo pelo campo X2_CHAVE.
3. Localize o arquivo e exclua o registro duplicado.

O tamanho das casas decimais do CAMPO <campo> TABELA <tabela> é diferente do dicionário de dados
1. Abra via APSDU a TABELA, se estiver vazia basta simplesmente dropar a TABELA do Banco de dados.
2. Caso tenha conteúdo, abra a estrutura da tabela e verifique o tamanho do decimal do campo com erro.
3. Abra o SX3 da empresa, localize o campo e compare o tamanho do X3_DECIMAL com o tamanho do decimal da TABELA.
4. Corrija a estrutura no SX3.

O tamanho do CAMPO <campo> TABELA <tabela> é diferente do dicionário
1. Abra via APSDU a TABELA, se a TABELA estiver vazia basta simplesmente dropar do Banco de dados.
2. Caso o arquivo tenha conteúdo, abra a estrutura da tabela e verifique o tamanho do campo com erro.
3. Abra o SX3 da empresa, localize o campo e compare o X3_TAMANHO com o tamanho do campo na TABELA.
4. Corrija a estrutura no SX3.

O campo <campo> esta duplicado no SX3
1. Abra o SX3 da empresa.
2. Indexe o arquivo pelo campo X3_CAMPO.
3. Localize o campo duplicado.
4. Exclua o registro.

O tamanho no SX3 do campo <campo> é diferente do SXG
O tamanho no SX3 do campo <campo> é inferior do limite do SXG
1. Abra o SX3 da empresa.
2. Indexe o arquivo pelo campo X3_CAMPO.
3. Localize o campo com erro, verifique o conteúdo dos campos X3_TAMNHO e X3_GRPSXG.
4. Faça um filtro na tabela somente com os campos que tenha o X3_GRPSXG igual ao campo com erro.
5. Compare o X3_TAMANHO de todos os campos.
6. Abra o SXG da empresa e verifique o conteúdo do campo SIZE do grupo informado no X3_GRPSXG.
7. Corrige o tamanho do campo no SX3 e na tabela.

O tamanho da pergunta 00 do grupo <grupo> é diferente do SXG
O tamanho da pergunta 00 do grupo <grupo> é superior ao limite do SXG
1. Abra o SX1 da empresa.
2. Indexe o arquivo pelo campo X1_GRUPO.
3. Localize a pergunta com erro, verifique o conteúdo dos campos X1_TAMNHO e X1_GRPSXG.
4. Faça um filtro na tabela somente com as perguntas que tenha o X1_GRPSXG igual à pergunta com erro.
5. Compare o X1_TAMANHO de todas as perguntas.
6. Abra o SXG da empresa e verifique o conteúdo do campo SIZE do grupo informado no X1_GRPSXG.
7. Corrige o tamanho do campo no SX1.

O campo de usuário <campo> existe na versão padrão e será substituído pelo campo da versão
Type:= c; Size:= 11; Decimal:= 0
Type:= c; Size:= 11; Decimal:= 0
1. Abra o SX3 da empresa.
2. Localize o campo.
3. Altere o conteúdo do campo X3_PROPRI para S





		
# Tarefas a serem executadas após a migração

1) [Ativar novo menu](https://tdn.totvs.com/display/framework/Nova+interface+do+Protheus+com+PO+UI)
	


