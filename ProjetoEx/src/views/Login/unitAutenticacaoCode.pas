unit unitAutenticacaoCode;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, FMX.Forms,
  FMX.Dialogs, FMX.Edit, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Objects,
  FMX.Layouts, RESTRequest4D, System.JSON, dmUsuario, usuarioClass, common.consts,
  codeGenarete;  // Importa a unidade de geração e envio do código

type
  TAutenticacaoCode = class(TForm)
    Layout6: TLayout;
    rectEntrar: TRectangle;
    btnValidar: TSpeedButton;
    Label15: TLabel;
    edtcode: TEdit;
    lblNewConta: TLabel;
    Label2: TLabel;
    procedure btnValidarClick(Sender: TObject);
    procedure FormShow(Sender: TObject); // Evento de mostrar o formulário
  private
    procedure ValidateCode;
    procedure EnviarCodigoAutenticacao;
  public
  end;

var
  AutenticacaoCode: TAutenticacaoCode;

implementation

{$R *.fmx}

uses mainClientes;

procedure TAutenticacaoCode.btnValidarClick(Sender: TObject);
begin
  ValidateCode;
end;

procedure TAutenticacaoCode.FormShow(Sender: TObject);
begin
  // Chama a função para gerar e enviar o código assim que o formulário for exibido
  EnviarCodigoAutenticacao;
end;

procedure TAutenticacaoCode.ValidateCode;
var
  resp: IResponse;
  jsonRequest, jsonResponse: TJSONObject;
begin
  jsonRequest := TJSONObject.Create;
  try
    jsonRequest.AddPair('user_id', TJSONNumber.Create(TSession.id));
    jsonRequest.AddPair('code', edtcode.Text);

    try
      resp := TRequest.New
              .BaseURL(baseURL + '/usuarios/verificar-codigo')
              .AddBody(jsonRequest.ToString)
              .Accept('application/json')
              .Post;

      if resp.StatusCode = 200 then
      begin
        ShowMessage('Código validado! Acesso liberado.');
        Close;  // Fecha a tela de autenticação

        // Abre o sistema principal
        if not Assigned(frmClientes) then
          Application.CreateForm(TfrmClientes, frmClientes);
        frmClientes.Show;
      end
      else
        ShowMessage('Código inválido. Tente novamente.');
    except
      on E: Exception do
        ShowMessage('Erro de comunicação: ' + E.Message);
    end;
  finally
    jsonRequest.Free;
  end;
end;

procedure TAutenticacaoCode.EnviarCodigoAutenticacao;
var
  Codigo: string;
  Destinatario: string;
begin
  Codigo := TCodeGenerator.GerarCodigo;

  Destinatario := '5561992045816';

  TCodeGenerator.EnviarCodigoSMS(Destinatario, Codigo);

  ShowMessage('Código enviado para o número ' + Destinatario);
end;

end.

