{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvJVCLAbout.PAS, released on 2001-02-28.

The Initial Developer of the Original Code is Michael Beck [mbeck@bigfoot.com]
Portions created by Michael Beck are Copyright (C) 2002 Michael Beck
All Rights Reserved.

Contributor(s):

Last Modified: 2000-02-28

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I JVCL.INC}

unit JvJVCLAbout;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls, Forms, Buttons, IniFiles,
  Dialogs, StdCtrls, ExtCtrls, jpeg,
  JvBaseDlg, JclSysInfo, JclWin32, JVCLVer, JvComponent;

type
  TJvJVCLAboutForm = class(TForm)
    Bevel1: TBevel;
    lblVersion: TLabel;
    pnlImage: TPanel;
    imgStarfield: TImage;
    btnOK: TButton;
    JvHotLink1: TLabel;
    JvHotLink4: TLabel;
    lblNews: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    lblCopyRight: TLabel;
    lblRights: TLabel;
    imgProjectJEDI: TImage;
    MainPanel: TPanel;
    Bevel2: TBevel;
    lblVisitJedi: TLabel;
    lblMailingList: TLabel;
    lblNewsgroup: TLabel;
    lblJvHotLink2: TLabel;
    lblBugs: TLabel;
    lblBugsURL: TLabel;
    Bevel3: TBevel;
    lblWindowsVersion: TLabel;
    Label4: TLabel;
    lblMemory: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure JvHotLink1Click(Sender: TObject);
  private
  public
    procedure LoadOptions;
    procedure SaveOptions;
    class procedure Execute(StoreSettings:boolean);
  end;
  
  TJvJVCLAboutComponent = class(TJvCommonDialogP)
  private
    FStoreSettings: boolean;
  public
    procedure Execute;override;
  published
    property StoreSettings:boolean read FStoreSettings write FStoreSettings default false;
  end;

implementation
uses
  JvFunctions;

{$R *.dfm}


procedure TJvJVCLAboutForm.FormShow(Sender: TObject);
var
  VersionInfo: TOSVersionInfoEx;
begin
  FillChar(VersionInfo, SizeOf(TOSVersionInfoEx), #0);
  VersionInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfoEx);
  JclWin32.GetVersionEx(@VersionInfo);
  lblVersion.Caption := 'Version: ' + JVCL_VERSIONSTRING;
  if VersionInfo.wServicePackMajor = 0 then
    lblWindowsVersion.Caption := Format('%s (Build %u)',
      [GetWindowsVersionString, VersionInfo.dwBuildNumber])
  else
    lblWindowsVersion.Caption := Format('%s (Build %u: %s)',
      [GetWindowsVersionString, VersionInfo.dwBuildNumber, GetWindowsServicePackVersionString]);
  lblMemory.Caption := Format('%u KB', [GetTotalPhysicalMemory div 1024]);
  lblCopyRight.Caption := 'Copyright � Project JEDI, 1999 - ' + FormatDateTime('yyyy', Now);
//  LoadOptions;

end;

procedure TJvJVCLAboutForm.Panel1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  Perform(WM_SYSCOMMAND, SC_MOVE + 2, 0);
end;

procedure TJvJVCLAboutForm.LoadOptions;
var
  l, t: Integer;
begin
  with TIniFile.Create(ExtractFileDir(Application.ExeName) + '\JVCL.ini') do
  try
    l := ReadInteger('Options', 'Bounds.Left', -1);
    t := ReadInteger('Options', 'Bounds.Top', -1);
  finally
    Free;
  end;

  //make sure the form is positioned on screen ...
  //(ie make sure nobody's fiddled with the INI file!)
  if (l >= 0) and (t >= 0) and (l < Screen.Width) and (t < Screen.Height) then
  begin
    Left := l;
    Top := t;
  end;
end;

procedure TJvJVCLAboutForm.SaveOptions;
begin
  with TIniFile.Create(ExtractFileDir(Application.ExeName) + '\JVCL.ini') do
  try
    if WindowState = wsNormal then
    begin
      WriteInteger('Options', 'Bounds.Left', Left);
      WriteInteger('Options', 'Bounds.Top', Top);
    end;
  finally
    Free;
  end;
end;

procedure TJvJVCLAboutForm.FormDestroy(Sender: TObject);
begin
//  SaveOptions;
end;

procedure TJvJVCLAboutForm.btnOKClick(Sender: TObject);
begin
  Close;
end;

{ TJvJVCLAboutComponent }

procedure TJvJVCLAboutComponent.Execute;
begin
  TJvJVCLAboutForm.Execute(StoreSettings);
end;

class procedure TJvJVCLAboutForm.Execute(StoreSettings: boolean);
begin
  with self.Create(Application) do
  try
    if StoreSettings then LoadOptions;
    ShowModal;
    if StoreSettings then SaveOptions;
  finally
    Free;
  end;
end;

procedure TJvJVCLAboutForm.JvHotLink1Click(Sender: TObject);
begin
  OpenObject((Sender as TLabel).Caption);
end;

end.

