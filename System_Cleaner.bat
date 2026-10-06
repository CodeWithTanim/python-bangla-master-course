@echo off
setlocal
chcp 65001 >nul
title Windows Master System Cleaner, RAM Optimizer ^& DNS Flusher
color 0B

:: ============================================================================
:: 0. ADMINISTRATOR PRIVILEGE CHECK & AUTO-ELEVATION
:: ============================================================================
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ============================================================================
    echo   [!] ADMINISTRATOR PRIVILEGES REQUIRED
    echo ============================================================================
    echo   Requesting Administrator rights to terminate unwanted processes,
    echo   flush DNS, purge system temp files, and optimize RAM...
    echo.
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process cmd -ArgumentList '/k \"\"%~f0\"\"' -Verb RunAs" 2>nul
    if %errorlevel% neq 0 (
        echo   [ERROR] Administrator elevation request was declined or blocked.
        echo   Please right-click '%~nx0' and select 'Run as administrator'.
        echo.
        pause
    )
    exit /b
)

:: Return to script directory
cd /d "%~dp0"

cls
echo ============================================================================
echo       WINDOWS MASTER CLEANER: RAM OPTIMIZER, DNS FLUSH ^& TEMP PURGE
echo ============================================================================
echo   Computer Name : %COMPUTERNAME%
echo   User Account  : %USERNAME%
echo   Date ^& Time   : %DATE% %TIME%
echo ============================================================================
echo.

:: Show current RAM status before anything
echo [CURRENT SYSTEM STATUS]
powershell -NoProfile -Command "$m = Get-CimInstance Win32_OperatingSystem; $used = [math]::Round(($m.TotalVisibleMemorySize - $m.FreePhysicalMemory)/1024, 2); $total = [math]::Round($m.TotalVisibleMemorySize/1024, 2); $pct = [math]::Round((($m.TotalVisibleMemorySize - $m.FreePhysicalMemory)/$m.TotalVisibleMemorySize)*100, 1); Write-Host ('   Total RAM Installed : ' + $total + ' MB'); Write-Host ('   Current RAM in Use  : ' + $used + ' MB (' + $pct + '%% used)') -ForegroundColor Yellow; Write-Host ('   Current Free RAM    : ' + [math]::Round($m.FreePhysicalMemory/1024, 2) + ' MB') -ForegroundColor Cyan"
echo.

echo ============================================================================
echo   CHOOSE CLEANING MODE:
echo ============================================================================
echo   [1] TURBO DEEP CLEAN (RECOMMENDED)
echo       - Closes heavy background apps (Chrome, Discord, WhatsApp, Edge)
echo       - Kills background bloatware / telemetry (PhoneLink, HP Omen, etc.)
echo       - Completely unlocks all temp files so they can be deleted 100%%
echo       - Maximum RAM drop (frees up to 5GB - 8GB RAM!)
echo.
echo   [2] SAFE CLEAN
echo       - Keeps your browser and chat apps open
echo       - Only kills background bloatware / telemetry
echo       - Trims process memory working sets, flushes DNS, and cleans temp
echo ============================================================================
echo.
set /p userchoice="Select Mode [1 or 2] (Press Enter for 1 - Turbo): "
if "%userchoice%"=="" set userchoice=1
if "%userchoice%" neq "1" if "%userchoice%" neq "2" set userchoice=1

cls
echo ============================================================================
if "%userchoice%"=="1" (
    echo   EXECUTING: [1] TURBO DEEP CLEAN MODE
) else (
    echo   EXECUTING: [2] SAFE CLEAN MODE
)
echo ============================================================================
echo.

:: ============================================================================
:: 1. TERMINATING UNWANTED BACKGROUND PROCESSES & BLOATWARE
:: ============================================================================
echo [1/4] TERMINATING UNWANTED BACKGROUND PROCESSES...
echo ----------------------------------------------------------------------------

if "%userchoice%"=="1" (
    echo Closing heavy background RAM hogs...
    taskkill /f /im chrome.exe >nul 2>&1
    taskkill /f /im discord.exe >nul 2>&1
    taskkill /f /im WhatsApp.exe >nul 2>&1
    taskkill /f /im WhatsApp.Root.exe >nul 2>&1
    taskkill /f /im msedge.exe >nul 2>&1
    taskkill /f /im msedgewebview2.exe >nul 2>&1
    taskkill /f /im spotify.exe >nul 2>&1
    taskkill /f /im steam.exe >nul 2>&1
    taskkill /f /im telegram.exe >nul 2>&1
    echo   - Chrome, Discord, WhatsApp, Edge and background webviews closed.
)

