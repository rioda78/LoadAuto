unit UQueryThread;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, DBTables, Db, adodb;

type
  TQueryThread = class(TThread)
  private
  protected
    procedure Execute; override;
  public

  end;

implementation



{ TQueryThread }

procedure TQueryThread.Execute;
begin
  inherited;
//
end;

end.
