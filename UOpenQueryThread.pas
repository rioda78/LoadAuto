unit UOpenQueryThread;

interface

uses
  Classes, Windows, Messages, SysUtils, Graphics, Controls,
  Dialogs, DBTables, Db, ADODB;

const
  WM_OPENDATASET = WM_USER + 1;
  WM_EXECUTESQL  = WM_USER + 2;

type
  TOpenQuery = class(TThread)
  private
    FID: integer;
    FADOQ: TAdoQuery;
    FSQL: string;
    constructor Create(CreateSuspended:Boolean; AConnString:String;
                       ASQL:string; IDThread:integer);
    procedure WMOpenDataSet(Msg: TMsg);
    procedure WMExecSQL(Msg: TMsg);
  protected
    procedure Execute; override;
  public
    connstring:widestring;
    Priority: TThreadPriority;
    property ID:integer read FID write FID;
    property SQL:string read FSQL write FSQL;
    property ADOQ:TADOQuery read FADOQ write FADOQ;
    procedure Open(DataSet: TDataSet);
    procedure ExecSQL(DataSet: TDataSet);
  end;

implementation

{ TOpenQuery }

constructor TOpenQuery.Create(CreateSuspended: Boolean; AConnString,
  ASQL: string; IDThread: integer);
begin
  inherited Create(CreateSuspended);

  // ini
  Self.FreeOnTerminate := False;

  // Create the Query
  FADOQ := TAdoquery.Create(nil);
  // assign connections
  FADOQ.ConnectionString := AConnString;
  FADOQ.SQL.Add(ASQL);
  Self.FID := IDThread;
  Self.FSQL:= ASQL;
end;

procedure TOpenQuery.ExecSQL(DataSet: TDataSet);
begin
 PostThreadMessage(ThreadID, WM_EXECUTESQL, Integer(DataSet), 0);
end;

procedure TOpenQuery.Execute;
var
  Msg : TMsg;
begin
 inherited;

  try
    // Ejecutar la consulta
    FADOQ.Open;
  except

  end;

end;

procedure TOpenQuery.Open(DataSet: TDataSet);
begin
 PostThreadMessage(ThreadID, WM_OPENDATASET, Integer(DataSet), 0);
end;

procedure TOpenQuery.WMExecSQL(Msg: TMsg);
var
  Qry : TQuery;
begin
  try
    Qry := TQuery(Msg.wParam);
    try
      Qry.Open;
    except
      Qry.ExecSQL;
    end;
  except
    On E: Exception do
       ShowMessage(E.Message);
  end;


end;

procedure TOpenQuery.WMOpenDataSet(Msg: TMsg);
var
  Ds : TDataSet;

begin
  try
    Ds := TDataSet(Msg.wParam);
    Ds.Open;
  except
    On E: Exception do
       ShowMessage(E.Message);
  end;


end;

end.
