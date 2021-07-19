unit UQThread;

interface

uses
  Classes, adodb, activex,SysUtils, Variants, db;

type
TFieldInfoRecord = Record // as far as sometimes parametertypes can not be detected by
    DataType: TFieldType; // Ado on his own, provide all needed informations
    Name: String;
    Size: Integer;
    Value: Variant;
  End;
  TFieldInfoArray = Array of TFieldInfoRecord;

type
  TQThread = class(TThread)
  private
   FQuery: TAdoQuery;
    FConstring: string;
    FSql: string;
    FRecordSet: _RecordSet;
    FTerminated: Boolean;
    procedure setConstring(const Value: string);
    procedure setSql(const Value: string);
    procedure setTerminated(const Value: Boolean);
  protected
    procedure Execute; override;
  public
    constructor Create(Const ConnectionString, query: String;FDArray: TFieldInfoArray);
    property Constring: string read FConstring write setConstring;
    property Sql: string read FSql write setSql;
    Property RecordSet: _RecordSet read FRecordSet;
    property Terminated: Boolean read FTerminated write setTerminated;
  end;


implementation

{ TQThread }

constructor TQThread.Create(Const ConnectionString, Query: String;
FDArray: TFieldInfoArray);
var
  I: Integer;
begin
 inherited Create(False);     // Create thread in a suspendend state so we can prepare vars
  //FQuery := Query;            //Set up local query var to be executed.
  FConstring := ConnectionString;
  FSQL := query;
  FreeOnTerminate := true;
  SetLength(FDArray, Length(FDArray));
  for I := 0 to High(FDArray) do
  begin
    FDArray[I].DataType := FDArray[I].DataType;
    FDArray[I].Size := FDArray[I].Size;
    FDArray[I].Name := FDArray[I].Name;
    FDArray[I].Value := FDArray[I].Value;
  end;
end;

//https://stackoverflow.com/questions/16247695/threaded-delphi-ado-query
//ado with parameter

procedure TQThread.Execute;
begin
   inherited;
    CoInitialize(nil);
  try
      With TADODataSet.Create(nil) do
      try
        CommandTimeOut := 600;
        ConnectionString := FConstring;
        CommandText := FSql ;
        While not Terminated do begin
          Open ;
        end;

      finally
        Free ;
      end;
  finally
    CoUnInitialize;
  end;
end;

procedure TQThread.setConstring(const Value: string);
begin
  FConstring := Value;
end;

procedure TQThread.setSql(const Value: string);
begin
  FSql := Value;
end;

procedure TQThread.setTerminated(const Value: Boolean);
begin
  FTerminated := Value;
end;

end.
