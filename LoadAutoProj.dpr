program LoadAutoProj;

uses
  Vcl.Forms,
  UUtama in 'UUtama.pas' {Form1},
  UOpenQuery in 'UOpenQuery.pas',
  UOpenQueryThread in 'UOpenQueryThread.pas',
  UPooledThread in 'UPooledThread.pas',
  UPoolThread in 'UPoolThread.pas',
  UQThread in 'UQThread.pas',
  UThreadDataset in 'UThreadDataset.pas',
  Udm in 'Udm.pas' {DataModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
