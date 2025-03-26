@echo off

REM Assign the value random password to the password variable
setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
set alfanum=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789

::Example can be JesusLovesYou2025
set rustdesk_pw=

::Only for creating a random set password.
for /L %%b in (1, 1, 12) do (
    set /A rnd_num=!RANDOM! %% 62
    for %%c in (!rnd_num!) do (
        set rustdesk_pw=!rustdesk_pw!!alfanum:~%%c,1!
    )
)

REM Set the ID Relay Server Address. IP or DNS (Note - Script needs to be Run as Administrator)
set rustdesk_svr=rustdesk.domain.com

REM Download Path that like to have RustDesk go to before it installs
set download_path=C:\Temp

REM ############################### Please Do Not Edit Below This Line #########################################
REM Checking to see if Terminal is 'Run as Administrator'
net session >nul 2>&1
if %errorLevel% == 0 (
	color A
    echo Success: Administrative permissions confirmed.
    goto AdminAccess
) else (
   color CE
   echo Failure: Current permissions inadequate.
   echo Run as administrator and try again
   TIMEOUT 10
   Exit
)
:AdminAccess
if not exist %download_path% md %download_path%
cd %download_path%
echo ------ Downloading RustDesk -----
echo ------     Please Wait      -----
curl -L "https://github.com/rustdesk/rustdesk/releases/download/1.3.8/rustdesk-1.3.8-x86_64.exe" -o rustdesk.exe
echo ------ Installing RustDesk -----
rustdesk.exe --silent-install
timeout /t 10
cd "C:\Program Files\RustDesk\"
rustdesk.exe --install-service
timeout /t 10

for /f "delims=" %%i in ('rustdesk.exe --get-id ^| more') do set rustdesk_id=%%i

::Line of code that changes the ID Server - (Note - Script needs to be Run as Administrator for setting to take effect)
rustdesk.exe --option custom-rendezvous-server %rustdesk_svr%
rustdesk.exe --password %rustdesk_pw%

echo ---- Installation Completed ----
echo ...............................................
REM Show the value of the ID Variable
echo RustDesk ID: %rustdesk_id%

REM Show the value of the Password Variable
echo Password: %rustdesk_pw%
echo ...............................................
echo -- Close Window when required --
timeout /t 5