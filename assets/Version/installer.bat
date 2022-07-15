@echo off
taskkill /F /IM desktop_test.exe
set arg1=%1
powershell.exe Add-AppxPackage -Path '%arg1%\out\desktop_test.msix'
timeout 3
powershell.exe start "shell:AppsFolder\$(Get-AppxPackage 'desktop_test' | select -ExpandProperty PackageFamilyName)!desktop_test"