unit uVendasProdutoControl;

interface

uses
  uVendasProdutoModel, System.SysUtils, FireDAC.Comp.Client, FireDAC.DApt;

type
  TVendasProdutoControl = class
  private
    FVendasProdutoModel: TVendasProdutoModel;

  public
    constructor Create;
    destructor Destroy; override;

    function Salvar: Boolean;
    function Obter: TFDQuery;
    function GerarCodigo(AAutoIncrementar: Integer): Integer;
    property VendasProdutoModel: TVendasProdutoModel read FVendasProdutoModel write FVendasProdutoModel;
    function ObterPorCodigo(ACodigo : Integer) : TFDQuery;
  end;

implementation

{ TClienteControl }

constructor TVendasProdutoControl.Create;
begin
  FVendasProdutoModel := TVendasProdutoModel.Create;
end;

destructor TVendasProdutoControl.Destroy;
begin
  FVendasProdutoModel.Free;
  inherited;
end;

function TVendasProdutoControl.GerarCodigo(AAutoIncrementar: Integer): Integer;
begin
  Result := FVendasProdutoModel.GerarCodigo(AAutoIncrementar);
end;

function TVendasProdutoControl.Obter: TFDQuery;
begin
  Result := FVendasProdutoModel.Obter;
end;

function TVendasProdutoControl.ObterPorCodigo(ACodigo: Integer): TFDQuery;
begin
  Result := FVendasProdutoModel.ObterPorCodigo(ACodigo);
end;

function TVendasProdutoControl.Salvar: Boolean;
begin
 Result := FVendasProdutoModel.Salvar;
end;

end.
