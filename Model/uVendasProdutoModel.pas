unit uVendasProdutoModel;

interface

uses
  uEnumerado, FireDAC.Comp.Client;

type
  TVendasProdutoModel = class
  private
    FAcao: TAcao;
    FTipo : TTipo;
    FNumPedido: Integer;
    FDtEmissao: Tdatetime;
    FCodigoCliente : Integer;
    FVlTotal : Real;


    procedure SetAcao(const Value: TAcao);
    procedure SetTipo(const Value: TTipo);
    procedure SetNumPedido(const Value: Integer);
    procedure SetDtEmissao(const Value: TDateTime);
    procedure SetCodigoCliente(const Value: Integer);
    procedure SetVlTotal(const Value: Real);

  public
    function Obter: TFDQuery;
    function Salvar: Boolean;
    function GerarCodigo(AAutoIncrementar: Integer): Integer;
    function ObterPorCodigo(ACodigo : Integer) : TFDQuery;

    property NumPedido: Integer read FNumPedido write SetNumPedido;
    property DtEmissao: TDateTime read FDtEmissao write SetDtEmissao;
    property CodigoCliente: Integer read FCodigoCliente write SetCodigoCliente;
    property VlTotal: Real read FVlTotal write SetVlTotal;
    property Acao: TAcao read FAcao write SetAcao;
    property Tipo: TTipo read FTipo write SetTipo;
  end;

implementation

{ TVendasProdutoModel }

uses uVendasProdutoDAO;

function TVendasProdutoModel.GerarCodigo(AAutoIncrementar: Integer): Integer;
var
  VVendasProdutoDao: TVendasProdutoDao;
begin
  VVendasProdutoDao := TVendasProdutoDao.Create;
  try
    Result := VVendasProdutoDao.GerarCodigo(AAutoIncrementar);
  finally
    VVendasProdutoDao.Free;
  end;
end;

function TVendasProdutoModel.Obter: TFDQuery;
var
  VVendasProdutoDao: TVendasProdutoDAO;
begin
  VVendasProdutoDao := TVendasProdutoDao.Create;
  try
    Result := VVendasProdutoDao.Obter;
  finally
    VVendasProdutoDao.Free;
  end;
end;

function TVendasProdutoModel.ObterPorCodigo(ACodigo: Integer): TFDQuery;
var
  VVendasProdutoDao: TVendasProdutoDao;
begin
  VVendasProdutoDao := TVendasProdutoDao.Create;
  try
    Result := VVendasProdutoDao.ObterPorCodigo(ACodigo);
  finally
    VVendasProdutoDao.Free;
  end;
end;

function TVendasProdutoModel.Salvar: Boolean;
var
  VVendasProdutoDao: TVendasProdutoDao;
begin
  Result := False;

  VVendasProdutoDao := TVendasProdutoDao.Create;
  try
    case FAcao of
      uEnumerado.tacIncluir: Result := VVendasProdutoDao.Incluir(Self);
      uEnumerado.tacAlterar: Result := VVendasProdutoDao.Alterar(Self);
      uEnumerado.tacExcluir: Result := VVendasProdutoDao.Excluir(Self);
    end;
  finally
    VVendasProdutoDao.Free;
  end;
end;

procedure TVendasProdutoModel.SetAcao(const Value: TAcao);
begin
  FAcao := Value;
end;

procedure TVendasProdutoModel.SetCodigoCliente(const Value: Integer);
begin
  FCodigoCliente := Value;
end;

procedure TVendasProdutoModel.SetDtEmissao(const Value: TDateTime);
begin
  FDtEmissao := Value;
end;

procedure TVendasProdutoModel.SetNumPedido(const Value: Integer);
begin
  FNumPedido := Value;
end;

procedure TVendasProdutoModel.SetTipo(const Value: TTipo);
begin
  FTipo := Value;
end;

procedure TVendasProdutoModel.SetVlTotal(const Value: Real);
begin
  FVlTotal := Value;
end;

end.
