# SrcTrans — Source Render Drag/Drop (C++ SOM), Open Watcom Port

OS/2 WorkPlace Shell sample demonstrating **source-rendered drag/drop**.
All standard WPS drag/drop is target-rendered — the drop target performs
the actual copy or move. This sample shows how a WPS class can force source
rendering instead: the source object handles `DM_RENDER` itself, giving it
full control over what happens when its instance is dropped into a folder.

- **Class:** `SrcTransient : WPTransient`  (metaclass: `M_SrcTransient`)
- **Author:** Andrew Clinch, January 1994
- **Original tools:** IBM VisualAge C++, LINK386, SOM 1.x CSC format

This port converts the `.CSC` definition to SOM 2.x IDL and rebuilds with
Open Watcom.

---

## How It Works

1. `wpFormatDragItem` is overridden to replace the DRM/DRF pair with
   `<DRM_OS2FILE, DRF_UNKNOWN>` and clear `hstrSourceName`, forcing the
   drop target to send `DM_RENDER` back to the source object's window.
2. An object window (`DragObjectWin`) is created; its handle replaces
   `hwndItem` in the `DRAGITEM` structure.
3. The object window's `DM_RENDER` handler reads the target folder path
   from `DRAGTRANSFER.hstrRenderToName` and calls `wpCopyObject` to copy
   the object to that folder — the source drives the copy, not the target.

---

## Class Hierarchy

```
SOMObject
  └── WPObject
        └── WPTransient
              └── SrcTransient     (metaclass: M_SrcTransient)
```

New class method: `clsQueryModuleHandle` — returns and caches the DLL
module handle (used by `wpclsQueryIconData`).

---

## Directory Layout

```
SrcTrans/
├── idl/          srctrans.idl     — SOM 2.x IDL (converted from srctrans.csc)
├── h/            srctrans.xih, srctrans.xh  (sc-generated; by genbind.cmd)
├── src/          srctrans.cpp, srctrans.rc, srctrans_res.h, srctrans.def
│                 srctrans.ico, srctrans.ph
├── doc/          (reserved)
├── release/      build output (dll, obj, res, lib, map, log)
├── Makefile.wat  Open Watcom makefile
├── mk.cmd        one-shot clean build
├── genbind.cmd   runs sc to generate h\srctrans.xih and h\srctrans.xh
├── register.cmd  REXX: copies DLL to C:\OS2\DLL, registers class, creates desktop object
└── deregister.cmd  REXX: destroys desktop object and deregisters class
```

---

## Prerequisites

