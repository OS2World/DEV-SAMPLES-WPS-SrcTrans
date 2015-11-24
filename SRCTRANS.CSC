//
//  Source render drag/drop sample
//
//  Author : Andrew Clinch
//
//  Disclaimer :
//  In no event shall Andrew Clinch be liable for any damages whatsoever
//  (including, without limitation, damaged or loss of business profits, business
//  interruption, loss of business information, or other pecuniary loss) arising
//  out of the use or inability to use this sample code, even if Andrew Clinch
//  has been advised of the possibility of such damages.
//

#******************************************************************************
#   Include the class definition file for the parent class
#******************************************************************************

include <wptrans.sc>

#******************************************************************************
#   Define the new class
#******************************************************************************

class: SrcTransient,
       external stem   = src,
       local,
       external prefix = src_,
       classprefix     = srcM_,
       major version   = 1,
       minor version   = 1;

--
-- CLASS: VCDataFile
--
-- CLASS HIERARCHY:
--
--     SOMObject
--       ÀÄÄ WPObject
--             ÀÄÄ WPTransient
--                   ÀÄÄ SrcTransient
--
-- DESCRIPTION:
--
--    
--
--    
--

#******************************************************************************
#   Specify the parent class
#******************************************************************************

parent: WPTransient;

#******************************************************************************
#   Passthru IMPLEMENTATION definitions to the .xih file - BEFORE
#******************************************************************************

passthru: C.xih, before;

   #define INCL_WIN
   #define INCL_DOS
   #define INCL_GPIBITMAPS
   #define INCL_DOSERRORS
   #include <os2.h>
   #include <string.h>
   #include <stdio.h>
   #include <memory.h>
   #include <stdlib.h>
   #include <setjmp.h>

   #define INCL_WPCLASS
   #define INCL_WPFOLDER
   #include <pmwp.h>

   #include "srctrans.ph"

endpassthru;   /* .xih after */

#******************************************************************************
#   Passthru IMPLEMENTATION definitions to the .xih file - AFTER
#******************************************************************************

passthru: C.xih, after;

    /*
     *   DRAGSTRUCT:  Structure used for object window
     */
    typedef struct _DRAGSTRUCT
    {
        USHORT      cb;
        SrcTransient  *somSelf;
    } DRAGSTRUCT;
    typedef DRAGSTRUCT *PDRAGSTRUCT;

endpassthru;   /* .xih after */

#******************************************************************************
#   Define methods
#******************************************************************************

methods:

#******************************************************************************
#   Specify methods being overridden
#******************************************************************************

-----------------------------------------------------------------------------
--   Methods from the WPObject class
-----------------------------------------------------------------------------

override wpFormatDragItem;
--
-- METHOD: wpFormatDragItem                               ( ) PRIVATE
--                                                        (X) PUBLIC
-- DESCRIPTION:
--
--   Allow the object to set its drag info
--
--

#******************************************************************************
#   Define class methods
#******************************************************************************

HMODULE  clsQueryModuleHandle (), class;
--
-- METHOD: clsQueryModuleHandle                           ( ) PRIVATE
--                                                        (X) PUBLIC
-- DESCRIPTION:
--
--   This method returns the module handle of this class.  If this is the
--   first invocation, DosQueryModuleHandle is called to save the handle
--   for future invocations.
--
-- RETURN:
--
--   0              Unsuccessful
--   non-zero       module handle
--

#******************************************************************************
#   Specify class methods being overridden
#******************************************************************************

override wpclsQueryIconData, class;
--
-- METHOD: clsQueryIconData                               ( ) PRIVATE
--                                                        (X) PUBLIC
-- DESCRIPTION:
--
--   Return the class icon.
--

