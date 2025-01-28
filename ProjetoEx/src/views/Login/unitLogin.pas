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
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FMX.Controls.Presentation,
  REST.Authenticator.OAuth.WebForm.FMX,
  REST.Types,
  REST.Client,
  Data.Bind.Components,
  Data.Bind.ObjectScope,
  REST.Authenticator.OAuth,
  REST.Utils,
  loginFacebook,
  System.UITypes,
  System.JSON,
  Web.HTTPApp,
  RESTRequest4D;

type
  TfrmLogin = class(TForm)
    TabControl: TTabControl;
    tabLogin: TTabItem;
    Layout2: TLayout;
    rectFaceBook: TRectangle;
    btnAcessarFacebook: TSpeedButton;
    lblCriarConta: TLabel;
    Layout1: TLayout;
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
    rectGoogle: TRectangle;
    btnAcessarGoogle: TSpeedButton;
    Image1: TImage;
    Image4: TImage;
    rectEmail: TRectangle;
    btnAcessarEmail: TSpeedButton;
    lblNovaConta: TLabel;
    Rectangle1: TRectangle;
    SpeedButton2: TSpeedButton;
    Image3: TImage;
    Rectangle4: TRectangle;
    SpeedButton3: TSpeedButton;
    Image5: TImage;
    lblNewConta: TLabel;
    Label2: TLabel;
    edtEmailcad: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Rectangle2: TRectangle;
    btnconta: TSpeedButton;
    lblExit1: TLabel;
    lblExit: TLabel;
    OAuth2_Facebook: TOAuth2Authenticator;
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    procedure btnEntrarClick(Sender: TObject);
    procedure lblNovaContaClick(Sender: TObject);
    procedure lblNewContaClick(Sender: TObject);
    procedure btncontaClick(Sender: TObject);
    procedure lblExitClick(Sender: TObject);
    procedure lblExit1Click(Sender: TObject);
    procedure btnAcessarEmailClick(Sender: TObject);
    procedure rectEmailClick(Sender: TObject);
    procedure btnCriarContaClick(Sender: TObject);
    procedure btnAcessarFacebookClick(Sender: TObject);
    procedure RESTRequestAfterExecute(Sender: TCustomRESTRequest);
  private
    { Private declarations }

    procedure TerminateLoading(sender:TObject);
    procedure TerminateCadastro(sender:TObject);
  public
    { Public declarations }
     FAccessToken : string;
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.fmx}

uses dmUsuario, mainClientes;

procedure TfrmLogin.btnEntrarClick(Sender: TObject);
begin
  TLoading.ExecuteThread(procedure
    begin
        Sleep(800);
        dm.Login(edtEmail.Text, edtSenha.Text);
    end,
    TerminateLoading);
end;

procedure TfrmLogin.TerminateCadastro(sender: TObject);
begin
  Tabcontrol.GotoVisibleTab(0);
end;

procedure TfrmLogin.TerminateLoading(sender: TObject);
begin
  if TSession.id > 0 then
  begin
    //lembrar de destruir a tela
    if not Assigned(frmClientes) then
      Application.CreateForm(TfrmClientes, frmClientes);

    frmClientes.Show;
  end
  else
  begin
    ShowMessage('Erro no login. Verifique suas credenciais.');
  end;
end;

procedure TfrmLogin.lblExit1Click(Sender: TObject);
begin
  Tabcontrol.GotoVisibleTab(0);
end;

procedure TfrmLogin.lblExitClick(Sender: TObject);
begin
  Tabcontrol.GotoVisibleTab(0);
end;

procedure TfrmLogin.lblNovaContaClick(Sender: TObject);
begin
  Tabcontrol.GotoVisibleTab(1);
end;

procedure TfrmLogin.rectEmailClick(Sender: TObject);
begin
   Tabcontrol.GotoVisibleTab(2);
end;

procedure TfrmLogin.RESTRequestAfterExecute(Sender: TCustomRESTRequest);
var
  LJsonObj: TJSONObject;
  msg, email, nome, user_id: string;
  response: IResponse;
  jsonRequest: TJSONObject;
