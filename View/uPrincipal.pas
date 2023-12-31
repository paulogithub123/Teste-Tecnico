unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error,   FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool,   FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  System.Actions, Vcl.ActnList, Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls,
  Vcl.ActnMenus, Vcl.PlatformDefaultStyleActnCtrls;

type
  TfrmPrincipal = class(TForm)
    Button1: TButton;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    ActionManager1: TActionManager;
    Action1: TAction;
    ActionMainMenuBar1: TActionMainMenuBar;
    procedure Button1Click(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses uConexao, uVendasProdutosView, uSistemaControl;

procedure TfrmPrincipal.Action1Execute(Sender: TObject);
begin
  Application.CreateForm(TfrmVendasProdutosView, frmVendasProdutosView);
  try
    frmVendasProdutosView.ShowModal;
  finally
    frmVendasProdutosView.Release;
  end;
end;

procedure TfrmPrincipal.Button1Click(Sender: TObject);
var uCon : TConexao;
begin
  uCon := TConexao.Create();
  uCon.GetConn.Connected := True;

  if uCon.GetConn.Connected then
    ShowMessage('Conectado!')
  else
    ShowMessage('N�o Conectado!');

end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  TSistemaControl.GetInstance();
end;

procedure TfrmPrincipal.FormDestroy(Sender: TObject);
begin
  TSistemaControl.GetInstance().Destroy();
end;

end.
