program elm327btcfg;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ELM327 BT YK1024 Configurator';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
