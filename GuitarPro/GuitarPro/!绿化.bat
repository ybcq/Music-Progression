@echo off

color 4f 
title ÂÌ»¯²¹¶¡

set "exe=GuitarPro.exe"
set "lnk=GuitarPro 6 Lite"
mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(a.SpecialFolders(""Desktop"") & ""\%lnk%.lnk""):b.TargetPath=""%~dp0%exe%"":b.WorkingDirectory=""%~dp0"":b.Save:close")

set "exe=GP5.exe"
set "lnk=GuitarPro 5"
mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(a.SpecialFolders(""Desktop"") & ""\%lnk%.lnk""):b.TargetPath=""%~dp0%exe%"":b.WorkingDirectory=""%~dp0"":b.Save:close")

set "exe=¼ªËûÆ×ÔÄÀÀÆ÷.exe"
set "lnk=¼ªËûÆ×ÔÄÀÀÆ÷(ÊÕ·Ñ)"
mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(a.SpecialFolders(""Desktop"") & ""\%lnk%.lnk""):b.TargetPath=""%~dp0%exe%"":b.WorkingDirectory=""%~dp0"":b.Save:close")

assoc .gpx=GuitarPro6Files
assoc .gp5=GuitarProFiles
assoc .gp4=GuitarProFiles
assoc .gp3=GuitarProFiles
assoc .xml=GuitarProFiles
assoc .mid=GuitarProFiles
ftype GuitarPro6Files="%~dp0\GuitarPro.exe" %1
ftype GuitarProFiles="%~dp0\GP5.exe" %1

regedit /s ./Install.reg

start wscript "%~dp0fonts\InstallFonts.vbs"
start /d "%~dp0" vcredist_x86.exe /q

start /d "%~dp0crack\" KeyGen.exe"

del "%~dp0Fonts\InstallFonts.vbs"
del Install.reg
del %