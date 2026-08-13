@echo off
setlocal enabledelayedexpansion

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Please run as admin
    pause
    exit /b 1
)

echo.
echo Applying Registry Policies
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v "DODownloadMode" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "01" /t REG_DWORD /d 0 /f >nul 2>&1

echo.
echo Stopping and Disabling Services
for %%S in (BITS wuauserv UsoSvc) do (
    echo Stopping and disabling %%S...
    net stop %%S /y >nul 2>&1
    sc config %%S start= disabled >nul 2>&1
)

echo Setting DoSvc to manual and stopping...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DoSvc" /v Start /t REG_DWORD /d 3 /f >nul 2>&1
net stop DoSvc /y >nul 2>&1

echo Applying additional service optimizations...
sc config "CscService" start= disabled >nul 2>&1
sc stop "CscService" >nul 2>&1

sc config "DiagTrack" start= disabled >nul 2>&1
sc stop "DiagTrack" >nul 2>&1

sc config "SharedAccess" start= disabled >nul 2>&1
sc stop "SharedAccess" >nul 2>&1

sc config "MapsBroker" start= demand >nul 2>&1
sc config "StorSvc" start= demand >nul 2>&1

echo.
echo Clearing Update Cache
cd /d "C:\Windows\SoftwareDistribution" 2>nul && (
    del /q /s /f *.* >nul 2>&1
    for /d %%i in (*) do rmdir /s /q "%%i" >nul 2>&1
)

echo.
echo Disabling Scheduled Tasks
for /f "tokens=1 delims=," %%a in ('schtasks /query /fo csv /nh 2^>nul') do (
    set "task=%%a"
    set "task=!task:"=!"
    
    for %%P in ("\Microsoft\Windows\InstallService\" "\Microsoft\Windows\UpdateOrchestrator\" "\Microsoft\Windows\UpdateAssistant\" "\Microsoft\Windows\WaaSMedic\" "\Microsoft\Windows\WindowsUpdate\" "\Microsoft\WindowsUpdate\") do (
        echo !task! | findstr /i /b "%%~P" >nul
        if !errorlevel! equ 0 (
            schtasks /Change /TN "!task!" /DISABLE >nul 2>&1
        )
    )
)

echo.
echo Applying System Optimizations
powershell -NoProfile -Command "$Memory = (Get-CimInstance Win32_PhysicalMemory | Measure-Object Capacity -Sum).Sum / 1KB; Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control' -Name SvcHostSplitThresholdInKB -Value $Memory"

echo.
echo Process Completed Successfully

pause
