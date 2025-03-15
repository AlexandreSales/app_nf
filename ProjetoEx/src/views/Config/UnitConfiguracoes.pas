unit UnitConfiguracoes;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.Layouts;

type
  TFrmConfiguracoes = class(TForm)
    Rectangle: TRectangle;
    Label3: TLabel;
    imgFechar: TImage;
    scrollDados: TScrollBox;
    Layout6: TLayout;
    Label14: TLabel;
    edtNomeFantasia: TEdit;
    Label15: TLabel;
    edtCNPJ: TEdit;
    Label2: TLabel;
    Label1: TLabel;
    edtInscricaoMunicipal: TEdit;
    Label4: TLabel;
    edtRazaoSocial: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    edtRua: TEdit;
    Label7: TLabel;
    edtNumero: TEdit;
    Label8: TLabel;
    edtBairro: TEdit;
    Label9: TLabel;
    Cidade: TEdit;
    Label10: TLabel;
    edtEstado: TEdit;
    Label11: TLabel;
    edtCEP: TEdit;
    Label12: TLabel;
    Label13: TLabel;
    edtEmail: TEdit;
    Label16: TLabel;
    edtTelefone: TEdit;
    Rectangle1: TRectangle;
    Image1: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure imgFecharClick(Sender: TObject);
    procedure imgSalvarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmConfiguracoes: TFrmConfiguracoes;

implementation

{$R *.fmx}

procedure TFrmConfiguracoes.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    FrmConfiguracoes := nil;
end;

procedure TFrmConfiguracoes.imgFecharClick(Sender: TObject);
begin
    close;
end;

procedure TFrmConfiguracoes.imgSalvarClick(Sender: TObject);
begin
    // Salvar os dados...

    close;
end;

end.
