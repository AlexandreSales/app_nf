program AppEx;

uses
  System.StartUpCopy,
  FMX.Forms,
  unitLogin in 'Login\unitLogin.pas' {frmLogin};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.Run;
end.
