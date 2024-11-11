Set-ItemProperty -Path "HKLM:\Software\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" -Name ExecutionPolicy -Value Unrestricted

Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableRealtimeMonitoring" -PropertyType DWord -Value 1

Stop-Service -Name "wuauserv" -Force
Set-Service -Name "wuauserv" -StartupType Disabled

New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -PropertyType DWord -Value 1

Write-Output "Windows Defender e Windows Update sono stati disabilitati con successo."

(New-Object net.webclient).DownloadFile('https://raw.githubusercontent.com/mandiant/flare-vm/main/install.ps1',"$([Environment]::GetFolderPath("Desktop"))\install.ps1")
Unblock-File .\install.ps1

Set-ExecutionPolicy Unrestricted -Force

.\install.ps1 -noWait -noGui -noPassword
