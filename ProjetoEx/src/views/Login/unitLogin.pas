unit unitLogin;

interface

uses
  System.SysUtils,
  System.Classes,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.Edit,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.Layouts,
  FMX.TabControl,
  usuarioClass,
  utilsLoadig,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.StorageBin,
  Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FMX.Controls.Presentation,
  REST.Authenticator.OAuth.WebForm.FMX,
  REST.Types, REST.Client,
  Data.Bind.Components,
  Data.Bind.ObjectScope,
  REST.Authenticator.OAuth,
  REST.Utils,
  loginFacebook,
  System.UITypes,
  System.JSON,
  Web.HTTPApp,
  RESTRequest4D,
  REST.Response.Adapter,
  common.consts,
 // FMX.BiometricAuth,
  System.IOUtils,
  System.IniFiles, FMX.BiometricAuth;

type
  TfrmLogin = class(TForm)
    TabControl: TTabControl;
    tabLogin: TTabItem;
    Layout2: TLayout;
    lblCriarConta: TLabel;
    tabNovaConta: TTabItem;
    Layout4: TLayout;
    Label8: TLabel;
    Label9: TLabel;
    edtNome: TEdit;
    Label10: TLabel;
    edtSenhaCad: TEdit;
    rectCriarConta: TRectangle;
    btnCriarConta: TSpeedButton;
    Label11: TLabel;
    edtUltimoNome: TEdit;
    tabEntrarComEmail: TTabItem;
    layMainLogin: TLayout;
    Label14: TLabel;
    edtSenha: TEdit;
    rectEntrar: TRectangle;
    btnEntrar: TSpeedButton;
    Label15: TLabel;
    edtEmail: TEdit;
    rectEmail: TRectangle;
    btnAcessarEmail: TSpeedButton;
    lblNovaConta: TLabel;
    lbTextUser: TLabel;
    edtEmailCadastro: TEdit;
    Rectangle1: TRectangle;
    SpeedButton1: TSpeedButton;
    Layout1: TLayout;
    Image1: TImage;
    Label1: TLabel;
    Label5: TLabel;
    lblTextUserCadastro: TLabel;
   BiometricAuth: TBiometricAuth;

    procedure btnEntrarClick(Sender: TObject);
    procedure lblNovaContaClick(Sender: TObject);
    procedure lbTextUserClick(Sender: TObject);
    procedure btnCriarContaClick(Sender: TObject);
    procedure btnAcessarEmailClick(Sender: TObject);
    procedure lblExitClick(Sender: TObject);
    procedure lblExit1Click(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure TerminateLoading(sender: TObject);
    procedure TerminateCadastro(sender: TObject);
    procedure MostrarMensagemUsuario(const Msg: string);
    procedure MostrarMensagemUsuarioCadastro(const Msg: string);
   procedure BiometricAuthAuthenticateFail(Sender: TObject;
     const FailReason: TBiometricFailReason; const ResultMessage: string);
    procedure BiometricAuthAuthenticateSuccess(Sender: TObject);
    procedure CarregarLoginSalvo;
    procedure SalvarLoginLocal(UserID: Integer);
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.fmx}

uses dmUsuario, mainClientes, unitAutenticacaoCode;

procedure TfrmLogin.btnEntrarClick(Sender: TObject);
begin
  TLoading.ExecuteThread(
    procedure
    begin
      if Trim(edtEmail.Text) = '' then
      begin
        TThread.Synchronize(nil, procedure begin
          MostrarMensagemUsuario('Preencha o campo E-mail.');
        end);
        Exit;
      end;

      if Trim(edtSenha.Text) = '' then
      begin
        TThread.Synchronize(nil, procedure begin
          MostrarMensagemUsuario('Preencha o campo de senha.');
        end);
        Exit;
      end;

      try
        dm.Login(edtEmail.Text, edtSenha.Text);
      except
        on E: Exception do
        begin
          TThread.Synchronize(nil,
            procedure begin
              MostrarMensagemUsuario('Erro no login: ' + E.Message);
            end
          );
        end;
      end;
    end,
    TerminateLoading
  );
end;

procedure TfrmLogin.btnVoltarClick(Sender: TObject);
begin
   TabControl.GotoVisibleTab(0);
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  TabControl.GotoVisibleTab(0);
  CarregarLoginSalvo;
  BiometricAuth.OnAuthenticateSuccess := BiometricAuthAuthenticateSuccess;
  BiometricAuth.OnAuthenticateFail := BiometricAuthAuthenticateFail;
