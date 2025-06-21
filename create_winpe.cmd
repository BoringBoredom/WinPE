:: RUN THIS AS ADMIN IN THE FOLDER YOU WANT THE ISO TO BE CREATED IN

setlocal

:: YOU MAY HAVE TO CHANGE THIS DEPENDING ON WINDOWS VERSION
SET "adk_path=C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit"

SET "current_dir=%~dp0"
SET "package_path=%adk_path%\Windows Preinstallation Environment\amd64\WinPE_OCs"
SET "winpe_path=%current_dir%\WinPE_amd64"

CALL "%adk_path%\Deployment Tools\DandISetEnv.bat"
CALL copype amd64 "%winpe_path%"

Dism /Mount-Image /ImageFile:"%winpe_path%\media\sources\boot.wim" /index:1 /MountDir:"%winpe_path%\mount"

Dism /Add-Package /Image:"%winpe_path%\mount" /PackagePath:"%package_path%\WinPE-WMI.cab"
Dism /Add-Package /Image:"%winpe_path%\mount" /PackagePath:"%package_path%\WinPE-NetFX.cab"
:: Dism /Add-Package /Image:"%winpe_path%\mount" /PackagePath:"%package_path%\WinPE-Scripting.cab"
:: Dism /Add-Package /Image:"%winpe_path%\mount" /PackagePath:"%package_path%\WinPE-PowerShell.cab"

(
    echo wpeinit
    echo powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    echo SET "explorerpp=X:\windows\explorerpp\Explorer++.exe"
    echo SET "screenshot=X:\windows\nircmd\nircmd.exe cmdwait 2000 savescreenshot"
    echo SET "mousetester_m=X:\windows\mousetester\microe1\MouseTester.exe"
    echo SET "mousetester_v=X:\windows\mousetester\valleyofdoom\MouseTester.exe"
    echo SET "mousetester_d=X:\windows\mousetester\dobragab\MouseTester.exe"
) > "%winpe_path%\mount\windows\system32\startnet.cmd"

reg load HKEY_USERS\WinPE_Default_User "%winpe_path%\mount\windows\system32\config\DEFAULT"
reg add "HKEY_USERS\WinPE_Default_User\Control Panel\Mouse" /v MouseSensitivity /t REG_SZ /d "1" /f
reg add "HKEY_USERS\WinPE_Default_User\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d "0" /f
reg unload HKEY_USERS\WinPE_Default_User

reg load HKEY_LOCAL_MACHINE\WinPE_System "%winpe_path%\mount\windows\system32\config\SYSTEM"
reg add "HKEY_LOCAL_MACHINE\WinPE_System\ControlSet001\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /t REG_DWORD /d 3 /f
reg add "HKEY_LOCAL_MACHINE\WinPE_System\ControlSet001\Control\Session Manager\Memory Management" /v FeatureSettingsOverrideMask /t REG_DWORD /d 3 /f
reg unload HKEY_LOCAL_MACHINE\WinPE_System


mkdir "%current_dir%\temp"

mkdir "%winpe_path%\mount\windows\explorerpp"
curl -L -o "%current_dir%\temp\explorerpp.zip" "https://github.com/derceg/explorerplusplus/releases/download/version-1.4.0/explorerpp_x64.zip"
tar -xf "%current_dir%\temp\explorerpp.zip" -C "%winpe_path%\mount\windows\explorerpp"


mkdir "%winpe_path%\mount\windows\nircmd"
curl -L -o "%current_dir%\temp\nircmd.zip" "https://www.nirsoft.net/utils/nircmd-x64.zip"
tar -xf "%current_dir%\temp\nircmd.zip" -C "%winpe_path%\mount\windows\nircmd"


mkdir "%winpe_path%\mount\windows\mousetester\microe1"
curl -L -o "%current_dir%\temp\mousetester_microe1.zip" "https://github.com/microe1/MouseTester/releases/download/MouseTester_v1.4/Release_v1.4.zip"
tar -xf "%current_dir%\temp\mousetester_microe1.zip" -C "%winpe_path%\mount\windows\mousetester\microe1"


mkdir "%winpe_path%\mount\windows\mousetester\valleyofdoom"
curl -L -o "%winpe_path%\mount\windows\mousetester\valleyofdoom\MouseTester.exe" "https://github.com/valleyofdoom/MouseTester/releases/download/MouseTester_v1.7.2/MouseTester.exe"


mkdir "%winpe_path%\mount\windows\mousetester\dobragab"
curl -L -o "%current_dir%\temp\mousetester_dobragab.zip" "https://github.com/dobragab/MouseTester/releases/download/v1.5.3/MouseTester_v1.5.3.zip"
tar -xf "%current_dir%\temp\mousetester_dobragab.zip" -C "%winpe_path%\mount\windows\mousetester\dobragab"


Dism /Unmount-Image /MountDir:"%winpe_path%\mount" /commit
MakeWinPEMedia /iso "%winpe_path%" "%current_dir%\WinPE.iso"


:: https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install
:: https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-create-usb-bootable-drive?view=windows-10
:: https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-mount-and-customize?view=windows-10
:: https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-add-packages--optional-components-reference?view=windows-10
:: https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-adding-powershell-support-to-windows-pe?view=windows-10