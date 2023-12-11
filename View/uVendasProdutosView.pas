unit uVendasProdutosView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, Vcl.Buttons,
  uVendasProdutoControl, uVendasItensProdutoControl, Vcl.ToolWin, Vcl.ComCtrls, Vcl.Mask;

type
  TfrmVendasProdutosView = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lblQtdItens: TLabel;
    Label5: TLabel;
    lblTotalItens: TLabel;
    GroupBox1: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    edtCodCliente: TEdit;
    btnIncluiProd: TBitBtn;
    GroupBox2: TGroupBox;
    dbgItens: TDBGrid;
    dsProdutoItens: TDataSource;
    FDMemProdutoGeral: TFDMemTable;
    spdbtnPesquisar: TSpeedButton;
    FDMemProdutoItens: TFDMemTable;
    Label9: TLabel;
    edtNumPedido: TEdit;
    edtDtEmissao: TMaskEdit;
    Panel2: TPanel;
    Panel3: TPanel;
    btnIncluiItem: TBitBtn;
    btnCancelarItem: TBitBtn;
    Label10: TLabel;
    edtCodProduto: TEdit;
    Label11: TLabel;
    mskEditVlUnit: TMaskEdit;
    Label12: TLabel;
    edtQtde: TEdit;
    btnCalcular: TBitBtn;
    mskEdtVlTotal: TMaskEdit;
    DBGrid1: TDBGrid;
    dsProdutoGeral: TDataSource;
    btnGravaPedido: TBitBtn;
    btnSalvarPedido: TBitBtn;
    btnSalvarItem: TBitBtn;
    btnCancelaProd: TBitBtn;
    edtNmCliente: TEdit;
    edtNmProduto: TEdit;
    StatusBar1: TStatusBar;
    procedure btnIncluiProdClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnIncluiItemClick(Sender: TObject);
    procedure btnCalcularClick(Sender: TObject);
    procedure btnCancelarItemClick(Sender: TObject);
    procedure btnSalvarPedidoClick(Sender: TObject);
    procedure btnSalvarItemClick(Sender: TObject);
    procedure btnGravaPedidoClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure FDMemProdutoGeralAfterScroll(DataSet: TDataSet);
    procedure dbgItensColEnter(Sender: TObject);
    procedure dbgItensKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCancelaProdClick(Sender: TObject);
    procedure edtCodClienteEnter(Sender: TObject);
    procedure edtCodClienteExit(Sender: TObject);
    procedure dbgItensKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure dbgItensCellClick(Column: TColumn);
    procedure edtCodProdutoExit(Sender: TObject);
    procedure spdbtnPesquisarClick(Sender: TObject);
  private
    { Private declarations }
    FVendasProdutoControl: TVendasProdutoControl;
    FVendasItensProdutoControl: TVendasItensProdutoControl;

    procedure CarregarProdutoGeralCod(ANum_Pedido : Integer);
    procedure CarregarEditsGeral;
    procedure HabilitaEditsPGeral;
    procedure LimpaEditsPGeral;

    procedure CarregarProdutoItens;
    procedure CarregarEditsItens;
    procedure HabilitaEditsPItens;
    procedure LimpaEditsPItens;
  public
    { Public declarations }
    procedure BuscaNomeCliente(ACOD_CLI : Integer);
    procedure BuscaDescProduto(ACOD_PROD : Integer);
    procedure SomaVlItens(ANum_Pedido : Integer);
  end;

var
  frmVendasProdutosView: TfrmVendasProdutosView;

implementation

{$R *.dfm}

uses uEnumerado, uConexao, System.UITypes;

