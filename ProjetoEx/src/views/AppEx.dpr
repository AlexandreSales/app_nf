program AppEx;

uses
  System.StartUpCopy,
  FMX.Forms,
  unitLogin in 'Login\unitLogin.pas' {frmLogin},
  dmUsuario in '..\model\dmUsuario.pas' {dm: TDataModule},
  usuarioClass in '..\model\usuarioClass.pas',
  mainClientes in 'mainClientes\mainClientes.pas' {frmClientes},
  utilsLoadig in '..\ultils\utilsLoadig.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(Tdm, dm);
  Application.Run;
end.
