#Temporary Custom script
#Invoke-WebPSScript -WebPSScript https://raw.githubusercontent.com/gvillant/OSDCloud/main/OSDCloud_Custom-ImageFileUrl.ps1
#wpeutil reboot

cls
Write-Host "================ Main Menu ==================" -ForegroundColor Yellow
Write-Host " "
Write-Host "=============================================" -ForegroundColor Yellow
Write-Host "============== @gaetanvillant ===============" -ForegroundColor Yellow
Write-Host "========== gaetan_villant@dell.com ==========" -ForegroundColor Yellow
Write-Host "=============================================`n" -ForegroundColor Yellow
Write-Host "1: Win10 21H1 | English | Enterprise (Windows Update ESD file)" -ForegroundColor Yellow
Write-Host "2: Win10 20H2 | English | Enterprise (Windows Update ESD file) + WS1 DS Online 3.3" -ForegroundColor Yellow
Write-Host "3: Win10 20H2 | English | Enterprise (Windows Update ESD file) + WS1 DS Online 3.2" -ForegroundColor Yellow
Write-Host "4: Win11 | English | Enterprise (Windows Update ESD file)" -ForegroundColor Yellow
Write-Host "5: Start the legacy OSDCloud CLI (Start-OSDCloud)" -ForegroundColor Yellow
Write-Host "6: Start the graphical OSDCloud (Start-OSDCloudGUI)" -ForegroundColor Yellow
Write-Host "7: Windows Custom WIMs (Azure storage file share)" -ForegroundColor Yellow
Write-Host "8: Win10 Custom WIMs (HTTP Server Wim File - ImageFileUrl)" -ForegroundColor Yellow
Write-Host "9: Server 2022 Std Gui (HTTP Server Wim File - ImageFileUrl)" -ForegroundColor Yellow
Write-Host "10: Exit`n"-ForegroundColor Yellow
Write-Host "11: Win10 20H2 | FRENCH | Enterprise (Windows Update ESD file) + WS1 DS Online 3.3" -ForegroundColor Yellow
Write-Host "12: Win11 | English | Enterprise (Windows Update ESD file) + WS1 DS Online 3.3" -ForegroundColor Yellow
Write-Host "13: Win10 21H2 | English | Enterprise (Windows Update ESD file) + WS1 DS Offline + Custom PPKG" -ForegroundColor Yellow

Write-Host "`n DISCLAIMER: USE AT YOUR OWN RISK - Going further will erase all data on your disk ! `n"-ForegroundColor Red

$input = Read-Host "Please make a selection"

function Create-WinREPartition {
	$DiskpartFilePath = "C:\OSDCloud"
	$DiskpartLog = "C:\OSDCloud\diskpart.log"
	$DiskpartFile = "recovery.txt"
	$FileExist = Test-Path -Path $DiskpartFilePath\$DiskpartFile -PathType Leaf
	if ($FileExist -eq $False) {
	   New-Item -Path $DiskpartFilePath -Name $DiskpartFile -ItemType file -force | Out-Null
	}
	Else {
		Remove-Item -Path $DiskpartFilePath\$DiskpartFile
		New-Item -Path $DiskpartFilePath -Name $DiskpartFile -ItemType file -force | Out-Null
	}
	#Build recovery.txt file
	Add-Content -path $DiskpartFilePath\$DiskpartFile -Value "select disk 0"
	Add-Content -path $DiskpartFilePath\$DiskpartFile -Value "select partition 3"
	Add-Content -path $DiskpartFilePath\$DiskpartFile -Value 'Shrink minimum=2048'
	Add-Content -path $DiskpartFilePath\$DiskpartFile -Value 'create partition primary'
	Add-Content -path $DiskpartFilePath\$DiskpartFile -Value 'format quick fs=ntfs label=WinRE'
	Add-Content -path $DiskpartFilePath\$DiskpartFile -Value 'Set id="de94bba4-06d1-4d40-a16a-bfd50179d6ac"'
	Add-Content -path $DiskpartFilePath\$DiskpartFile -Value 'gpt attributes=0x8000000000000001' 
	Add-Content -path $DiskpartFilePath\$DiskpartFile -Value 'exit diskpart'
	# Execute diskpart file recovery.txt
	Write-host "- Executing diskpart file recovery.txt ..."
	$CMD2Run="C:\Windows\System32\Diskpart.exe"
	$CMDArgs = "/s $($DiskpartFilePath)\$($DiskpartFile)"
	Write-host  " Execute Command: [$CMD2Run $CMDArgs]"
	$Command = Start-Process -WindowStyle Hidden -FilePath $CMD2Run -ArgumentList $CMDArgs -RedirectStandardOutput $DiskpartLog -Wait -PassThru; $Command.ExitCode
	$ReturnCode = $Command.ExitCode
	Write-host  " Return Code: $ReturnCode"
	if (!($ReturnCode -eq 0)) {
		Write-host  " Failed to run Command: [$CMD2Run $CMDArgs]. Return Code=$ReturnCode. Exit process"	
		Exit $ReturnCode
	}
	Write-host " Pausing for 5 seconds before next action. Please wait..."
	sleep -seconds 5
}

