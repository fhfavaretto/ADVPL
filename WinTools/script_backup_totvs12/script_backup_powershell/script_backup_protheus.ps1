##############################################################
#    SCRIPT PARA PARAR OS SERVIÇOS TOTVS ANTES DO BACKUP     #
##############################################################
##############################################################################
#    ANTES DE UTILIZAR O SCRIPT, FA�A UM TESTE COM ARQUIVOS N�O OFICIAIS     #
##############################################################################

#cria sem�foro para outros scripts detectarem que o backup est� sendo executado#
fsutil file createnew C:\TOTVS\Scripts\semaforo_backup.txt 1

$current_date  = Get-Date #pega a data atual do sistema
$source_folder = "C:\TOTVS12" #onde est�o os arquivos a serem copiados para o backup 
$backup_folder = "C:\Backup_" + $current_date.Year + $current_date.Month.ToString().PadLeft(2,'0') + $current_date.Day.ToString().PadLeft(2,'0') #pega o caminho do diret�rio de backup

#servi�os a serem parados
$TotvsServices = 
	'.TOTVS-Appserver12'
	'.TOTVS-DBACCESS'
#	'02_TOTVS_P12_SLV2',
#	'03_TOTVS_P12_SLV3'

Write-host "--------Inicio do processo de backup do sistema--------"
Write-host $current_date.Day.ToString().PadLeft(2,'0')'/'$current_date.Month.ToString().PadLeft(2,'0')'/'$current_date.Year
Write-host "-------------------------------------------------------"

foreach ($TotvsService in $TotvsServices) {
	Write-host "Parando servicos: " + $TotvsService
    $ServicePID = (get-wmiobject win32_service | where { $_.name -eq $TotvsService}).processID
    Stop-Process $ServicePID -Force #For�a a parada do servi�o se ficar travado
    #echo $ServicePID    
}

#cria o diret�rio de backup caso n�o exista
if((Test-Path $backup_folder) -eq 0) {
	mkdir $backup_folder
}

#inicia o processo de c�pia
$log_xcopy = "C:\LOG_TOTVS"+$current_date.Year+$current_date.Month.ToString().PadLeft(2,'0')+$current_date.Day.ToString().PadLeft(2,'0')
Write-host "Copiando projeto TOTVS para unidade de backup"
xcopy $source_folder $backup_folder /e /c /i /h /r /k /y > $log_xcopy

Write-host "Copiando RPO atualizado para ambiente de producao"
xcopy C:\TOTVS\Protheus\apo\APO12_OK\TTTP120.rpo C:\TOTVS\Protheus\apo\APO\ /d /y /c /q

#reinicia todos os servi�os
foreach ($TotvsService in $TotvsServices) {
	Write-host "Iniciando serviCo: " + $TotvsService
    Start-Service $TotvsService
    #echo $ServicePID    
}

$SMTPServer = "mail.upduo.com.br"
$SMTPPort = "587"
$FromName = "Servidor Aplicacao"
$Username = "fabio.favaretto@upduo.com.br"
$Password = "Mudar@123"

$to = "favaretto.fabio@icloud.com.br"
#$cc = "analista2@seudominio.com.br"
$subject = "[NOTIFICACAO DO SERVIDOR] - Backup realizado"
$body = "O backup foi finalizado $((Get-Date).ToString())"
#$attachment = "c:\Temp\texto.txt"

$message = New-Object System.Net.Mail.MailMessage
$message.subject = $subject
$message.body = $body
$message.to.add($to)
$message.cc.add($cc)
#$message.from = $username
$message.from = New-Object System.Net.Mail.MailAddress $username, $FromName
#$message.attachments.add($attachment)

$smtp = New-Object System.Net.Mail.SmtpClient($SMTPServer, $SMTPPort);
$smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
$smtp.send($message)

Get-ChildItem D:\ | ? {$_.Attributes -eq "Directory" -AND $_.CreationTime -lt (Get-Date).AddDays(-7)} | % {Remove-Item $_.FullName -Recurse -Force | Out-Null}

#write-host "Mail Sent"

#remove semaforo#
#del C:\TOTVS\Scripts\P12\semaforo_backup.txt