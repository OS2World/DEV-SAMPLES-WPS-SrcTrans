/* deregister.cmd - Deregister SrcTransient WPS class */
call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
call SysLoadFuncs

rc1 = SysDestroyObject('<SRCTRANS001>')
say 'SysDestroyObject  SRCTRANS001   =' rc1

rc2 = SysDeregisterObjectClass('SrcTransient')
say 'SysDeregisterObjectClass SrcTransient =' rc2

say 'Done. Refresh the desktop.'
