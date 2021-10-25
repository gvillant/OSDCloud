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
Write-Host "========== gaetan_villant@dell.com ==========" -ForegroundColor Yellow
Write-Host "=============================================`n" -ForegroundColor Yellow

Write-Host "`n DISCLAIMER: USE AT YOUR OWN RISK - Going further will erase all data on your disk ! `n"-ForegroundColor Red

#Prompt for confirmation
$title    = 'Warning'
$question = 'Are you sure you want to proceed? All data will be deleted and a new OS will be installed'
$choices  = '&Yes', '&No'

$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
if ($decision -eq 0) {
    Write-Host 'Operation confirmed by user: OSD Cloud is starting' -ForegroundColor Yellow
} else {
    Write-Host 'Operation cancelled by user'
    exit
}

Start-OSDCloud -ImageFileUrl http://osd.gaetanvillant.com:8888/20h2_en_us_wer.wim -ImageIndex 1 -Zti

#reboot to OS
wpeutil reboot
