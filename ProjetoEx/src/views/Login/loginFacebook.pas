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
    WebBrowser: TWebBrowser;
    lblExit: TLabel;
    procedure WebBrowserDidFinishLoad(ASender: TObject);
    procedure lblExitClick(Sender: TObject);
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


procedure Facebook_AccessTokenRedirect(const AURL: string; var DoCloseWebView: boolean);
var
      LATPos: integer;
      LToken: string;
begin
        try
                LATPos := Pos('access_token=', AURL);

                if (LATPos > 0) then
                begin
                        LToken := Copy(AURL, LATPos + 13, Length(AURL));

                        if (Pos('&', LToken) > 0) then
                        begin
                                LToken := Copy(LToken, 1, Pos('&', LToken) - 1);
                        end;

                        frmLogin.FAccessToken := LToken;

                        if (LToken <> '') then
                        begin
                                DoCloseWebView := True;
                        end;
                end
                else
                begin
                        LATPos := Pos('api_key=', AURL);

                        if LATPos <= 0 then
                        begin
                                LATPos := Pos('access_denied', AURL);

                                if (LATPos > 0) then
                                begin
                                        // Acesso negado, cancelado ou usuário não permitiu o acesso...
                                        frmLogin.FAccessToken := '';
                                        DoCloseWebView := True;
                                end;
                        end;
                end;
      except
        on E: Exception do
          ShowMessage(E.Message);
      END;
    end;

procedure TfrmLoginFacebook.lblExitClick(Sender: TObject);
begin
  frmLogin.FAccessToken := '';
  ModalResult := mrOk;
end;

procedure TfrmLoginFacebook.WebBrowserDidFinishLoad(ASender: TObject);
var
  CloseWebView: Boolean;
  URL: string;
begin
  URL := TWebBrowser(ASender).URL;
  CloseWebView := False;

  if URL <> '' then
    Facebook_AccessTokenRedirect(URL, CloseWebView);

  // Fechar o navegador e o formulário somente após o login
  if CloseWebView then
  begin
    // Quando o token for encontrado, feche a tela
    TWebBrowser(ASender).Stop;
    TWebBrowser(ASender).URL := '';
    ModalResult := mrOk;  // Fechar o formulário
  end;
end;


end.
