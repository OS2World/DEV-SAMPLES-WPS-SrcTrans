                        Source Render Drag/Drop Example
                        Author: Andrew Clinch
                        Date: 10th January, 1994


Introduction
------------

This small offering shows how to perform a source rendered drag/drop in the 
WPS of OS/2.  All drag/drop operations performed in the WPS are target
rendered, so you have no control if you are coding a WPS class which needs
to be part of the rendering in such an operation.

The example simply shows a copy command being performed on an object that is
dragged and dropped in a folder.


How It Works
------------

It turns out (after much dialog on CIS) that the solution to getting a source
render is quite simple.  These are the key steps :

        1 -     Override the wpFormatDragItem method in your source class.
                In this method, remove the hstrSourceName field contents
                from the DRAGITEM structure, and change the hstrRMF field
                to be <DRM_OS2FILE, DRF_UNKNOWN> (this is set to
                <DRM_OBJECT, DRF_OBJECT> by the parent method.  Then create
                an object window, and substitute the hwndItem field with
                the handle to the object window.

        2 -     In the object window procedure, code for the DM_RENDER
                message.  This is sent by the target, as there is not
                sufficient information for it to complete the rendering.

And thats it boys and girls.


Thanks To
---------

Many thanks go to Dan Kehn and Gregory Czaja for helping me get this sort of
stuff working.  Hope the sample helps for your work!


Installation
------------

Just run inst.exe, passing as the only parameter the fully qualified path
name of the srctrans.dll (eg. 'c:\os2\dll\srctrans.dll').  It will
create a SrcTransient instance called "dragit" on the Desktop.  Just drag
and drop this in another folder, and it should (not going to commit myself
here) copy the object to where you dropped it (regardless of the modification
keys you hold down).  This copy is done by the source object, not the
target folder.


Disclaimer
----------

In no event shall Andrew Clinch be liable for any damages whatsoever
(including, without limitation, damaged or loss of business profits, business
interruption, loss of business information, or other pecuniary loss) arising
out of the use or inability to use this sample code, even if Andrew Clinch
has been advised of the possibility of such damages.

