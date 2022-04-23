@echo off

echo PARAR SERVIÇOS PROTHEUS

:A
echo Digite a senha para iniciar o programa:
set /p "pass="

if %pass%==MUSTAINE ( 
echo Por favor, aguarde ... 

sc start "NOME DO SERVIÇO A SER INICIADO"


timeout 30

sc start "NOME DO SERVIÇO A SER INICIADO APOS 30 SEGUNDOS DO ULTIMO COMANDO"


echo Processo Concluido !
) ELSE (
echo Senha incorreta... )

pause