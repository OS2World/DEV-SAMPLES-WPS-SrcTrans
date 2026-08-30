# Makefile.wat - Open Watcom makefile for srctrans.dll
#
# Build with:  wmake -f Makefile.wat
# Or use:      mk.cmd

SOMINC = C:\os2tk45\som\include
WPSINC = C:\os2tk45\h

SOMDLL  = C:\OS2\DLL\som.dll
SOMLIB  = release\som.lib
PMWPDLL = C:\OS2\DLL\pmwp.dll
PMWPLIB = release\pmwp.lib

CC    = wpp386
LINK  = wlink
RC    = wrc
WLIB  = wlib

# -wcd=726:  suppress W726 "unused formal parameter" in SOM toolkit headers
# -wcd=136:  suppress W136 "conversion between different pointer types"
# -wcd=1177: suppress W1177 "Modifier repeated in declaration" in sombtype.h
CFLAGS = -bd -bt=os2 -zq -wx -wcd=726 -d1
INCL   = -Ih -Isrc -I$(SOMINC) -I$(WPSINC)

# Data exports: wpp386 32-bit flat model does not add _ prefix to C-linkage data symbols
EXPS = &
    EXP SrcTransientNewClass &
    EXP M_SrcTransientNewClass &
    EXP SrcTransientClassData &
    EXP SrcTransientCClassData &
    EXP M_SrcTransientClassData &
    EXP M_SrcTransientCClassData

OBJLIST = release\srctrans.obj

LFLAGS = SYSTEM OS2V2_DLL &
         NAME release\srctrans.dll &
         OP MAP=release\srctrans.map &
         @src\srctrans.def &
         LIBF $(SOMLIB),$(PMWPLIB) &
         $(EXPS)

all : release\srctrans.dll .SYMBOLIC

# ---- srctrans.dll ----

release\srctrans.dll : release\srctrans.obj release\srctrans.res $(SOMLIB) $(PMWPLIB)
	$(LINK) $(LFLAGS) FIL $(OBJLIST)
	$(RC) release\srctrans.res $@

release\srctrans.obj : src\srctrans.cpp h\srctrans.xih h\srctrans.xh
	$(CC) $(CFLAGS) $(INCL) src\srctrans.cpp -fo=$@

release\srctrans.res : src\srctrans.rc src\srctrans_res.h src\srctrans.ico
	$(RC) -r -i=src -i=h -i=$(SOMINC) -i=$(WPSINC) src\srctrans.rc
	copy src\srctrans.res release
	del src\srctrans.res

# ---- shared libs ----

release\som.lib : $(SOMDLL)
	$(WLIB) -n -b -q $@ +$(SOMDLL)

release\pmwp.lib : $(PMWPDLL)
	$(WLIB) -n -b -q $@ +$(PMWPDLL)

clean : .SYMBOLIC
	@if exist release\*.obj del release\*.obj
	@if exist release\*.res del release\*.res
	@if exist release\*.lib del release\*.lib
	@if exist release\*.dll del release\*.dll
	@if exist release\*.map del release\*.map
	@if exist release\*.err del release\*.err