end;

procedure TfrmLogin.CarregarLoginSalvo;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(TPath.Combine(TPath.GetDocumentsPath, 'config.ini'));
  try
    TSession.id := Ini.ReadInteger('Login', 'UserID', 0);
  finally
    Ini.Free;
  end;
end;

procedure TfrmLogin.BiometricAuthAuthenticateSuccess(Sender: TObject);
begin
  TThread.CreateAnonymousThread(
    procedure
    var
      Resp: IResponse;
    begin
      try
        Resp := TRequest.New
          .BaseURL(baseURL + '/usuarios/ativar-biometria')
          .AddBody(TJSONObject.Create.AddPair('user_id', TJSONNumber.Create(TSession.id)).ToString)
          .Accept('application/json')
          .Post;
      except
        on E: Exception do
          TThread.Synchronize(nil,
            procedure
            begin
              MostrarMensagemUsuario('Erro ao ativar biometria: ' + E.Message);
            end
          );
      end;

      TThread.Synchronize(nil,
        procedure
        begin
          if not Assigned(frmClientes) then
            Application.CreateForm(TfrmClientes, frmClientes);
          frmClientes.Show;
          Self.Hide;
        end
      );
    end
  ).Start;
end;



procedure TfrmLogin.SalvarLoginLocal(UserID: Integer);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(TPath.Combine(TPath.GetDocumentsPath, 'config.ini'));
  try
    Ini.WriteInteger('Login', 'UserID', UserID);
  finally
    Ini.Free;
  end;
end;

procedure TfrmLogin.BiometricAuthAuthenticateFail(Sender: TObject;
  const FailReason: TBiometricFailReason; const ResultMessage: string);
begin
  MostrarMensagemUsuario('Falha na autenticação biométrica: ' + ResultMessage);
end;

procedure TfrmLogin.TerminateLoading(Sender: TObject);
begin
  if TSession.id > 0 then
  begin
    TThread.CreateAnonymousThread(
      procedure
      var
        SessaoValida, CodigoExiste, BiometriaAtiva: Boolean;
        resp: IResponse;
        jsonRequest, jsonResponse: TJSONObject;
      begin
        SessaoValida := False;
        CodigoExiste := False;
        BiometriaAtiva := False;

        try
          SessaoValida := dm.ValidarSessao;

          // Verificar código existente
          jsonRequest := TJSONObject.Create;
          jsonRequest.AddPair('user_id', TJSONNumber.Create(TSession.id));

          resp := TRequest.New
            .BaseURL(baseURL + '/usuarios/verificar-codigo-existente')
            .AddBody(jsonRequest.ToString)
            .Accept('application/json')
            .Post;

          jsonResponse := TJSONObject.ParseJSONValue(resp.Content) as TJSONObject;

          if jsonResponse.GetValue<Boolean>('codigo_existe', False) then
            CodigoExiste := True;

          // Verificar se a biometria está ativada
          if jsonResponse.TryGetValue<Boolean>('biometria_ativa', BiometriaAtiva) then
            BiometriaAtiva := jsonResponse.GetValue<Boolean>('biometria_ativa', False);

        except
          SessaoValida := False;
        end;

        TThread.Synchronize(nil,
          procedure
          begin
            if not SessaoValida then
            begin
              MostrarMensagemUsuario('Sessão inválida. Verifique o servidor.');
              Exit;
            end;

            if not CodigoExiste then
            begin
              if not Assigned(AutenticacaoCode) then
                Application.CreateForm(TAutenticacaoCode, AutenticacaoCode);
              AutenticacaoCode.Show;
              Exit;
            end;

            // Se código existe e biometria foi ativada
            if BiometriaAtiva then
            begin
              if BiometricAuth.IsSupported and BiometricAuth.CanAuthenticate then
              begin
                BiometricAuth.OnAuthenticateSuccess := BiometricAuthAuthenticateSuccess;
                BiometricAuth.OnAuthenticateFail := BiometricAuthAuthenticateFail;
                BiometricAuth.Authenticate;
              end
              else
                MostrarMensagemUsuario('Biometria não disponível.');
            end
            else
            begin
              // Se biometria não está ativada, segue direto pro sistema
              if not Assigned(frmClientes) then
                Application.CreateForm(TfrmClientes, frmClientes);
              frmClientes.Show;
              Self.Hide;
            end;
          end
        );

        FreeAndNil(jsonRequest);
        FreeAndNil(jsonResponse);
      end
    ).Start;
  end
  else
    MostrarMensagemUsuario('Login falhou. Verifique e-mail e senha.');
