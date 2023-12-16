@echo off
cls
echo ************************************************************
echo * Script pour optimiser Windows 10
echo ************************************************************

REM Vérification des privilèges administrateur
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    echo Vous devez être en mode administrateur pour exécuter ce script.
    pause
    exit /b 1
)

echo Veuillez entrer 1 pour commencer l'optimisation:
set /p userChoice=
if %userChoice% equ 1 (
    echo Lancement de l'optimisation...

:: Restaure le fichier HOST
echo Restauration du fichier HOST...
echo.
takeown /f "C:\Windows\System32\drivers\etc\hosts" /r >nul
icacls "C:\Windows\System32\drivers\etc\hosts" /grant administrateurs:F >nul
echo.

:: Active ou désactive la prise en charge de SMBv1
echo Active la prise en charge de SMBv1...
echo.
sc.exe config lanmanworkstation depend= bowser/mrxsmb10/nsi
sc.exe config mrxsmb10 start= disabled
echo.

:: Désactive les fonctionnalités superflues de Windows 10
echo Désactivation des fonctionnalités superflues...
echo.
DISM.exe /Online /Disable-Feature /FeatureName:MediaPlayback /Quiet /NoRestart >nul
DISM.exe /Online /Disable-Feature /FeatureName:SMB1Protocol /Quiet /NoRestart >nul
echo.

:: Optimise les paramètres du système
echo Optimisation des paramètres du système...
echo.
powercfg -h off >nul
echo.

:: Supprime les fichiers temporaires et de cache
echo Suppression des fichiers temporaires et de cache...
echo.
del /f /s /q "%TEMP%"\*.* >nul
del /f /s /q "%SystemRoot%"\Temp\*.* >nul
echo.

echo.
echo Optimisation terminée. Redémarrez votre ordinateur pour que les modifications prennent effet.
echo.
pause