{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvTipProperty.PAS, released on 2002-05-26.

The Initial Developer of the Original Code is Peter Th�rnqvist [peter3@peter3.com]
Portions created by Peter Th�rnqvist are Copyright (C) 2002 Peter Th�rnqvist.
All Rights Reserved.

Contributor(s):

Last Modified: 2002-05-26

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I JVCL.INC}

{ Property editor for the TJvTipWindow components }

unit JvTipOfDayProp;

interface

uses
{$IFDEF COMPILER6_UP}DesignEditors, DesignIntf{$ELSE}DsgnIntf{$ENDIF};
type
  { a component editor that by default opens the editor for the Items property in TTimeline }
  TJvTipOfDayEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    procedure Edit; override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

resourcestring
  SEditProperty = 'Preview...';

procedure Register;

implementation

uses
  SysUtils, JvTipOfDay,
  Classes; // Alleen voor RegisterComponents; nog weghalen

{ TJvTipPropertyEditor }

procedure TJvTipOfDayEditor.Edit;
var
  SavedOptions: TJvTipOfDayOptions;
begin
{$IFDEF COMPILER6_UP}
  with GetComponent as TJvTipOfDay do
  begin
{$ELSE}
  if Component is TJvTipOfDay then
    with TJvTipOfDay(Component) do
    begin
{$ENDIF}
      SavedOptions := Options;
      Options := [toShowOnStartUp];
      try
        Execute;
      finally
        Options := SavedOptions;
      end;
    end;
end;

procedure TJvTipOfDayEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then
    Edit
  else
    inherited;
end;

function TJvTipOfDayEditor.GetVerb(Index: Integer): string;
begin
  if Index = 0 then
    Result := SEditProperty
  else
    Result := '';
end;

function TJvTipOfDayEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

procedure Register;
begin
  RegisterComponents('Test', [TJvTipOfDay]);
  RegisterComponentEditor(TJvTipOfDay, TJvTipOfDayEditor);
end;

end.

