@echo off
set /p folder=Please Enter "Folder" name:
set /p EXT=Please Enter filename Extension(i.e.: .jpg or .tif):
set /p titleName=Please Enter newName's form, "title" name: 
set /p volume=Please Enter "Volume" name:

choice /C YNC /M "Are you sure rename all files in the %folder%?"
if errorlevel 3 goto cancel 
if errorlevel 2 goto cancel
if errorlevel 1 goto excute

:excute 
setlocal EnableDelayedExpansion

rem Populate the array with existent files in folder
set i=0
for %%a in (%cd%\"%folder%"\*) do (
   set /A i+=1
   set list[!i!]=%%a
)
set Filesx=%i%

rem Display array elements
set level1=0
set level2=-1
for /L %%i in (1,1,%Filesx%) do (
	set /a s=%%i%%2
	if !s!==0 (
		set /a level1+=1
		set /a num1=%%i-!level1! 
		if !num1! lss 10 set newName1=00!num1!b
		if !num1! geq 10 set newName1=0!num1!b
		if !num1! geq 100 set newName1=!num1!b
		ren "!list[%%i]!" %titleName%%volume%-!newName1!%EXT%
	) else (
		set /a level2+=1
		set /a num2=%%i-!level2!
		if !num2! lss 10 set newName2=00!num2!a
		if !num2! geq 10 set newName2=0!num2!a
		if !num2! geq 100 set newName2=!num2!a
		ren "!list[%%i]!" %titleName%%volume%-!newName2!%EXT%
	)
)

pause
:cancel