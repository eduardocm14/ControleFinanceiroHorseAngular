unit UfrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Menus,
  Vcl.WinXPanels, Vcl.StdCtrls;

type
  TFrmPrincipal = class(TForm)
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    Configurao1: TMenuItem;
    ValidarConexoBancoDados1: TMenuItem;
    ConfiguraoBancoDados1: TMenuItem;
    BackupBancoDados1: TMenuItem;
    CategoryPanelGroup1: TCategoryPanelGroup;
    CategoryPanel1: TCategoryPanel;
    CategoryPanel2: TCategoryPanel;
    CategoryPanel3: TCategoryPanel;
    CategoryPanel4: TCategoryPanel;
    ComboBox1: TComboBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

end.