begin
  try
    if Assigned(RESTResponse.JSONValue) then
    begin
      LJsonObj := RESTResponse.JSONValue as TJSONObject;
      email := LJsonObj.GetValue<string>('email', '');
      nome := LJsonObj.GetValue<string>('first_name', '') + ' ' + LJsonObj.GetValue<string>('last_name', '');
      user_id := LJsonObj.GetValue<string>('id', '');

      // Cria JSON para envio ao backend
      jsonRequest := TJSONObject.Create;
      try
        jsonRequest.AddPair('email', email);
        jsonRequest.AddPair('first_name', nome);
        jsonRequest.AddPair('provider', 'Facebook');
        jsonRequest.AddPair('provider_id', user_id);

        // Envia ao backend
        response := TRequest.New
          .BaseURL('http://localhost:3000')  // URL do backend
          .Resource('/usuarios/register')  // Rota para login do Facebook
          .AddBody(jsonRequest.ToString, TRESTContentType.ctAPPLICATION_JSON)
          .Accept('application/json')
          .Post;

        if response.StatusCode = 200 then
        begin
          // Login bem-sucedido
          if not Assigned(frmClientes) then
            Application.CreateForm(TfrmClientes, frmClientes);
          frmClientes.Show;
        end
        else
        begin
          ShowMessage('Erro ao fazer login: ' + response.Content);
        end;
      finally
        jsonRequest.Free;
      end;
    end
    else
    begin
      ShowMessage('Erro ao obter dados do Facebook.');
    end;
  except
    on E: Exception do
      ShowMessage('Erro: ' + E.Message);
  end;
end;

procedure TfrmLogin.lblNewContaClick(Sender: TObject);
begin
  Tabcontrol.GotoVisibleTab(1);
end;

procedure TfrmLogin.btnAcessarEmailClick(Sender: TObject);
begin
 Tabcontrol.GotoVisibleTab(2);
end;

procedure TfrmLogin.btnAcessarFacebookClick(Sender: TObject);
var
  id_aplicativo, LURL: string;
begin
  try
    FAccessToken := '';
    id_aplicativo := '9083636655052448'; // ID do aplicativo no Facebook

    // URL de autenticação ajustada
    LURL := 'https://www.facebook.com/v16.0/dialog/oauth'
            + '?client_id=' + URIEncode(id_aplicativo)
            + '&redirect_uri=' + URIEncode('https://localhost')
            + '&response_type=token'
            + '&scope=' + URIEncode('public_profile,email')
            + '&auth_type=rerequest'
            + '&prompt=login'; // Força exibição de login

    frmLoginFacebook := TfrmLoginFacebook.Create(nil);
    frmLoginFacebook.WebBrowser.Navigate(LURL);
    frmLoginFacebook.ShowModal(
      procedure(ModalResult: TModalResult)
      begin
        if FAccessToken <> '' then
        begin
          RESTRequest.ResetToDefaults;
          RESTClient.ResetToDefaults;
          RESTResponse.ResetToDefaults;

          RESTClient.BaseURL := 'https://graph.facebook.com';
          RESTClient.Authenticator := OAuth2_Facebook;
          RESTRequest.Resource := 'me?fields=first_name,last_name,email,picture.height(150)';
          OAuth2_Facebook.AccessToken := FAccessToken;

          RESTRequest.Execute;
        end;
      end);
  except
    on E: Exception do
      ShowMessage('Erro de comunicação: ' + E.Message);
  end;
end;

procedure TfrmLogin.btncontaClick(Sender: TObject);
begin
  Tabcontrol.GotoVisibleTab(2);
end;

procedure TfrmLogin.btnCriarContaClick(Sender: TObject);
begin
    TLoading.ExecuteThread(procedure
    begin
        Sleep(800);
        dm.cadastrarUsuario(edtNome.text,edtUltimoNome.text, edtEmailcad.Text, edtSenhaCad.Text);
    end,
    TerminateCadastro);
end;

end.

