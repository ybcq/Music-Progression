; Inno Setup 配置文件
; 自动生成自旧格式配置文件

[Setup]
; 基本设置
AppId={Guitar Pro Lite}
AppName=Guitar Pro Lite
AppVersion=1.0.0.2019
AppVerName=Guitar Pro Lite 1.0.0.2019
AppPublisher=御坂初琴の软件屋
AppPublisherURL=https://ybcq.github.io/
AppSupportURL=https://github.com/ybcq/
AppUpdatesURL=https://github.com/ybcq/
DefaultDirName={autopf}\Guitar
DefaultGroupName=Guitar Pro Lite
AllowNoIcons=yes
OutputBaseFilename=Guitar Pro Lite
Compression=lzma
SolidCompression=yes
SetupIconFile=E:\软件工程\图标\Setup.ico
WizardImageFile=E:\Projects\@安装包配图\向导图像.bmp
WizardSmallImageFile=E:\Projects\@安装包配图\标题图像.png
LicenseFile=E:\Projects\@软件协议\协议.txt

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "chinese"; MessagesFile: "compiler:Languages\ChineseSimplified.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 6.1; Check: not IsAdminInstallMode

[Files]
Source: "E:\Projects\Guitar Pro Lite\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Guitar Pro Lite"; Filename: "{app}\GuitarPro.exe"
Name: "{autodesktop}\Guitar Pro Lite"; Filename: "{app}\GuitarPro.exe"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\Guitar Pro Lite"; Filename: "{app}\GuitarPro.exe"; Tasks: quicklaunchicon

[Code]
// 自定义初始化过程
function InitializeSetup(): Boolean;
begin
  Result := True;
end;
