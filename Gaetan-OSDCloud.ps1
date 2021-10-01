Write-Host  -ForegroundColor Yellow "Starting Gaëtan @ Dell Custom OSDCloud ..."
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
Write-Host "1: Zero-Touch Win11      | English | Enterprise"-ForegroundColor Yellow
Write-Host "2: Zero-Touch Win10 21H1 | English | Enterprise"-ForegroundColor Yellow
Write-Host "3: Zero-Touch Win10 21H1 | French  | Enterprise"-ForegroundColor Yellow
Write-Host "4: Zero-Touch Win10 20H2 | English | Enterprise" -ForegroundColor Yellow
Write-Host "5: I'll select it myself"-ForegroundColor Yellow
Write-Host "6: Exit`n"-ForegroundColor Yellow
$input = Read-Host "Please make a selection"

Write-Host  -ForegroundColor Yellow "Loading OSDCloud..."

Import-Module OSD -Force
Install-Module OSD -Force

switch ($input)
{
    '1' { Start-OSDCloud -OSLanguage en-us -OSBuild 21H1 -OSEdition Enterprise -ZTI } 
    '2' { Start-OSDCloud -OSLanguage en-us -OSBuild 21H1 -OSEdition Enterprise -ZTI } 
    '3' { Start-OSDCloud -OSLanguage fr-fr -OSBuild 21H1 -OSEdition Enterprise -ZTI } 
    '4' { Start-OSDCloud -OSLanguage en-us -OSBuild 20H2 -OSEdition Enterprise -ZTI } 
    '5' { Start-OSDCloud	} 
    '6' { Exit		}
}

wpeutil reboot