procedure TfrmVendasProdutosView.btnCalcularClick(Sender: TObject);
var fQtd, fVlUnit : Real;
begin
  if (FVendasItensProdutoControl.VendasItensProdutoModel.Acao = tacIncluir) then
  begin
    if (mskEditVlUnit.Text <> EmptyStr) or (edtQtde.Text <> EmptyStr) then
    begin
      fQtd    := StrToFloat(edtQtde.Text);
      fVlUnit := StrToFloat(mskEditVlUnit.Text);
      mskEdtVlTotal.Text := formatfloat('#,##0.00', fQtd * fVlUnit);
    end
    else
    begin
      ShowMessage('Informe a Qtde e/ou o Valor Unit�rio.');
      mskEditVlUnit.SetFocus;
    end;
  end
  else
  begin
    FDMemProdutoItens.Edit;
    FDMemProdutoItens.Fields[6].AsFloat := FDMemProdutoItens.Fields[4].AsFloat * FDMemProdutoItens.Fields[5].AsFloat;
    FDMemProdutoItens.Post;
  end;
end;

procedure TfrmVendasProdutosView.btnCancelaProdClick(Sender: TObject);
begin
  FVendasProdutoControl.VendasProdutoModel.Acao := tacIndefinido;

  HabilitaEditsPGeral;

  LimpaEditsPGeral;

  FDMemProdutoGeral.Close;
  FDMemProdutoGeral.Open;
end;

procedure TfrmVendasProdutosView.btnCancelarItemClick(Sender: TObject);
begin
  FVendasItensProdutoControl.VendasItensProdutoModel.Acao := tacIndefinido;

  HabilitaEditsPItens;

  LimpaEditsPItens;

  FDMemProdutoItens.Close;
  FDMemProdutoItens.Open;
end;

procedure TfrmVendasProdutosView.btnGravaPedidoClick(Sender: TObject);
var ICod : Integer;
begin
  iCod := FDMemProdutoItens.Fields[1].AsInteger;

  if (FVendasItensProdutoControl.VendasItensProdutoModel.Acao = tacIncluir) or
     (FVendasProdutoControl.VendasProdutoModel.Acao           = tacIncluir) then
  begin
    FVendasProdutoControl.Salvar();

    if (FDMemProdutoItens.RecordCount > 0) then
    begin
      FDMemProdutoItens.First;
      while not FDMemProdutoItens.Eof do
      begin
        FVendasItensProdutoControl.VendasItensProdutoModel.Num_Pedido     := FDMemProdutoItens.Fields[1].AsInteger;
        FVendasItensProdutoControl.VendasItensProdutoModel.Codigo_Produto := FDMemProdutoItens.Fields[2].AsInteger;
        FVendasItensProdutoControl.VendasItensProdutoModel.Vl_Unitario    := FDMemProdutoItens.Fields[5].AsFloat;
        FVendasItensProdutoControl.VendasItensProdutoModel.Quantidade     := FDMemProdutoItens.Fields[4].AsInteger;
        FVendasItensProdutoControl.VendasItensProdutoModel.Vl_Total       := FDMemProdutoItens.Fields[6].AsFloat;
        FVendasItensProdutoControl.Salvar();

        FDMemProdutoItens.Next;
      end;
    end;

    ShowMessage('Incluido com sucesso.');
    FVendasItensProdutoControl.VendasItensProdutoModel.Acao := tacIndefinido;

    CarregarProdutoGeralCod(iCod);
  end
  else if (FVendasItensProdutoControl.VendasItensProdutoModel.Acao = tacExcluir) then
  begin
    if FVendasItensProdutoControl.VendasItensProdutoModel.Tipo = tacItem then
    begin
      FVendasItensProdutoControl.VendasItensProdutoModel.Codigo := FDMemProdutoItens.Fields[0].AsInteger;
      FVendasItensProdutoControl.Salvar();
    end;

    if FVendasProdutoControl.VendasProdutoModel.Tipo = tacProd then
    begin
      FVendasItensProdutoControl.VendasItensProdutoModel.Tipo := tacProd;

      FVendasProdutoControl.VendasProdutoModel.NumPedido            := FDMemProdutoGeral.Fields[0].AsInteger;
      FVendasItensProdutoControl.VendasItensProdutoModel.Num_Pedido := FDMemProdutoGeral.Fields[0].AsInteger;

      FVendasItensProdutoControl.Salvar();
      FVendasProdutoControl.Salvar();
    end;

    ShowMessage('Exclu�do com sucesso.');
    FVendasItensProdutoControl.VendasItensProdutoModel.Acao := tacIndefinido;

    if iCod > 0 then
      CarregarProdutoGeralCod(iCod);
  end
  else if (FVendasItensProdutoControl.VendasItensProdutoModel.Acao = tacAlterar) then
  begin
    FVendasItensProdutoControl.VendasItensProdutoModel.Codigo_Produto := FDMemProdutoItens.Fields[2].AsInteger;
    FVendasItensProdutoControl.VendasItensProdutoModel.Vl_Unitario    := FDMemProdutoItens.Fields[5].AsFloat;
    FVendasItensProdutoControl.VendasItensProdutoModel.Quantidade     := FDMemProdutoItens.Fields[4].AsInteger;
    FVendasItensProdutoControl.VendasItensProdutoModel.Vl_Total       := FDMemProdutoItens.Fields[6].AsFloat;
    FVendasItensProdutoControl.Salvar();

    ShowMessage('Alterado com sucesso.');
    FVendasItensProdutoControl.VendasItensProdutoModel.Acao := tacIndefinido;
  end;

  SomaVlItens(FDMemProdutoItens.Fields[1].AsInteger);
