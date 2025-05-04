unit UnitConfiguracoesGerais;

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
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Objects,
  usuarioClass,
  common.consts,
  RESTRequest4D,
  System.JSON;

type
  TfrmConfigGerais = class(TForm)
    Rectangle3: TRectangle;
    Label3: TLabel;
    Label15: TLabel;
    SwtDigital: TSwitch;
    procedure FormShow(Sender: TObject);
  private
    CarregandoInicial: Boolean;
    procedure SwtDigitalSwitch(Sender: TObject);
    procedure CarregarStatusBiometria;
  public
    { Public declarations }
  end;

var
  frmConfigGerais: TfrmConfigGerais;

implementation

{$R *.fmx}

procedure TfrmConfigGerais.FormShow(Sender: TObject);
begin
   CarregarStatusBiometria;
end;

procedure TfrmConfigGerais.CarregarStatusBiometria;
var
  resp: IResponse;
  jsonReq, jsonRes: TJSONObject;
  valor: string;
  isAtiva: Boolean;
begin
  if TSession.id = 0 then
    Exit;

  CarregandoInicial := True;
  isAtiva := False;

  SwtDigital.OnSwitch := nil;

  jsonReq := TJSONObject.Create;
  jsonRes := nil;
  try
    jsonReq.AddPair('user_id', TJSONNumber.Create(TSession.id));
    resp := TRequest.New
      .BaseURL(baseURL + '/usuarios/status-biometria')
      .AddBody(jsonReq.ToString)
      .Accept('application/json')
      .Post;

    jsonRes := TJSONObject.ParseJSONValue(resp.Content) as TJSONObject;
    if Assigned(jsonRes) then
    begin
      valor := jsonRes.GetValue<string>('ativa');

      SwtDigital.OnSwitch := nil;
      SwtDigital.IsChecked := (valor = '1') or (valor.ToLower = 'true');
    end;
  finally
    jsonReq.Free;
    if Assigned(jsonRes) then
      jsonRes.Free;

    CarregandoInicial := False;
    SwtDigital.OnSwitch := SwtDigitalSwitch;
  end;

end;

procedure TfrmConfigGerais.SwtDigitalSwitch(Sender: TObject);
  var
    resp: IResponse;
    jsonReq: TJSONObject;
begin

  if TSession.id = 0 then
  begin
    ShowMessage('Usuário não autenticado.');
    Exit;
  end;

  jsonReq := TJSONObject.Create;
  try
    jsonReq.AddPair('user_id', TJSONNumber.Create(TSession.id));
    jsonReq.AddPair('ativa', TJSONBool.Create(SwtDigital.IsChecked));

    resp := TRequest.New
      .BaseURL(baseURL + '/usuarios/ativar-biometria')
      .AddBody(jsonReq.ToString)
      .Accept('application/json')
      .Post;

    ShowMessage('Status da biometria atualizado.');
  except
    on E: Exception do
      ShowMessage('Erro ao atualizar biometria: ' + E.Message);
  end;

  jsonReq.Free;
end;

end.

