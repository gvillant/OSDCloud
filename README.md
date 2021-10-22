# My OSDCloud scripts

## ⚙️ Starter-OSDCloud.ps1
Example: 

**.\Starter-OSDCloud.ps1 -ADK -New -Workspace C:\OSDCloud -WebPSScriptGaetan -Wallpaper C:\Tmp\DellServices2021_HQ.jpg -BuildISO**
- Download and install ADK and WinPe Addon (version 10.1.22000.1)
- Install module OSD (-new = force module installation) 
- Create a new OSDCloud Workspace to C:\OSDCloud 
- Inject my custom WebPSScript (https://raw.githubusercontent.com/gvillant/OSDCloud/main/Gaetan-OSDCloud.ps1)
- Set the Dell Services Wallpaper
- Build ISOs (one with prompt, one without prompt)
