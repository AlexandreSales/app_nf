unit UnitConfiguracoes;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit,
  FMX.Layouts, DadosCadastraisClass, System.JSON, dmMeiDados, usuarioClass,
  FMX.ExtCtrls, System.NetEncoding, System.IOUtils, FMX.Media, FMX.DialogService.Async,
  common.consts, RESTRequest4D, FMX.MediaLibrary, FMX.Platform, System.Threading,
  uPermission, FMX.MediaLibrary.Actions, System.Permissions,
  FMX.StdActns, System.Actions, FMX.ActnList, FMX.TabControl
  {$IFDEF ANDROID}, Androidapi.Helpers, Androidapi.JNI.Os, Androidapi.JNI.JavaTypes {$ENDIF};


type
  TFrmConfiguracoes = class(TForm)
    Rectangle: TRectangle;
    Label3: TLabel;
    imgFechar: TImage;
    scrollDados: TScrollBox;
    layDados: TLayout;
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
    edtCidade: TEdit;
    rectSalvar: TRectangle;
    btnSalvar: TSpeedButton;
    layimgpai: TLayout;
    layImgfilho: TLayout;
    imgUser: TImage;
    lblTextImg: TLabel;
    ActionList1: TActionList;
    ActLogin: TChangeTabAction;
    ActConta: TChangeTabAction;
    ActFoto: TChangeTabAction;
    ActLibrary: TTakePhotoFromLibraryAction;
    ActCamera: TTakePhotoFromCameraAction;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure imgFecharClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure imgUserClick(Sender: TObject);
    procedure layImgfilhoClick(Sender: TObject);
    procedure lblTextImgClick(Sender: TObject);
    procedure edtCNPJKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure edtCEPKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure EditFocus(Sender: TObject);
    procedure EditGenericEnter(Sender: TObject);
    procedure EditGenericExit(Sender: TObject);
    procedure edtEmailEnter(Sender: TObject);
    procedure edtEmailExit(Sender: TObject);
    procedure edtTelefoneEnter(Sender: TObject);
    procedure edtTelefoneExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FOriginalHeight: Single;
    permissao: TPermissions;
    procedure ActLibraryDidFinishTaking(Image: TBitmap);
    procedure PreencherDadosCNPJ(Dados: TJSONObject);
    procedure PreencherDadosCEP(Dados: TJSONObject);
    procedure AjustarLayoutTeclado(TecladoAtivo: Boolean);
    procedure CarregarDadosExistentes;
    procedure ErroPermissao(Sender: TObject);


    function BitmapToBase64(Bitmap: TBitmap): string;

  public
  end;

var
  FrmConfiguracoes: TFrmConfiguracoes;

implementation

{$R *.fmx}

uses FMX.DialogService;

procedure TFrmConfiguracoes.FormCreate(Sender: TObject);
begin
  FOriginalHeight := layDados.Height;
  permissao := TPermissions.Create;

  ActLibrary.OnDidFinishTaking := ActLibraryDidFinishTaking;
end;

procedure TFrmConfiguracoes.FormShow(Sender: TObject);
begin
  CarregarDadosExistentes;
end;

procedure TFrmConfiguracoes.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  permissao.DisposeOf;
  Action := TCloseAction.caFree;
  FrmConfiguracoes := nil;
end;

procedure TFrmConfiguracoes.imgFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmConfiguracoes.imgUserClick(Sender: TObject);
begin
  permissao.SolicitarGaleria(ActLibrary, ErroPermissao);
  lblTextImg.Visible:= false;
end;

procedure TFrmConfiguracoes.layImgfilhoClick(Sender: TObject);
begin
  imgUserClick(Sender);
end;

procedure TFrmConfiguracoes.lblTextImgClick(Sender: TObject);
begin
  imgUserClick(Sender);
end;

procedure LoadBase64ImageToImageControl(const Base64: string; ImageControl: TImage);
var
  Bytes: TBytes;
  Stream: TMemoryStream;
begin
  if Base64.Trim = '' then Exit;

  Bytes := TNetEncoding.Base64.DecodeStringToBytes(Base64);
  Stream := TMemoryStream.Create;
  try
    Stream.WriteData(Bytes, Length(Bytes));
    Stream.Position := 0;
    ImageControl.Bitmap.LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;



procedure TFrmConfiguracoes.ActLibraryDidFinishTaking(Image: TBitmap);
begin
  if Assigned(Image) then
    imgUser.Bitmap.Assign(Image);
end;

procedure TFrmConfiguracoes.edtCNPJKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
var
  DadosCNPJ, DadosCEP: TJSONObject;
begin
  if Key = vkReturn then
  begin
    if Length(edtCNPJ.Text) < 14 then
    begin
      TDialogService.ShowMessage('CNPJ inválido.');
      Exit;
    end;
    DadosCNPJ := DataModuleMei.BuscarDadosCNPJ(edtCNPJ.Text);
    if Assigned(DadosCNPJ) then
    begin
      PreencherDadosCNPJ(DadosCNPJ);
      if Length(edtCEP.Text) >= 8 then
      begin
        DadosCEP := DataModuleMei.BuscarDadosCEP(edtCEP.Text);
        if Assigned(DadosCEP) then
          PreencherDadosCEP(DadosCEP)
        else
          TDialogService.ShowMessage('CEP não encontrado. Preencha manualmente.');
      end;
    end
    else
      TDialogService.ShowMessage('CNPJ não encontrado. Preencha manualmente.');
  end;
