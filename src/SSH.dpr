program SSH;

uses
  Vcl.Forms,
  SSHMain in 'SSHMain.pas' {MainConexao};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainConexao, MainConexao);
  Application.Run;
end.
