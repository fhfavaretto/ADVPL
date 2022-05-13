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

	[Erros comuns](https://tdn.totvs.com/pages/releaseview.action?pageId=271414000)
		
# Tarefas a serem executadas após a migração

1) [Ativar novo menu](https://tdn.totvs.com/display/framework/Nova+interface+do+Protheus+com+PO+UI)
	


