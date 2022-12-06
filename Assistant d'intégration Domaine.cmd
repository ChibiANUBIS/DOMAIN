@echo off
chcp 65001>nul
TITLE Assistant d'intégration Domaine
COLOR F0

SET DOMAIN=[ADMIN-ACCOUNT]
SET PWD=[PASSWORD-ADMIN]

ECHO ***************************************
ECHO ***************************************
ECHO *****                             *****
ECHO *****       Vous devez être       *****
ECHO *****    connecté sur un compte   *****
ECHO *****       ADMINISTRATEUR        *****
ECHO *****                             *****
ECHO *****                             *****
ECHO ***************************************
ECHO.
ECHO Appuyez sur une touche pour continuer...
pause>nul

pushd "%~dp0"
SET CHDETECTE=%computername:~0,2%
if not %CHDETECTE%==RT if not %CHDETECTE%==VZ GOTO LOOP

rem :::::::::::::::INTEGRATE DOMAIN:::::::::::::::::::::::
cls
ECHO ***************************************
ECHO *****    Le poste a intégrer      *****
ECHO *****         ce nomme :          *****
ECHO *****                             *****
ECHO *****           %computername%             *****
ECHO ***************************************
ECHO.
CHOICE /C IQ /M "Appuyez sur une [I] pour intégrer le poste ou sur [Q] pour quitter."%1
IF %ERRORLEVEL% EQU 1 GOTO INTCH
IF %ERRORLEVEL% EQU 2 EXIT

:INTCH
ECHO.
ECHO Veuillez patienter...
ECHO.

copy NETDOM\netdom.exe %WinDir%\System32\netdom.exe
copy NETDOM\netdom.exe.mui %WinDir%\System32\fr-FR\netdom.exe.mui

if not exist %WinDir%\System32\netdom.exe GOTO Error
if not exist %WinDir%\System32\fr-FR\netdom.exe.mui GOTO Error

NETDOM JOIN %computername% /domain:[DOMAIN_NAME] /OU:"OU=%CHDETECTE%,OU=PCs,OU=Machines,DC=[DOMAIN_NAME]" /ud:%DOMAIN% /pd:%PWD%

ECHO.
ECHO Appuyez sur une touche pour quitter...
pause>nul
exit

rem ::::::::::::::::INSERT NAME::::::::::::::::::::::::
:LOOP
cls
SET "ch="
SET "id="
ECHO * RENOMMEZ VOTRE ORDINATEUR SELON LA REGLE *
ECHO.
ECHO Tapez RT ou VZ
set /p ch="CH : "
ECHO Tapez le numéro du poste 
set /p id="NUMEROS : "

if not defined ch GOTO LOOP
if not defined id GOTO LOOP

if %ch%==rt set ch=RT
if %ch%==Rt set ch=RT
if %ch%==rT set ch=RT

if %ch%==vz set ch=VZ
if %ch%==Vz set ch=VZ
if %ch%==vZ set ch=VZ

if not %ch%==RT if not %ch%==VZ GOTO LOOP

cls
ECHO ***************************************
ECHO *****    Le poste a intégrer      *****
ECHO *****         ce nomme :          *****
ECHO *****                             *****
ECHO *****           %ch%%id%             *****
ECHO ***************************************
ECHO.
CHOICE /C IRQ /M "Appuyez sur une [I] pour renommer le poste ou sur [R] pour changer le poste, ou [Q] pour quitter."%1
IF %ERRORLEVEL% EQU 1 GOTO INTINSERT
IF %ERRORLEVEL% EQU 2 GOTO LOOP
IF %ERRORLEVEL% EQU 3 EXIT

:INTINSERT
ECHO.
ECHO Veuillez patienter...
ECHO.

WMIC computersystem where caption='%computername%' rename '%ch%%id%'

ECHO.
ECHO Vous devez redémarrer l'ordinateur et relancer l'assistant.
ECHO Appuyez sur une touche pour quitter...
pause>nul
exit

:Error
cls
ECHO ***************************************
ECHO ***************************************
ECHO *****                             *****
ECHO *****       ERREUR DURANT LA      *****
ECHO *****      COPIE DES FICHIERS     *****
ECHO *****                             *****
ECHO *****                             *****
ECHO *****                             *****
ECHO ***************************************
ECHO.
ECHO Appuyez sur une touche pour quitter...
pause>nul
exit