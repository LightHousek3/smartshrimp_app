@echo off
setlocal
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0tool\run.ps1" %*
exit /b %ERRORLEVEL%
