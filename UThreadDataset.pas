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
  WM_OPENDATASET = WM_USER + 1;

{ TThreadDataSet }

procedure TThreadDataSet.ExecSQL(DataSet: TDataSet);
begin
 PostThreadMessage(ThreadID, WM_EXECUTESQL, Integer(DataSet), 0);
end;

procedure TThreadDataSet.Execute;
var
  Msg : TMsg;
end;

procedure TThreadDataSet.Open(DataSet: TDataSet);
begin
  PostThreadMessage(ThreadID, WM_OPENDATASET, Integer(DataSet), 0);
end;

procedure TThreadDataSet.WMExecSQL(Msg: TMsg);
var
  Qry : TQuery;

end;

procedure TThreadDataSet.WMOpenDataSet(Msg: TMsg);
var
  Ds : TDataSet;
end;

end.