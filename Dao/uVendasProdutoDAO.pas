unit uVendasProdutoDAO;

interface

uses
  FireDAC.Comp.Client, uConexao, uVendasProdutoModel, System.SysUtils, FireDAC.DApt, FireDac.Stan.Param;

type
  TVendasProdutoDAO = class
  private
    FConexao: TConexao;
  public
    constructor Create;

    function Incluir(AVendasProdutoModel: TVendasProdutoModel): Boolean;
    function Alterar(AVendasProdutoModel: TVendasProdutoModel): Boolean;
    function Excluir(AVendasProdutoModel: TVendasProdutoModel): Boolean;
    function Obter: TFDQuery;
    function GerarCodigo(AAutoIncrementar: Integer): Integer;
    function ObterPorCodigo(ACodigo : Integer) : TFDQuery;
  end;

implementation

{ TClienteDao }

uses uSistemaControl;

function TVendasProdutoDAO.Alterar(AVendasProdutoModel: TVendasProdutoModel): Boolean;
var
  VQry: TFDQuery;
  Transact : TFDConnection;
begin
  VQry := FConexao.CriarQuery();

  Transact := uConexao.TConexao.Create.GetConn;

  Transact.StartTransaction();
  try
    try
      VQry.Close;
      VQry.SQL.Clear;
      VQry.SQL.Add(' UPDATE PEDIDO_GERAL ');
      VQry.SQL.Add('    SET CODIGO_CLIENTE = :PCODIGO_CLIENTE, ');
      VQry.SQL.Add('        VL_TOTAL       = :PVL_TOTAL ');
      VQry.SQL.Add('  WHERE NUM_PEDIDO     = :PNUM_PEDIDO ');
      VQry.Params.ParamByName('PCODIGO_CLIENTE').AsInteger := AVendasProdutoModel.CodigoCliente;
      VQry.Params.ParamByName('PVL_TOTAL').AsFloat         := AVendasProdutoModel.VlTotal;
      VQry.Params.ParamByName('PNUM_PEDIDO').AsInteger := AVendasProdutoModel.NumPedido;
      VQry.ExecSQL;

      Transact.Commit;

      If Not Transact.InTransaction Then
        Transact.CommitRetaining;

      Result := True;
    finally
      VQry.Free;
    end;
  except
    Transact.Rollback;
    raise Exception.Create('Erro ao Atualizar o Pedido!');
  end;
end;

constructor TVendasProdutoDAO.Create;
begin
  FConexao := TSistemaControl.GetInstance().Conexao;
end;

function TVendasProdutoDAO.Excluir(AVendasProdutoModel: TVendasProdutoModel): Boolean;
var
  VQry: TFDQuery;
  Transact : TFDConnection;
begin
  VQry := FConexao.CriarQuery();

  Transact := uConexao.TConexao.Create.GetConn;

  Transact.StartTransaction();
  try
    Try
      VQry.Close;
      VQry.SQL.Clear;
      VQry.SQL.Add(' DELETE FROM PEDIDO_GERAL ');
      VQry.SQL.Add('  WHERE NUM_PEDIDO     = :PNUM_PEDIDO ');
      VQry.Params.ParamByName('PNUM_PEDIDO').AsInteger := AVendasProdutoModel.NumPedido;
      VQry.ExecSQL;

      Result := True;
      Transact.Commit;

      If Not Transact.InTransaction Then
        Transact.CommitRetaining;
    Finally
      VQry.Free;
    End;
  except
    Transact.Rollback;
    raise Exception.Create('Erro ao Deletar Pedido!');
  end;
end;

function TVendasProdutoDAO.GerarCodigo(AAutoIncrementar: Integer): Integer;
var
  VQry: TFDQuery;
begin
  VQry := FConexao.CriarQuery();
  try
    VQry.Close;
    VQry.SQL.Clear;
    VQry.SQL.Add(' SELECT MAX(IFNULL(NUM_PEDIDO, 0)) FROM PEDIDO_GERAL ');
    VQry.Open();
    try
      Result := VQry.Fields[0].AsInteger + AAutoIncrementar;
    finally
      VQry.Close;
    end;
  finally
    VQry.Free;
  end;
end;

function TVendasProdutoDAO.Incluir(AVendasProdutoModel: TVendasProdutoModel): Boolean;
var
  VQry: TFDQuery;
  Transact : TFDConnection;
begin
  VQry := FConexao.CriarQuery();

  Transact := uConexao.TConexao.Create.GetConn;

  Transact.StartTransaction();
  Try
    try
      VQry.Close;
      VQry.SQL.Clear;
      VQry.SQL.Add(' INSERT INTO PEDIDO_GERAL (NUM_PEDIDO, DT_EMISSAO, CODIGO_CLIENTE, VL_TOTAL)');
      VQry.SQL.Add('                   VALUES (:PNUM_PEDIDO, :PDT_EMISSAO, :PCODIGO_CLIENTE, :PVL_TOTAL) ');
      VQry.Params.ParamByName('PNUM_PEDIDO').AsInteger := AVendasProdutoModel.NumPedido;
      VQry.Params.ParamByName('PDT_EMISSAO').AsDateTime := AVendasProdutoModel.DtEmissao;
      VQry.Params.ParamByName('PCODIGO_CLIENTE').AsInteger := AVendasProdutoModel.CodigoCliente;
      VQry.Params.ParamByName('PVL_TOTAL').AsFloat := AVendasProdutoModel.VlTotal;
      VQry.ExecSQL;

      Result := True;
      Transact.Commit;

      If Not Transact.InTransaction Then
        Transact.CommitRetaining;

    finally
      VQry.Free;
    end;
  Except
    Transact.Rollback;
    raise Exception.Create('Erro ao Inserir Pedido!');
  End;
end;

function TVendasProdutoDAO.Obter: TFDQuery;
var
  VQry: TFDQuery;
begin
  VQry := FConexao.CriarQuery();

  VQry.Open('SELECT * FROM PEDIDO_GERAL ORDER BY 1');

  Result := VQry;
end;

function TVendasProdutoDAO.ObterPorCodigo(ACodigo: Integer): TFDQuery;
var
  VQry: TFDQuery;
begin
  VQry := FConexao.CriarQuery();

  VQry.Close;
  VQry.SQL.Clear;
  VQry.SQL.Add(' SELECT pg.NUM_PEDIDO, pg.DT_EMISSAO, pg.CODIGO_CLIENTE, cl.NOME_CLI, pg.VL_TOTAL ');
  VQry.SQL.Add('   FROM PEDIDO_GERAL pg ');
  VQry.SQL.Add('   JOIN CLIENTE cl ON (cl.CODIGO_CLI = pg.CODIGO_CLIENTE) ');
  VQry.SQL.Add('  WHERE pg.NUM_PEDIDO = :PNUM_PEDIDO ');
  VQry.Params.ParamByName('PNUM_PEDIDO').AsInteger := ACodigo;
  VQry.Open();

  Result := VQry;
end;

end.
