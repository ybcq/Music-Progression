@echo off

::根本没有窗口

::建立快捷方式
::set "exe=Overture.exe"
::set "lnk=Overture4"
::mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(a.SpecialFolders(""Desktop"") & ""\%lnk%.lnk""):b.TargetPath=""%~dp0%exe%"":b.WorkingDirectory=""%~dp0"":b.Save:close")

::set "exe=Overture5_cn.exe"
::set "lnk=Overture5中文版"
::mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(a.SpecialFolders(""Desktop"") & ""\%lnk%.lnk""):b.TargetPath=""%~dp0%exe%"":b.WorkingDirectory=""%~dp0"":b.Save:close")

::set "exe=Overture5_en.exe"
::set "lnk=Overture5英文版"
::mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(a.SpecialFolders(""Desktop"") & ""\%lnk%.lnk""):b.TargetPath=""%~dp0%exe%"":b.WorkingDirectory=""%~dp0"":b.Save:close")
start wscript "%~dp0Fonts\InstallFonts.vbs"

assoc .ove=OvertureFiles
assoc .mid=OvertureFiles
assoc .ovex=Overture5Files
assoc .xml=Overture5Files
ftype OvertureFiles="%~dp0Overture.exe" %1
ftype Overture5Files="%~dp0Overture5_cn.exe" %1

del "%~dp0Fonts\InstallFonts.vbs"
del %