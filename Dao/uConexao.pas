unit uConexao;

interface

uses
  System.SysUtils, IniFiles, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error,   FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool,   FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client;

type
  TConexao = class
  private
    FConn: TFDConnection;

    procedure ConfigurarConexao;
  public
    constructor Create;
    destructor Destroy; override;

    function GetConn: TFDConnection;
    function CriarQuery: TFDQuery;
    procedure CriaArqIni;
  end;

implementation

{ FConexao }


{ TConexao }

procedure TConexao.ConfigurarConexao;
var
  ArqINI: Tinifile;
  caminho : String;
begin
  caminho := 'C:\PauloFN\Projetos Desenvolvimento\Delphi\Delphi x MySQL\Projeto 1\';
  ArqINI := Tinifile.Create(caminho + 'Config.ini');

  try
    FConn.Params.DriverID         := ArqINI.ReadString('Servidor', 'DriverID', EmptyStr);
    FConn.Params.UserName         := ArqINI.ReadString('Servidor', 'User_name', EmptyStr);
    FConn.Params.Password         := ArqINI.ReadString('Servidor', 'Password', EmptyStr);
    FConn.Params.Values['Server'] := ArqINI.ReadString('Servidor', 'Server', EmptyStr);
    FConn.Params.Database         := ArqINI.ReadString('Servidor', 'Database', EmptyStr);
    FConn.LoginPrompt             := False;
  finally
    FreeAndNil(ArqINI);
  end;
end;

constructor TConexao.Create;
begin
  FConn := TFDConnection.Create(nil);
 // CriaArqIni();
  Self.ConfigurarConexao();
end;

procedure TConexao.CriaArqIni;
var
  ArqINI: Tinifile;
begin
  ArqIni := TIniFile.Create('C:\PauloFN\Projetos Desenvolvimento\Delphi\Delphi x MySQL\Projeto 1\Config.ini');

  ArqINI.WriteString('Servidor', 'DriverID', 'MySQL');
  ArqINI.WriteString('Servidor', 'User_name', 'root');
  ArqINI.WriteString('Servidor', 'Password', '123456');
  ArqINI.WriteString('Servidor', 'Server', '127.0.0.1');
  ArqINI.WriteString('Servidor', 'Database', 'pedido');
  ArqINI.WriteString('Arquivo', 'Caminho', 'C:\PauloFN\Projetos Desenvolvimento\Delphi\Delphi x MySQL\Projeto 1\');
end;

function TConexao.CriarQuery: TFDQuery;
var
  VQuery: TFDQuery;
begin
  VQuery := TFDQuery.Create(nil);
  VQuery.Connection := FConn;

  Result := VQuery;
end;

destructor TConexao.Destroy;
begin
  FConn.Free;

  inherited;
end;

function TConexao.GetConn: TFDConnection;
begin
  Result := FConn;
end;

end.
