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
Write-Host "1: Win10 21H1 | English | Enterprise (Windows Update ESD file)" -ForegroundColor Yellow
Write-Host "2: Win10 21H1 | French  | Enterprise (Windows Update ESD file)" -ForegroundColor Yellow
Write-Host "3: Win10 20H2 | English | Enterprise (Windows Update ESD file)" -ForegroundColor Yellow
Write-Host "4: Start the legacy OSDCloud CLI (Start-OSDCloud)" -ForegroundColor Yellow
Write-Host "5: Start the graphical OSDCloud (Start-OSDCloudGUI)" -ForegroundColor Yellow
Write-Host "6: Win10 Custom WIMs (Azure storage file share)" -ForegroundColor Yellow
Write-Host "7: Exit`n"-ForegroundColor Yellow

Write-Host "`n DISCLAIMER: USE AT YOUR OWN RISK - Going further will erase all data on your disk ! `n"-ForegroundColor Red

$input = Read-Host "Please make a selection"

switch ($input)
{
    '1' { Start-OSDCloud -OSLanguage en-us -OSBuild 21H1 -OSEdition Enterprise -ZTI } 
    '2' { Start-OSDCloud -OSLanguage fr-fr -OSBuild 21H1 -OSEdition Enterprise -ZTI } 
    '3' { Start-OSDCloud -OSLanguage en-us -OSBuild 20H2 -OSEdition Enterprise -ZTI } 
    '4' { Start-OSDCloud } 
    '5' { Start-OSDCloudGUI } 
    '6' { 
        #Connect Azure Storage file share for custom DELL WIM access
        Write-Host  -ForegroundColor Yellow "Connect to Azure File Share ..."
        cmd.exe /C "c:\windows\system32\cmdkey.exe /add:`"osdcloud.file.core.windows.net`" /user:`"localhost\osdcloud`" /pass:`"BckU9jeGTOtkSjQ56byVkbFYYTFkvtqte2NPPpjt5bsuK930Licjim7R39/FGzs3GxTmot3r7wLT2g62+pRlLg==`""
        # Mount the drive
        Write-Host  -ForegroundColor Yellow "Mount drive O:"
        New-PSDrive -Name O -PSProvider FileSystem -Root "\\osdcloud.file.core.windows.net\osdcloud-fs"
        Start-OSDCloud -FindImageFile -ZTI
        } 
    '7' { Exit }
}

wpeutil reboot
