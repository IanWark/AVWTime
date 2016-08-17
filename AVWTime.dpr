program AVWTime;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {HeaderFooterForm},
  DataController in 'DataController.pas',
  Add in 'Add.pas' {FormAdd},
  classTimeRecord in 'classTimeRecord.pas',
  MiscTypes in 'MiscTypes.pas',
  ClientClassesUnit2 in 'ClientClassesUnit2.pas',
  ClientModuleUnit in 'ClientModuleUnit.pas' {ClientModule: TDataModule},
  FileController in 'FileController.pas',
  classThreads in 'classThreads.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(THeaderFooterForm, HeaderFooterForm);
  Application.CreateForm(TFormAdd, FormAdd);
  Application.CreateForm(TClientModule, ClientModule);
  Application.Run;
end.

