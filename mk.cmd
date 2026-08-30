@echo off
rem mk.cmd - Clean build wrapper for srctrans.dll
rem Usage: mk.cmd          (runs genbind + full build)
rem        mk.cmd nobind   (skips genbind, runs build only)

set MK_LOG=release\mk.log
if not exist release md release

if "x%1"=="xnobind" goto build
call genbind.cmd

:build
wmake -f Makefile.wat all 2>&1 | tee %MK_LOG%
