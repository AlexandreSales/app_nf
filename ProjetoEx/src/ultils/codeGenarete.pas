unit codeGenarete;

interface

uses
   System.SysUtils, System.Classes, RESTRequest4D, System.JSON, System.Net.URLClient, System.Net.HttpClient,FMX.Dialogs,System.NetEncoding;

   type
  TCodeGenerator = class
  public
    class function GerarCodigo: string;
    class procedure EnviarCodigoSMS(const Destinatario, Codigo: string);
  end;

implementation


{ TCodeGenerator }


class procedure TCodeGenerator.EnviarCodigoSMS(const Destinatario, Codigo: string);
var
  Request: IRequest;
  Resp: IResponse;
  JsonRequest: TJSONObject;
  AuthHeader: string;
  Username, Password: string;
  URL: string;
begin
  // Credenciais da API ClickSend
  Username := 'wellingtoncarvalho908@gmail.com';  // Seu e-mail
  Password := '9F73ABD1-89B9-5809-1943-8F664EFD2FFC'; // Sua API Key

  // URL da API ClickSend
  URL := 'https://rest.clicksend.com/v3/sms/send';

  // Criando Basic Auth (username:password em Base64)
  AuthHeader := 'Basic ' + TNetEncoding.Base64.Encode(Username + ':' + Password);

  // Criando JSON do corpo da requisição
  JsonRequest := TJSONObject.Create;
  try
    JsonRequest.AddPair('messages', TJSONArray.Create(
      TJSONObject.Create
        .AddPair('source', 'DelphiApp')
        .AddPair('to', Destinatario)
        .AddPair('body', 'Seu código de autenticação é: ' + Codigo)
        .AddPair('from', '583839')
    ));

    // Criando e enviando a requisição
    Request := TRequest.New
      .BaseURL(URL)
      .AddHeader('Authorization', AuthHeader)  // Apenas Basic Auth
      .AddBody(JsonRequest.ToString);

    // Enviando POST
    Resp := Request.Post;

    // Verificando resposta
    if Resp.StatusCode = 200 then
      ShowMessage('Código enviado com sucesso!')
    else
      ShowMessage('Erro ao enviar código: ' + Resp.StatusText + ' (' + Resp.Content + ')');
  finally
    JsonRequest.Free;
  end;
end;


class function TCodeGenerator.gerarCodigo: string;
var
  i : integer;
  codigo: string;
begin
  codigo:= '';

  Randomize;

  for I := 1 to 6 do
    codigo := codigo + IntToStr(Random(10));

  result := Codigo;
end;

end.
