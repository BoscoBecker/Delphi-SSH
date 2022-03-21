unit SSHMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.WinXCtrls, System.IOUtils,
  System.Classes,JclSysUtils,ShellApi,Ssh2Client,libssh2,libssh2_sftp,SftpClient;

type
  TMainConexao = class(TForm)
    log: TMemo;
    info: TLabel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    btnIniciar: TButton;
    edthost: TEdit;
    edtPort: TEdit;
    loading: TActivityIndicator;
    edtusuario: TEdit;
    lblusuario: TLabel;
    Label4: TLabel;
    edtSenha: TEdit;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    listComandos: TEdit;
    btnComandos: TButton;
    procedure btnIniciarClick(Sender: TObject);
    procedure btnComandosClick(Sender: TObject);
  Strict private
    Session: ISshSession;
    SshExec: ISshExec;
  private
    Function GetDosOutput(CommandLine, Work: string): string;
    Function ExpandEnvStrings(const AString: String): String;
  public
    Function ExistsInKnowHost(const host: String): boolean;
    function ExecutarComando(Comando: string): TStringList;
    procedure AddRSAkeyTOKnowHost(const host: String);
  end;

var
  MainConexao: TMainConexao;

implementation

{$R *.dfm}

uses SocketUtils;

function TMainConexao.ExpandEnvStrings(const AString: String): String;
var
  bufsize: Integer;
begin
  bufsize := ExpandEnvironmentStrings(PChar(AString), nil, 0);
  SetLength(result, bufsize);
  ExpandEnvironmentStrings(PChar(AString), PChar(result), bufsize);
  result := TrimRight(result);
end;


procedure TMainConexao.AddRSAkeyTOKnowHost(const host: String);
begin
  var List:= TStringList.Create;
  Try
    var PathFIle:=
        ExpandEnvStrings(
          IncludeTrailingPathDelimiter('%USERPROFILE%') + '.ssh\known_hosts');
    if FileExists(PathFIle) then
    begin
      const pathcmd = 'C:\Users\DevDelphi\Desktop\Delphi SSH\Win32\Debug\GENERATE RSA KEY.txt';
      var EchoCommandtoGenerateRSA:  String;
      var command:= 'ssh-keyscan -t rsa ' + host;

      EchoCommandtoGenerateRSA:= command   +' > ' +PathFIle;
      var RSA:= GetDosOutput(EchoCommandtoGenerateRSA,'C:');
      //ssh-keyscan -t rsa 10.2.2.4 > C:\Users\DevDelphi\.ssh\known_hosts
      //'C:\Users\DevDelphi\Desktop\Delphi SSH\Win32\Debug\GENERATE RSA KEY.cmd'
      //Sleep(5000);
      //winexec(PAnsiChar(pathcmd),sw_normal);

//      var RSA:= GetDosOutput(command,'');
//      List.LoadFromFile(PathFIle);
//      List.Add(#13+#10);
//      List.Add(RSA);
    end;
  Finally
    FreeAndNil(List);
  End;

end;

procedure TMainConexao.btnIniciarClick(Sender: TObject);
begin
  loading.Animate:= True;
  btnIniciar.Caption:= 'Conectando ...';
  Try
    Log.Lines.Clear;
    Log.Lines.Add('Carregando informações de conexão SSH...');
    Session := CreateSession(edthost.Text,22);
    Log.Lines.Add('Criando sessão...');
    Application.ProcessMessages;
    Log.Lines.Add('Conectando...');
    Try
      loading.Repaint;

      if not ExistsInKnowHost(edthost.Text)then
      begin
        // Work on it >>   AddRSAkeyTOKnowHost(host.Text);
        info.Font.Color:= clRed;
        info.Caption:= ' É necessário gerar uma Key RSA. Comando "ssh-keyscan -t rsa seu host" ' +
          ' Arquivo HOST disponível em: ssh-keyscan -t rsa seu host > %USERPROFILE% + .ssh\known_hosts';
      end else
      Begin
        info.Font.Color:= clGreen;
        info.Caption:=' Conexão SSH Estabelecida com o HOST ' +edthost.Text;
      End;

      Session.Connect;

    Except
      On e : Exception do
      begin
        btnIniciar.Caption:= 'Iniciar conexão';
        log.Lines.Add(
          'Não foi possível estabelecer uma conexão SSH com o HOST: ' + edthost.Text +#13#10+#13#10+
          'Mensagem de Erro '+ E.Message+#13#10+#13#10+
          'Classe do Erro: ' + E.ClassName +#13#10+#13#10+
          'Unit da Classe ' + E.ClassType.UnitName);
      end;
    End;
    btnIniciar.Caption:= 'Conexão iniciada';

    btnComandos.Enabled:= True;
    listComandos.Enabled:= True;

    if not Session.UserAuthPass(edtusuario.Text, edtsenha.text) then
    begin
      Log.Lines.Add('Authorization Failure!!!');
    end;

    Log.Lines.Add('Conectado no host: ' + edthost.Text );
    loading.Repaint;
   Finally
    loading.Animate:= False;
  End;
