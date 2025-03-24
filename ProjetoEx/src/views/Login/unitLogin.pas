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
    lblNewConta: TLabel;
    lblExit1: TLabel;
    lblExit: TLabel;
    edtEmailCadastro: TEdit;

    procedure btnEntrarClick(Sender: TObject);
    procedure lblNovaContaClick(Sender: TObject);
    procedure lblNewContaClick(Sender: TObject);
    procedure btnCriarContaClick(Sender: TObject);
    procedure btnAcessarEmailClick(Sender: TObject);
    procedure lblExitClick(Sender: TObject);
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
      Sleep(800);
      dm.Login(edtEmail.Text, edtSenha.Text);
    end,TerminateLoading
  );
end;

procedure TfrmLogin.TerminateLoading(Sender: TObject);
var
  resp: IResponse;
  jsonRequest: TJSONObject;
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
        if resp.Content.Contains('codigo_existe') then
        begin
          if not Assigned(frmClientes) then
            Application.CreateForm(TfrmClientes, frmClientes);
          frmClientes.Show;
        end
        else
        begin
          Application.CreateForm(TAutenticacaoCode, AutenticacaoCode);
          AutenticacaoCode.Show;
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
      Sleep(800);
      dm.cadastrarUsuario(edtNome.Text, edtUltimoNome.Text, edtEmailCadastro.Text, edtSenhaCad.Text);
    end,
    TerminateCadastro
  );
end;

procedure TfrmLogin.btnAcessarEmailClick(Sender: TObject);
begin
  TabControl.GotoVisibleTab(2);
end;

end.

