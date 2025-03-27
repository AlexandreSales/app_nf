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
  common.consts;

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
    lblNewConta: TLabel;
    edtEmailCadastro: TEdit;
    Rectangle1: TRectangle;
    SpeedButton1: TSpeedButton;
    Layout1: TLayout;
    Image1: TImage;
    Label1: TLabel;

    procedure btnEntrarClick(Sender: TObject);
    procedure lblNovaContaClick(Sender: TObject);
    procedure lblNewContaClick(Sender: TObject);
    procedure btnCriarContaClick(Sender: TObject);
    procedure btnAcessarEmailClick(Sender: TObject);
    procedure lblExitClick(Sender: TObject);
    procedure lblExit1Click(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
  private
    procedure TerminateLoading(sender: TObject);
    procedure TerminateCadastro(sender: TObject);
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
      try
        Sleep(800);
        dm.Login(edtEmail.Text, edtSenha.Text);
      except
        on E: Exception do
        begin
          TThread.Synchronize(nil,
            procedure
            begin
              ShowMessage('Erro ao realizar login: ' + E.Message);
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

procedure TfrmLogin.TerminateLoading(Sender: TObject);
var
  resp: IResponse;
  jsonRequest: TJSONObject;
  jsonResp: TJSONObject;
  codigoSalvo: string;
begin
  if TSession.id > 0 then
  begin
    jsonRequest := TJSONObject.Create;
    try
      jsonRequest.AddPair('user_id', TJSONNumber.Create(TSession.id));

      resp := TRequest.New
              .BaseURL(baseURL + '/usuarios/verificar-codigo-existente')
              .AddBody(jsonRequest.ToString)
              .Accept('application/json')
              .Post;

      if resp.StatusCode = 200 then
      begin
        jsonResp := TJSONObject.ParseJSONValue(resp.Content) as TJSONObject;
        try
          if jsonResp.GetValue<Boolean>('codigo_existe', False) then
          begin
            codigoSalvo := jsonResp.GetValue<string>('codigo_salvo', '');

            if not Assigned(frmClientes) then
              Application.CreateForm(TfrmClientes, frmClientes);
            frmClientes.Show;
          end
          else
          begin
            Application.CreateForm(TAutenticacaoCode, AutenticacaoCode);
            AutenticacaoCode.Show;
          end;
        finally
          jsonResp.Free;
        end;
      end
      else
        ShowMessage('Erro ao verificar código: ' + resp.Content);
    finally
      jsonRequest.Free;
    end;
  end
  else
    ShowMessage('Erro no login. Verifique suas credenciais.');
end;

procedure TfrmLogin.TerminateCadastro(sender: TObject);
begin


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

procedure TfrmLogin.lblNewContaClick(Sender: TObject);
begin
  TabControl.GotoVisibleTab(1);
end;

procedure TfrmLogin.btnCriarContaClick(Sender: TObject);
begin
  TLoading.ExecuteThread(
    procedure
    begin
      try
        Sleep(800);
        dm.cadastrarUsuario(edtNome.Text, edtUltimoNome.Text, edtEmailCadastro.Text, edtSenhaCad.Text);
      except
        on E: Exception do
        begin
          TThread.Synchronize(nil,
            procedure
            begin
              ShowMessage('Erro ao cadastrar usuário: ' + E.Message);
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

