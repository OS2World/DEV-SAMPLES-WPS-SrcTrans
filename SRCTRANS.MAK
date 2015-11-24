
#
#  Source render drag/drop sample
#
#  Author : Andrew Clinch
#
#  Disclaimer :
#  In no event shall Andrew Clinch be liable for any damages whatsoever
#  (including, without limitation, damaged or loss of business profits, business
#  interruption, loss of business information, or other pecuniary loss) arising
#  out of the use or inability to use this sample code, even if Andrew Clinch
#  has been advised of the possibility of such damages.
#

LFLAGS   = /NOE /NOD /ALIGN:16 /EXEPACK /M /BASE:0x10000
LINK    = LINK386  $(LFLAGS)
LIBS    = DDE4MBS + OS2386
STLIBS  = DDE4SBS + OS2386
MTLIBS  = DDE4MBS + os2386
DLLLIBS = DDE4NBS + os2386
VLIBS   = DDE4SBS + vdh + os2386

PRJLIBDIR=\projects\lib\#

#****************************************************************************
#  Dot directive definition area (usually just suffixes)
#****************************************************************************

.SUFFIXES:
.SUFFIXES: .cpp .obj .dll .csc .sc .xh .xih .xph .psc .rc .res .def

#****************************************************************************
#  Environment Setup for the component(s).
#****************************************************************************

SOMTEMP = .\somtemp
SCPATH  = e:\toolkt21\sc
HPATH   = e:\toolkt21\cplus\os2h
LIBPATH = e:\toolkt21\os2lib

!if [set SMINCLUDE=.;$(HPATH);$(SCPATH);] || \
    [set SMTMP=$(SOMTEMP)] || \
    [set SMEMIT=xih;xh;psc;sc;xc;def]
!endif

!if [cd $(SOMTEMP)]
!  if [md $(SOMTEMP)]
!    error error creating $(SOMTEMP) directory
!  endif
!else
!  if [cd ..]
!    error - Couldn't cd .. from $(SOMTEMP) directory
!  endif
!endif

#
# Compiler/tools Macros
#

CPP     = icc /Ge-
LINK    = LINK386
LDFLAGS = /noi /map /nol /nod /exepack /packcode /packdata /align:16
DLLLIBS = $(DLLLIBS) som.lib dde4muii.lib dde4cci.lib dde4mbsi.lib 

GCPPFLAGS=-Fd -c -Gm+ -O+

#****************************************************************************
# Set up Macros that will contain all the different dependencies for the
# executables and dlls etc. that are generated.
#****************************************************************************

OBJS = srctrans.obj $(PRJLIBDIR)printf.obj

#****************************************************************************
#   Setup the inference rules for compiling source code to
#   object code.
#****************************************************************************

# Remove pound signs to have CSC recompile
.csc.xih:
        sc -v -r  srctrans.csc

all: srctrans.dll

#
# Specific Process Tag
#

srctrans.xih:   $$(@B).csc

srctrans.def:   $$(@B).csc

srctrans.cpp:   $$(@B).csc

srctrans.obj: $$(@B).cpp $$(@B).xih $$(@B).xh  $$(@B).sc 
         $(CPP) -I$(HPATH) /Fosrctrans.obj -c srctrans.cpp

srctrans.dll: $$(@B).def $(OBJS) srctrans.res
         $(LINK) $(LDFLAGS) $(OBJS),$@,,$(DLLLIBS),srctrans;
         rc -p -x srctrans.res srctrans.dll
         mapsym srctrans.map

srctrans.res: $$(@B).rc $$(@B).xih
         rc -r srctrans.rc srctrans.res