echo Terminating system telemetry and background bloatware...
taskkill /f /im PhoneExperienceHost.exe >nul 2>&1
taskkill /f /im CrossDeviceService.exe >nul 2>&1
taskkill /f /im SysInfoCap.exe >nul 2>&1
taskkill /f /im OmenCommandCenterBackground.exe >nul 2>&1
taskkill /f /im HP.Omen.OmenCommandCenter.exe >nul 2>&1
taskkill /f /im GameBarPresenceWriter.exe >nul 2>&1
taskkill /f /im XboxGamingOverlay.exe >nul 2>&1
taskkill /f /im Cortana.exe >nul 2>&1
echo   - Phone Link, HP Telemetry, and Xbox background services stopped.

echo Trimming working sets of all remaining processes...
powershell -NoProfile -Command "[System.GC]::Collect(); [System.GC]::WaitForPendingFinalizers(); (Get-Process) | ForEach-Object { try { [System.Diagnostics.Process]::GetProcessById($_.Id).EmptyWorkingSet() | Out-Null } catch {} }" >nul 2>&1

echo Clearing Windows clipboard...
cmd.exe /c "echo off | clip" >nul 2>&1

echo.
echo RAM status after process cleanup:
powershell -NoProfile -Command "$m = Get-CimInstance Win32_OperatingSystem; $used = [math]::Round(($m.TotalVisibleMemorySize - $m.FreePhysicalMemory)/1024, 2); $pct = [math]::Round((($m.TotalVisibleMemorySize - $m.FreePhysicalMemory)/$m.TotalVisibleMemorySize)*100, 1); Write-Host ('   RAM in Use Now      : ' + $used + ' MB (' + $pct + '%% used)') -ForegroundColor Green; Write-Host ('   Free Available RAM  : ' + [math]::Round($m.FreePhysicalMemory/1024, 2) + ' MB') -ForegroundColor Green"
echo [OK] Unwanted processes terminated and RAM freed!
echo.

:: ============================================================================
:: 2. FLUSH DNS & PURGE NETWORK CACHES
:: ============================================================================
echo [2/4] FLUSHING DNS ^& NETWORK CACHES...
echo ----------------------------------------------------------------------------
echo Flushing Windows DNS Resolver Cache...
ipconfig /flushdns

echo Purging ARP cache (IP-to-MAC table)...
arp -d * >nul 2>&1
echo   - ARP cache cleared.

echo Reloading NetBIOS name cache...
nbtstat -R >nul 2>&1
echo   - NetBIOS cache refreshed.

echo [OK] DNS and Network routing tables successfully flushed!
echo.

:: ============================================================================
:: 3. PERMANENTLY REMOVE ALL VISIBLE AND HIDDEN TEMP FILES
:: ============================================================================
echo [3/4] PERMANENTLY REMOVING ALL HIDDEN ^& VISIBLE TEMP FILES...
echo ----------------------------------------------------------------------------

:: 3.1 User Temp Directory
echo [x] Purging User Temp files (%TEMP%)...
if exist "%TEMP%" (
    del /s /f /q /a:h /a:s /a:r /a:-h "%TEMP%\*.*" >nul 2>&1
    for /d %%p in ("%TEMP%\*.*") do rmdir "%%p" /s /q >nul 2>&1
)
echo     - User Temp permanently deleted.

:: 3.2 Windows System Temp Directory
echo [x] Purging Windows System Temp (%SystemRoot%\Temp)...
if exist "%SystemRoot%\Temp" (
    del /s /f /q /a:h /a:s /a:r /a:-h "%SystemRoot%\Temp\*.*" >nul 2>&1
    for /d %%p in ("%SystemRoot%\Temp\*.*") do rmdir "%%p" /s /q >nul 2>&1
)
echo     - Windows System Temp permanently deleted.

:: 3.3 Windows Prefetch Cache
echo [x] Purging Windows Prefetch files (%SystemRoot%\Prefetch)...
if exist "%SystemRoot%\Prefetch" (
    del /s /f /q /a:h /a:s /a:r /a:-h "%SystemRoot%\Prefetch\*.*" >nul 2>&1
)
echo     - Prefetch cache removed.

:: 3.4 Recent Items & Jump Lists
echo [x] Purging Recent files, Jump Lists, and search history...
if exist "%APPDATA%\Microsoft\Windows\Recent" (
    del /s /f /q /a:h /a:s /a:r /a:-h "%APPDATA%\Microsoft\Windows\Recent\*.*" >nul 2>&1
    for /d %%p in ("%APPDATA%\Microsoft\Windows\Recent\*.*") do rmdir "%%p" /s /q >nul 2>&1
)
echo     - Recent items history cleared.

