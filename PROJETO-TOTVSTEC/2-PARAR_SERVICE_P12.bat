@echo off

echo PARAR SERVIÇOS PROTHEUS UPDUO CONSULTORIA

:A
echo Digite a senha para iniciar o programa:
set /p "pass="

if %pass%==MUSTAINE ( 
echo Por favor, aguarde ... 



sc stop "NOME DO SERVIÇO A SER PARADO"


timeout 30    

sc stop "NOME DO SERVIÇO A SER PARADO APOS 30 SEGUNDOS DO ULTIMO COMANDO"



echo Processo Concluido !
) ELSE (
echo Senha incorreta... )

PAUSE
