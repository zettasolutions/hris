@echo off

rem %1 = user and pwd and server
rem %2 = filename to compile

if '%2' == '' goto on_exit
if '%1' == '' goto on_exit
if not exist %2 goto end

rem echo %date% %time%

if '%~x2' == '.PSP' goto psp
if '%~x2' == '.psp' goto psp
if '%~x2' == '.SQL' goto sql
if '%~x2' == '.sql' goto sql
goto end

:psp
echo.
echo Compiling %2 file in %1
rem loadpsp -replace -user %1 %2 >> "CompResults.txt" 2>>"CompErrors.txt"
rem loadpsp -replace -user %1 %2 >> "..\psp.txt" 2>>"..\errors.txt"
loadpsp -replace -user %1 %2
goto end

:sql
echo.
echo Compiling %2 file in %1
rem echo exit | sqlplus -S %1 @%2 >>"..\sql.txt"
echo exit | sqlplus -S %1 @%2
goto end


:on_exit
echo Not enough parameters...


:end


