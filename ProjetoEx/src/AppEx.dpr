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
  unitAutenticacaoCode in 'views\Login\unitAutenticacaoCode.pas' {AutenticacaoCode},
  UnitConfiguracoes in 'views\Config\UnitConfiguracoes.pas' {FrmConfiguracoes},
  DadosCadastraisClass in 'model\DadosCadastraisClass.pas',
  dmMeiDados in 'model\dmMeiDados.pas' {DataModuleMei: TDataModule},
  uPermission in 'ultils\uPermission.pas',
  UnitConfiguracoesGerais in 'views\Config\UnitConfiguracoesGerais.pas' {frmConfigGerais};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmConfigGerais, frmConfigGerais);
  Application.Run;
end.
