unit UThreadDataset;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, DBTables, Db, adodb;

type
  TThreadDataSet = class(TThread)
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

const
  WM_OPENDATASET = WM_USER + 1;  WM_EXECUTESQL  = WM_USER + 2;

{ TThreadDataSet }

procedure TThreadDataSet.ExecSQL(DataSet: TDataSet);
begin
 PostThreadMessage(ThreadID, WM_EXECUTESQL, Integer(DataSet), 0);
end;

procedure TThreadDataSet.Execute;
var
  Msg : TMsg;begin  FreeOnTerminate := True;  PeekMessage(Msg, 0, WM_USER, WM_USER, PM_NOREMOVE);  while not Terminated do begin    if GetMessage(Msg, 0, 0, 0) then       case Msg.Message of         WM_OPENDATASET: WMOpenDataSet(Msg);         WM_EXECUTESQL:  WMExecSQL(Msg);       end;  end;
end;

procedure TThreadDataSet.Open(DataSet: TDataSet);
begin
  PostThreadMessage(ThreadID, WM_OPENDATASET, Integer(DataSet), 0);
end;

procedure TThreadDataSet.WMExecSQL(Msg: TMsg);
var
  Qry : TQuery;begin  try    Qry := TQuery(Msg.wParam);    try      Qry.Open;    except      Qry.ExecSQL;    end;  except    On E: Exception do       ShowMessage(E.Message);  end;

end;

procedure TThreadDataSet.WMOpenDataSet(Msg: TMsg);
var
  Ds : TDataSet;begin  try    Ds := TDataSet(Msg.wParam);    Ds.Open;  except    On E: Exception do       ShowMessage(E.Message);  end;
end;

end.
