@echo off

:setFolder
set /p folder="Please type 'Folder' name:"
if not exist "%folder%" (
  echo Error! "%folder%" folder doesn't exist!
  echo Please type the folder name again!
  pause
  goto setFolder
)

:setRenameMethod
set /p renameMethod="(A)a,b,c,d in one folder (B)change title and volume in one folder (C)a,b in every sub-folder (D)No a,b in one folder [A,B,C,D]? "
if %renameMethod% == d goto normalNumberRename
if %renameMethod% == D goto normalNumberRename
if %renameMethod% == c goto renameMultiAB
if %renameMethod% == C goto renameMultiAB
if %renameMethod% == b goto renameTitleVolume
if %renameMethod% == B goto renameTitleVolume
if %renameMethod% == a goto renameABCD
if %renameMethod% == A goto renameABCD

echo.
echo "Please type 'a' or 'b' or 'c' or 'd' to select rename method."
pause
echo.
goto setRenameMethod

:normalNumberRename
set /p EXT=Please Enter filename Extension(example: .jpg or .tif):
set /p titleName="Please key in 'Title':" 
set /p volume="Please key in 'Volume' name:"
set /a firstPage=1
set /p firstPage="please key in 'First' page number:"
echo Please key in skipping page number from small to large
echo (example:1 15) then these two page numbers 1 and 15 will be skipped
echo (wrong example: 15 1) not small to large
set /p skipPages=Which pages do you want to skip(small to large page):

:confirmNormalNumberRename
set /p shouldRenameNormalNumber="Are you sure to rename files in folder '%folder%'? [Y,N] "
if %shouldRenameNormalNumber% == n goto cancel
if %shouldRenameNormalNumber% == N goto cancel
if %shouldRenameNormalNumber% == y (
  call :excuteNormalNumberRename
  goto preCancel
)
if %shouldRenameNormalNumber% == Y (
  call :excuteNormalNumberRename
) else (
  echo.
  echo "Please type 'y' or 'n' to rename files."
  pause
  echo.
  goto confirmNormalNumberRename
)

goto preCancel

:renameMultiAB
setlocal EnableDelayedExpansion
set /p EXT=Please Enter filename Extension(example: .jpg or .tif):

:confirmRenameMultiAB
set /p shouldRenameMultiAB="Are you sure to rename files in folder '%folder%'? [Y,N] "
if %shouldRenameMultiAB% == n goto cancel
if %shouldRenameMultiAB% == N goto cancel
if %shouldRenameMultiAB% == y goto onRenameMultiAB
if %shouldRenameMultiAB% == Y (
  goto onRenameMultiAB
) else (
  echo.
  echo "Please type 'y' or 'n' to rename files."
  pause
  echo.
  goto confirmRenameMultiAB
)

:onRenameMultiAB
set /a firstPage=1
cd "%folder%"
set i=0
for /f %%f in ('dir /a:d /b') do (
  set folder=%%f
  set titleName=%%f
  call :excute
)
goto preCancel

:renameABCD
set /p EXT=Please Enter filename Extension(example: .jpg or .tif):
set /p titleName="Please key in 'Title':" 
set /p volume="Please key in 'Volume' name:"
set /a firstPage=1
set /p firstPage="please key in 'First' page number:"
echo Please key in C,D page number from small to large
echo (example:1 15) will get 001c 001d 015c 015d
echo (wrong example: 15 1) not small to large
echo (wrong exmaple: 1c 1d) don't key in letters
set /p cdPages=Please key in C,D pages here:
set /p skipPages=Which pages do you want to skip(small to large page):

:confirmRenameABCD
set /p shouldRenameABCD="Are you sure to rename files in folder '%folder%'? [Y,N] "
if %shouldRenameABCD% == n goto cancel
if %shouldRenameABCD% == N goto cancel
if %shouldRenameABCD% == y (
  call :excute
  goto preCancel
)
if %shouldRenameABCD% == Y (
  call :excute
) else (
  echo.
  echo "Please type 'y' or 'n' to rename files."
  pause
  echo.
  goto confirmRenameABCD
)

goto preCancel

:excuteNormalNumberRename
setlocal EnableDelayedExpansion
::make array of file names in the folder
cd "%folder%"
set i=0
for %%a in (*) do (
   set /a i+=1
   set list[!i!]=%%a
)
set filesN=%i%
::make array of skipPages
set /a skipCount=0

for %%a in (%skipPages%) do (
  if %%a geq 1 (
    for /f "tokens=* delims=0" %%b in ("%%a") do (
      set /a decNum2=%%b
    )

    set /a skipCount+=1
    set skipPages[!skipCount!]=!decNum2!
  )
)

if not defined skipPages[1] (
  set skipPage=noPage
) else (
  set /a skipPageI=1
  call set /a skipPage=%%skipPages[!skipPageI!]%%
)
::make array of new names
set /a newNameI=0
set /a countDown=%filesN%
set /a finalPage=%firstPage%+%filesN%+%skipCount%

