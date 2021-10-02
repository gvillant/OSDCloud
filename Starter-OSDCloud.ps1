# OSDCloud starter kit 
# OSDCloud module created by David Segura
# https://osdcloud.osdeploy.com/get-started
# initially developped by Brooks Peppin
# improved by Gaëtan Villant
#--------------------------------------------
#----------------Pre-Reqs--------------------
#--------------------------------------------
[CmdletBinding()]
param (
    [switch]$ADK,
    [switch]$New,
    [switch]$WifiSupport,
    [string]$Workspace,
    [string]$CustomURL,
    [switch]$CustomGaetanURL,
    [string]$Wallpaper,
    [switch]$BuildISO,
    [switch]$BuildUSB
)


#Install Win10 ADK and WinPE ADK
If($ADK){
    Write-Host "Downloading ADKsetup.exe (10.1.22000.1)..."
    $downloads = "$env:USERPROFILE\downloads"
    Invoke-WebRequest "https://go.microsoft.com/fwlink/?linkid=2165884" -OutFile $downloads\adksetup.exe
    
    Write-Host "Installing ADK for Windows 10"
    start-process -FilePath "$downloads\adksetup.exe" -ArgumentList "/quiet /features OptionId.DeploymentTools" -Wait
    
    Write-Host "Downloading ADKWinpesetup.exe (10.1.22000.1)..."
    Invoke-WebRequest "https://go.microsoft.com/fwlink/?linkid=2166133" -OutFile $downloads\adkwinpesetup.exe
    Write-Host "Installing ADK WinPE for Windows 10"
    start-process -FilePath "$downloads\adkwinpesetup.exe" -ArgumentList "/quiet /features OptionId.WindowsPreinstallationEnvironment" -Wait
}

if($New){
    Write-Host "Installing OSDCloud Powershell Module"
    Install-Module OSD -Force
    
    if($WifiSupport){
        Write-Host "Setting up OSDCloud template with wifi support (WinRE)..."
        New-OSDCloud.template -winre -Verbose
    } else {
        Write-Host "Setting up OSDCloud template without wifi support (WinPE)..."
        New-OSDCloud.template -Verbose
    }

}
if($Workspace){
    New-OSDCloud.workspace -WorkspacePath $Workspace
}

if($WifiSupport){
    Write-Host "Injecting drivers with wifi support"
    Edit-OSDCloud.winpe -CloudDriver 'Dell','VMware','WiFi' 
} else {
    Write-Host "Injecting drivers without wifi support"
    Edit-OSDCloud.winpe -CloudDriver 'Dell','VMware'
}


Edit-OSDCloud.winpe -CloudDriver 'Dell','VMware','WiFi' 

if($CustomURL){
    Edit-OSDCloud.winpe -WebPSScript $CustomURL 
}

if($CustomGaetanURL){
    Edit-OSDCloud.winpe -WebPSScript "https://raw.githubusercontent.com/gvillant/OSDCloud/main/Gaetan-OSDCloud.ps1" 
}

if($Wallpaper){
    Edit-OSDCloud.winpe Wallpaper $Wallpaper # C:\OSDCloud\Wallpaper.jpg ? 
}

if($BuildISO){
    New-OSDCloud.iso
}

if($BuildUSB){
    New-OSDCloud.usb
}