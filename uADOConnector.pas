unit uADOConnector;

interface
uses
  Winapi.ActiveX,
  System.SysUtils,
  System.Classes,
  System.Threading,
  Data.DB,
  Data.Win.ADODB;
type
  TADOConnector = class
  private
    FUninitializeNeeded: Boolean;
    FConnection: TADOConnection;
  public
    constructor Create(const ConnectionString: string);
    destructor Destroy; override;
  public
    function CreateDataSet(const CommandText: string = ''): TADODataSet;
    function CreateCommand(const CommandText: string = ''): TADOCommand;
  public
    property Connection: TADOConnection read FConnection;
  end;
//https://www.board4all.biz/threads/query-in-thread.624893/#post-1158113
{
uses
  System.Threading;

procedure TMainForm.Button1StartClick(Sender: TObject);
begin
  if (Assigned(FQueryTask)) then
    Exit;

  FQueryTask := TTask.Run(QueryProc);
end;

procedure TMainForm.Button2CancelClick(Sender: TObject);
begin
  if (not Assigned(FQueryTask)) then
    Exit;

  FQueryTask.Cancel();
end;
}
implementation
{ Internals }

function CoInitializeRequired(): Boolean;
begin
  Result := MainThreadID <> TThread.Current.ThreadID;
end;

{ TADOConnector }

constructor TADOConnector.Create(const ConnectionString: string);
begin
 inherited Create();
  if (CoInitializeRequired()) then
  begin
    FUninitializeNeeded := True;
    if (not Succeeded(Winapi.ActiveX.CoInitializeEx(nil, COINIT_APARTMENTTHREADED))) then
      raise Exception.Create('COM library initialization failed.');
  end;
  FConnection := TADOConnection.Create(nil);
  FConnection.ConnectionString := ConnectionString;
  FConnection.LoginPrompt := False;
end;

function TADOConnector.CreateCommand(const CommandText: string): TADOCommand;
begin
   Result := TADOCommand.Create(FConnection);
  Result.Connection := FConnection;
  Result.CommandText := CommandText;
end;

function TADOConnector.CreateDataSet(const CommandText: string): TADODataSet;
begin
 Result := TADODataSet.Create(FConnection);
  Result.Connection := FConnection;
  Result.CommandText := CommandText;
end;

destructor TADOConnector.Destroy;
begin
 FConnection.Free();
  if (FUninitializeNeeded) then
    Winapi.ActiveX.CoUninitialize();
  inherited;
end;

end.
