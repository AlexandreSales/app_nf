unit loginFacebook;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.WebBrowser,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TfrmLoginFacebook = class(TForm)
    Rectangle1: TRectangle;
    WebBrowser1: TWebBrowser;
    lblExit: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLoginFacebook: TfrmLoginFacebook;

implementation

{$R *.fmx}

end.
