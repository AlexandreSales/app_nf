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
  passwordValue: TJSONValue;
begin
    jsonRequest := TJSONObject.Create;

    try
      try
        jsonRequest.AddPair('first_name', primeiroNome);
        jsonRequest.AddPair('last_name', ultimoNome);
        jsonRequest.AddPair('email', email);
        jsonRequest.AddPair('password', senha);

         resp := TRequest.New
                      .BaseURL('http://localhost:3000')
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

                TSession.name := passwordValue.Value;

                TSession.lastName := passwordValue.Value;

              if jsonResponse.TryGetValue('email', TJSONValue(passwordValue)) then
                TSession.EMAIL := passwordValue.Value;

              if jsonResponse.TryGetValue('password', TJSONValue(passwordValue)) then
                TSession.password := passwordValue.Value;
            end;
          finally
          jsonResponse.Free;
          end;
        end
      else
        raise Exception.Create('Erro no cadastro do usuáro : ' + resp.Content);

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
    jsonRequest.AddPair('email', email);
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

end.