function Install-WS1DropShipOnline32 {
	$GenericPPKGURL = "http://osd.gaetanvillant.com:8888/_WS1/GenericPPKG.zip"
    $AuditUnattendXML = "https://raw.githubusercontent.com/gvillant/OSDCloud/main/unattend_ws1_DropShip.xml"
    $GenericPPKGDestPath = "C:\Temp"
    #Get Dropship Generic PPKG
    Save-WebFile -SourceURL $GenericPPKGURL -DestinationName "GenericPPKG.zip" -DestinationDirectory $GenericPPKGDestPath
    Expand-Archive $GenericPPKGDestPath\GenericPPKG.zip $GenericPPKGDestPath
    #Stage Audit_unattend file 
    Save-WebFile -SourceURL $AuditUnattendXML -DestinationName "Unattend.xml" -DestinationDirectory "C:\Windows\panther\Unattend"
    #read-host "Press ENTER to continue..."        
}

function Install-WS1DropShipOnline33 {
	$GenericPPKGURL = "http://osd.gaetanvillant.com:8888/_WS1/GenericPPKG_3-3.zip"
    $AuditUnattendXML = "https://raw.githubusercontent.com/gvillant/OSDCloud/main/unattend_ws1_DropShip.xml"
    $GenericPPKGDestPath = "C:\Temp\VMware"
    #Get Dropship Generic PPKG
    Save-WebFile -SourceURL $GenericPPKGURL -DestinationName "GenericPPKG.zip" -DestinationDirectory $GenericPPKGDestPath
    Expand-Archive $GenericPPKGDestPath\GenericPPKG.zip $GenericPPKGDestPath
    #Stage Audit_unattend file 
    Save-WebFile -SourceURL $AuditUnattendXML -DestinationName "Unattend.xml" -DestinationDirectory "C:\Windows\panther\Unattend"
    #read-host "Press ENTER to continue..."        
}

