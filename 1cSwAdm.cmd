:: Swap Radmin.dll
:: Интерактиная смена версии библиотеки консоли управления 1С
:: Version 0.2
:: Rudakov E.A.
:: https://github.com/DonPager/1c-swadmin 

@Echo Off
at > nul
IF %errorlevel% NEQ 0 (
 echo Только для админов
 ping 127.0.0.1 > NUL 2>&1
 exit /b
)

setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
Set /a Hhigh=5
Set /a Wwidth=20
Set FDir="%ProgramFiles(x86)%\1cv8\"
Set FDir82="%ProgramFiles(x86)%\1cv82\"
Set /a Num=0
FOR /R %FDir82% %%i IN ("*radmin.dll") DO Call :Obrabotka82 "%%i"
FOR /R %FDir% %%i IN ("*radmin.dll") DO Call :Obrabotka "%%i"

::pause>nul
if %Num%==0 goto xt
Set /a Hhigh+=%Num%
mode con:cols=%Wwidth% lines=%Hhigh%
set menu1=█-%menu1:~2%-█
set NumT=1

:str
cls
for /l %%i in (1,1,%Num%) do (echo.!menu%%i!)
echo. ________________
echo.^| W/S - Up/Down  ^|
echo.^| R/Q - Run/Quit ^|
echo.^|________________^|
choice /c wsrq /n 
if %errorlevel%==1 call :math "1" "%Num%" "-1"
if %errorlevel%==2 call :math "%Num%" "1" "+1"
::if %errorlevel%==3 call :%NumT%
if %errorlevel%==3 call :Zapusk !menu%NumT%:~2,-2!
if %errorlevel%==4 goto xt
goto str
:xt
endlocal
exit /b

:math
set menu%NumT%=  !menu%NumT%:~2,-2!
if %NumT%==%~1 (set /a NumT=%~2) else (set /a NumT=%NumT%%~3)
set menu%NumT%=█-!menu%NumT%:~2!-█
exit /b

:Obrabotka
Set vrem=%1
Set vrem=!vrem:%FDir:~0,-1%=!
Set vrem=%vrem:\bin\radmin.dll"=%
set /a Num+=1
set menu!Num!=  !menu%Num%!%vrem%
exit /b

:Obrabotka82
Set vrem=%1
Set vrem=!vrem:%FDir82:~0,-1%=!
Set vrem=%vrem:\bin\radmin.dll"=%
set /a Num+=1
set menu!Num!=  !menu%Num%!%vrem%
exit /b

:Zapusk
regsvr32 /s /i:user %FDir:~0,-1%%~1\bin\radmin.dll"
exit /b 4

:1
echo menu 1 run 