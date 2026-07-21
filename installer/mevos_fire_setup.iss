#define MyAppName "MEVOS Fire"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "MEVOS"
#define MyAppExeName "mevos_fire.exe"
#define BuildDir "..\build\windows\x64\runner\Release"

[Setup]
AppId={{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
OutputDir=output
OutputBaseFilename=MevosFireSetup_v{#MyAppVersion}
Compression=lzma
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=admin

[Languages]
Name: "turkish"; MessagesFile: "compiler:Languages\Turkish.isl"

[Tasks]
Name: "desktopicon"; Description: "Masaüstü kısayolu oluştur"; GroupDescription: "Ek görevler:"; Flags: unchecked

[Files]
; Ana çalıştırılabilir dosya
Source: "{#BuildDir}\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion

; DLL dosyaları
Source: "{#BuildDir}\flutter_windows.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#BuildDir}\url_launcher_windows_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion

; Data klasörü (flutter_assets, icudtl.dat, app.so)
Source: "{#BuildDir}\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{#MyAppName}'i Kaldır"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{#MyAppName}'i başlat"; Flags: nowait postinstall skipifsilent
