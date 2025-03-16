unit UnitConfiguracoes;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Edit, FMX.Layouts, DadosCadastraisClass, System.JSON, dmMeiDados,usuarioClass;

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
    btnSalvar: TImage;
    edtCidade: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure imgFecharClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure edtCNPJExit(Sender: TObject);
    procedure edtCEPExit(Sender: TObject);
  private
    procedure PreencherDadosCNPJ(Dados: TJSONObject);
    procedure PreencherDadosCEP(Dados: TJSONObject);
  public
  end;

var
  FrmConfiguracoes: TFrmConfiguracoes;

implementation

{$R *.fmx}

uses
  FMX.DialogService;

procedure TFrmConfiguracoes.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  FrmConfiguracoes := nil;
end;

procedure TFrmConfiguracoes.imgFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmConfiguracoes.edtCNPJExit(Sender: TObject);
var
  DadosCNPJ: TJSONObject;
begin
  if Length(edtCNPJ.Text) < 14 then Exit;

  DadosCNPJ := DataModuleMei.BuscarDadosCNPJ(edtCNPJ.Text);
  if Assigned(DadosCNPJ) then
  begin
    PreencherDadosCNPJ(DadosCNPJ);
  end
  else
  begin
    TDialogService.ShowMessage('CNPJ não encontrado. Por favor, preencha os dados manualmente.');
  end;
end;

procedure TFrmConfiguracoes.edtCEPExit(Sender: TObject);
var
  DadosCEP: TJSONObject;
begin
  if Length(edtCEP.Text) < 8 then Exit;

  DadosCEP := DataModuleMei.BuscarDadosCEP(edtCEP.Text);
  if Assigned(DadosCEP) then
  begin
    PreencherDadosCEP(DadosCEP);
  end
  else
  begin
    TDialogService.ShowMessage('CEP não encontrado. Preencha os dados manualmente.');
  end;
end;

procedure TFrmConfiguracoes.PreencherDadosCNPJ(Dados: TJSONObject);
begin
  edtRazaoSocial.Text := Dados.GetValue<string>('razao_social', '');
  edtNomeFantasia.Text := Dados.GetValue<string>('nome_fantasia', '');
  edtInscricaoMunicipal.Text := Dados.GetValue<string>('inscricao_estadual', '');
  edtCEP.Text := Dados.GetValue<string>('cep', '');
end;

procedure TFrmConfiguracoes.PreencherDadosCEP(Dados: TJSONObject);
begin
  edtRua.Text := Dados.GetValue<string>('street', '');
  edtBairro.Text := Dados.GetValue<string>('neighborhood', '');
  edtCidade.Text := Dados.GetValue<string>('city', '');
  edtEstado.Text := Dados.GetValue<string>('state', '');
end;

procedure TFrmConfiguracoes.btnSalvarClick(Sender: TObject);
var
  Dados: TJSONObject;
begin
  Dados := TJSONObject.Create;
  try
    Dados.AddPair('id_usuario', TJSONNumber.Create(TSession.id));
    Dados.AddPair('cnpj', edtCNPJ.Text);
    Dados.AddPair('razao_social', edtRazaoSocial.Text);
    Dados.AddPair('nome_fantasia', edtNomeFantasia.Text);
    Dados.AddPair('inscricao_municipal', edtInscricaoMunicipal.Text);
    Dados.AddPair('cep', edtCEP.Text);
    Dados.AddPair('rua', edtRua.Text);
    Dados.AddPair('numero', edtNumero.Text);
    Dados.AddPair('bairro', edtBairro.Text);
    Dados.AddPair('cidade', edtCidade.Text);
    Dados.AddPair('estado', edtEstado.Text);
    Dados.AddPair('email', edtEmail.Text);
    Dados.AddPair('telefone', edtTelefone.Text);

    if DataModuleMei.SalvarDadosNoBanco(Dados) then
    begin
      TDialogService.ShowMessage('Dados salvos com sucesso!');
      Close;
    end
    else
    begin
      TDialogService.ShowMessage('Erro ao salvar os dados. Tente novamente.');
    end;
  finally
    Dados.Free;
  end;
end;


end.

