program AppEx;

uses
  System.StartUpCopy,
  FMX.Forms,
  unitLogin in 'views\Login\unitLogin.pas' {frmLogin},
  dmUsuario in 'model\dmUsuario.pas' {dm: TDataModule},
  usuarioClass in 'model\usuarioClass.pas',
  loginFacebook in 'views\Login\loginFacebook.pas' {frmLoginFacebook},
  mainClientes in 'views\mainClientes\mainClientes.pas' {frmClientes},
  utilsLoadig in 'ultils\utilsLoadig.pas',
  common.consts in 'common\common.consts.pas',
  unitAutenticacaoCode in 'views\Login\unitAutenticacaoCode.pas' {AutenticacaoCode};


{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TfrmLoginFacebook, frmLoginFacebook);
  Application.CreateForm(TfrmClientes, frmClientes);
  Application.CreateForm(TAutenticacaoCode, AutenticacaoCode);
  Application.Run;
end.
