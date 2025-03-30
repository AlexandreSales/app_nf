unit uPermission;

interface

uses
  System.Permissions, FMX.DialogService, FMX.MediaLibrary.Actions,
  System.SysUtils
{$IFDEF ANDROID}
  , Androidapi.Helpers, Androidapi.JNI.JavaTypes, Androidapi.JNI.Net,
    Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.App, Androidapi.JNI.Provider
{$ENDIF}
;

type
  TCallbackProc = procedure(Sender: TObject) of Object;

  TPermissions = class
  public
    procedure SolicitarGaleria(ActionLibrary: TTakePhotoFromLibraryAction;
      ACallBackError: TCallbackProc = nil);
  end;

implementation

procedure TPermissions.SolicitarGaleria(ActionLibrary: TTakePhotoFromLibraryAction;
  ACallBackError: TCallbackProc = nil);
const
  PERMISSAO_ANTIGA = 'android.permission.READ_EXTERNAL_STORAGE';
  PERMISSAO_NOVA = 'android.permission.READ_MEDIA_IMAGES';
var
  SDK_INT: Integer;
  Permissao: string;
begin
  {$IFDEF ANDROID}
  SDK_INT := TOSVersion.Major * 10 + TOSVersion.Minor; // Android 13 = 33

  // Android 13 ou superior usa permissão nova
  if TOSVersion.Check(13) then
    Permissao := PERMISSAO_NOVA
  else
    Permissao := PERMISSAO_ANTIGA;

  if PermissionsService.IsPermissionGranted(Permissao) then
    ActionLibrary.Execute
  else
    TDialogService.ShowMessage(
      'Permissão para acessar a galeria não foi concedida. Vá até as configurações do app.');
  {$ENDIF}

  {$IFDEF IOS}
  ActionLibrary.Execute;
  {$ENDIF}

  {$IFDEF MSWINDOWS}
  TDialogService.ShowMessage('Não suportado no Windows');
  {$ENDIF}
end;





end.