for /l %%a in (%firstPage%,1,%finalPage%) do (
  if !countDown! leq 0 goto newNormalNamesMaked
  if %%a equ !skipPage! (
    set /a skipPageI+=1
    if defined skipPages[!skipPageI!] (
      call set /a skipPage=%%skipPages[!skipPageI!]%%
    )
  ) else (
    set /a newNameI+=1
    ::make a,b page names
    if %%a lss 10 (
      set newNames[!newNameI!]=00%%a
    ) 
    if %%a geq 10 (
      if %%a lss 100 (
        set newNames[!newNameI!]=0%%a
      )
    )
    if %%a geq 100 (
      set newNames[!newNameI!]=%%a
    )
    set /a countDown-=1
  )
)
:newNormalNamesMaked

::renameNormalNumber
for /l %%a in (1,1,%filesN%) do (
  set newName=!newNames[%%a]!
  ren "!list[%%a]!" %titleName%%volume%-!newName!%EXT%
)
Exit /b

:excute
setlocal EnableDelayedExpansion
::make array of file names in the folder
cd "%folder%"
set i=0
for %%a in (*) do (
   set /a i+=1
   set list[!i!]=%%a
)
set filesN=%i%
::make array of c,d pages
set /a cdCount=0

for %%a in (%cdPages%) do (
  if %%a geq 1 (
    for /f "tokens=* delims=0" %%b in ("%%a") do (
      set /a decNum=%%b
    )

    set /a cdCount+=1
    set cdPages[!cdCount!]=!decNum!
  )
)

if not defined cdPages[1] (
  set cdPage=noPage
) else (
  set /a cdPageI=1
  call set /a cdPage=%%cdPages[!cdPageI!]%%
)
::make array of skipPages
set /a skipCount=0

for %%a in (%skipPages%) do (
  if %%a geq 1 (
    for /f "tokens=* delims=0" %%b in ("%%a") do (
      set /a decNum2=%%b
    )

    set /a skipCount+=1
    set skipPages[!skipCount!]=!decNum2!
  )
)

if not defined skipPages[1] (
  set skipPage=noPage
) else (
  set /a skipPageI=1
  call set /a skipPage=%%skipPages[!skipPageI!]%%
)
::make array of new names
set /a newNameI=0
set /a countDown=%filesN%
set /a finalPage=%firstPage%+%filesN%

for /l %%a in (%firstPage%,1,%finalPage%) do (
  if !countDown! leq 0 goto newNamesMaked
  if %%a equ !skipPage! (
    set /a skipPageI+=1
    if defined skipPages[!skipPageI!] (
      call set /a skipPage=%%skipPages[!skipPageI!]%%
    )
  ) else (
    set /a newNameI+=1
    ::make a,b page names
    if %%a lss 10 (
      set newNames[!newNameI!]=00%%aa
      set /a newNameI+=1
      set newNames[!newNameI!]=00%%ab
    ) 
    if %%a geq 10 (
      if %%a lss 100 (
        set newNames[!newNameI!]=0%%aa
        set /a newNameI+=1
        set newNames[!newNameI!]=0%%ab
      )
    )
    if %%a geq 100 (
      set newNames[!newNameI!]=%%aa
      set /a newNameI+=1
      set newNames[!newNameI!]=%%ab
    )
    set /a countDown-=2
    ::make c,d page names
    if %%a equ !cdPage! (
      set /a newNameI+=1
      set /a cdPageI+=1
      if defined cdPages[!cdPageI!] (
        call set /a cdPage=%%cdPages[!cdPageI!]%%
      )
      if %%a lss 10 (
        set newNames[!newNameI!]=00%%ac
        set /a newNameI+=1
        set newNames[!newNameI!]=00%%ad
      )
      if %%a geq 10 (
        if %%a lss 100 (
          set newNames[!newNameI!]=0%%ac
          set /a newNameI+=1
          set newNames[!newNameI!]=0%%ad
        )
      )
      if %%a geq 100 (
        set newNames[!newNameI!]=%%ac
        set /a newNameI+=1
        set newNames[!newNameI!]=%%ad
      )
      set /a countDown-=2
    )
  )
)
:newNamesMaked

::renameA.B,C,D
for /l %%a in (1,1,%filesN%) do (
  set newName=!newNames[%%a]!
  ren "!list[%%a]!" %titleName%%volume%-!newName!%EXT%
)
Exit /b

:renameTitleVolume
set /p newTitle="Please key in new 'Title':"
set /p newVolume="Please key in new 'Volume' name:"

:confirmRenameTitleVolume
set /p shouldRenameTitleVolume="Are you sure to rename files in folder '%folder%'? [Y,N] "
if %shouldRenameTitleVolume% == n goto cancel
if %shouldRenameTitleVolume% == N goto cancel
if %shouldRenameTitleVolume% == y goto excuteRenameTV
if %shouldRenameTitleVolume% == Y (
  goto excuteRenameTV
) else (
  echo.
  echo "Please type 'y' or 'n' to rename files."
  pause
  echo.
  goto confirmRenameTitleVolume
)
::make array of file names in the folder
:excuteRenameTV
setlocal EnableDelayedExpansion
cd "%folder%"
for %%a in (*) do (
  set oldTVname=%%a
  set newTVname=!oldTVname:*-=%newTitle%%newVolume%-!
  ren !oldTVname! !newTVname!
)

:preCancel
pause
:cancel
