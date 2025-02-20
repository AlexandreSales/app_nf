unit codeGenarete;

interface

uses
   System.SysUtils,System.IOUtils, System.Classes, RESTRequest4D, System.JSON, System.Net.URLClient, System.Net.HttpClient,FMX.Dialogs,System.NetEncoding;

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
  JsonString: string;
  FilePath, DirectoryPath: string;
begin
  Username := 'wellingtoncarvalho908@gmail.com';
  Password := '9F73ABD1-89B9-5809-1943-8F664EFD2FFC';

  URL := 'https://rest.clicksend.com/v3/sms/send';

  // Criando Basic Auth (username:password em Base64)
  //AuthHeader := 'Basic ' + TNetEncoding.Base64.Encode(Username + ':' + Password);

  // Criando JSON do corpo da requisição
  JsonRequest := TJSONObject.Create;
  try
    // Montando o JSON com a estrutura correta
    JsonRequest.AddPair('messages', TJSONArray.Create(
      TJSONObject.Create
        .AddPair('to', Destinatario)
        .AddPair('body', 'Seu código de autenticação é: ' + Codigo)
        .AddPair('from', '583839')
    ));

    // Convertendo JSON para string
    JsonString := JsonRequest.ToString;

    // Definindo caminho da pasta e do arquivo
    DirectoryPath := 'C:\Documentos\jsondoc';
    FilePath := DirectoryPath + '\json_log.txt';

    // Criando a pasta caso não exista
    if not DirectoryExists(DirectoryPath) then
      ForceDirectories(DirectoryPath);

    // Salvando o JSON no arquivo
    TFile.WriteAllText(FilePath, JsonString, TEncoding.UTF8);

    // Criando e enviando a requisição
    resp := TRequest.New
      .BaseURL(URL)
      .BasicAuthentication(Username, Password)
      .AddBody(JsonString)
      .ContentType('application/json')
      .Accept('application/json')
      .Post;

    if Resp.StatusCode = 200 then
      ShowMessage('Código enviado com sucesso! JSON salvo em: ' + FilePath)
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
