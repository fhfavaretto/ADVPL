@echo OFF
title Backup Geral
 
set /p _Destino=Insira o diretorio de destino: 
 
if exist "%_Destino%" (
  echo Backup iniciado - %DATE% %TIME%
   
  if not exist "%_Destino%\backups" mkdir "%_Destino%\backups\"
 
  robocopy D:\Skype   %_Destino%\backups\Skype\  /s /e /nfl /ndl /ns /nc /njh /njs /r:0 /w:0
  echo Copia diretorio "Skype" finalizado - %DATE% %TIME%
   
  robocopy D:\Thunderbird   %_Destino%\backups\Thunderbird\  /s /e /nfl /ndl /ns /nc /njh /njs /r:0 /w:0
  echo Copia diretorio "Thunderbird" finalizado - %DATE% %TIME%
 
  echo Backup finalizado - %DATE% %TIME%
   
) else (
  echo Diretorio "%_Destino%" nao existe!
)
 
pause