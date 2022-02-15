cls
Write-Host "================ Main Menu ==================" -ForegroundColor Yellow
Write-Host " "
Write-Host "=============================================" -ForegroundColor Yellow
Write-Host "============== @gaetanvillant ===============" -ForegroundColor Yellow
Write-Host "=============================================`n" -ForegroundColor Yellow
Write-Host "1: Win10 21H1 | English | Enterprise (Windows Update ESD file)" -ForegroundColor Yellow
Write-Host "2: Win10 20H2 | English | Enterprise (Windows Update ESD file) + WS1 DS Online 3.2 + WinRE" -ForegroundColor Yellow
Write-Host "3: Win11 | English | Enterprise (Windows Update ESD file)" -ForegroundColor Yellow
Write-Host "4: Start the graphical OSDCloud (Start-OSDCloudGUI)" -ForegroundColor Yellow
Write-Host "9: Exit`n"-ForegroundColor Yellow

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

switch ($input)
{
    '1' { Start-OSDCloud -OSLanguage en-us -OSBuild 21H1 -OSEdition Enterprise -ZTI } 
    '2' { 
        Start-OSDCloud -OSLanguage en-us -OSBuild 20H2 -OSEdition Enterprise -ZTI
        $GenericPPKGURL = "http://osd.gaetanvillant.com:8888/_WS1/GenericPPKG.zip"
        $AuditUnattendXML = "https://raw.githubusercontent.com/gvillant/OSDCloud/main/unattend_ws1_DropShip.xml"
        $GenericPPKGDestPath = "C:\Temp"
        #Get Dropship Generic PPKG
        Save-WebFile -SourceURL $GenericPPKGURL -DestinationName "GenericPPKG.zip" -DestinationDirectory $GenericPPKGDestPath
        Expand-Archive $GenericPPKGDestPath\GenericPPKG.zip $GenericPPKGDestPath
        #Stage Audit_unattend file 
        Save-WebFile -SourceURL $AuditUnattendXML -DestinationName "Unattend.xml" -DestinationDirectory "C:\Windows\panther\Unattend"
        #read-host "Press ENTER to continue..."        
        Create-WinREPartition   
        } 
    '3' { #Win11
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
    '4' { Start-OSDCloudGUI } 
    '9' { Exit }
}

wpeutil reboot
