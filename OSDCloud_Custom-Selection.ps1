cls
Write-Host "================ Main Menu ==================" -ForegroundColor Yellow
Write-Host "=============================================" -ForegroundColor Yellow
Write-Host "============== @gaetanvillant ===============" -ForegroundColor Yellow
Write-Host "========== gaetan_villant@dell.com ==========" -ForegroundColor Yellow
Write-Host "=============================================`n" -ForegroundColor Yellow
Write-Host "1: Win10 21H1 | English | Enterprise (Windows Update ESD file)" -ForegroundColor Yellow
Write-Host "2: Win10 21H1 | French  | Enterprise (Windows Update ESD file)" -ForegroundColor Yellow
Write-Host "3: Win10 20H2 | English | Enterprise (Windows Update ESD file)" -ForegroundColor Yellow
Write-Host "4: Win11 | English | Enterprise (Windows Update ESD file)" -ForegroundColor Yellow
Write-Host "5: Start the legacy OSDCloud CLI (Start-OSDCloud)" -ForegroundColor Yellow
Write-Host "6: Start the graphical OSDCloud (Start-OSDCloudGUI)" -ForegroundColor Yellow
Write-Host "7: Windows Custom WIMs (Azure storage file share)" -ForegroundColor Yellow
Write-Host "8: Win10 Custom WIMs (HTTP Server Wim File - ImageFileUrl)" -ForegroundColor Yellow
Write-Host "9: Exit`n"-ForegroundColor Yellow

Write-Host "`n DISCLAIMER: USE AT YOUR OWN RISK - Going further will erase all data on your disk ! `n"-ForegroundColor Red

$input = Read-Host "Please make a selection"

switch ($input)
{
    '1' { Start-OSDCloud -OSLanguage en-us -OSBuild 21H1 -OSEdition Enterprise -ZTI } 
    '2' { Start-OSDCloud -OSLanguage fr-fr -OSBuild 21H1 -OSEdition Enterprise -ZTI } 
    '3' { Start-OSDCloud -OSLanguage en-us -OSBuild 20H2 -OSEdition Enterprise -ZTI } 
    '4' { 
        #Win11
        $Global:StartOSDCloudGUI = $null
        $Global:StartOSDCloudGUI = [ordered]@{
            ApplyManufacturerDrivers    = $true
            ApplyCatalogDrivers         = $false
            ApplyCatalogFirmware        = $false
            AutopilotJsonChildItem      = $false
            AutopilotJsonItem           = $false
            AutopilotJsonName           = $false
            AutopilotJsonObject         = $false
            AutopilotOOBEJsonChildItem  = $false
            AutopilotOOBEJsonItem       = $false
            AutopilotOOBEJsonName       = $false
            AutopilotOOBEJsonObject     = $false
            ImageFileFullName           = $false
            ImageFileItem               = $false
            ImageFileName               = $false
            #Manufacturer                = $formMainWindowControlCSManufacturerTextbox.Text
            OOBEDeployJsonChildItem     = $false
            OOBEDeployJsonItem          = $false
            OOBEDeployJsonName          = $false
            OOBEDeployJsonObject        = $false
            OSBuild                     = '21H2'
            OSEdition                   = 'Enterprise'
            OSImageIndex                = 1
            OSLanguage                  = 'en-us'
            OSLicense                   = 'Volume'
            OSVersion                   = 'Windows 11'
            #Product                     = $formMainWindowControlCSProductTextbox.Text
            Restart                     = $true
            SkipAutopilot               = $false
            SkipAutopilotOOBE           = $false
            SkipODT                     = $true
            SkipOOBEDeploy              = $false
            ZTI                         = $true
            }
        #$Global:StartOSDCloudGUI | Out-Host
        Start-OSDCloud
        }
    '5' { Start-OSDCloud } 
    '6' { Start-OSDCloudGUI } 
    '7' { 
        #Connect Azure Storage file share for custom DELL WIM access
        Write-Host  -ForegroundColor Yellow "Connect to Azure File Share ..."
        cmd.exe /C "c:\windows\system32\cmdkey.exe /add:`"YourShare.file.core.windows.net`" /user:`"localhost\YourShare`" /pass:`"YourKey`""
        # Mount the drive
        Write-Host  -ForegroundColor Yellow "Mount drive O:"
        New-PSDrive -Name O -PSProvider FileSystem -Root "\\YourShare.file.core.windows.net\YourShare-fs"
        Start-OSDCloud -FindImageFile -ZTI
        } 
    '8' { 
        # Win10 Custom WIMs (HTTP Server Wim File)
        $ImageFileUrl = "http://yourwebserver.com/_Wim/2004_en_us_388.wim"
        Write-Host "ImageFileURL = $ImageFileUrl" -ForegroundColor Green
        Start-OSDCloud -ImageFileUrl $ImageFileUrl -ImageIndex 1 -Zti
     } 
    '9' { Exit }
}

#Reboot to OS
wpeutil reboot
