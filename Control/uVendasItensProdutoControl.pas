unit uVendasItensProdutoControl;

interface

uses
  uVendasItensProdutoModel, System.SysUtils, FireDAC.Comp.Client;

type
  TVendasItensProdutoControl = class
  private
    FVendasItensProdutoModel: TVendasItensProdutoModel;

  public
    constructor Create;
    destructor Destroy; override;

    function Salvar: Boolean;
    function Obter: TFDQuery;
    function ObterItem(ACodigo : Integer) : TFDQuery;

    property VendasItensProdutoModel: TVendasItensProdutoModel read FVendasItensProdutoModel write FVendasItensProdutoModel;
  end;

implementation

{ TClienteControl }

constructor TVendasItensProdutoControl.Create;
begin
  FVendasItensProdutoModel := TVendasItensProdutoModel.Create;
end;

destructor TVendasItensProdutoControl.Destroy;
begin
  FVendasItensProdutoModel.Free;

  inherited;
end;

function TVendasItensProdutoControl.Obter: TFDQuery;
begin
  Result := FVendasItensProdutoModel.Obter;
end;

function TVendasItensProdutoControl.ObterItem(ACodigo: Integer): TFDQuery;
begin
  Result := FVendasItensProdutoModel.ObterItem(ACodigo);
end;

function TVendasItensProdutoControl.Salvar: Boolean;
begin
  Result := FVendasItensProdutoModel.Salvar;
end;

end.
