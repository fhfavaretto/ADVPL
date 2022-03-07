# Abra uma janela do Terminal e execute o seguinte comando: 

docker pull mcr.microsoft.com/azure-sql-edge

 # Quando o download estiver concluído, execute o seguinte comando para iniciar uma instância da imagem do Docker que você acabou de baixar: 

sudo docker run --cap-add SYS_PTRACE -e 'ACCEPT_EULA=1' -e 'MSSQL_SA_PASSWORD=mustaine' -p 1433:1433 --name sqledge -d mcr.microsoft.com/azure-sql-edge


docke