end;

procedure TfrmVendasProdutosView.btnIncluiItemClick(Sender: TObject);
begin
  FVendasItensProdutoControl.VendasItensProdutoModel.Acao := tacIncluir;

  HabilitaEditsPItens;
  LimpaEditsPItens;
end;

procedure TfrmVendasProdutosView.btnIncluiProdClick(Sender: TObject);
begin
  FVendasProdutoControl.VendasProdutoModel.Acao := uEnumerado.tacIncluir;

  LimpaEditsPGeral;
  HabilitaEditsPGeral;
  edtNumPedido.Text := IntToStr(FVendasProdutoControl.VendasProdutoModel.GerarCodigo(1));
end;

procedure TfrmVendasProdutosView.btnSalvarItemClick(Sender: TObject);
begin
  if (FVendasItensProdutoControl.VendasItensProdutoModel.Acao = tacIncluir)  then
  begin
    FVendasItensProdutoControl.VendasItensProdutoModel.Num_Pedido     := StrToInt(edtNumPedido.Text);
    FVendasItensProdutoControl.VendasItensProdutoModel.Codigo_Produto := StrToInt(edtCodProduto.Text);
    FVendasItensProdutoControl.VendasItensProdutoModel.Quantidade     := StrToInt(edtQtde.Text);
    FVendasItensProdutoControl.VendasItensProdutoModel.Vl_Unitario    := StrToFloat(mskEditVlUnit.Text);
    FVendasItensProdutoControl.VendasItensProdutoModel.Vl_Total       := StrToFloat(mskEdtVlTotal.Text);

    FDMemProdutoItens.Append;
    FDMemProdutoItens.Fields[0].AsInteger := FDMemProdutoItens.RecordCount+1;
    FDMemProdutoItens.Fields[1].AsString  := edtNumPedido.Text;
    FDMemProdutoItens.Fields[2].AsString  := edtCodProduto.Text;
    FDMemProdutoItens.Fields[4].AsString  := edtQtde.Text;
    FDMemProdutoItens.Fields[5].AsString  := mskEditVlUnit.Text;
    FDMemProdutoItens.Fields[6].AsString  := mskEdtVlTotal.Text;
    FDMemProdutoItens.Post;
  end
  else if (FVendasItensProdutoControl.VendasItensProdutoModel.Acao IN [tacAlterar, tacExcluir]) then
  begin
    FVendasItensProdutoControl.VendasItensProdutoModel.Codigo         := FDMemProdutoItens.Fields[0].AsInteger;
    FVendasItensProdutoControl.VendasItensProdutoModel.Codigo_Produto := FDMemProdutoItens.Fields[2].AsInteger;
    FVendasItensProdutoControl.VendasItensProdutoModel.Num_Pedido     := FDMemProdutoItens.Fields[1].AsInteger;
    FVendasItensProdutoControl.VendasItensProdutoModel.Quantidade     := FDMemProdutoItens.Fields[4].AsInteger;
    FVendasItensProdutoControl.VendasItensProdutoModel.Vl_Unitario    := FDMemProdutoItens.Fields[5].AsInteger;
    FVendasItensProdutoControl.VendasItensProdutoModel.Vl_Total       := FDMemProdutoItens.Fields[6].AsInteger;
  end;

  lblQtdItens.Caption   := IntToStr(FDMemProdutoItens.RecordCount);
