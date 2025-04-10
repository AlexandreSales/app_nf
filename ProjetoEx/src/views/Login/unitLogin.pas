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
  FMX.BiometricAuth,
  System.IOUtils,
  System.IniFiles;

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
    Layout6: TLayout;
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
  TThread.Synchronize(nil,
    procedure
    begin
      if not Assigned(frmClientes) then
        Application.CreateForm(TfrmClientes, frmClientes);
      frmClientes.Show;
      Self.Hide;
    end
  );
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
        SessaoValida: Boolean;
      begin
        SessaoValida := False;

        try
          SessaoValida := dm.ValidarSessao;
        except
          SessaoValida := False;
        end;

        TThread.Synchronize(nil,
          procedure
          begin
            if SessaoValida then
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
              MostrarMensagemUsuario('Sessão inválida. Verifique o servidor.');
          end
        );
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
  TThread.Synchronize(nil,
    procedure
    begin
      lblTextUserCadastro.visible := true;
      lblTextUserCadastro.Text := Msg;

      TThread.CreateAnonymousThread(
        procedure
        begin
          Sleep(3000);
          TThread.Synchronize(nil,
            procedure
            begin
              lblTextUserCadastro.Text := '';
              lblTextUserCadastro.visible := false;
            end
          );
        end
      ).Start;
    end
  );
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
begin
  TLoading.ExecuteThread(
    procedure
    begin
      if Trim(edtNome.Text) = '' then
      begin
        MostrarMensagemUsuarioCadastro('Por favor, preencha o campo Nome.');
        Exit;
      end;

      if Trim(edtUltimoNome.Text) = '' then
      begin
        MostrarMensagemUsuarioCadastro('Por favor, preencha o campo Último nome.');
        Exit;
      end;

      if Trim(edtEmailCadastro.Text) = '' then
      begin
        MostrarMensagemUsuarioCadastro('Por favor, preencha o campo E-mail.');
        Exit;
      end;

      if Trim(edtSenhaCad.Text) = '' then
      begin
        MostrarMensagemUsuarioCadastro('Por favor, preencha o campo Senha.');
        Exit;
      end;

      try
        Sleep(800);
        dm.cadastrarUsuario(
          edtNome.Text,
          edtUltimoNome.Text,
          edtEmailCadastro.Text,
          edtSenhaCad.Text
        );
      except
        on E: Exception do
        begin
          TThread.Synchronize(nil,
            procedure
            var
              LJson: TJSONObject;
              Msg: string;
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
              end;

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

