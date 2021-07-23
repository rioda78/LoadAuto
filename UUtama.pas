unit UUtama;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,Udm, System.Threading ,uADOConnector,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.Grids,
  Vcl.DBGrids, UOpenQuery, Vcl.StdCtrls, UOpenQueryThread, Datasnap.DBClient;

type
  TForm1 = class(TForm)
    DBGrid1: TDBGrid;
    ADOQuery1: TADOQuery;
    DataSource1: TDataSource;
    BtnSiap: TButton;
    BtnQueryThread: TButton;
    ADODataSet1: TADODataSet;
    ClientDataSet1: TClientDataSet;
    procedure BtnSiapClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnQueryThreadClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
   poolquery : TOpenQuery ;
   querythread : TOpenQueryThread ;
   dm : TDm ;
   FQueryTask : ITask ;
    FConstring: string;
   procedure QueryProc ;
    procedure setConstring(const Value: string);
  public
   property Constring: string read FConstring write setConstring;
  end;

var
  Form1: TForm1;

implementation


{$R *.dfm}

procedure TForm1.BtnQueryThreadClick(Sender: TObject);
var
constring , query : string ;
begin
query := 'select * from ta_pemda';
  {
  dm := Tdm.Create(nil);
  try
    constring := dm.ConstringSatu ;
    query := 'select * from ta_pemda';
    ADOQuery1.SQL.Text := query ;
    ADOQuery1.Connection := dm.ADOConnSatu ;
    querythread  := TOpenquerythread.Create(False);
    querythread.Open(ADODataSet1);   // Opening a dataset (table or query)
   // ADOQuery1.Open ;
  finally
    dm.Free ;
  end;
  }
   if (Assigned(FQueryTask)) then
    Exit;

  FQueryTask := TTask.Run(queryproc);
  //querythread.ExecSQL(Query1);  // Executing a SQL
end;

procedure TForm1.BtnSiapClick(Sender: TObject);
var
constring, query : string ;
begin
query := 'select * from ta_pemda' ;


dm := TDm.Create(nil);
try
  constring := dm.ConstringSatu ;
  //ADOQuery1.ConnectionString := dm.ConstringSatu ;
 poolquery := TOpenQuery.Create(ADOQuery1, query)  ;
finally
 dm.Free ;
end;

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(querythread) then
    querythread.Terminate;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
ReportMemoryLeaksOnShutDown := true;
dm := TDm.Create(nil);
try
  constring := dm.ConstringSatu ;
finally
 dm.free;
end;
end;

procedure TForm1.QueryProc;
var
  Connector: TADOConnector;
  CommandText: string;
  DS: TADODataSet;
begin
  try

    Connector := TADOConnector.Create(constring);
    try
      CommandText := 'insert into ta_pemda';
      DS := Connector.CreateDataSet(CommandText);
      DS.Open();
      while (not DS.Eof) do
      begin
        if (FQueryTask.Status = TTaskStatus.Canceled) then
          Break;
        // Do whatever
        DS.Next();
      end;
    finally
      Connector.Free();
    end;
  finally
    TThread.Synchronize(TThread.Current,
      procedure()
      begin
        FQueryTask := nil;
      end);
  end;

end;


procedure TForm1.setConstring(const Value: string);
begin
  FConstring := Value;
end;

end.
