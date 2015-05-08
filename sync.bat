@echo off
echo. >..\psp.txt
echo. >..\sql.txt
echo. >..\errors.txt ..\
cls
echo Compiling source codes...
echo.
for /f "eol=;" %%i in (src.txt) do (call comp.bat s004/S004 .\plsql\%%i)

rem copy ..\psp.txt + ..\sql.txt + ..\errors.txt ..\results.txt
rem del ..\psp.txt
rem del ..\sql.txt
rem del ..\errors.txt
rem type ..\results.txt
echo.
echo done.