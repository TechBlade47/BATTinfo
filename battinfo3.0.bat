@echo off
title BATTinfo

echo  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo  ~ BBBBB  AAAAA TTTTTT TTTTTT III  N   N  FFFFF  OOO  ~
echo  ~ B   B  A   A   TT     TT    I   NN  N  F     O   O ~
echo  ~ BBBBB  AAAAA   TT     TT    I   N N N  FFFF  O   O ~
echo  ~ B   B  A   A   TT     TT    I   N  NN  F     O   O ~
echo  ~ BBBBB  A   A   TT     TT   III  N   N  F      OOO  ~
echo  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
setlocal EnableDelayedExpansion

>nul 2>&1 net session
if %errorLevel% neq 0 (
    echo Administrator permissions are required in order to get accurate results. Please run as administrator.
    pause
    goto :eof
)

for /f "tokens=2 delims==" %%I in ('wmic path Win32_Battery get BatteryStatus /value') do (
    set BatteryStatus=%%I
)

if "%BatteryStatus%" equ "2" (
    set BatteryStatus=Charging
) else (
    set BatteryStatus=Discharging
)

for /f "tokens=2 delims==" %%I in ('wmic path Win32_Battery get EstimatedChargeRemaining /value') do (
    set BatteryLevel=%%I
)

for /f "tokens=2 delims==" %%I in ('wmic path Win32_Battery get EstimatedRunTime /value') do (
    set EstimatedTime=%%I
)

echo ===================================================================
echo Battery Status: %BatteryStatus%
echo Battery Level: %BatteryLevel%%% (%EstimatedTime% minutes remaining)
echo ===================================================================
echo.

set /p Confirm=Do you want to generate a battery report? (yes/no): 
if /i "!Confirm!" neq "yes" goto :eof

set /p SaveDir=Enter the directory to save the report (leave blank for C:): 

if "!SaveDir!"=="" set SaveDir=C:

powercfg /batteryreport /output "%SaveDir%\battery_report.html"

echo ~~~~~~~~~~~~~~~~~
echo C O M P L E T E D
echo ~~~~~~~~~~~~~~~~~

set /p ConfirmLocation=Do you want to open the directory of the saved report? (yes/no): 
if /i "!ConfirmLocation!" equ "yes" (
    start explorer "%SaveDir%"
)

echo.
echo Thanks for using BATTinfo 3.0!

pause