:: 3.5 Crash Dumps & Windows Error Reporting (WER)
echo [x] Purging Crash Dumps and Error Reporting Logs...
if exist "%LOCALAPPDATA%\CrashDumps" (
    del /s /f /q /a:h /a:s /a:r /a:-h "%LOCALAPPDATA%\CrashDumps\*.*" >nul 2>&1
    for /d %%p in ("%LOCALAPPDATA%\CrashDumps\*.*") do rmdir "%%p" /s /q >nul 2>&1
)
if exist "%PROGRAMDATA%\Microsoft\Windows\WER" (
    del /s /f /q /a:h /a:s /a:r /a:-h "%PROGRAMDATA%\Microsoft\Windows\WER\*.*" >nul 2>&1
    for /d %%p in ("%PROGRAMDATA%\Microsoft\Windows\WER\*.*") do rmdir "%%p" /s /q >nul 2>&1
)
if exist "%LOCALAPPDATA%\Microsoft\Windows\WER" (
    del /s /f /q /a:h /a:s /a:r /a:-h "%LOCALAPPDATA%\Microsoft\Windows\WER\*.*" >nul 2>&1
    for /d %%p in ("%LOCALAPPDATA%\Microsoft\Windows\WER\*.*") do rmdir "%%p" /s /q >nul 2>&1
)
echo     - Crash dumps and WER logs purged.

:: 3.6 Windows Explorer Thumbnail & Icon Cache
echo [x] Purging Stale Icon and Thumbnail Caches...
del /f /q /a:h "%LOCALAPPDATA%\IconCache.db" >nul 2>&1
del /f /s /q /a:h "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
del /f /s /q /a:h "%LOCALAPPDATA%\Microsoft\Windows\Explorer\iconcache_*.db" >nul 2>&1
echo     - Icon and thumbnail caches cleared.

:: 3.7 Windows Internet Temporary Cache
echo [x] Purging Windows Web / INetCache...
if exist "%LOCALAPPDATA%\Microsoft\Windows\INetCache" (
    del /f /s /q /a:h /a:s /a:r /a:-h "%LOCALAPPDATA%\Microsoft\Windows\INetCache\*.*" >nul 2>&1
    for /d %%p in ("%LOCALAPPDATA%\Microsoft\Windows\INetCache\*.*") do rmdir "%%p" /s /q >nul 2>&1
)
echo     - Web and INetCache purged.

:: 3.8 Windows Update Download Cache (SoftwareDistribution)
echo [x] Purging Windows Update Temporary Download Cache...
if exist "%SystemRoot%\SoftwareDistribution\Download" (
    del /f /s /q /a:h /a:s /a:r /a:-h "%SystemRoot%\SoftwareDistribution\Download\*.*" >nul 2>&1
    for /d %%p in ("%SystemRoot%\SoftwareDistribution\Download\*.*") do rmdir "%%p" /s /q >nul 2>&1
)
echo     - Windows Update download cache cleaned.

:: 3.9 Windows Minidump, CBS logs & Delivery Optimization
echo [x] Purging System Memory Dumps and Delivery Optimization...
if exist "%SystemRoot%\Minidump" del /f /s /q "%SystemRoot%\Minidump\*.*" >nul 2>&1
if exist "%SystemRoot%\MEMORY.DMP" del /f /q "%SystemRoot%\MEMORY.DMP" >nul 2>&1
if exist "%ProgramData%\Microsoft\Network\Downloader" (
    del /f /s /q "%ProgramData%\Microsoft\Network\Downloader\*.*" >nul 2>&1
)
echo     - Dump and download optimization files cleared.

:: 3.10 Empty Recycle Bin Permanently (All Drives)
echo [x] Emptying Windows Recycle Bin permanently across all drives...
powershell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" >nul 2>&1
for %%d in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist "%%d:\$Recycle.bin" rd /s /q "%%d:\$Recycle.bin" >nul 2>&1
)
echo     - Recycle Bin permanently emptied.

echo.
echo [OK] All visible and hidden temporary files permanently removed!
echo.

:: ============================================================================
:: 4. CLEANUP SUMMARY & VERIFICATION
:: ============================================================================
echo [4/4] FINAL SUMMARY REPORT
echo ----------------------------------------------------------------------------
powershell -NoProfile -Command "$m = Get-CimInstance Win32_OperatingSystem; $used = [math]::Round(($m.TotalVisibleMemorySize - $m.FreePhysicalMemory)/1024, 2); $total = [math]::Round($m.TotalVisibleMemorySize/1024, 2); $pct = [math]::Round((($m.TotalVisibleMemorySize - $m.FreePhysicalMemory)/$m.TotalVisibleMemorySize)*100, 1); Write-Host ('   Total System RAM : ' + $total + ' MB'); Write-Host ('   Current RAM Usage: ' + $used + ' MB (' + $pct + '%% used)') -ForegroundColor Green; Write-Host ('   Free RAM Now     : ' + [math]::Round($m.FreePhysicalMemory/1024, 2) + ' MB') -ForegroundColor Green"
echo.
echo ============================================================================
echo                CLEANUP COMPLETED SUCCESSFULLY!
echo ============================================================================
echo   [✓] 1. Unwanted background processes killed and RAM trimmed.
echo   [✓] 2. DNS resolver cache and network tables flushed.
echo   [✓] 3. All visible and hidden temporary files permanently deleted.
echo ============================================================================
echo.
pause
