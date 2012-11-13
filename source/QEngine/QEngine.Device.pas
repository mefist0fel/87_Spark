unit QEngine.Device;

interface

uses
  Generics.Collections,
  Windows,
  QuadEngine,
  QCore.Types,
  QEngine.Types,
  Strope.Math;

type
  TQuadDevice = class sealed (TBaseObject, IQuadDevice)
    strict private
      FEngine: IQuadEngine;
      FDevice: IQuadDevice;

      function GetIsResolutionSupported(AWidth, AHeight: Word): Boolean; stdcall;
      procedure GetSupportedScreenResolution(index: Integer;
        out Resolution: TCoord); stdcall;
    public
      constructor Create(AEngine: IQuadEngine);

      function CreateAndLoadFont(AFontTextureFilename, AUVFilename: PAnsiChar;
        out pQuadFont: IQuadFont): HResult; stdcall;
      function CreateAndLoadTexture(ARegister: Byte; AFilename: PAnsiChar;
        out pQuadTexture: IQuadTexture;
        APatternWidth: Integer = 0;
        APatternHeight: Integer = 0;
        AColorKey : Integer = -1): HResult; stdcall;
      function CreateFont(out pQuadFont: IQuadFont): HResult; stdcall;
      function CreateShader(out pQuadShader: IQuadShader): HResult; stdcall;
      function CreateTexture(out pQuadTexture: IQuadTexture): HResult; stdcall;
      function CreateTimer(out pQuadTimer: IQuadTimer): HResult; stdcall;
      function CreateRender(out pQuadRender: IQuadRender): HResult; stdcall;
      function GetLastError: PAnsiChar; stdcall;
      function GetMonitorsCount: Byte; stdcall;
      procedure SetActiveMonitor(AMonitorIndex: Byte); stdcall;
      procedure SetOnErrorCallBack(Proc: TOnErrorFunction); stdcall;

      function GetResolutionsList(): TList<TVectorI>;

      property Device: IQuadDevice read FDevice;
  end;

implementation

uses
  SysUtils,
  QEngine.Render,
  QEngine.Texture,
  QEngine.Font;

{$REGION '  TQuadDevice  '}
constructor TQuadDevice.Create(AEngine: IQuadEngine);
begin
  if not Assigned(AEngine) then
    raise EArgumentException.Create(
      'Не указан экземпляр интерфейса IQuadEngine при инициализации объекта класса TQuadDevice. ' +
      '{05E1C3BB-47BE-43B4-87E7-E93A6D14CB84}');

  FEngine := AEngine;
  FDevice := CreateQuadDevice;
end;

function TQuadDevice.CreateAndLoadFont(
  AFontTextureFilename: PAnsiChar;
  AUVFilename: PAnsiChar;
  out pQuadFont: IQuadFont): HRESULT;
var
  AFont: IQuadFont;
begin
  Result := FDevice.CreateAndLoadFont(
    AFontTextureFilename,
    AUVFilename,
    AFont);
  pQuadFont := TQuadFont.Create(FEngine, AFont);
end;

function TQuadDevice.CreateAndLoadTexture(
  ARegister: Byte;
  AFilename: PAnsiChar;
  out pQuadTexture: IQuadTexture;
  APatternWidth: Integer = 0;
  APatternHeight: Integer = 0;
  AColorKey: Integer = -1): HRESULT;
var
  ATexture: IQuadTexture;
begin
  Result := FDevice.CreateAndLoadTexture(
    ARegister,
    AFilename,
    ATexture,
    APatternWidth,
    APatternHeight,
    AColorKey);
  pQuadTexture := TQuadTexture.Create(FEngine, ATexture);
end;

function TQuadDevice.CreateFont(out pQuadFont: IQuadFont): HRESULT;
var
  AFont: IQuadFont;
begin
  Result := FDevice.CreateFont(AFont);
  pQuadFont := TQuadFont.Create(FEngine, AFont);
end;

function TQuadDevice.CreateShader(out pQuadShader: IQuadShader): HRESULT;
begin
  Result := FDevice.CreateShader(pQuadShader);
end;

function TQuadDevice.CreateTexture(out pQuadTexture: IQuadTexture): HRESULT;
var
  ATexture: IQuadTexture;
begin
  Result := FDevice.CreateTexture(ATexture);
  pQuadTexture := TQuadTexture.Create(FEngine, ATexture);
end;

function TQuadDevice.CreateTimer(out pQuadTimer: IQuadTimer): HRESULT;
begin
  Result := FDevice.CreateTimer(pQuadTimer);
end;

function TQuadDevice.CreateRender(out pQuadRender: IQuadRender): HRESULT;
var
  ARender: IQuadRender;
begin
  Result := FDevice.CreateRender(ARender);
  pQuadRender := TQuadRender.Create(FEngine, ARender);
end;

function TQuadDevice.GetIsResolutionSupported(AWidth, AHeight: Word): Boolean;
begin
  Result := FDevice.GetIsResolutionSupported(AWidth, AHeight);
end;

function TQuadDevice.GetLastError;
begin
  Result := FDevice.GetLastError;
end;

function TQuadDevice.GetMonitorsCount;
begin
  Result := FDevice.GetMonitorsCount;
end;

function TQuadDevice.GetResolutionsList: TList<TVectorI>;
var
  AResolution: TCoord;
  AIndex: Integer;
begin
  Result := TList<TVectorI>.Create;
  AIndex := 0;
  while True do
  begin
    FDevice.GetSupportedScreenResolution(AIndex, AResolution);
    if AResolution.X <> -1 then
      Result.Add(Vec2I(AResolution.X, AResolution.Y))
    else
      Break;
    Inc(AIndex);
  end;
end;

procedure TQuadDevice.GetSupportedScreenResolution(
  index: Integer; out Resolution: TCoord);
begin
  FDevice.GetSupportedScreenResolution(index, Resolution);
end;

procedure TQuadDevice.SetActiveMonitor(AMonitorIndex: Byte);
begin
  FDevice.SetActiveMonitor(AMonitorIndex);
end;

procedure TQuadDevice.SetOnErrorCallBack(Proc: TOnErrorFunction);
begin
  FDevice.SetOnErrorCallBack(Proc);
end;
{$ENDREGION}

end.
