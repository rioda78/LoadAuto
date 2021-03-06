unit UOpenQuery;

interface

uses
  Classes, adodb, forms, controls, activex, db;

type
  TOpenQuery = class(TThread)
  private
    FConstring: string;
    FTsql: string;
    tQry: TADOQuery;
    FTerminated: Boolean;
    procedure setConstring(const Value: string);
    procedure setTsql(const Value: string);
    procedure setTerminated(const Value: Boolean);
  protected

    procedure Execute; override;
  public
    constructor Create(Q: TADOQuery;sSQL: String);
    property Tsql: string read FTsql write setTsql;
    property Constring: string read FConstring write setConstring;
    property Terminated: Boolean read FTerminated write setTerminated;
  end;

implementation

{ TOpenQuery }

constructor TOpenQuery.Create(Q: TADOQuery;sSQL: String);
begin
  inherited Create(False);
  FreeOnTerminate := True;
  tQry:=Q;
  Tsql := sSQL;

end;

procedure TOpenQuery.Execute;
begin
  inherited;
  CoInitialize(nil);
    with tQry do
    begin
      SQL.Text := tsql;

        Open;

        Sleep(100);

    end;
  CoUninitialize();
 // Screen.Cursor:=crDefault;
end;

procedure TOpenQuery.setConstring(const Value: string);
begin
  FConstring := Value;
end;

procedure TOpenQuery.setTerminated(const Value: Boolean);
begin
  FTerminated := Value;
end;

procedure TOpenQuery.setTsql(const Value: string);
begin
  FTsql := Value;
end;

end.

