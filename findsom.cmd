@echo off
setlocal
set LOG=release\findsom.log
if not exist release md release
echo. > %LOG%

echo Searching for somobj.idl... 2>&1 | tee -a %LOG%
dir /s C:\os2tk45\somobj.idl 2>&1 | tee -a %LOG%

echo Searching for sombacls.idl... 2>&1 | tee -a %LOG%
dir /s C:\os2tk45\sombacls.idl 2>&1 | tee -a %LOG%

echo Searching for somcls.idl... 2>&1 | tee -a %LOG%
dir /s C:\os2tk45\somcls.idl 2>&1 | tee -a %LOG%

echo Done. 2>&1 | tee -a %LOG%
endlocal
