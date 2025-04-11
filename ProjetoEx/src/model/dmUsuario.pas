unit dmUsuario;

interface

uses
  System.SysUtils,
  System.Classes,
  RESTRequest4D,
  FireDAC.Comp.Client,
  System.JSON,
  usuarioClass,
  common.consts;

type
  Tdm = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
    procedure login(email, senha: string);
    procedure cadastrarUsuario(primeiroNome, ultimoNome,email,senha:string);
    function ValidarSessao: Boolean;
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl' %}

{$R *.dfm}

procedure Tdm.cadastrarUsuario(primeiroNome, ultimoNome, email, senha: string);
var
  resp: IResponse;
  jsonRequest, jsonResponse: TJSONObject;
  jsonValue: TJSONValue;
begin
  jsonRequest := TJSONObject.Create;

  try
    try
      jsonRequest.AddPair('first_name', primeiroNome);
      jsonRequest.AddPair('last_name', ultimoNome);
      jsonRequest.AddPair('email', LowerCase(Trim(email)));
      jsonRequest.AddPair('password', senha);

      resp := TRequest.New
        .BaseURL(baseURL)
        .Resource('/usuarios/register')
        .AddBody(jsonRequest.ToString)
        .Accept('application/json')
        .Post;

      if resp.StatusCode = 200 then
      begin
        jsonResponse := TJSONObject.ParseJSONValue(resp.Content) as TJSONObject;
        try
          if Assigned(jsonResponse) then
          begin
            if jsonResponse.TryGetValue('first_name', TJSONValue(jsonValue)) then
              TSession.name := jsonValue.Value;

            if jsonResponse.TryGetValue('last_name', TJSONValue(jsonValue)) then
              TSession.lastName := jsonValue.Value;

            if jsonResponse.TryGetValue('email', TJSONValue(jsonValue)) then
              TSession.email := jsonValue.Value;
          end;
        finally
          jsonResponse.Free;
        end;
      end
      else
        raise Exception.Create('Erro no cadastro do usuário: ' + resp.Content);

    except
      on E: Exception do
        raise Exception.Create('Erro de comunicação: ' + E.Message);
    end;
  finally
    jsonRequest.Free;
  end;
end;


procedure Tdm.Login(email, senha: string);
var
  resp: IResponse;
  jsonRequest, jsonResponse: TJSONObject;
begin
  jsonRequest := TJSONObject.Create;
  try
     jsonRequest.AddPair('email', LowerCase(Trim(email)));
    jsonRequest.AddPair('password', senha);

    try
      resp := TRequest.New
              .BaseURL(baseURL + '/usuarios/login')
              .AddBody(jsonRequest.ToString)
              .Accept('application/json')
              .Post;

      if resp.StatusCode = 200 then
      begin
        jsonResponse := TJSONObject.ParseJSONValue(resp.Content) as TJSONObject;
        try
          if Assigned(jsonResponse) then
          begin
            TSession.id := jsonResponse.GetValue<integer>('id', 0);
            TSession.EMAIL := jsonResponse.GetValue<string>('email', '');
            TSession.requires2FA := jsonResponse.GetValue<boolean>('requires_2fa', false);
          end;
        finally
          jsonResponse.Free;
        end;
      end
      else
        raise Exception.Create('Erro no login: ' + resp.Content);
    except
      on E: Exception do
        raise Exception.Create('Erro de comunicação: ' + E.Message);
    end;
  finally
    jsonRequest.Free;
  end;
end;

function Tdm.ValidarSessao: Boolean;
var
  resp: IResponse;
  jsonRequest, jsonResponse: TJSONObject;
begin
  Result := False;

  if TSession.id <= 0 then
    Exit;

  jsonRequest := TJSONObject.Create;
  try
    jsonRequest.AddPair('user_id', TJSONNumber.Create(TSession.id));

    try
      resp := TRequest.New
        .BaseURL(baseURL + '/usuarios/validar-sessao')
        .AddBody(jsonRequest.ToString)
        .Accept('application/json')
        .Post;

      if resp.StatusCode = 200 then
      begin
        jsonResponse := TJSONObject.ParseJSONValue(resp.Content) as TJSONObject;
        try
          Result := jsonResponse.GetValue<Boolean>('sessao_valida', False);
        finally
          jsonResponse.Free;
        end;
      end;
    except
      on E: Exception do
        Result := False;
    end;
  finally
    jsonRequest.Free;
  end;
end;

end.

