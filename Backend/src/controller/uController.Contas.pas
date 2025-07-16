unit uController.Contas;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  Horse,
  Horse.Jhonson,
  Horse.GBSwagger.Register,
  Horse.GBSwagger.Controller,
  GBSwagger.Path.Attributes,
  GBSwagger.Model.Types,
  uConta,
  uContaDAO,
  Rest.Json;

type
  THTTPStatus = record
  const
    OK = 200;
    HTTP_CREATED = 201;
    HTTP_NO_CONTENT = 204;
    BAD_REQUEST = 400;
    HTTP_UNAUTHORIZED = 401;
    NOT_FOUND = 404;
    INTERNAL_SERVER_ERROR = 500;
  end;

  [SwagPath('v1', 'contas')]
  TControllerConta = class(THorseGBSwagger)
  public
    [SwagGET('contas', 'Listar todas as contas')]
    [SwagResponse(THTTPStatus.OK, TConta, 'Retorno com sucesso')]
    procedure DoList;

    [SwagGET('contas/{id}', 'Obter conta por ID')]
    [SwagParamPath('id', 'ID da conta')]
    [SwagResponse(THTTPStatus.OK, TConta, 'Retorno com sucesso')]
    [SwagResponse(THTTPStatus.NOT_FOUND, nil, 'Conta não encontrada')]
    procedure DoGetById;

    [SwagPOST('contas', 'Criar nova conta')]
    [SwagParamBody('body', TConta, true, 'Nova conta')]
    [SwagResponse(THTTPStatus.HTTP_CREATED, nil, 'Criado com sucesso')]
    procedure DoPost;

    [SwagPOST('contas/{id}/editar', 'Editar conta')]
    [SwagParamPath('id', 'ID da conta')]
    [SwagParamBody('body', TConta, true, 'Conta editada')]
    [SwagResponse(THTTPStatus.OK, nil, 'Atualizado com sucesso')]
    procedure DoEdit;

    [SwagDELETE('contas/{id}', 'Excluir conta')]
    [SwagParamPath('id', 'ID da conta')]
    [SwagResponse(THTTPStatus.HTTP_NO_CONTENT, nil, 'Removido com sucesso')]
    procedure DoDelete;

    [SwagPOST('contas/{id}/pagar', 'Pagar uma conta')]
    [SwagParamPath('id', 'ID da conta')]
    [SwagParamBody('body', TJSONObject, true, 'Data de pagamento')]
    [SwagResponse(THTTPStatus.OK, nil, 'Conta paga com sucesso')]
    procedure DoPagar;

    [SwagPOST('contas/{id}/reabrir', 'Reabrir conta')]
    [SwagParamPath('id', 'ID da conta')]
    [SwagResponse(THTTPStatus.OK, nil, 'Conta reaberta')]
    procedure DoReabrir;
  end;

implementation

uses
  Horse.Request,
  Horse.Response,
  GBSwagger.Resources,
  System.Generics.Collections;

{ TControllerConta }

procedure TControllerConta.DoList;
var
  Lista: TJSONArray;
begin
  Lista := TContaDAO.GetAll;
  try
    try
      FResponse
        .ContentType('application/json')
        .Send(Lista.ToJSON);
    except
      on E: Exception do
        FResponse
          .Status(THTTPStatus.INTERNAL_SERVER_ERROR)
          .ContentType('application/json')
          .Send(Format('{"erro":"%s"}', [E.Message]));
    end;
  finally
    Lista.Free;
  end;
end;

procedure TControllerConta.DoGetById;
var
  ID: Integer;
  Conta: TJSONObject;
begin
  ID := FRequest.Params['id'].ToInteger;
  Conta := TContaDAO.GetById(ID);
  if Assigned(Conta) then
    FResponse.Status(THTTPStatus.OK).Send(Conta)
  else
    FResponse.Status(THTTPStatus.NOT_FOUND)
      .Send('{"erro":"Conta não encontrada"}');
end;

procedure TControllerConta.DoPost;
var
  Body: TJSONObject;
begin
  try
    Body := FRequest.Body<TJSONObject>;
    if Body = nil then
      raise Exception.Create('JSON inválido ou malformado.');

    TContaDAO.Insert(Body);

    FResponse.Status(THTTPStatus.HTTP_CREATED)
      .ContentType('application/json')
      .Send('{"mensagem":"Conta criada com sucesso"}');
  except
    on E: Exception do
      FResponse.Status(THTTPStatus.INTERNAL_SERVER_ERROR)
        .ContentType('application/json')
        .Send(Format('{"erro":"%s"}', [E.Message]));
  end;
end;

procedure TControllerConta.DoEdit;
var
  ID: Integer;
  Body: TJSONObject;
begin
  try
    ID := FRequest.Params['id'].ToInteger;
    Body := FRequest.Body<TJSONObject>;
    if Body = nil then
      raise Exception.Create('JSON inválido');

    if not TContaDAO.Update(ID, Body) then
      FResponse.Status(THTTPStatus.NOT_FOUND)
        .Send('{"erro":"Conta não encontrada"}')
    else
      FResponse.Status(THTTPStatus.OK)
        .Send('{"mensagem":"Conta atualizada"}');
  except
    on E: Exception do
      FResponse.Status(THTTPStatus.BAD_REQUEST)
        .Send(Format('{"erro":"%s"}', [E.Message]));
  end;
end;

procedure TControllerConta.DoDelete;
var
  ID: Integer;
begin
  try
    ID := FRequest.Params['id'].ToInteger;
    if TContaDAO.Delete(ID) then
      FResponse.Status(THTTPStatus.HTTP_NO_CONTENT)
    else
      FResponse.Status(THTTPStatus.NOT_FOUND)
        .Send('{"erro":"Conta não encontrada"}');
  except
    on E: Exception do
      FResponse.Status(THTTPStatus.INTERNAL_SERVER_ERROR)
        .Send(Format('{"erro":"%s"}', [E.Message]));
  end;
end;

procedure TControllerConta.DoPagar;
begin

end;

procedure TControllerConta.DoReabrir;
begin

end;

initialization
  THorse.Use(Jhonson());
  THorseGBSwaggerRegister.RegisterPath(TControllerConta);
end.

