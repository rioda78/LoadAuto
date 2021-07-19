unit Udm;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TDataModule1 = class(TDataModule)
    ADOConnSatu: TADOConnection;
    ADOConnDua: TADOConnection;
    procedure DataModuleCreate(Sender: TObject);
    procedure ADOConnSatuBeforeConnect(Sender: TObject);
    procedure ADOConnDuaBeforeConnect(Sender: TObject);
  private
    FServer: string;
    FDatabaseDua: string;
    FIsSqlAuth: Boolean;
    FPassword: string;
    FUserid: string;
    FDatabaseSatu: string;
    FConstringDua: string;
    FConstringSatu: string;
    procedure setServer(const Value: string);
    procedure setDatabaseDua(const Value: string);
    procedure setIsSqlAuth(const Value: Boolean);
    procedure setPassword(const Value: string);
    procedure setUserid(const Value: string);
    procedure setDatabaseSatu(const Value: string);
    procedure BacaIniFile();

    procedure BuildString;
    procedure setConstringDua(const Value: string);
    procedure setConstringSatu(const Value: string);
    { Private declarations }
  public
    property Server: string read FServer write setServer;
    property DatabaseDua: string read FDatabaseDua write setDatabaseDua;
    property DatabaseSatu: string read FDatabaseSatu write setDatabaseSatu;
    property Userid: string read FUserid write setUserid;
    property Password: string read FPassword write setPassword;
    property IsSqlAuth: Boolean read FIsSqlAuth write setIsSqlAuth;
    property ConstringDua: string read FConstringDua write setConstringDua;
    property ConstringSatu: string read FConstringSatu write setConstringSatu;
  end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}
uses System.IniFiles;

{ TDataModule1 }

procedure TDataModule1.ADOConnSatuBeforeConnect(Sender: TObject);
begin
BacaIniFile ;
BuildString ;
ADOConnSatu.ConnectionString := ConstringSatu ;
end;

procedure TDataModule1.ADOConnDuaBeforeConnect(Sender: TObject);
begin
BacaIniFile ;
BuildString ;
ADOConnDua.ConnectionString := ConstringDua ;
end;

procedure TDataModule1.BacaIniFile;
var
  ini: TIniFile;
  vmode,alamat : string ;
begin
  alamat := GetCurrentDir + '\Config.ini' ;
  if FileExists(alamat) then
  begin
    ini := TInifile.create(alamat);
    try
      DatabaseSatu := ini.readstring('filedb', 'DB1', '');
      DatabaseDua := ini.readstring('filedb', 'DB2', '');
      Userid := ini.readstring('filedb', 'USER', '');
      Password := ini.readstring('filedb', 'PWD', '');
      vmode := ini.readstring('filedb', 'MODE', '');
      if vmode = 'SQL' then
      begin
        IsSqlAuth := True ;
      end
      else
      begin
        IsSqlAuth := False ;
      end;

      Server := ini.readstring('filedb', 'SN', '');

    finally
      ini.free ;
    end;
  end
  else
  begin
   ini := TInifile.create(alamat);
    try
      ini.writestring('filedb', 'DB1', 'datasatu');
      ini.writestring('filedb', 'DB2', 'datadua');
      ini.writestring('filedb', 'USER', 'sa');
     ini.WriteString('filedb', 'PWD', '12345');
     ini.WriteString('filedb', 'MODE', 'SQL');

     ini.WriteString('filedb', 'SN', '.');

    finally
      ini.free ;
    end;
  end;
end;

procedure TDataModule1.BuildString;
begin
  if IsSqlAuth then
  begin
    ConstringDua :=  'Provider=SQLOLEDB.1;Password='+password+';Persist Security Info=True;User ID='+
     Userid +';Initial Catalog='+databaseDua+';Data Source='+Server ;
     ConstringSatu :=  'SQLOLEDB.1;Password='+password+';Persist Security Info=True;User ID='+
     Userid +';Initial Catalog='+databaseSatu+';Data Source='+Server ;
  end
  else
  begin
    ConstringDua := 'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;'+
    'User ID='+userid+';Initial Catalog='+databaseDua+';Data Source='+Server;
    ConstringSatu := 'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;'+
    'User ID='+userid+';Initial Catalog='+databasesatu+';Data Source='+Server;
  end;
//windows///Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;User ID=sa;Initial Catalog=siskeudes_sragen;Data Source=.
//Provider=SQLOLEDB.1;Password=12345;Persist Security Info=True;User ID=sa;Initial Catalog=siskeudes_sragen;Data Source=.
end;

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
  BacaIniFile ;
  BuildString ;
end;

procedure TDataModule1.setConstringSatu(const Value: string);
begin
  FConstringSatu := Value;
end;

procedure TDataModule1.setConstringDua(const Value: string);
begin
  FConstringDua := Value;
end;

procedure TDataModule1.setDatabaseSatu(const Value: string);
begin
  FDatabaseSatu := Value;
end;

procedure TDataModule1.setDatabaseDua(const Value: string);
begin
  FDatabaseDua := Value;
end;

procedure TDataModule1.setIsSqlAuth(const Value: Boolean);
begin
  FIsSqlAuth := Value;
end;

procedure TDataModule1.setPassword(const Value: string);
begin
  FPassword := Value;
end;

procedure TDataModule1.setServer(const Value: string);
begin
  FServer := Value;
end;

procedure TDataModule1.setUserid(const Value: string);
begin
  FUserid := Value;
end;

end.
