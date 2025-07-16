unit uContaDAO;

interface

uses
  System.SysUtils,
  System.Classes,
  Data.Win.ADODB,
  System.JSON,
  uConexaoODBC,
  Variants;

type
  TContaDAO = class
  public
    class function GetAll: TJSONArray;
    class function GetById(AId: Integer): TJSONObject;
    class function Insert(AJson: TJSONObject): Boolean;
    class function Update(AId: Integer; AJson: TJSONObject): Boolean;
    class function Delete(AId: Integer): Boolean;
  end;

implementation

uses
  System.DateUtils;

{ TContaDAO }

class function TContaDAO.GetAll: TJSONArray;
var
  Conexao: TConexaoODBC;
  Qry: TADOQuery;
  JsonArray: TJSONArray;
  Obj: TJSONObject;
begin
  JsonArray := TJSONArray.Create;
  Conexao := TConexaoODBC.Create;
  Qry := TADOQuery.Create(nil);
  try
    Qry.Connection := Conexao.GetConnection;
    Qry.SQL.Text := 'SELECT * FROM "Contas" ORDER BY "Id" DESC';
    Qry.Open;

    while not Qry.Eof do
    begin
      Obj := TJSONObject.Create;
      Obj.AddPair('id', TJSONNumber.Create(Qry.FieldByName('Id').AsInteger));
      Obj.AddPair('nome', Qry.FieldByName('Nome').AsString);
      Obj.AddPair('valor', TJSONNumber.Create(Qry.FieldByName('Valor').AsFloat));
      Obj.AddPair('dataVencimento', Qry.FieldByName('DataVencimento').AsString);

      if not Qry.FieldByName('DataPagamento').IsNull then
        Obj.AddPair('dataPagamento', Qry.FieldByName('DataPagamento').AsString)
      else
        Obj.AddPair('dataPagamento', TJSONNull.Create);

      Obj.AddPair('pago', TJSONBool.Create(Qry.FieldByName('Pago').AsBoolean));
      JsonArray.AddElement(Obj);

      Qry.Next;
    end;

    Result := JsonArray;
  finally
    Qry.Free;
    Conexao.Free;
  end;
end;

class function TContaDAO.GetById(AId: Integer): TJSONObject;
var
  Conexao: TConexaoODBC;
  Qry: TADOQuery;
  Obj: TJSONObject;
begin
  Result := nil;
  Conexao := TConexaoODBC.Create;
  Qry := TADOQuery.Create(nil);
  try
    Qry.Connection := Conexao.GetConnection;
    Qry.SQL.Text := 'SELECT * FROM "Contas" WHERE "Id" = :Id';
    Qry.Parameters.ParamByName('Id').Value := AId;
    Qry.Open;

    if not Qry.Eof then
    begin
      Obj := TJSONObject.Create;
      Obj.AddPair('id', TJSONNumber.Create(Qry.FieldByName('Id').AsInteger));
      Obj.AddPair('nome', Qry.FieldByName('Nome').AsString);
      Obj.AddPair('valor', TJSONNumber.Create(Qry.FieldByName('Valor').AsFloat));
      Obj.AddPair('dataVencimento', Qry.FieldByName('DataVencimento').AsString);

      if not Qry.FieldByName('DataPagamento').IsNull then
        Obj.AddPair('dataPagamento', Qry.FieldByName('DataPagamento').AsString)
      else
        Obj.AddPair('dataPagamento', TJSONNull.Create);

      Obj.AddPair('pago', TJSONBool.Create(Qry.FieldByName('Pago').AsBoolean));

      Result := Obj;
    end;
  finally
    Qry.Free;
    Conexao.Free;
  end;
end;

class function TContaDAO.Insert(AJson: TJSONObject): Boolean;
var
  Conexao: TConexaoODBC;
  Qry: TADOQuery;
  JsonValue: TJSONValue;
  NomeStr: string;
  ValorFloat: Double;
  DataVencimentoDT: TDateTime;
