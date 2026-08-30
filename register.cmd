/* register.cmd - Register SrcTransient WPS class */
call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
call SysLoadFuncs

'copy release\srctrans.dll C:\OS2\DLL\srctrans.dll'

rc1 = SysRegisterObjectClass('SrcTransient', 'srctrans')
say 'SysRegisterObjectClass SrcTransient =' rc1

rc2 = SysCreateObject('SrcTransient', 'dragit', '<WP_DESKTOP>', 'OBJECTID=<SRCTRANS001>', 'U')
say 'SysCreateObject SrcTransient =' rc2

say 'Done. Drag the "dragit" object on the desktop into any folder to test.'
