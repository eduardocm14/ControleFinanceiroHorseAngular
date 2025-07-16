unit uConta;

interface

uses
  System.SysUtils, System.Classes;

type
  TConta = class
  public
    Id: Integer;
    Nome: string;
    Valor: Double;
    DataVencimento: TDateTime;
    DataPagamento: TDateTime;
    Pago: Boolean;
  end;

implementation

end.