end;

procedure TfrmVendasProdutosView.btnSalvarPedidoClick(Sender: TObject);
begin
  FDMemProdutoGeral.Append;
  FDMemProdutoGeral.Fields[0].AsString   := edtNumPedido.Text;
  FDMemProdutoGeral.Fields[1].AsString   := edtDtEmissao.Text;
  FDMemProdutoGeral.Fields[2].AsString   := edtCodCliente.Text;
  FDMemProdutoGeral.Fields[3].AsString   := '0';

  FVendasProdutoControl.VendasProdutoModel.Acao           := tacIncluir;
  FVendasProdutoControl.VendasProdutoModel.NumPedido      := StrToInt(edtNumPedido.Text);
  FVendasProdutoControl.VendasProdutoModel.DtEmissao      := StrToDateTime(edtDtEmissao.Text);
  FVendasProdutoControl.VendasProdutoModel.CodigoCliente  := StrToInt(edtCodCliente.Text);
  FVendasProdutoControl.VendasProdutoModel.VlTotal        := FDMemProdutoItens.Fields[6].AsInteger;

  FDMemProdutoGeral.Post;

  HabilitaEditsPItens;
end;

procedure TfrmVendasProdutosView.BuscaDescProduto(ACOD_PROD: Integer);
var
  VQry: TFDQuery;
begin
  VQry := TConexao.Create.CriarQuery();

  VQry.Close;
  VQry.SQL.Clear;
  VQry.SQL.Add(' select pro.DESC_PRO ');
  VQry.SQL.Add('   from PRODUTOS pro ');
  VQry.SQL.Add('  where pro.CODIGO_PRO = :PCODIGO_PRO ');
  VQry.Params.ParamByName('PCODIGO_PRO').AsInteger := ACOD_PROD;
  VQry.Open();

  if vQry.RecordCount > 0 then
    edtNmProduto.Text := VQry.FieldByName('DESC_PRO').AsString
  else
  begin
    ShowMessage('Produto n�o existe!');
    edtNmProduto.Clear;
    edtNmProduto.SetFocus;
  end;
end;

procedure TfrmVendasProdutosView.BuscaNomeCliente(ACOD_CLI : Integer);
var
  VQry: TFDQuery;
begin
  VQry := TConexao.Create.CriarQuery();

  VQry.Close;
  VQry.SQL.Clear;
  VQry.SQL.Add(' select cli.NOME_CLI ');
  VQry.SQL.Add('   from CLIENTE cli ');
  VQry.SQL.Add('  where cli.CODIGO_CLI = :PCODIGO_CLI ');
  VQry.Params.ParamByName('PCODIGO_CLI').AsInteger := ACOD_CLI;
  VQry.Open();

  if vQry.RecordCount > 0 then
    edtNmCliente.Text := VQry.FieldByName('NOME_CLI').AsString
  else
  begin
    ShowMessage('Cliente n�o existe!');
    edtNmCliente.Clear;
    edtNmCliente.SetFocus;
  end;
end;

procedure TfrmVendasProdutosView.CarregarProdutoGeralCod(ANum_Pedido: Integer);
var
  VQryP: TFDQuery;
