unit UPoolThread;

interface

uses

  Data.DB,SQLServerUniProvider,
  System.Threading, System.Classes, DBAccess, Uni, MemDS;

type
  TSQLType = (stOpen, stExecute);
  TCallback = procedure(SQLType: TSQLType; Q: TUniQuery) of object;

procedure RunSQL(sSQL: string; SQLType: TSQLType = stExecute; pCallback: TCallback = nil);

implementation

uses
  System.SysUtils;

type

  TPooledQuery = class(TThread)
  private
    FConnection: TUniConnection;
    FQuery: TUniQuery;
    FSQL: string;
    FResume: Boolean;
    FShutdown: Boolean;
    FSQLType: TSQLType;
    FIsGUIApp: Boolean;
    procedure SetSQL(const Value: string);
  protected
    procedure Execute; override;
  public
    CallBack: TCallback;
    procedure Initialise;
    procedure Finalise;
    property Connection: TUniConnection read FConnection;
    property Query: TUniQuery read FQuery;
    property SQL: string read FSQL write SetSQL;
    property SQLType: TSQLType write FSQLType;
    property IsGUIApp: Boolean read FIsGUIApp;
  end;

var
  Queries: TArray<TPooledQuery>;
  LastUsed: Integer;

procedure RunSQL(sSQL: string; SQLType: TSQLType = stExecute; pCallback: TCallback = nil);
begin
  Inc(LastUsed);
  if LastUsed = Length(Queries) then
    LastUsed := 0;

  Queries[LastUsed].CallBack := pCallback;
  Queries[LastUsed].SQLType := SQLType;
  Queries[LastUsed].SQL := sSQL;
  if Queries[LastUsed].Suspended then
    Queries[LastUsed].Start;
end;

procedure CreatePool(NoOfWorkers: Integer);
var
  PQ: TPooledQuery;
  I: Integer;
begin
  SetLength(Queries, NoOfWorkers);
  for I := 0 to NoOfWorkers - 1 do
  begin
    PQ := TPooledQuery.Create(True);
    PQ.Initialise;
    Queries[I] := PQ;
  end;
end;

procedure DestroyPool;
var
  I: Integer;
begin
  for I := 0 to Length(Queries) - 1 do
  begin
    Queries[I].FShutdown := True;
    Queries[I].Finalise;
    Queries[I].Terminate;
    Queries[I].Free;
  end;

  SetLength(Queries, 0);
end;




{ TPooledQuery }

procedure TPooledQuery.Execute;
begin
  inherited;
  FIsGUIApp := true ;

  while True do
  begin
    if FResume then
    begin
      if FSQLType = stOpen then
      begin
        FQuery.Close;
        FQuery.SQL.Text := FSQL ;
        FQuery.Open();
      end
      else
      begin
        FQuery.SQL.Text := FSQL ;
        FQuery.ExecSQL();
      end;

      if FIsGUIApp then
        Synchronize(
          procedure
          begin
            if Assigned(CallBack) then
              CallBack(FSQLType, FQuery);
          end)
      else
        if Assigned(CallBack) then
              CallBack(FSQLType, FQuery);

      FResume := False;
    end;

    if FShutdown then
      break;

    Sleep(5);
  end;

end;

procedure TPooledQuery.Finalise;
begin
  if Assigned(FQuery) then
  begin
    FQuery.Close;
    FQuery.Free;
  end;

  if Assigned(FConnection) then
  begin
    FConnection.Close;
    FConnection.Free;
  end;
end;

procedure TPooledQuery.Initialise;
begin
  if not Assigned(FConnection) then
  begin
    FConnection := TUniConnection.Create(nil);
    FConnection.ProviderName := 'Sql Server' ;
    FConnection.Server := '.' ;
    FConnection.Database := 'Siskeudes_sragen';
    FConnection.Username := 'sa' ;
    FConnection.Password := '12345' ;
    FConnection.Pooling := True ;
   // FConnection.ResourceOptions.KeepConnection := True;
   // FConnection.ResourceOptions.AutoReconnect := True;
    FConnection.LoginPrompt := False;
    FConnection.Connected := True;
  end;

  if not Assigned(FQuery) then
  begin
    FQuery := TUniQuery.Create(FConnection);
    FQuery.Connection := FConnection;
  end;
end;

procedure TPooledQuery.SetSQL(const Value: string);
begin
  FSQL := Value;
  FResume := True;
end;

initialization
  LastUsed := -1;
  CreatePool(5);

finalization
  DestroyPool;


end.