begin
  Result := False;
  Conexao := TConexaoODBC.Create;
  Qry := TADOQuery.Create(nil);
  try
    Qry.Connection := Conexao.GetConnection;

    Qry.SQL.Text :=
      'INSERT INTO "Contas" ("Nome", "Valor", "DataVencimento", "DataPagamento", "Pago") ' +
      'VALUES (:Nome, :Valor, :DataVencimento, :DataPagamento, :Pago)';

    // Nome (string)
    JsonValue := AJson.GetValue('nome');
    if Assigned(JsonValue) and (JsonValue is TJSONString) then
      NomeStr := TJSONString(JsonValue).Value
    else
      raise Exception.Create('Campo "nome" obrigatório e deve ser string');

    // Valor (float)
    JsonValue := AJson.GetValue('valor');
    if Assigned(JsonValue) then
    begin
      if JsonValue is TJSONNumber then
        ValorFloat := TJSONNumber(JsonValue).AsDouble
      else if JsonValue is TJSONString then
        ValorFloat := StrToFloatDef(TJSONString(JsonValue).Value, 0)
      else
        ValorFloat := 0;
    end
    else
      ValorFloat := 0;

    // DataVencimento (datetime obrigatório)
    JsonValue := AJson.GetValue('dataVencimento');
    if Assigned(JsonValue) and (JsonValue is TJSONString) and (Trim(TJSONString(JsonValue).Value) <> '') then
      DataVencimentoDT := ISO8601ToDate(TJSONString(JsonValue).Value)
    else
      raise Exception.Create('Campo "dataVencimento" obrigatório e deve ser string no formato ISO8601');

    // Assign parameters
    Qry.Parameters.ParamByName('Nome').Value := NomeStr;
    Qry.Parameters.ParamByName('Valor').Value := ValorFloat;
    Qry.Parameters.ParamByName('DataVencimento').Value := DataVencimentoDT;
    Qry.Parameters.ParamByName('Pago').Value := False;

    Qry.ExecSQL;
    Result := True;
  finally
    Qry.Free;
    Conexao.Free;
  end;
end;

class function TContaDAO.Update(AId: Integer; AJson: TJSONObject): Boolean;
var
  Conexao: TConexaoODBC;
  Qry: TADOQuery;
  S: string;
begin
  Result := False;
  Conexao := TConexaoODBC.Create;
  Qry := TADOQuery.Create(nil);
  try
    Qry.Connection := Conexao.GetConnection;

    Qry.SQL.Text :=
      'UPDATE "Contas" SET "Nome" = :Nome, "Valor" = :Valor, "DataVencimento" = :DataVencimento, ' +
      '"DataPagamento" = :DataPagamento, "Pago" = :Pago WHERE "Id" = :Id';

    Qry.Parameters.ParamByName('Nome').Value := AJson.GetValue<string>('nome');
    Qry.Parameters.ParamByName('Valor').Value := AJson.GetValue<Double>('valor');
    Qry.Parameters.ParamByName('DataVencimento').Value := AJson.GetValue<string>('dataVencimento');

    if AJson.TryGetValue<string>('dataPagamento', S) then
      Qry.Parameters.ParamByName('DataPagamento').Value := S
    else
      Qry.Parameters.ParamByName('DataPagamento').Value := Null;

    Qry.Parameters.ParamByName('Pago').Value := AJson.GetValue<Boolean>('pago');
    Qry.Parameters.ParamByName('Id').Value := AId;

    Qry.ExecSQL;
    Result := True;
  finally
    Qry.Free;
    Conexao.Free;
  end;
end;

class function TContaDAO.Delete(AId: Integer): Boolean;
var
  Conexao: TConexaoODBC;
  Qry: TADOQuery;
begin
  Result := False;
  Conexao := TConexaoODBC.Create;
  Qry := TADOQuery.Create(nil);
  try
    Qry.Connection := Conexao.GetConnection;
    Qry.SQL.Text := 'DELETE FROM "Contas" WHERE "Id" = :Id';
    Qry.Parameters.ParamByName('Id').Value := AId;
    Qry.ExecSQL;
    Result := True;
  finally
    Qry.Free;
    Conexao.Free;
  end;
end;

end.

