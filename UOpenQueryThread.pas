unit UOpenQueryThread;

interface

uses
  Classes, Windows, Messages, SysUtils, Graphics, Controls,
  Dialogs, DBTables, Db, ADODB;

const
  WM_OPENDATASET = WM_USER + 1;
  WM_EXECUTESQL  = WM_USER + 2;

type
  TOpenQueryThread = class(TThread)
  private
    procedure WMOpenDataSet(Msg: TMsg);
    procedure WMExecSQL(Msg: TMsg);
  protected
    procedure Execute; override;
  public
    procedure Open(DataSet: TDataSet);
    procedure ExecSQL(DataSet: TDataSet);
  end;

implementation

{ TOpenQuery }

procedure TOpenQueryThread.ExecSQL(DataSet: TDataSet);
begin
PostThreadMessage(ThreadID, WM_EXECUTESQL, Integer(DataSet), 0);
end;

procedure TOpenQueryThread.Execute;
var
  Msg : TMsg;begin  FreeOnTerminate := True;  PeekMessage(Msg, 0, WM_USER, WM_USER, PM_NOREMOVE); while not Terminated do begin    if GetMessage(Msg, 0, 0, 0) then       case Msg.Message of         WM_OPENDATASET: WMOpenDataSet(Msg);         WM_EXECUTESQL:  WMExecSQL(Msg);       end; end;

end;

procedure TOpenQueryThread.Open(DataSet: TDataSet);
begin
PostThreadMessage(ThreadID, WM_OPENDATASET, Integer(DataSet), 0);
end;

procedure TOpenQueryThread.WMExecSQL(Msg: TMsg);
var
  Qry : TQuery;begin  try    Qry := TQuery(Msg.wParam);    try      Qry.Open;    except      Qry.ExecSQL;    end;  except    On E: Exception do       ShowMessage(E.Message);  end;end;

procedure TOpenQueryThread.WMOpenDataSet(Msg: TMsg);
var
  Ds : TDataSet;begin  try    Ds := TDataSet(Msg.wParam);    Ds.Open;  except    On E: Exception do       ShowMessage(E.Message);  end;
end;

end.
