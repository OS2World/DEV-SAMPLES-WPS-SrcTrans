@echo off
setlocal
rem genbind.cmd - Generate SOM C++ bindings for srctrans
rem Runs sc to produce srctrans.xih and srctrans.xh, then moves them to h\

set MK_LOG=release\genbind.log
if not exist release md release
if not exist h md h

rem Clear the log at the start, then append throughout
echo. > %MK_LOG%

rem SMINCLUDE: idl\ for local IDL; src\ so sc finds srctrans.ph (in passthru);
rem            C:\os2tk45\idl for wptrans.idl and other WPS IDL files;
rem            C:\os2tk45\h for OS/2 headers referenced in passthru.
set SMINCLUDE=.;idl;src;C:\os2tk45\idl;C:\os2tk45\som\include;C:\os2tk45\h
set SMEMIT=xih;xh
set SMADDSTAR=1

echo Generating bindings for srctrans.idl... 2>&1 | tee -a %MK_LOG%
sc -s"xih;xh" idl\srctrans.idl 2>&1 | tee -a %MK_LOG%

rem sc puts output next to the input file (in idl\)
if exist idl\srctrans.xih move idl\srctrans.xih h\srctrans.xih
if exist idl\srctrans.xh  move idl\srctrans.xh  h\srctrans.xh

echo genbind done. 2>&1 | tee -a %MK_LOG%
endlocal
