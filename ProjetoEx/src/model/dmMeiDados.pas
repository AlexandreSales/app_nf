unit dmMeiDados;

interface

uses
  System.SysUtils, System.Classes, RESTRequest4D, System.JSON,common.consts;

type
  TDataModuleMei = class(TDataModule)
  private
    { Private declarations }
  public
    function BuscarDadosCNPJ(const ACNPJ: string): TJSONObject;
    function BuscarDadosCEP(const ACEP: string): TJSONObject;
    function SalvarDadosNoBanco(Dados: TJSONObject): Boolean;
  end;

var
  DataModuleMei: TDataModuleMei;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TDataModuleMei }

function TDataModuleMei.BuscarDadosCNPJ(const ACNPJ: string): TJSONObject;
var
  Response: IResponse;
begin
  Result := nil;
  try
    Response := TRequest.New.BaseURL(baseURL + '/mei/cnpj/' + ACNPJ)
      .Accept('application/json')
      .Get;

    if Response.StatusCode = 200 then
      Result := TJSONObject.ParseJSONValue(Response.Content) as TJSONObject;
  except
    on E: Exception do
      Result := nil;
  end;
end;

function TDataModuleMei.BuscarDadosCEP(const ACEP: string): TJSONObject;
var
  Response: IResponse;
begin
  Result := nil;
  try
    Response := TRequest.New.BaseURL(baseURL + '/mei/cep/' + ACEP)
      .Accept('application/json')
      .Get;

    if Response.StatusCode = 200 then
      Result := TJSONObject.ParseJSONValue(Response.Content) as TJSONObject;
  except
    on E: Exception do
      Result := nil;
  end;
end;

function TDataModuleMei.SalvarDadosNoBanco(Dados: TJSONObject): Boolean;
var
  Response: IResponse;
begin
  Result := False;
  try
    Response := TRequest.New.BaseURL(baseURL + '/mei/cadastrar')
      .Accept('application/json')
      .ContentType('application/json')
      .AddBody(Dados.ToString)
      .Post;

    Result := Response.StatusCode = 201;
  except
    on E: Exception do
      Result := False;
  end;
end;

end.

