@echo off
echo. >..\psp.txt
echo. >..\sql.txt
echo. >..\errors.txt ..\
cls
echo Compiling source codes...
echo.
for /f "eol=;" %%i in (srcviews.txt) do (call comp.bat s004/S004 .\table-scripts\views\%%i)

copy ..\psp.txt + ..\sql.txt + ..\errors.txt ..\results.txt
del ..\psp.txt
del ..\sql.txt
del ..\errors.txt
type ..\results.txt
echo.
echo done.