end;

procedure TFrmConfiguracoes.edtCEPKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
var
  DadosCEP: TJSONObject;
begin
  if Key = vkReturn then
  begin
    if Length(edtCEP.Text) < 8 then Exit;
    DadosCEP := DataModuleMei.BuscarDadosCEP(edtCEP.Text);
    if Assigned(DadosCEP) then
      PreencherDadosCEP(DadosCEP)
    else
      TDialogService.ShowMessage('CEP não encontrado. Preencha manualmente.');
  end;
end;

procedure TFrmConfiguracoes.EditFocus(Sender: TObject);
var
  Edit: TControl;
begin
  if Sender is TControl then
  begin
    Edit := TControl(Sender);
    TTask.Run(procedure
    begin
      Sleep(300);
      TThread.Synchronize(nil, procedure
      var DestY: Single;
      begin
        DestY := Edit.Position.Y - 100;
        if DestY < 0 then DestY := 0;
        scrollDados.ViewportPosition := PointF(0, DestY);
      end);
    end);
  end;
end;

procedure TFrmConfiguracoes.EditGenericEnter(Sender: TObject);
begin
  EditFocus(Sender);
  AjustarLayoutTeclado(True);
end;

procedure TFrmConfiguracoes.EditGenericExit(Sender: TObject);
begin
  AjustarLayoutTeclado(False);
end;

procedure TFrmConfiguracoes.edtEmailEnter(Sender: TObject);
begin
  EditGenericEnter(Sender);
end;

procedure TFrmConfiguracoes.edtEmailExit(Sender: TObject);
begin
  EditGenericExit(Sender);
end;

procedure TFrmConfiguracoes.edtTelefoneEnter(Sender: TObject);
begin
  EditGenericEnter(Sender);
end;

procedure TFrmConfiguracoes.edtTelefoneExit(Sender: TObject);
begin
  EditGenericExit(Sender);
end;

procedure TFrmConfiguracoes.ErroPermissao(Sender: TObject);
begin
  showmessage('Você não possui permissão para esse recurso');
end;

procedure TFrmConfiguracoes.AjustarLayoutTeclado(TecladoAtivo: Boolean);
begin
  if TecladoAtivo then
    layDados.Height := FOriginalHeight + 350
  else
    layDados.Height := FOriginalHeight;
end;

function TFrmConfiguracoes.BitmapToBase64(Bitmap: TBitmap): string;
var
  Stream: TMemoryStream;
  Bytes: TBytes;
begin
  Stream := TMemoryStream.Create;
  try
    Bitmap.SaveToStream(Stream);
    Stream.Position := 0;
    SetLength(Bytes, Stream.Size);
    Stream.ReadBuffer(Bytes, Length(Bytes));
    Result := TNetEncoding.Base64.EncodeBytesToString(Bytes);
  finally
    Stream.Free;
  end;
end;


function BitmapToBase64(Bitmap: TBitmap): string;
var
  Stream: TMemoryStream;
  Bytes: TBytes;
begin
  Stream := TMemoryStream.Create;
  try
    Bitmap.SaveToStream(Stream);
    Stream.Position := 0;
    SetLength(Bytes, Stream.Size);
    Stream.ReadBuffer(Bytes, Length(Bytes));
    Result := TNetEncoding.Base64.EncodeBytesToString(Bytes);
  finally
    Stream.Free;
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

procedure TFrmConfiguracoes.CarregarDadosExistentes;
var
  Json: TJSONObject;
  FotoBase64: string;
begin
  Json := DataModuleMei.BuscarDadosMeiSalvos(TSession.id);

  if Assigned(Json) then
  begin
    edtCNPJ.Text := Json.GetValue<string>('cnpj', '');
    edtRazaoSocial.Text := Json.GetValue<string>('razao_social', '');
    edtNomeFantasia.Text := Json.GetValue<string>('nome_fantasia', '');
    edtEmail.Text := Json.GetValue<string>('email', '');
    edtTelefone.Text := Json.GetValue<string>('telefone', '');
    edtRua.Text := Json.GetValue<string>('endereco_rua', '');
    edtNumero.Text := Json.GetValue<string>('endereco_numero', '');
    edtBairro.Text := Json.GetValue<string>('endereco_bairro', '');
    edtCidade.Text := Json.GetValue<string>('endereco_cidade', '');
    edtEstado.Text := Json.GetValue<string>('endereco_estado', '');
    edtCEP.Text := Json.GetValue<string>('endereco_cep', '');

    // Carregar imagem
    FotoBase64 := Json.GetValue<string>('foto', '');
    LoadBase64ImageToImageControl(FotoBase64, imgUser);

    // Ocultar texto da imagem, se houver imagem carregada
    lblTextImg.Visible := imgUser.Bitmap.IsEmpty;
  end;
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

    if imgUser.Bitmap.IsEmpty then
      Dados.AddPair('foto', '')
    else
      Dados.AddPair('foto', BitmapToBase64(imgUser.Bitmap));

    if DataModuleMei.SalvarDadosNoBanco(Dados) then
    begin
      TDialogService.ShowMessage('Dados salvos com sucesso!');
      Close;
    end
    else
      TDialogService.ShowMessage('Erro ao salvar os dados. Tente novamente.');
  finally
    Dados.Free;
  end;
end;

end.

