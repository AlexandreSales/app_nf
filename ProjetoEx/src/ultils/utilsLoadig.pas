unit utilsLoadig;

interface

uses
  System.SysUtils, System.UITypes, FMX.Forms, FMX.Graphics, FMX.Controls,
  FMX.Types, FMX.Dialogs, FMX.StdCtrls, System.Classes, FMX.Objects;

type
  TMyThreadMethod = procedure(Sender: TObject) of object;

  TLoading = class
  private
    class var Fundo: TForm;
    class var Loading: TForm;
    //class var Indicator: TActivityIndicator;
  public
    class procedure Show(Frm: TForm = nil);
    class procedure Hide;
    class procedure ExecuteThread(proc: TProc; procTerminate: TMyThreadMethod);
  end;

implementation

{ TLoading }

class procedure TLoading.Hide;
begin
  //if Assigned(Indicator) then
    //FreeAndNil(Indicator);

  if Assigned(Loading) then
    FreeAndNil(Loading);

  if Assigned(Fundo) then
    FreeAndNil(Fundo);
end;

class procedure TLoading.Show(Frm: TForm = nil);
begin
  // Form de fundo opaco...
 (* if NOT Assigned(Fundo) then
    Fundo := TForm.Create(nil);

  Fundo.Position := TFormPosition.poScreenCenter;
  Fundo.AlphaBlend := true;
  Fundo.AlphaBlendValue := 150;
  Fundo.Color := TAlphaColorRec.Black;
  Fundo.BorderStyle := TBorderStyle.bsNone;
  Fundo.FormStyle := TFormStyle.fsStayOnTop;

  if Frm = nil then
    Fundo.WindowState := TWindowState.wsMaximized
  else
  begin
    Fundo.Width := Frm.Width;
    Fundo.Height := Frm.Height;
    Fundo.Left := Frm.Left;
    Fundo.Top := Frm.Top;
  end;

  // Form transparente com o loading...
  if NOT Assigned(Loading) then
    Loading := TForm.Create(nil);

  Loading.Position := TFormPosition.poScreenCenter;
  Loading.TransparentColor := true;
  Loading.Color := TAlphaColorRec.Gray;
  Loading.TransparentColorValue := TAlphaColorRec.Gray;
  Loading.BorderStyle := TBorderStyle.bsNone;
  Loading.FormStyle := TFormStyle.fsStayOnTop;

  if Frm = nil then
  begin
    Loading.Width := Screen.Width;
    Loading.Height := Screen.Height;
    Loading.Left := 0;
    Loading.Top := 0;
  end
  else
  begin
    Loading.Width := Frm.Width - 16;
    Loading.Height := Frm.Height - 8;
    Loading.Left := Frm.Left + 8;
    Loading.Top := Frm.Top;
  end;

  // Cria a animação...
  if NOT Assigned(Indicator) then
    Indicator := TActivityIndicator.Create(Loading);

  Indicator.Parent := Loading;
  Indicator.IndicatorSize := TActivityIndicatorSize.Large;
  Indicator.IndicatorType := TActivityIndicatorType.RotatingSector;
  Indicator.FrameDelay := 100;

  if Frm = nil then
  begin
    Indicator.Left := Trunc(Screen.Width / 2) - Trunc(Indicator.Width / 2);
    Indicator.Top := Trunc(Screen.Height / 2) - Trunc(Indicator.Height / 2);
  end
  else
  begin
    Indicator.Left := Trunc(Frm.Width / 2) - Trunc(Indicator.Width / 2);
    Indicator.Top := Trunc(Frm.Height / 2) - Trunc(Indicator.Height / 2);
  end;

  Indicator.Animate := true;

  // Exibe o loading...
  Fundo.Show;
  Fundo.BringToFront;
  Loading.Show;
  Loading.BringToFront; *)
end;

class procedure TLoading.ExecuteThread(proc: TProc; procTerminate: TMyThreadMethod);
var
  t: TThread;
begin
  t := TThread.CreateAnonymousThread(proc);

  if Assigned(procTerminate) then
    t.OnTerminate := procTerminate;

  t.Start;
end;

end.

