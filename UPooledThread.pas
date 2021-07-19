unit UPooledThread;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, System.SysUtils  ;


type
  TSQLType = (stOpen, stExecute);
  TCallback = procedure(SQLType: TSQLType; Q: TFDQuery) of object;

procedure RunSQL(sSQL: string; SQLType: TSQLType = stExecute; pCallback: TCallback = nil);

implementation

uses System.Classes ;

type
  TPooledQuery = class(TThread)
  private
    FIsGUIApp: Boolean;
    FSQLType: TSQLType;
    FConnection: TFDConnection;
    FQuery: TFDQuery;
    FSQL: string;
    FResume: boolean;
    FShutdown: Boolean;
    procedure SetSQL(const Value: string);
    procedure setResume(const Value: boolean);
    procedure setShutdown(const Value: Boolean);
    { Private declarations }
  protected
    procedure Execute; override;
  public
    CallBack: TCallback;
    procedure Initialise;
    procedure Finalise;
    property Connection: TFDConnection read FConnection;
    property Query: TFDQuery read FQuery;
    property SQL: string read FSQL write SetSQL;
    property SQLType: TSQLType write FSQLType;
    property IsGUIApp: Boolean read FIsGUIApp;
    property Resume: boolean read FResume write setResume;
    property Shutdown: Boolean read FShutdown write setShutdown;
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

{ TPooledQuery }

procedure TPooledQuery.Execute;
begin
 inherited;

  while True do
  begin
    if FResume then
    begin
      if FSQLType = stOpen then
      begin
        FQuery.Close;
        FQuery.Open(FSQL);
      end
      else
        FQuery.ExecSQL(FSQL);

      FResume := False;

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
    FConnection := TFDConnection.Create(nil);
    FConnection.Params.Add('Database=abcdatabase');
    FConnection.Params.Add('User_Name=root');
    FConnection.Params.Add('Server=localhost');
    FConnection.Params.Add('DriverID=MySQL');
    FConnection.ResourceOptions.KeepConnection := True;
    FConnection.ResourceOptions.AutoReconnect := True;
    FConnection.LoginPrompt := False;
    FConnection.Connected := True;
  end;

  if not Assigned(FQuery) then
  begin
    FQuery := TFDQuery.Create(FConnection);
    FQuery.Connection := FConnection;
  end;
end;

procedure TPooledQuery.setResume(const Value: boolean);
begin
  FResume := Value;
end;

procedure TPooledQuery.setShutdown(const Value: Boolean);
begin
  FShutdown := Value;
end;

procedure TPooledQuery.SetSQL(const Value: string);
begin
    FSQL := Value;
    FResume := True;
end;

end.
