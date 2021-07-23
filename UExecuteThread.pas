unit UExecuteThread;

interface

uses
  Classes, adodb, forms, controls, activex, db;

type
  TExecuteThread = class(TThread)
  private
    tQry: TADOQuery;
    FConstring: string;
    FTerminated: Boolean;
    FTsql: string;
    procedure setConstring(const Value: string);
    procedure setTerminated(const Value: Boolean);
    procedure setTsql(const Value: string);
  protected
    procedure Execute; override;
  public
    constructor Create(Q: TADOQuery; sSQL: string);
    property Tsql: string read FTsql write setTsql;
    property Constring: string read FConstring write setConstring;
    property Terminated: Boolean read FTerminated write setTerminated;
  end;

implementation

{ TExecuteThread }

constructor TExecuteThread.Create(Q: TADOQuery; sSQL: string);
begin
  inherited Create(False);
  FreeOnTerminate := True;
  tQry := Q;
  Tsql := sSQL;
end;

procedure TExecuteThread.Execute;
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
end;

procedure TExecuteThread.setConstring(const Value: string);
begin
  FConstring := Value;
end;

procedure TExecuteThread.setTerminated(const Value: Boolean);
begin
  FTerminated := Value;
end;

procedure TExecuteThread.setTsql(const Value: string);
begin
  FTsql := Value;
end;

end.