end;


procedure TMainConexao.btnComandosClick(Sender: TObject);
begin
  var output: String;
  var ErrOutput: string;
  var ExitCode: Integer;

  SshExec:= CreateSshExec(session);
  SshExec.Exec(listComandos.Text, Output,  ErrOutput, ExitCode);
  Log.Lines.add('Command:' + listComandos.Text);
  Log.Lines.add('Output:');
  if Output <> '' then Log.Lines.add(Output);
  Log.Lines.add('Error Output:');
  if ErrOutput <> '' then Log.Lines.add(ErrOutput);
  Log.Lines.add('Exit Code:' + ExitCode.ToString);
  Log.Lines.add('All done!');
end;

function TMainConexao.ExecutarComando(Comando: string): TStringList;
var
 SE: TShellExecuteInfo;
 ExitCode: DWORD;
begin
 Result := TStringList.Create;
 FillChar(SE, SizeOf(SE), 0);
 SE.cbSize := SizeOf(TShellExecuteInfo);
 SE.fMask := SEE_MASK_NOCLOSEPROCESS;
 SE.Wnd := Application.Handle;
 SE.lpFile := 'cmd.exe';
 SE.lpParameters :=  pchar('/C' + Comando + ' > output.txt');
 SE.nShow := SW_HIDE;

 if ShellExecuteEx(@SE) then begin
   repeat
     Application.ProcessMessages;
     GetExitCodeProcess(SE.hProcess, ExitCode);
   until (ExitCode <> STILL_ACTIVE) or Application.Terminated;
     Result.LoadFromFile('output.txt');
 end else
     RaiseLastOSError;
end;

function TMainConexao.ExistsInKnowHost(const host: String): boolean;
begin
  Result:= False;
  var List:= TStringList.Create;
  Try
    var PathFIle:=
        ExpandEnvStrings(
          IncludeTrailingPathDelimiter('%USERPROFILE%') + '.ssh\known_hosts');
    if FileExists(PathFIle) then
    begin
      List.LoadFromFile(PathFIle);
      for var i := 0 to List.Count - 1 do
      begin
         if pos(host, List[i]) > 0 then
         Result:= True
      end;

    end;
  Finally
    FreeAndNil(List);
  End;
end;

function TMainConexao.GetDosOutput(CommandLine, Work: string): string;
var SA: TSecurityAttributes;
    SI: TStartupInfo;
    PI: TProcessInformation;
    StdOutPipeRead, StdOutPipeWrite: THandle;
    WasOK: Boolean;
    Buffer: array[0..2048] of AnsiChar;
    BytesRead: Cardinal;
    WorkDir: string;
    Handle: Boolean;
begin
  Result := '';
  with SA do
    begin
      nLength := SizeOf(SA);
      bInheritHandle := True;
      lpSecurityDescriptor := nil;
    end;
  CreatePipe(StdOutPipeRead, StdOutPipeWrite, @SA, 0);
  try
    with SI do
      begin
        FillChar(SI, SizeOf(SI), 0);
        cb := SizeOf(SI);
        dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
        wShowWindow := SW_HIDE;
        hStdInput := GetStdHandle(STD_INPUT_HANDLE); // don't redirect stdin
        hStdOutput := StdOutPipeWrite;
        hStdError := StdOutPipeWrite;
      end;
    WorkDir := Work;
    Handle := CreateProcess(nil, PChar('cmd.exe  ' + CommandLine), nil, nil, True, 0, nil, PChar(WorkDir), SI, PI);
    CloseHandle(StdOutPipeWrite);
    if Handle then
      try
        repeat
          WasOK := ReadFile(StdOutPipeRead, Buffer, 2048, BytesRead, nil);
          if BytesRead > 0 then
            begin
              Buffer[BytesRead] := #0;
              Result := Result + Buffer;
            end;
        until not WasOK or (BytesRead = 0);
        WaitForSingleObject(PI.hProcess, INFINITE);
      finally
        CloseHandle(PI.hThread);
        CloseHandle(PI.hProcess);
      end;
  finally
    CloseHandle(StdOutPipeRead);

  end;
end;

end.
