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
  FMX.TabControl, usuarioClass, utilsLoadig, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.StorageBin, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Controls.Presentation;

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
    procedure btnEntrarClick(Sender: TObject);
    procedure lblNovaContaClick(Sender: TObject);
    procedure lblNewContaClick(Sender: TObject);
    procedure btncontaClick(Sender: TObject);
    procedure lblExitClick(Sender: TObject);
    procedure lblExit1Click(Sender: TObject);
    procedure btnAcessarEmailClick(Sender: TObject);
    procedure rectEmailClick(Sender: TObject);
    procedure btnCriarContaClick(Sender: TObject);
  private
    { Private declarations }

    procedure TerminateLoading(sender:TObject);
    procedure TerminateCadastro(sender:TObject);
  public
    { Public declarations }
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

procedure TfrmLogin.lblNewContaClick(Sender: TObject);
begin
  Tabcontrol.GotoVisibleTab(1);
end;

procedure TfrmLogin.btnAcessarEmailClick(Sender: TObject);
begin
 Tabcontrol.GotoVisibleTab(2);
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

