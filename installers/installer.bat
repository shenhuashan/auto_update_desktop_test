@ECHO off
cd %~dp0
for /r .\ %%a in (*) do if "%%~nxa"=="installer.ps1" set p=%%~dpnxa
if defined p (
start powershell.exe -executionpolicy bypass -file .\installer.ps1
) else (
echo File not found
)