function Install-WS1DropShipOffline {
	$ProvToolURL = "http://osd.gaetanvillant.com:8888/_WS1/VMwareWS1ProvisioningTool%203.3%20GA.zip"
    $BatFileURL = "http://osd.gaetanvillant.com:8888/_WS1/RunPPKGandXML.bat"
	$CustomPPKGURL = "http://osd.gaetanvillant.com:8888/_WS1/Custom.ppkg"
    $CustomUnattend = "http://osd.gaetanvillant.com:8888/_WS1/Custom_Unattend.xml"
    $AuditUnattendXML = "https://raw.githubusercontent.com/gvillant/OSDCloud/main/unattend_ws1_DropShip.xml"
    $WorkingPath = "C:\Temp\VMware"
    #Get Dropship files
    Save-WebFile -SourceURL $ProvToolURL -DestinationName "VMwareWS1ProvisioningTool_3.3.zip" -DestinationDirectory $WorkingPath
    Expand-Archive "$WorkingPath\VMwareWS1ProvisioningTool_3.3.zip" $WorkingPath
    Save-WebFile -SourceURL $BatFileURL -DestinationName "RunPPKGandXML.bat" -DestinationDirectory $WorkingPath
    Save-WebFile -SourceURL $CustomPPKGURL -DestinationName "CP-Generic-Package.ppkg" -DestinationDirectory $WorkingPath
    Save-WebFile -SourceURL $CustomUnattend -DestinationName "Unattend.xml" -DestinationDirectory $WorkingPath
    Save-WebFile -SourceURL $AuditUnattendXML -DestinationName "Unattend.xml" -DestinationDirectory "C:\Windows\panther\Unattend"
    
    #read-host "Press ENTER to continue..."        
}

switch ($input)
{
    '1' { Start-OSDCloud -OSLanguage en-us -OSBuild 21H1 -OSEdition Enterprise -ZTI } 
    '2' { 
        Start-OSDCloud -OSLanguage en-us -OSBuild 20H2 -OSEdition Enterprise -ZTI
        Install-WS1DropShipOnline33
	Create-WinREPartition   
        } 
    '3' { 
        Start-OSDCloud -OSLanguage en-us -OSBuild 20H2 -OSEdition Enterprise -ZTI
        Install-WS1DropShipOnline32
	Create-WinREPartition   
        } 
    '4' { #Win11
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
        cmd.exe /C "c:\windows\system32\cmdkey.exe /add:`"osdcloud.file.core.windows.net`" /user:`"localhost\osdcloud`" /pass:`"BckU9jeGTOtkSjQ56byVkbFYYTFkvtqte2NPPpjt5bsuK930Licjim7R39/FGzs3GxTmot3r7wLT2g62+pRlLg==`""
        # Mount the drive
        Write-Host  -ForegroundColor Yellow "Mount drive O:"
        New-PSDrive -Name O -PSProvider FileSystem -Root "\\osdcloud.file.core.windows.net\osdcloud-fs"
        Start-OSDCloud -FindImageFile -ZTI
        } 
    '8' { 
        # Win10 Custom WIMs (HTTP Server Wim File)
        $ImageFileUrl = "http://osd.gaetanvillant.com:8888/_Wim/2004_en_us_388.wim" #"http://osd.gaetanvillant.com:8888/20h2_en_us_wer.wim"
        Write-Host "ImageFileURL = $ImageFileUrl" -ForegroundColor Green
        Start-OSDCloud -ImageFileUrl $ImageFileUrl -ImageIndex 1 -Zti
     } 
     
    '9' { 
        # Server 2022 WIM (HTTP Server ISO File)
        $ImageFileUrl = "http://osd.gaetanvillant.com:8888/_Wim/en-us_windows_server_version_2022_updated_october_2021_x64.wim"
        Write-Host "ImageFileURL = $ImageFileUrl" -ForegroundColor Green
        Start-OSDCloud -ImageFileUrl $ImageFileUrl -ImageIndex 2 -Zti
     } 
    '10' { Exit }
    '11' { 
        Start-OSDCloud -OSLanguage fr-fr -OSBuild 20H2 -OSEdition Enterprise -ZTI
        Install-WS1DropShipOnline33
	#Create-WinREPartition   
     } 
    '12' { #Win11 + ws1 3.3
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
        Install-WS1DropShipOnline33
	#Create-WinREPartition   
        } 
    '13' { #Win10 + Dropship Offline
        Start-OSDCloud -OSLanguage en-us -OSBuild 21H2 -OSEdition Enterprise -ZTI
        Install-WS1DropShipOffline
    #Create-WinREPartition   
        } 
}

wpeutil reboot