| Item | Path |
|---|---|
| Open Watcom 2.0 | `PATH` must include Watcom bin |
| OS/2 Toolkit 4.5 | `C:\os2tk45` |
| SOM runtime | `C:\OS2\DLL\som.dll` |
| PMWP (WPS shell) | `C:\OS2\DLL\pmwp.dll` |
| SOM compiler `sc` | on `PATH` (Toolkit) |
| `wptrans.idl` | `C:\os2tk45\idl\` |
| `somobj.idl`, `somcls.idl` | `C:\os2tk45\som\include\` |

---

## Build

```
cd C:\Temporal\1.- OS2\Projects\SrcTrans
genbind.cmd
wmake -f Makefile.wat
```

Or use the convenience wrapper (runs genbind + build in one step):

```
mk.cmd
```

To rebuild without regenerating bindings:

```
mk.cmd nobind
```

Output: `release\srctrans.dll`

---

## Register / Test

```
register.cmd
```

Copies `release\srctrans.dll` to `C:\OS2\DLL\`, registers `SrcTransient`,
and creates a transient object called **"dragit"** on the desktop.
Drag "dragit" into any folder — the object window intercepts `DM_RENDER`
and calls `wpCopyObject` to copy itself to the target, regardless of the
modifier key held.

```
deregister.cmd
```

---

## Porting Notes (IBM C/C++ → Open Watcom)

| Item | Status |
|---|---|
| `wpp386` replaces IBM `icc /Ge-` | Done — C++ project (`-bd` for DLL mode) |
| `SRCTRANS.CSC` converted to IDL | `idl\srctrans.idl` — SOM 2.x IDL format |
| `sc -s"xih;xh"` generates C++ bindings | `srctrans.xih` and `srctrans.xh` moved to `h\` by `genbind.cmd` |
| SMINCLUDE in `genbind.cmd` | `C:\os2tk45\idl` for WPS IDL; `C:\os2tk45\som\include` for base SOM IDL (`somobj.idl` etc.) |
| `passthru C.xih, before/after` (CSC) | → `passthru C_xih_before` / `C_xih_after` in IDL implementation block |
| IDL passthru strings: no `\n` | sc does not interpret `\n` in passthru strings — it adds its own newline after each quoted segment |
| `using namespace std;` in passthru | Required — Watcom `wpp386` wraps C headers (`string.h` etc.) in `std::` namespace |
| `#include <wpfolder.xh>` in passthru | Required — `WPFolder` C++ class definition needed for `wpCopyObject` argument type |
| `IDD_DRAGWIN` / `ID_ICON` in `srctrans.ph` | Pulled in via `passthru C_xih_before` `#include "srctrans.ph"` |
| `src/srctrans.rc` `#include "srctrans.ph"` replaced | `#include <os2.h>` + `#include "srctrans_res.h"` |
| `<wpobject.h>` removed from RC | Not needed — only ICON resource in this file |
| `OPTION CASEEXACT` in `srctrans.def` | Required for correct C-linkage symbol matching |
| Data symbol exports | Bare form — wpp386 32-bit flat model does not add `_` prefix |
| `INITINSTANCE` removed from DEF | IBM ilink directive; causes wlink E3033 error |
| Bug fix: uninitialized `cbLength`/`pBuffer` | First `DrgQueryStrName` call now passes `0, NULL` to query the size |
| Bug fix: `delete pBuffer` → `delete[] pBuffer` | Array allocated with `new[]` must use `delete[]` |
| Bug fix: `wpAllocMem(..., FALSE)` → `(..., NULL)` | Second param is `PULONG pRC`, not BOOL; NULL = don't return error code |
| Bug fix: `wpCopyObject` arg cast | `wpclsQueryFolder` returns `WPObject *`; cast to `WPFolder *` for `wpCopyObject` |
| `EXPENTRY` / `_System` | Defined in OS/2 headers; Watcom supports `_System` — no change needed |
| `DDE4NBS`, `dde4*.lib` (IBM CRT) | Not needed — Watcom links its own DLL CRT via `-bd` |
| `mapsym` step | Omitted — wlink produces `.map`; OS/2 tools can use it directly |
| `register.cmd` / `deregister.cmd` | Self-contained REXX scripts (start with `/* */`); no separate `.rex` file |

---

## Changelog

### 1.2 — 2026-08-30
- Open Watcom port: `Makefile.wat`, `mk.cmd`, `genbind.cmd`
- Files reorganized into `idl/`, `h/`, `src/`, `doc/`, `release/`
- `SRCTRANS.CSC` converted to `idl/srctrans.idl` (SOM 2.x IDL format)
- SMINCLUDE requires both `C:\os2tk45\idl` (WPS IDL) and `C:\os2tk45\som\include` (base SOM IDL)
- IDL passthru: no `\n` escape sequences; `using namespace std;` after C headers; `#include <wpfolder.xh>`
- Created `src/srctrans_res.h` (wrc-safe resource constants)
- `src/srctrans.rc`: replaced `#include "srctrans.ph"` / `<wpobject.h>` with `<os2.h>` + `"srctrans_res.h"`
- Created `src/srctrans.def` (wlink-format, BLDLEVEL)
- `src/srctrans.cpp`: four fixes (uninitialized DrgQueryStrName args, `delete[]`, `wpAllocMem NULL`, `WPFolder *` cast)
- `register.cmd` / `deregister.cmd`: self-contained REXX (no separate `.rex` wrapper)
- Added `.gitattributes`

---

## Original README

This small offering shows how to perform a source rendered drag/drop in the
WPS of OS/2.  All drag/drop operations performed in the WPS are target
rendered, so you have no control if you are coding a WPS class which needs
to be part of the rendering in such an operation.

LICENSE: AS IS
AUTHORS: Andrew Clinch
ORIGINAL COMPILE TOOLS: LINK386, sc, icc
