Write-Host  -ForegroundColor Yellow "Starting Gaëtan @ Dell Custom v2 OSDCloud ..."
cls
Write-Host "================ Main Menu ==================" -ForegroundColor Yellow
Write-Host " "
Write-Host "       _____    ______   _        _      " -ForegroundColor Cyan
Write-Host "      |  __ \  |  ____| | |      | |     " -ForegroundColor Cyan
Write-Host "      | |  | | | |__    | |      | |     " -ForegroundColor Cyan
Write-Host "      | |  | | |  __|   | |      | |     " -ForegroundColor Cyan
Write-Host "      | |__| | | |____  | |____  | |____ " -ForegroundColor Cyan
Write-Host "      |_____/  |______| |______| |______|" -ForegroundColor Cyan
Write-Host " "
Write-Host "=============================================" -ForegroundColor Yellow
Write-Host "============== @gaetanvillant ===============" -ForegroundColor Yellow
Write-Host "=============================================" -ForegroundColor Yellow
Write-Host "1: Zero-Touch Win10 21H1 | English | Enterprise"-ForegroundColor Yellow
Write-Host "2: Zero-Touch Win10 21H1 | French  | Enterprise"-ForegroundColor Yellow
Write-Host "3: Zero-Touch Win10 20H2 | English | Enterprise" -ForegroundColor Yellow
Write-Host "4: Give me more choice ... "-ForegroundColor Yellow
Write-Host "5: Start-OSDCloudGUI "-ForegroundColor Yellow
Write-Host "6: Start-OSDCloudWIM (DELL Generic WIMs)"-ForegroundColor Yellow
Write-Host "7: Exit`n"-ForegroundColor Yellow
$input = Read-Host "Please make a selection"

Write-Host  -ForegroundColor Yellow "Loading OSDCloud..."

#Connect Azure Storage file share for custom DELL WIM access
cmd.exe /C "c:\windows\system32\cmdkey.exe /add:`"osdcloud.file.core.windows.net`" /user:`"localhost\osdcloud`" /pass:`"BckU9jeGTOtkSjQ56byVkbFYYTFkvtqte2NPPpjt5bsuK930Licjim7R39/FGzs3GxTmot3r7wLT2g62+pRlLg==`""
# Mount the drive
New-PSDrive -Name O -PSProvider FileSystem -Root "\\osdcloud.file.core.windows.net\osdcloud-fs"

switch ($input)
{
    '1' { Start-OSDCloud -OSLanguage en-us -OSBuild 21H1 -OSEdition Enterprise -ZTI } 
    '2' { Start-OSDCloud -OSLanguage fr-fr -OSBuild 21H1 -OSEdition Enterprise -ZTI } 
    '3' { Start-OSDCloud -OSLanguage en-us -OSBuild 20H2 -OSEdition Enterprise -ZTI } 
    '4' { Start-OSDCloud } 
    '5' { Start-OSDCloudGUI } 
    '6' { Start-OSDCloudWIM } 
    '7' { Exit }
}

wpeutil reboot