end;



 procedure TfrmLogin.MostrarMensagemUsuario(const Msg: string);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      lbTextUser.Visible := true;
      lbTextUser.Text := Msg;

      TThread.CreateAnonymousThread(
        procedure
        begin
          Sleep(3000);
          TThread.Synchronize(nil,
            procedure
            begin
              lbTextUser.Text := '';
              lbTextUser.Visible := false;
            end
          );
        end
      ).Start;
    end
  );
end;

procedure TfrmLogin.MostrarMensagemUsuarioCadastro(const Msg: string);
begin
  lblTextUserCadastro.Visible := True;
  lblTextUserCadastro.Text := Msg;

  TThread.CreateAnonymousThread(
    procedure
    begin
      Sleep(3000);
      TThread.Queue(nil,
        procedure
        begin
          lblTextUserCadastro.Text := '';
          lblTextUserCadastro.Visible := False;
          edtNome.Text := '';
          edtUltimoNome.Text := '';
          edtEmailCadastro.Text := '';
          edtSenhaCad.Text := '';
        end
      );
    end
  ).Start;
end;

procedure TfrmLogin.TerminateCadastro(Sender: TObject);
begin
  MostrarMensagemUsuarioCadastro('Cadastro realizado com sucesso!');
  TabControl.GotoVisibleTab(0);
end;


procedure TfrmLogin.lblNovaContaClick(Sender: TObject);
begin
  TabControl.GotoVisibleTab(1);
end;

procedure TfrmLogin.lblExit1Click(Sender: TObject);
begin
 TabControl.GotoVisibleTab(0);
end;

procedure TfrmLogin.lblExitClick(Sender: TObject);
begin
  TabControl.GotoVisibleTab(0);
end;

procedure TfrmLogin.lbTextUserClick(Sender: TObject);
begin
  TabControl.GotoVisibleTab(1);
end;

procedure TfrmLogin.btnCriarContaClick(Sender: TObject);
var
  Nome, Sobrenome, Email, Senha: string;
begin
  Nome := Trim(edtNome.Text);
  Sobrenome := Trim(edtUltimoNome.Text);
  Email := Trim(edtEmailCadastro.Text);
  Senha := Trim(edtSenhaCad.Text);

  // Validação rápida antes da thread
  if Nome = '' then
  begin
    MostrarMensagemUsuarioCadastro('Por favor, preencha o campo Nome.');
    Exit;
  end;

  if Sobrenome = '' then
  begin
    MostrarMensagemUsuarioCadastro('Por favor, preencha o campo Último nome.');
    Exit;
  end;

  if Email = '' then
  begin
    MostrarMensagemUsuarioCadastro('Por favor, preencha o campo E-mail.');
    Exit;
  end;

  if Senha = '' then
  begin
    MostrarMensagemUsuarioCadastro('Por favor, preencha o campo Senha.');
    Exit;
  end;

  // Thread de cadastro
  TLoading.ExecuteThread(
    procedure
    var
      Msg: string;
      LJson: TJSONObject;
    begin
      try
        dm.cadastrarUsuario(Nome, Sobrenome, Email, Senha);
      except
        on E: Exception do
        begin
          Msg := E.Message;

          if Msg.Contains('{') then
          begin
            try
              LJson := TJSONObject.ParseJSONValue(Msg) as TJSONObject;
              if Assigned(LJson) then
              begin
                Msg := LJson.GetValue<string>('message');
                LJson.Free;
              end;
            except

            end;
          end
          else if Msg.ToLower.Contains('httprequest') or Msg.ToLower.Contains('could not connect') then
            Msg := 'Não foi possível conectar ao servidor. Verifique sua internet ou tente novamente.';


          TThread.Synchronize(nil,
            procedure
            begin
              MostrarMensagemUsuarioCadastro('Erro ao cadastrar: ' + Msg);
            end
          );
        end;
      end;
    end,
    TerminateCadastro
  );
end;

procedure TfrmLogin.btnAcessarEmailClick(Sender: TObject);
begin
  TabControl.GotoVisibleTab(2);
end;

end.

