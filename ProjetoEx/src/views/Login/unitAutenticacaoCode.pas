unit unitAutenticacaoCode;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, FMX.Forms,
  FMX.Dialogs, FMX.Edit, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Objects,
  FMX.Layouts, RESTRequest4D, System.JSON, dmUsuario, usuarioClass, common.consts;

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
    procedure lblNewContaClick(Sender: TObject);
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

procedure TAutenticacaoCode.lblNewContaClick(Sender: TObject);
begin
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
        Close;

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
  resp: IResponse;
  jsonRequest, jsonResponse: TJSONObject;
begin
  jsonRequest := TJSONObject.Create;
  try
    jsonRequest.AddPair('user_id', TJSONNumber.Create(TSession.id));
    jsonRequest.AddPair('phone', '5561992045816');

    try
      resp := TRequest.New
                      .BaseURL(baseURL)
                      .Resource('/usuarios/enviarCodigo')
                      .AddBody(jsonRequest.ToString)
                      .Accept('application/json')
                      .Post;

      if resp.StatusCode = 200 then
        ShowMessage('Foi enviado com sucesso')
      else
        ShowMessage('O codigo nao foi enviado, verifique o backend ' + resp.Content);
    except
      on E: Exception do
        ShowMessage('Erro de comunicação: ' + E.Message);
    end;
  finally
    if jsonRequest <> nil then
      freeandnil(jsonRequest);

  end;
end;

end.

