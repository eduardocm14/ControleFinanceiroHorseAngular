unit uBrowserHelper;

interface

type
  TBrowserHelper = class
  public
    class procedure OpenURL(const AURL: string);
  end;

implementation

uses
  ShellAPI, Windows;

class procedure TBrowserHelper.OpenURL(const AURL: string);
begin
  ShellExecute(0, 'open', PChar(AURL), nil, nil, SW_SHOWNORMAL);
end;

end.
