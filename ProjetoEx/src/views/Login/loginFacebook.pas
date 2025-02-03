unit loginFacebook;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.WebBrowser,
  FMX.Objects,
  FMX.Controls.Presentation,
  FMX.StdCtrls;

type
  TWebFormRedirectEvent = procedure(const AURL : string; var DoCloseWebView: boolean) of object;

type
  TfrmLoginFacebook = class(TForm)
    Rectangle1: TRectangle;
    lblExit: TLabel;
    WebBrowser: TWebBrowser;
    procedure lblExitClick(Sender: TObject);

    procedure WebBrowserDidFinishLoad(ASender: TObject);
  private
    FOnBeforeRedirect: TWebFormRedirectEvent;
    { Private declarations }
  public
    { Public declarations }
    property OnBeforeRedirect: TWebFormRedirectEvent read FOnBeforeRedirect write FOnBeforeRedirect;
  end;

var
  frmLoginFacebook: TfrmLoginFacebook;

implementation
{$R *.fmx}

uses unitLogin;




procedure TfrmLoginFacebook.lblExitClick(Sender: TObject);
begin
  frmLogin.FAccessToken := '';
  ModalResult := mrOk;
end;


procedure TfrmLoginFacebook.WebBrowserDidFinishLoad(ASender: TObject);
var
  CloseWebView: Boolean;
  URL: string;
  WebBrowser: TWebBrowser;
begin
    if not (ASender is TWebBrowser) then
    Exit;

  WebBrowser := TWebBrowser(ASender);
  URL := WebBrowser.URL;
  CloseWebView := False;


  // Fechar o navegador e o formulário somente após o login
  if CloseWebView then
  begin
    WebBrowser.Stop;
    WebBrowser.URL := '';
    Application.Terminate;  // Encerra toda a aplicação
  end;
end;




end.
