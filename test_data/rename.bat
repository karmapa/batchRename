@echo off
:setFolder
set /p folder="Please type 'Folder' name:"
if not exist "%folder%" (
  echo Error! "%folder%" folder doesn't exist!
  echo Please type the folder name again!
  pause
  goto setFolder
)

set /p EXT=Please Enter filename Extension(example: .jpg or .tif):
set /p titleName=Please Enter newName's form, "title" name: 
set /p volume=Please Enter "Volume" name:
set /p cdPages=Please key in the page number of C,D(Separate pages by "space", example: 100 200):

choice /C YNC /M "Are you sure rename all files in the %folder%?"
if errorlevel 3 goto cancel 
if errorlevel 2 goto cancel
if errorlevel 1 goto excute

:excute
setlocal EnableDelayedExpansion

::make array of file names in the folder
cd "%folder%"
set i=0
for %%a in (*) do (
   set /A i+=1
   set list[!i!]=%%a
)
set filesN=%i%

::make array of c,d pages
set /a cdCount=0

for %%a in (%cdPages%) do (

  for /f "tokens=* delims=0" %%b in ("%%a") do (
    set /a decNum=%%b
  )

  set /a cdCount+=1
  set cdPages[!cdCount!]=!decNum!
)

if not defined cdPages[1] (
  set cdPage=noPage
) else (
  set /a cdPageI=1
  call set /a cdPage=%%cdPages[!cdPageI!]%%
)

::make array of new names
set /a newNameI=0
set /a countDown=%filesN%

for /l %%a in (1,1,%filesN%) do (
  if !countDown! leq 0 goto newNamesMaked
  set /a newNameI+=1
  if %%a equ !cdPage! (
    set /a cdPageI+=1
    if defined cdPages[!cdPageI!] (
      call set /a cdPage=%%cdPages[!cdPageI!]%%
    )
    if %%a lss 10 (
      set newNames[!newNameI!]=00%%aa
      set /a newNameI+=1
      set newNames[!newNameI!]=00%%ab
      set /a newNameI+=1
      set newNames[!newNameI!]=00%%ac
      set /a newNameI+=1
      set newNames[!newNameI!]=00%%ad
    )
    if %%a geq 10 (
      if %%a lss 100 (
        set newNames[!newNameI!]=0%%aa
        set /a newNameI+=1
        set newNames[!newNameI!]=0%%ab
        set /a newNameI+=1
        set newNames[!newNameI!]=0%%ac
        set /a newNameI+=1
        set newNames[!newNameI!]=0%%ad
      )
    )
    if %%a geq 100 (
      set newNames[!newNameI!]=%%aa
      set /a newNameI+=1
      set newNames[!newNameI!]=%%ab
      set /a newNameI+=1
      set newNames[!newNameI!]=%%ac
      set /a newNameI+=1
      set newNames[!newNameI!]=%%ad
    )
    set /a countDown-=4
  ) else (
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
  )
)
:newNamesMaked

::rename
for /l %%a in (1,1,%filesN%) do (
  set newName=!newNames[%%a]!
  ren "!list[%%a]!" %titleName%%volume%-!newName!%EXT%
)

pause
:cancel