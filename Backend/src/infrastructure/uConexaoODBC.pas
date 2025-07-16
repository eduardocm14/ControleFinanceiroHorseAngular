unit uConexaoODBC;

interface

uses
  System.SysUtils,
  System.Classes,
  Data.Win.ADODB,
  Data.DB,
  ActiveX;          // <--- para CoInitialize e CoUninitialize;;

type
  TConexaoODBC = class
  private
    FConnection: TADOConnection;
  public
    constructor Create;
    destructor Destroy; override;
    function GetConnection: TADOConnection;
  end;

implementation

{ TConexaoODBC }

constructor TConexaoODBC.Create;
begin
  CoInitialize(nil);      // Inicializa COM
  FConnection := TADOConnection.Create(nil);
  try
    // Conexão via DSN (pré-configurado no Painel de Controle)
    // FConnection.ConnectionString := 'DSN=PostgreSQL_DSN_Name';

    // OU conexão direta sem DSN (DSN-Less)
    FConnection.ConnectionString :=
      'Driver={PostgreSQL Unicode};' +
      'Server=localhost;' +
      'Port=5432;' +
      'Database=ControleFinanceiro;' +
      'Uid=postgres;' +
      'Pwd=root;';

    FConnection.LoginPrompt := False;
    FConnection.Connected := True;
    Writeln('Conexão com o banco de dados(PostgreSQL) estabelecida com sucesso!');
  except
    on E: Exception do
      raise Exception.Create('Erro ao conectar via ODBC: ' + E.Message);
  end;
end;

destructor TConexaoODBC.Destroy;
begin
  FConnection.Free;
  CoUninitialize;      // Libera COM
  inherited;
end;

function TConexaoODBC.GetConnection: TADOConnection;
begin
  Result := FConnection;
end;

end.