begin
  FDMemProdutoGeral.Close;

  //if ANum_Pedido > 0 then
  //begin
    VQryP := FVendasProdutoControl.ObterPorCodigo(ANum_Pedido);
    try
      VQryP.FetchAll;
      FDMemProdutoGeral.Data := VQryP.Data;

    finally
      VQryP.Close;
      VQryP.Free;
    end;
  //end;

  if (FDMemProdutoGeral.RecordCount = 0) and
     (FVendasProdutoControl.VendasProdutoModel.Acao = tacIncluir) then
    ShowMessage('N�o existe(m) Pedidos!');
end;

procedure TfrmVendasProdutosView.CarregarProdutoItens;
var
  VQry: TFDQuery;
begin
  FDMemProdutoItens.Close;

  VQry := FVendasItensProdutoControl.ObterItem(FDMemProdutoGeral.Fields[0].AsInteger);
  try
    VQry.FetchAll;
    FDMemProdutoItens.Data := VQry.Data;
  finally
    VQry.Close;
    VQry.Free;
  end;
end;

procedure TfrmVendasProdutosView.dbgItensCellClick(Column: TColumn);
begin
  CarregarEditsItens;
end;

procedure TfrmVendasProdutosView.dbgItensColEnter(Sender: TObject);
var iCod : Integer;
begin
  if FVendasItensProdutoControl.VendasItensProdutoModel.Acao = tacAlterar then
  begin
    iCod := FDMemProdutoItens.Fields[1].AsInteger;

    if (dbgItens.Columns.Grid.SelectedField.FieldName = 'QUANTIDADE') or
       (dbgItens.Columns.Grid.SelectedField.FieldName = 'VL_UNITARIO') or
       (dbgItens.Columns.Grid.SelectedField.FieldName = 'VL_TOTAL')then
    begin
      FVendasProdutoControl.VendasProdutoModel.Acao           := tacIndefinido;

      btnCalcular.Click();
      btnSalvarItem.Click();
      btnGravaPedido.Click();

      CarregarProdutoGeralCod(iCod);

      btnSalvarItem.Enabled   := False;
      btnCancelarItem.Enabled := False;

      FVendasItensProdutoControl.VendasItensProdutoModel.Acao := tacIndefinido;
    end;
  end;
end;

procedure TfrmVendasProdutosView.dbgItensKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
  begin
    if (dbgItens.Columns.Grid.SelectedField.FieldName = 'QUANTIDADE') or
       (dbgItens.Columns.Grid.SelectedField.FieldName = 'VL_UNITARIO')then
    begin
      btnSalvarItem.Enabled   := True;
      btnCancelarItem.Enabled := True;

      dbgItens.Options := dbgItens.Options + [dgEditing];
      FVendasItensProdutoControl.VendasItensProdutoModel.Acao := tacAlterar;
    end;
  end;

  if (Key = VK_DELETE) then
  begin
    if MessageDlg('Deseja realmente apagar o Item?', mtConfirmation, [mbyes,mbno],0) = mrYes then
    begin
      FVendasProdutoControl.VendasProdutoModel.Acao           := tacExcluir;
      FVendasItensProdutoControl.VendasItensProdutoModel.Acao := tacExcluir;

      FVendasItensProdutoControl.VendasItensProdutoModel.Tipo := tacItem;
      FVendasProdutoControl.VendasProdutoModel.Tipo           := tacNenhum;
      btnGravaPedido.Click();
    end;
  end;
end;

procedure TfrmVendasProdutosView.dbgItensKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  CarregarEditsItens;
end;

procedure TfrmVendasProdutosView.DBGrid1CellClick(Column: TColumn);
begin
  CarregarEditsGeral;
end;

procedure TfrmVendasProdutosView.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DELETE) then
  begin
    if MessageDlg('Deseja realmente apagar o Item?', mtConfirmation, [mbyes,mbno],0) = mrYes then
    begin
      FVendasProdutoControl.VendasProdutoModel.Acao           := tacExcluir;
      FVendasItensProdutoControl.VendasItensProdutoModel.Acao := tacExcluir;

      FVendasItensProdutoControl.VendasItensProdutoModel.Tipo := tacNenhum;
      FVendasProdutoControl.VendasProdutoModel.Tipo           := tacProd;
      btnGravaPedido.Click();

      LimpaEditsPGeral;
      LimpaEditsPItens;
    end;
  end;
