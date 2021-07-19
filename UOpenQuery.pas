unit UOpenQuery;

interface

uses
  Classes, adodb, forms, controls, activex, db;

type
  TOpenQuery = class(TThread)
  private
    tQry: TADOQuery;
    FConstring: string;
    FSql: string;
    procedure setConstring(const Value: string);
    procedure setSql(const Value: string);
  protected
    procedure Execute; override;
  public
    constructor Create(const conn, Query : string ;Q: TADOQuery);
    property Sql: string read FSql write setSql;
    property Constring: string read FConstring write setConstring;


  end;

implementation

{ TOpenQuery }


constructor TOpenQuery.Create(const conn, Query: string ;Q: TADOQuery);
begin
  inherited Create(False);
  FreeOnTerminate:=True;
  Sql := Query ;
  Constring := conn ;
  tQry:=Q;
end;

procedure TOpenQuery.Execute;
begin
  inherited;
  CoInitialize(nil) ;
  try
    tQry.ConnectionString := Constring ;
    tQry.SQL.Text := Sql ;
    tQry.Open;
  finally
    CoUninitialize() ;
  end;
end;


procedure TOpenQuery.setConstring(const Value: string);
begin
  FConstring := Value;
end;

procedure TOpenQuery.setSql(const Value: string);
begin
  FSql := Value;
end;

end.
