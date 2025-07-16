program ControleFinanceiroAPI;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.Jhonson,
  Horse.GBSwagger,
  uConexaoSQLServer in 'infrastructure\uConexaoSQLServer.pas',
  uTesteConexao in 'infrastructure\uTesteConexao.pas',
  uConexaoODBC in 'infrastructure\uConexaoODBC.pas',
  uContaDAO in 'dao\uContaDAO.pas',
  uConta in 'model\uConta.pas',
  uController.Contas in 'controller\uController.Contas.pas',
  uBrowserHelper in 'infrastructure\uBrowserHelper.pas';

begin
  Writeln('Servidor rodando com Swagger em http://localhost:9000//swagger/doc/html');
  // Writeln('API_BASE_URL = http://localhost:9000/v1');
  TTesteConexaoSQLServer.ValidarConexaoSQLServer;
  Writeln('API rodar Controle Financeiro utilizando Horse, WinForm e Angular');
  THorse.Use(Jhonson());
  THorse.Use(HorseSwagger);
  // Abre o navegador na documentação Swagger
  TBrowserHelper.OpenURL('http://localhost:9000/swagger/doc/html');
  THorse.Listen(9000);
end.