end;

procedure TfrmVendasProdutosView.DBGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 CarregarEditsGeral;
 CarregarProdutoItens;
 CarregarEditsItens;

 if FDMemProdutoItens.Fields[2].AsInteger > 0 then
   BuscaDescProduto(FDMemProdutoItens.Fields[2].AsInteger);
end;

procedure TfrmVendasProdutosView.edtCodClienteEnter(Sender: TObject);
begin
  if edtCodCliente.Text <> EmptyStr then
    BuscaNomeCliente(StrToInt(edtCodCliente.Text));
end;

procedure TfrmVendasProdutosView.edtCodClienteExit(Sender: TObject);
begin
  if edtCodCliente.Text <> EmptyStr then
    BuscaNomeCliente(StrToInt(edtCodCliente.Text));
end;

procedure TfrmVendasProdutosView.edtCodProdutoExit(Sender: TObject);
begin
  BuscaDescProduto(StrToInt(edtCodCliente.Text));
end;

procedure TfrmVendasProdutosView.CarregarEditsGeral;
begin
  edtNumPedido.Text  := FDMemProdutoGeral.Fields[0].AsString;
  edtDtEmissao.Text  := FDMemProdutoGeral.Fields[1].AsString;
  edtCodCliente.Text := FDMemProdutoGeral.Fields[2].AsString;

  if edtNumPedido.Text <> EmptyStr then
  begin
    BuscaNomeCliente(StrToInt(edtNumPedido.Text));
    SomaVlItens(StrToInt(edtNumPedido.Text));
  end;
end;

procedure TfrmVendasProdutosView.CarregarEditsItens;
begin
  if FDMemProdutoItens.RecordCount > 0 then
  begin
    edtCodProduto.Text := FDMemProdutoItens.Fields[2].AsString;
    mskEditVlUnit.Text := FDMemProdutoItens.Fields[5].AsString;
    edtQtde.Text       := FDMemProdutoItens.Fields[4].AsString;
    mskEdtVlTotal.Text := formatfloat('#,##0.00', StrToFloat(FDMemProdutoItens.Fields[6].AsString));

    if edtCodProduto.Text <> EmptyStr then
      BuscaDescProduto(StrToInt(edtCodProduto.Text));
  end;
end;

procedure TfrmVendasProdutosView.FDMemProdutoGeralAfterScroll(
  DataSet: TDataSet);
begin
  CarregarProdutoItens;
end;

procedure TfrmVendasProdutosView.FormCreate(Sender: TObject);
begin
  FVendasProdutoControl := TVendasProdutoControl.Create;
  FVendasItensProdutoControl := TVendasItensProdutoControl.Create;
end;

procedure TfrmVendasProdutosView.FormShow(Sender: TObject);
begin
  FVendasProdutoControl.VendasProdutoModel.Acao := tacIndefinido;
  FVendasItensProdutoControl.VendasItensProdutoModel.Acao := tacIndefinido;

  StatusBar1.Panels[0].text := DateToStr(Date);
  Statusbar1.Panels[1].text := TimeToStr(Time);
  Statusbar1.Panels[2].text := 'TESTE T�CNIC.';

  CarregarProdutoGeralCod(99);
end;

procedure TfrmVendasProdutosView.HabilitaEditsPGeral;
begin
  edtNumPedido.Enabled  := FVendasProdutoControl.VendasProdutoModel.Acao = tacIncluir;
  edtDtEmissao.Enabled  := FVendasProdutoControl.VendasProdutoModel.Acao = tacIncluir;
  edtCodCliente.Enabled := FVendasProdutoControl.VendasProdutoModel.Acao = tacIncluir;

  if (FVendasProdutoControl.VendasProdutoModel.Acao = tacIncluir) then
    edtDtEmissao.SetFocus;

  btnSalvarPedido.Enabled := FVendasProdutoControl.VendasProdutoModel.Acao = tacIncluir;
  btnCancelaProd.Enabled  := FVendasProdutoControl.VendasProdutoModel.Acao = tacIncluir;
