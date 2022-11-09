<#
.SYNOPSIS
Install OSDCloud prerequisites, create the OSDCloud workspace and build the ISO 
OSDCloud module created by David Segura - https://osdcloud.osdeploy.com/
This script is an improvment of Brooks Peppin initial script.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
.DESCRIPTION
Install OSDCloud prerequisites (ADK, WinPE Addon), installs the OSDCloud module, create the OSDCloud workspace and build the ISO and USB
.PARAMETER ADK
Download and install ADK and WinPE Addon
.PARAMETER New
Install latest OSDCloud module version and create a template  
.PARAMETER WifiSupport
Enable Wifi support (require Winre)
.PARAMETER Workspace
Specify the workspace location 
.PARAMETER WebPSScript
Specify the WebPSScript URL
.PARAMETER WebPSScriptGaetan
Use the Gaëtan Demo WebPSScript 
.PARAMETER Wallpaper
Specify the wallpaper to inject in the Boot image C:\OSDCloud\Wallpaper.jpg 
.PARAMETER BuildISO
Build ISOs
.PARAMETER BuildUSB
Build USB dongle
.EXAMPLE
.\Starter-OSDCloud.ps1 -ADK -New -Workspace C:\OSDCloud -WebPSScriptGaetan -Wallpaper C:\Tmp\DellServices2021_HQ.jpg -BuildISO
- Download and install ADK and WinPe Addon (version 10.1.22000.1)
- Install module OSD (-new = force module installation)
- Create a new OSDCloud Workspace to C:\OSDCloud
- Inject my custom WebPSScript (https://raw.githubusercontent.com/gvillant/OSDCloud/main/Gaetan-OSDCloud.ps1)
- Set the Dell Services Wallpaper
- Build ISOs (one with prompt, one without prompt)
.EXAMPLE
.\Starter-OSDCloud.ps1 -ADK -New -Workspace C:\OSDCloud -BuildUSB
#>

[CmdletBinding()]
param (
    [switch]$ADK,
    [switch]$New,
    [switch]$WifiSupport,
    [string]$Workspace,
    [string]$WebPSScript,
    [switch]$WebPSScriptGaetan,
    [string]$Wallpaper,
    [switch]$BuildISO,
    [switch]$BuildUSB
)

#Install ADK and WinPE ADK
If($ADK){
    # URLs for ADK Windows 11 - 10.1.22000.1
    $ADKVersion = "10.1.22000.1 - Windows 11"
    $ADKSetupURL = "https://go.microsoft.com/fwlink/?linkid=2165884" 
    $ADKWinPESetupURL = "https://go.microsoft.com/fwlink/?linkid=2166133"
    $downloads = "$env:USERPROFILE\downloads"

    # ADK
    Write-Host "Downloading ADKsetup.exe $ADKVersion ..."
    Invoke-WebRequest $ADKSetupURL -OutFile $downloads\adksetup.exe
    Write-Host "Installing ADK ..."
    start-process -FilePath "$downloads\adksetup.exe" -ArgumentList "/quiet /features OptionId.DeploymentTools" -Wait
    
    # ADK WinPE Addon
    Write-Host "Downloading ADKWinpesetup.exe $ADKVersion ..."
    Invoke-WebRequest $ADKWinPESetupURL -OutFile $downloads\adkwinpesetup.exe
    Write-Host "Installing ADK WinPE add-on"
    start-process -FilePath "$downloads\adkwinpesetup.exe" -ArgumentList "/quiet /features OptionId.WindowsPreinstallationEnvironment" -Wait
}

if($New){
    Write-Host "Installing OSDCloud Powershell Module"
    Install-Module OSD -Force
    
    if($WifiSupport){
        Write-Host "Setting up OSDCloud template with wifi support (WinRE)..."
        New-OSDCloudTemplate -winre -Verbose
    } else {
        Write-Host "Setting up OSDCloud template without wifi support (WinPE)..."
        New-OSDCloudTemplate -Verbose
    }

}
if($Workspace){
    New-OSDCloudWorkspace -WorkspacePath $Workspace
}

$Params = @{}

if($WifiSupport){
    Write-Host "Injecting drivers with wifi support"
    $Params["CloudDriver"] = 'Dell','VMware','WiFi'

} else {
    Write-Host "Injecting drivers without wifi support"
    $Params["CloudDriver"] = 'Dell','VMware'
}

if($WebPSScript){
    Write-Host "Will use custom WebPSScript: $WebPSScript"
    $Params["WebPSScript"] = $WebPSScript 
}

if($WebPSScriptGaetan){
    $CustomGaetanURL = "https://raw.githubusercontent.com/gvillant/OSDCloud/main/Gaetan-OSDCloud.ps1"
    Write-Host "Will use custom WebPSScript: $CustomGaetanURL"
    $Params["WebPSScript"] = $CustomGaetanURL
}

if($Wallpaper){
    Write-Host "Injecting Wallpaper $Wallpaper"
    $Params["Wallpaper"] = $Wallpaper 
}

Edit-OSDCloudWinpe @Params

if($BuildISO){
    New-OSDCloudISO
}

if($BuildUSB){
    New-OSDCloudUSB
}
