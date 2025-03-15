unit mainClientes;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView,
  FMX.TabControl,FMX.Ani,UnitConfiguracoes;

type
  TfrmClientes = class(TForm)
    TabControl: TTabControl;
    TabItem1: TTabItem;
    Rectangle1: TRectangle;
    lvCliente: TListView;
    TabItem2: TTabItem;
    Rectangle2: TRectangle;
    lvCardapio: TListView;
    TabItem3: TTabItem;
    Rectangle3: TRectangle;
    Label3: TLabel;
    rectItemConfig: TRectangle;
    Image3: TImage;
    Label6: TLabel;
    Image7: TImage;
    rectItemLogout: TRectangle;
    Image8: TImage;
    Label7: TLabel;
    Image9: TImage;
    Rectangle6: TRectangle;
    imgAba1: TImage;
    imgAba2: TImage;
    imgAba3: TImage;
    rectIndicador: TRectangle;
    procedure imgAba1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imgAba2Click(Sender: TObject);
    procedure imgAba3Click(Sender: TObject);
  private
    { Private declarations }
     procedure MudarAba(img: TImage);
  public
    { Public declarations }
  end;

var
  frmClientes: TfrmClientes;

implementation

{$R *.fmx}

procedure TfrmClientes.FormShow(Sender: TObject);
begin
 MudarAba(imgAba1);
end;

procedure TfrmClientes.imgAba1Click(Sender: TObject);
begin
  MudarAba(TImage(Sender));
end;

procedure TfrmClientes.imgAba2Click(Sender: TObject);
begin
  MudarAba(TImage(Sender));
end;

procedure TfrmClientes.imgAba3Click(Sender: TObject);
begin
  MudarAba(TImage(Sender));
end;

procedure TfrmClientes.MudarAba(img: TImage);
begin
    imgAba1.Opacity := 0.5;
    imgAba2.Opacity := 0.5;
    imgAba3.Opacity := 0.5;
    img.Opacity := 1;

    TAnimator.AnimateFloat(rectIndicador, 'Position.x',
                           img.position.x, 0.2, TAnimationType.InOut,
                           TInterpolationType.Circular);

    TabControl.GotoVisibleTab(img.Tag);


end;

end.