end;

procedure TfrmVendasProdutosView.HabilitaEditsPItens;
begin
  edtCodProduto.Enabled   := FVendasItensProdutoControl.VendasItensProdutoModel.Acao = tacIncluir;
  mskEditVlUnit.Enabled   := FVendasItensProdutoControl.VendasItensProdutoModel.Acao = tacIncluir;
  edtQtde.Enabled         := FVendasItensProdutoControl.VendasItensProdutoModel.Acao = tacIncluir;
  mskEdtVlTotal.Enabled   := FVendasItensProdutoControl.VendasItensProdutoModel.Acao = tacIncluir;

  btnIncluiItem.Enabled   := (FVendasItensProdutoControl.VendasItensProdutoModel.Acao = tacIncluir) or
                             (FVendasProdutoControl.VendasProdutoModel.Acao           = tacIncluir);
  btnSalvarItem.Enabled   := (FVendasItensProdutoControl.VendasItensProdutoModel.Acao = tacIncluir) or
                             (FVendasProdutoControl.VendasProdutoModel.Acao           = tacIncluir);
  btnCancelarItem.Enabled := (FVendasItensProdutoControl.VendasItensProdutoModel.Acao = tacIncluir) or
                             (FVendasProdutoControl.VendasProdutoModel.Acao           = tacIncluir);

  if FVendasItensProdutoControl.VendasItensProdutoModel.Acao = tacIncluir then
    edtCodProduto.SetFocus;
end;

procedure TfrmVendasProdutosView.LimpaEditsPGeral;
begin
  edtNumPedido.Clear;
  edtDtEmissao.Clear;
  edtCodCliente.Clear;
  edtNmCliente.Clear;
end;

procedure TfrmVendasProdutosView.LimpaEditsPItens;
begin
  edtCodProduto.Clear;
  edtNmProduto.Clear;
  mskEditVlUnit.Clear;
  edtQtde.Clear;
  mskEdtVlTotal.Clear;
end;

procedure TfrmVendasProdutosView.SomaVlItens(ANum_Pedido: Integer);
var
  VQry: TFDQuery;
begin
  VQry := TConexao.Create.CriarQuery();

  VQry.Close;
  VQry.SQL.Clear;
  VQry.SQL.Add(' SELECT COUNT(pp.NUM_PEDIDO) QTDE, SUM(pp.VL_TOTAL) AS TOTAL ');
  VQry.SQL.Add('   FROM PEDIDO_PRODUTO pp ');
  VQry.SQL.Add('  WHERE pp.NUM_PEDIDO = :PNUM_PEDIDO ');
  VQry.Params.ParamByName('PNUM_PEDIDO').AsInteger := ANum_Pedido;
  VQry.Open();

  if VQry.RecordCount > 0 then
  begin
    lblTotalItens.Caption := formatfloat('#,##0.00', VQry.FieldByName('TOTAL').AsFloat);
    lblQtdItens.Caption   := FloatToStr(VQry.FieldByName('QTDE').AsFloat);
  end
  else
  begin
    lblTotalItens.Caption := '0,00';
    lblQtdItens.Caption   := '0';
  end;
end;

procedure TfrmVendasProdutosView.spdbtnPesquisarClick(Sender: TObject);
var VCodigo : String;
begin
  VCodigo := InputBox('Pesquisar', 'Digite o N�mero do Pedido', EmptyStr);

  CarregarProdutoGeralCod(StrToInt(VCodigo));
  FVendasProdutoControl.VendasProdutoModel.ObterPorCodigo(StrToInt(VCodigo));
end;

end.
