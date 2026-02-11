[Setup]
AppName=Minesweeper
AppVersion=1.0.0
DefaultDirName={autopf}\Minesweeper
DefaultGroupName=Minesweeper
OutputDir=installer
OutputBaseFilename=MinesweeperSetup
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Files]
Source: "*.*"; DestDir: "{app}"; Flags: recursesubdirs ignoreversion

[Icons]
Name: "{group}\Minesweeper"; Filename: "{app}\Minesweeper.exe"; IconFilename: "{app}\window_icon.ico"
Name: "{commondesktop}\Minesweeper"; Filename: "{app}\Minesweeper.exe"; Tasks: desktopicon; IconFilename: "{app}\window_icon.ico"




[Tasks]
Name: "desktopicon"; Description: "Create a desktop icon"; GroupDescription: "Additional icons:"

[Run]
Filename: "{app}\Minesweeper.exe"; Description: "Launch Minesweeper"; Flags: nowait postinstall skipifsilent
