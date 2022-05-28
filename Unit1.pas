unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, shellapi, ComCtrls, ExtCtrls, MMSystem, Unit2;

type
  TForm1 = class(TForm)
    Image2: TImage;
    Image1: TImage;
    Image3: TImage;
    Timer1: TTimer;
    Label1: TLabel;
    procedure registrarOCX (fichero : string);
    procedure Image1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    registrados,noRegistrados: integer;
    mpath:string;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
{$R 'thorkesin.res' 'thorkesin.rc'}

procedure msgP(owner: HWND; p_texto, p_titulo :string);
var
  flags : uint;
  MsgPars: TMsgBoxParams;
begin
  flags := MB_USERICON or MB_OK or MB_DEFBUTTON1 or MB_TASKMODAL;

  //Establecemos los parámetros
  with MsgPars do
  begin
    cbSize := SizeOf(MsgPars);
    hwndOwner := owner;
    hInstance := Sysinit.hInstance;
    lpszText := PChar(p_texto);
    lpszCaption := pchar(p_titulo );
    dwStyle := flags;
    lpszIcon := 'ICONO2.bmp';
    dwContextHelpId := 0;
    lpfnMsgBoxCallback := nil;
    dwLanguageId := LANG_NEUTRAL;
  end;

  MessageBoxIndirect(MsgPars);

end;

function IsWin64: Boolean;
var
  IsWow64Process : function(hProcess : THandle; var Wow64Process : BOOL): BOOL; stdcall;
  Wow64Process : BOOL;
begin
  Result := False;
  IsWow64Process := GetProcAddress(GetModuleHandle(Kernel32), 'IsWow64Process');
  if Assigned(IsWow64Process) then begin
    if IsWow64Process(GetCurrentProcess, Wow64Process) then begin
      Result := Wow64Process;
    end;
  end;
end;

function ExecAndWait(const ExecuteFile, ParamString : string): boolean;
var
  SEInfo: TShellExecuteInfo;
  ExitCode: DWORD;
begin
  FillChar(SEInfo, SizeOf(SEInfo), 0);
  SEInfo.cbSize := SizeOf(TShellExecuteInfo);
  with SEInfo do begin
    fMask := SEE_MASK_NOCLOSEPROCESS;
    Wnd := Application.Handle;
    lpFile := PChar(ExecuteFile);
    lpParameters := PChar(ParamString);
    nShow := SW_HIDE;
  end;
  if ShellExecuteEx(@SEInfo) then
  begin
    repeat
      Application.ProcessMessages;
      GetExitCodeProcess(SEInfo.hProcess, ExitCode);
    until (ExitCode <> STILL_ACTIVE) or Application.Terminated;
    Result:=True;
  end
  else Result:=False;
end;

procedure TForm1.registrarOCX (fichero : string);
type
  TRegFunc = function : HResult; stdcall;
var
  ARegFunc : TRegFunc;
  aHandle  : THandle;
begin
  try
    aHandle := LoadLibrary(PChar(fichero));
    if aHandle <> 0 then
    begin
      ARegFunc := GetProcAddress(aHandle,'DllRegisterServer');
      if Assigned(ARegFunc) then
      begin
        ExecAndWait('regsvr32', '/s ' + fichero);

      end;
      FreeLibrary(aHandle);
    end;

    registrados := registrados + 1;

  except

    noRegistrados := noRegistrados + 1;

  end;
end;

function MoveDir(SrcDir, DstDir: string): Boolean;
var
  FOS: TSHFileOpStruct;
begin
  ZeroMemory(@FOS, SizeOf(FOS));
  with FOS do
  begin
    wFunc  := FO_MOVE;
    fFlags := FOF_FILESONLY or
      FOF_ALLOWUNDO or FOF_SIMPLEPROGRESS;
    pFrom  := PChar(SrcDir + #0);
    pTo    := PChar(DstDir + #0);
  end;
  Result := (SHFileOperation(FOS) = 0);
end;

procedure moveFileThorkes(orig, mlib:string);
var path:string;
begin

        if IsWin64 then
        begin
              path:='C:\Windows\SysWOW64\' + mlib;
              if not FileExists(path) then MoveDir(orig,'C:\Windows\SysWOW64');

              path:=ExtractFilePath((ParamStr(0))) + 'Libs\Libs\' + mlib;

              if not FileExists(path) then MoveDir(path,'C:\Windows\System32');

        end
        else
              path:='C:\Windows\System32' + mlib;
              if not FileExists(path) then MoveDir(orig,'C:\Windows\System32');
        begin

        end

end;

procedure TForm1.Image1Click(Sender: TObject);
var
        path:string;
        fPath:string;
        i:integer;
const
        libs:array[1..9] of string = ('capicom.dll','dx8vb.dll','MSINET.OCX','MSVBVM60.DLL','OLEAUT32.DLL','OLEPRO32.DLL','RICHTX32.OCX','VBALPROGBAR6.OCX','ZLIB.DLL');
        fenix:string = 'FenixAO.exe';

begin

        Image1.enabled:=false;

        sndPlaySound(pchar(mpath + 'Wav\click.wav'), SND_ASYNC);

        Label1.Visible:=true;
        Label1.Caption:='Cargando librerías...';

        fPath:= mpath + fenix;

        if FileExists(fPath) then
        begin

        for i:=1 to 9 do

                begin
                        path:=mpath + 'Libs\' + libs[i];

                        moveFileThorkes(path,libs[i]);

                        if FileExists(path) then
                                begin
                                        registrarOCX(libs[i]);
                                end
                        else
                                begin
                                      Label1.caption:='No se encontró el archivo: ' + libs[i];
                                end

                end;

                WinExec(pchar(fPath),SW_SHOWNORMAL);
                Application.Terminate;

        end
        else
        begin
              Application.MessageBox('No se encontró el aplicativo del juego','FenixAO',0);
        end

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
        mpath:=ExtractFilePath((ParamStr(0)));
        Image2.Picture.LoadFromFile(pchar(mpath + 'Graficos\Interfaces\Interface\launcher.bmp'));
        sndPlaySound(pchar(mpath + 'Wav\launcher.wav'), SND_ASYNC);
end;

procedure TForm1.Image3Click(Sender: TObject);
begin
        sndPlaySound(pchar(mpath + 'Wav\click.wav'), SND_NODEFAULT);
        Application.Terminate;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
        if (Form1.AlphaBlendValue<255) then
                begin
                        Form1.AlphaBlendValue:=Form1.AlphaBlendValue+1;
                end
        else
                begin
                        Timer1.enabled:=false;
                end
end;

end.
