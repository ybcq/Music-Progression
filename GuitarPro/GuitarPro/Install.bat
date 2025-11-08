@echo off

::没有窗口

::创建快捷方式
::set "exe=GuitarPro.exe"
::set "lnk=GuitarPro 6 Lite"
::mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(a.SpecialFolders(""Desktop"") & ""\%lnk%.lnk""):b.TargetPath=""%~dp0%exe%"":b.WorkingDirectory=""%~dp0"":b.Save:close")

set "exe=GP5.exe"
set "lnk=GuitarPro 5"
mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(a.SpecialFolders(""Desktop"") & ""\%lnk%.lnk""):b.TargetPath=""%~dp0%exe%"":b.WorkingDirectory=""%~dp0"":b.Save:close")

set "exe=吉他谱阅览器.exe"
set "lnk=吉他谱阅览器(收费)"
mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(a.SpecialFolders(""Desktop"") & ""\%lnk%.lnk""):b.TargetPath=""%~dp0%exe%"":b.WorkingDirectory=""%~dp0"":b.Save:close")

::设置文件关联
assoc .gpx=GuitarPro6Files
assoc .gp5=GuitarProFiles
assoc .gp4=GuitarProFiles
assoc .gp3=GuitarProFiles
assoc .xml=GuitarProFiles
assoc .mid=GuitarProFiles
::ftype GuitarPro6Files="%~dp0\GuitarPro.exe" %1
ftype GuitarProFiles="%~dp0\GP5.exe" %1

::破解补丁
regedit /s ./Install.reg

::字体安装
start wscript "%~dp0fonts\InstallFonts.vbs"
start /d "%~dp0" vcredist_x86.exe /q

::唤醒破解补丁
start /d "%~dp0crack\" KeyGen.exe"

::清理临时文件
::del "%~dp0Fonts\InstallFonts.vbs"
::del Install.reg
::del %