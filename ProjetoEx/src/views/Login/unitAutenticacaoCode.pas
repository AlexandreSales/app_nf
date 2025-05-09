unit unitAutenticacaoCode;

interface

uses
  System.SysUtils,
  System.Classes,
  System.UITypes,
  System.JSON,

  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.Edit,
  FMX.StdCtrls,
  FMX.Controls.Presentation,
  FMX.Objects,
  FMX.Layouts,
  FMX.DialogService.Async,

  {$if not defined(mswindows)}
    FMX.BiometricAuth,
  {$endif}

  RESTRequest4D,
  dmUsuario,
  usuarioClass,
  common.consts;

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
    procedure FormCreate(Sender: TObject);
    procedure BiometricAuthSuccess(Sender: TObject);

    {$if not defined(mswindows)}
      procedure BiometricAuthFail(Sender: TObject; const FailReason: TBiometricFailReason; const ResultMessage: string);
    {$endif}
  private
    {$if not defined(mswindows)}
      BiometricAuth: TBiometricAuth;
    {$endif}

    procedure ValidateCode;
    procedure EnviarCodigoAutenticacao;
    procedure PerguntarBiometria;
    procedure AtivarBiometria;
  public
  end;

var
  AutenticacaoCode: TAutenticacaoCode;

implementation

{$R *.fmx}

uses mainClientes;

procedure TAutenticacaoCode.FormCreate(Sender: TObject);
begin
  {$if not defined(mswindows)}
    if BiometricAuth = nil then
      BiometricAuth := tbiometricAuth.create(self);

    BiometricAuth.BiometricStrengths := [TBiometricStrength.DeviceCredential];
    BiometricAuth.PromptCancelButtonText := 'Cancelar';
    BiometricAuth.PromptConfirmationRequired := false;
    BiometricAuth.PromptDescription := 'Voc� precisa de autentica��o';
    BiometricAuth.PromptSubtitle := 'Para acessar, voc� precisa se autenticar';
    BiometricAuth.PromptTitle := 'Autentica��o';

    BiometricAuth.OnAuthenticateSuccess := BiometricAuthSuccess;
    BiometricAuth.OnAuthenticateFail := BiometricAuthFail;
  {$endif}
end;

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
              .BaseURL(baseURL + '/usuarios/verificar-codigo-existente')
              .AddBody(jsonRequest.ToString)
              .Accept('application/json')
              .Post;

      jsonResponse := TJSONObject.ParseJSONValue(resp.Content) as TJSONObject;

      if jsonResponse.GetValue<string>('status') = 'success' then
      begin
        ShowMessage(jsonResponse.GetValue<string>('mensagem'));
        PerguntarBiometria;
      end
      else
        ShowMessage(jsonResponse.GetValue<string>('mensagem'));
    except
      on E: Exception do
        ShowMessage('Erro de comunica��o: ' + E.Message);
    end;
  finally
    jsonRequest.Free;
    if Assigned(jsonResponse) then
      jsonResponse.Free;
  end;
end;

procedure TAutenticacaoCode.PerguntarBiometria;
begin
  {$if not defined(mswindows)}
    if BiometricAuth.IsSupported and BiometricAuth.CanAuthenticate then
    begin
      TDialogServiceAsync.MessageDialog(
        'Deseja ativar o login por digital?',
        TMsgDlgType.mtConfirmation,
        [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
        TMsgDlgBtn.mbNo,
        0,
        procedure(const AResult: TModalResult)
        begin
          if AResult = mrYes then
          begin
             BiometricAuth.Authenticate;
            AtivarBiometria;
          end
          else
          begin
            // Fecha esta tela e volta para o login
            Self.Close;
            if Assigned(Self.Owner) then
              TForm(Self.Owner).Show
            else if Assigned(Application.MainForm) then
              Application.MainForm.Show;
          end;
        end
      );
    end
    else
    begin
      ShowMessage('Seu dispositivo n�o suporta biometria.');
      Self.Close;
      if Assigned(Self.Owner) then
        TForm(Self.Owner).Show
      else if Assigned(Application.MainForm) then
        Application.MainForm.Show;
    end;
  {$endif}
end;

procedure TAutenticacaoCode.BiometricAuthSuccess(Sender: TObject);
begin
  AtivarBiometria;
end;

{$if not defined(mswindows)}
  procedure TAutenticacaoCode.BiometricAuthFail(Sender: TObject; const FailReason: TBiometricFailReason; const ResultMessage: string);
  begin
    ShowMessage('Autentica��o falhou: ' + ResultMessage);
  end;
{$endif}

procedure TAutenticacaoCode.AtivarBiometria;
var
  resp: IResponse;
begin
  try
    resp := TRequest.New
      .BaseURL(baseURL + '/usuarios/ativar-biometria')
      .AddBody(TJSONObject.Create
        .AddPair('user_id', TJSONNumber.Create(TSession.id)).ToString)
      .Accept('application/json')
      .Post;

    if resp.StatusCode = 200 then
      ShowMessage('Biometria ativada com sucesso!')
    else
      ShowMessage('Erro ao ativar biometria: ' + resp.Content);
  except
    on E: Exception do
      ShowMessage('Erro ao comunicar com o servidor: ' + E.Message);
  end;

  // Fecha a tela e vai para tela principal
  Close;
  if not Assigned(frmClientes) then
    Application.CreateForm(TfrmClientes, frmClientes);
  frmClientes.Show;
end;


procedure TAutenticacaoCode.EnviarCodigoAutenticacao;
var
  resp: IResponse;
  jsonRequest: TJSONObject;
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
        ShowMessage('C�digo enviado com sucesso.')
      else
        ShowMessage('Erro ao enviar c�digo: ' + resp.Content);
    except
      on E: Exception do
        ShowMessage('Erro de comunica��o: ' + E.Message);
    end;
  finally
    jsonRequest.Free;
  end;
end;

end.

