@echo off
cls
@echo.
@echo                           # TECLE ENTER #
@echo.      
@echo  # "Obs:" CUIDADO AO EXECUTAR ESSA ROTINA VERIFIQUE SEMPRE O BACKUP ANTES #
@echo.
pause
@echo.
@echo ****************************************************************************
@echo ***               DELETA ARQUIVOS SYSTEM PROTHEUS_DATA/SYSTEM            ***
@echo ***   TIPOS ARQUIVOS *.tmp / sc*.log / sc*.dtc / sc*.cdx  / sc*          ***
@echo ****************************************************************************                                
@echo. 
@echo Deletando tmp.....
@echo.
del /q W:\TOTVS12\Microsiga\protheus_data\system\*.tmp
@echo   Ok Deletados arquivos.tmp
@echo.
@echo Deletando sc*.log
@echo.
del /q W:\TOTVS12\Microsiga\protheus_data\system\sc*.log
@echo   Ok Deletados arquivos sc*.log
@echo.
@echo Deletando sc*.FILE.....
@echo.
del /q W:\TOTVS12\Microsiga\protheus_data\system\sc*.""
@echo   Ok Deletados arquivos sc*.dtc
@echo.
@echo Deletando sc*.cdx
@echo.
del /q W:\TOTVS12\Microsiga\protheus_data\system\sc*.cdx
@echo   Ok Deletados arquivos sc*.cdx
@echo.
@echo Deletando Pasta Spool
@echo.
del /q W:\TOTVS12\Microsiga\protheus_data\spool\*.*
@echo   Ok Deletados Pasta Spool
@echo.
@echo           # Tecle enter para encerrar #
@echo.
pause