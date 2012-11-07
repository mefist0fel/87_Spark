unit QEngine.Render;

interface

uses
  QuadEngine,
  QCore.Types,
  QEngine.Types,
  direct3d9;

type
  TQuadRender = class sealed (TBaseObject, IQuadRender)
    strict private
      FEngine: IQuadEngine;
      FRender: IQuadRender;
    public
      constructor Create(AEngine: IQuadEngine; ARender: IQuadRender);

      procedure CreateRenderTexture(AWidth, AHeight: Word;
        var AQuadTexture: IQuadTexture; ARegister: Byte); stdcall;
      function GetAvailableTextureMemory: Cardinal; stdcall;
      function GetMaxAnisotropy: Cardinal; stdcall;
      function GetMaxTextureHeight: Cardinal; stdcall;
      function GetMaxTextureStages: Cardinal; stdcall;
      function GetMaxTextureWidth: Cardinal; stdcall;
      function GetPixelShaderVersionString: PAnsiChar; stdcall;
      function GetPSVersionMajor: Byte; stdcall;
      function GetPSVersionMinor: Byte; stdcall;
      function GetRenderTexture(index: Integer): IDirect3DTexture9; stdcall;
      function GetVertexShaderVersionString: PAnsiChar; stdcall;
      function GetVSVersionMajor: Byte; stdcall;
      function GetVSVersionMinor: Byte; stdcall;
      procedure AddTrianglesToBuffer(const AVertexes: array of TVertex;
        ACount: Cardinal); stdcall;
      procedure BeginRender; stdcall;
      procedure ChangeResolution(AWidth, AHeight : Word); stdcall;
      procedure Clear(AColor: Cardinal); stdcall;
      procedure CreateOrthoMatrix; stdcall;
      procedure DrawDistort(x1, y1, x2, y2, x3, y3, x4, y4: Double;
        u1, v1, u2, v2: Double; Color: Cardinal); stdcall;
      procedure DrawRect(x, y, x2, y2: Double; u1, v1, u2, v2: Double;
        Color: Cardinal); stdcall;
      procedure DrawRectRot(x, y, x2, y2, ang, Scale: Double;
        u1, v1, u2, v2: Double; Color: Cardinal); stdcall;
      procedure DrawRectRotAxis(x, y, x2, y2, ang, Scale, xA, yA : Double;
        u1, v1, u2, v2: Double; Color: Cardinal); stdcall;
      procedure DrawLine(x, y, x2, y2 : Single; Color: Cardinal); stdcall;
      procedure DrawPoint(x, y : Single; Color : Cardinal); stdcall;
      procedure EndRender; stdcall;
      procedure Finalize; stdcall;
      procedure FlushBuffer; stdcall;
      procedure Initialize(AHandle: THandle; AWidth, AHeight: Integer;
        AIsFullscreen: Boolean; AIsCreateLog: Boolean = True); stdcall;
      procedure InitializeFromIni(AHandle: THandle; AFilename: PAnsiChar); stdcall;
      procedure Polygon(x1, y1, x2, y2, x3, y3, x4, y4: Double;
        Color: Cardinal); stdcall;
      procedure Rectangle(x, y, x2, y2: Double; Color: Cardinal); stdcall;
      procedure RectangleEx(x, y, x2, y2: Double;
        Color1, Color2, Color3, Color4: Cardinal); stdcall;
      procedure RenderToTexture(AIsRenderToTexture: Boolean;
        AQuadTexture: IQuadTexture; ARegister: Byte = 0;
        AIsCropScreen: Boolean = false); stdcall;
      procedure SetAutoCalculateTBN(Value: Boolean); stdcall;
      procedure SetBlendMode(qbm: TQuadBlendMode); stdcall;
      procedure SetClipRect(X, Y, X2, Y2: Cardinal); stdcall;
      procedure SetTexture(ARegister: Byte; ATexture: IDirect3DTexture9); stdcall;
      procedure SetTextureAdressing(ATextureAdressing: TD3DTextureAddress); stdcall;
      procedure SetTextureFiltering(ATextureFiltering: TD3DTextureFilterType); stdcall;
      procedure SetPointSize(ASize: Cardinal); stdcall;
      procedure SkipClipRect; stdcall;
      procedure ResetDevice; stdcall;
      function GetD3DDevice: IDirect3DDevice9; stdcall;
  end;

implementation

uses
  SysUtils,
  Strope.Math;

{$REGION '  TQuadRender  '}
constructor TQuadRender.Create(AEngine: IQuadEngine; ARender: IQuadRender);
begin
  if not Assigned(AEngine) then
    raise EArgumentException.Create(
      'Не указан экземпляр интерфейса IQuadEngine при инициализации объекта класса TQuadRender. ' +
      '{5B2EDB5D-5315-4A39-9A31-0FB22F6C746B}');

  if not Assigned(ARender) then
    raise EArgumentException.Create(
      'Не указан экземпляр интерфейса IQuadRender при инициализации объекта класса TQuadRender. ' +
      '{90B1BFC7-D0F6-44AC-83CE-AFCC7359572E}');

  FEngine := AEngine;
  FRender := ARender;
end;

procedure TQuadRender.CreateRenderTexture(
  AWidth: Word; AHeight: Word;
  var AQuadTexture: IQuadTexture; ARegister: Byte);
begin
  FRender.CreateRenderTexture(AWidth, AHeight, AQuadTexture, ARegister);
end;

function TQuadRender.GetAvailableTextureMemory: Cardinal;
begin
  Result := FRender.GetAvailableTextureMemory;
end;

function TQuadRender.GetMaxAnisotropy: Cardinal;
begin
  Result := FRender.GetMaxAnisotropy;
end;

function TQuadRender.GetMaxTextureHeight: Cardinal;
begin
  Result := FRender.GetMaxTextureHeight;
end;

function TQuadRender.GetMaxTextureStages: Cardinal;
begin
  Result := FRender.GetMaxTextureStages;
end;

function TQuadRender.GetMaxTextureWidth: Cardinal;
begin
  Result := FRender.GetMaxTextureWidth;
end;

function TQuadRender.GetPixelShaderVersionString: PAnsiChar;
begin
  Result := FRender.GetPixelShaderVersionString
end;

function TQuadRender.GetPSVersionMajor: Byte;
begin
  Result := FRender.GetPSVersionMajor;
end;

function TQuadRender.GetPSVersionMinor: Byte;
begin
  Result := FRender.GetPSVersionMinor;
end;

function TQuadRender.GetRenderTexture(index: Integer): IDirect3DTexture9;
begin
  Result := FRender.GetRenderTexture(index);
end;

function TQuadRender.GetVertexShaderVersionString: PAnsiChar;
begin
  Result := FRender.GetVertexShaderVersionString;
end;

function TQuadRender.GetVSVersionMajor: Byte;
begin
  Result := FRender.GetVSVersionMajor;
end;

function TQuadRender.GetVSVersionMinor: Byte;
begin
  Result := FRender.GetVSVersionMinor;
end;

procedure TQuadRender.AddTrianglesToBuffer(const AVertexes: array of TVertex;
  ACount: Cardinal);
begin
  FRender.AddTrianglesToBuffer(AVertexes, ACount);
end;

procedure TQuadRender.BeginRender;
begin
  FRender.BeginRender;
end;

procedure TQuadRender.ChangeResolution(AWidth, AHeight : Word);
begin
  FRender.ChangeResolution(AWidth, AHeight);
end;

procedure TQuadRender.Clear(AColor: Cardinal);
begin
  FRender.Clear(AColor);
end;

procedure TQuadRender.CreateOrthoMatrix;
begin
  FRender.CreateOrthoMatrix;
end;

procedure TQuadRender.DrawDistort(x1, y1, x2, y2, x3, y3, x4, y4: Double;
  u1, v1, u2, v2: Double; Color: Cardinal);
begin
  //
  FRender.DrawDistort(x1, y1, x2, y2, x3, y3, x4, y4, u1, v1, u2, v2, Color);
end;

procedure TQuadRender.DrawRect(x, y, x2, y2: Double; u1, v1, u2, v2: Double;
  Color: Cardinal);
begin
  //
  FRender.DrawRect(x, y, x2, y2, u1, v1, u2, v2, Color);
end;

procedure TQuadRender.DrawRectRot(x, y, x2, y2, ang, Scale: Double;
  u1, v1, u2, v2: Double; Color: Cardinal);
begin
  //
  FRender.DrawRectRot(x, y, x2, y2, ang, Scale, u1, v1, u2, v2, Color);
end;

procedure TQuadRender.DrawRectRotAxis(x, y, x2, y2, ang, Scale, xA, yA : Double;
  u1, v1, u2, v2: Double; Color: Cardinal);
begin
  //
  FRender.DrawRectRotAxis(x, y, x2, y2, ang, Scale, xA, yA, u1, v1, u2, v2, Color);
end;

procedure TQuadRender.DrawLine(x, y, x2, y2 : Single; Color: Cardinal);
var
  AScreenPosition1: TVectorF;
  AScreenPosition2: TVectorF;
begin
  AScreenPosition1.Create(x, y);
  AScreenPosition2.Create(x2, y2);
  if Assigned(FEngine.Camera) then
  begin
    AScreenPosition1 := FEngine.Camera.GetScreenPosition(AScreenPosition1);
    AScreenPosition2 := FEngine.Camera.GetScreenPosition(AScreenPosition2);
  end;
  FRender.DrawLine(
    AScreenPosition1.X, AScreenPosition1.Y,
    AScreenPosition2.X, AScreenPosition2.Y,
    Color);
end;

procedure TQuadRender.DrawPoint(x, y : Single; Color : Cardinal);
var
  AScreenPosition: TVectorF;
begin
  AScreenPosition.Create(x, y);
  if Assigned(FEngine.Camera) then
    AScreenPosition := FEngine.Camera.GetScreenPosition(AScreenPosition);
  FRender.DrawPoint(AScreenPosition.X, AScreenPosition.Y, Color);
end;

procedure TQuadRender.EndRender;
begin
  FRender.EndRender;
end;

procedure TQuadRender.Finalize;
begin
  FRender.Finalize;
end;

procedure TQuadRender.FlushBuffer;
begin
  FRender.FlushBuffer;
end;

procedure TQuadRender.Initialize(AHandle: THandle; AWidth, AHeight: Integer;
  AIsFullscreen: Boolean; AIsCreateLog: Boolean = True);
begin
  FRender.Initialize(AHandle, AWidth, AHeight, AIsFullscreen, AIsCreateLog);
end;

procedure TQuadRender.InitializeFromIni(AHandle: THandle; AFilename: PAnsiChar);
begin
  FRender.InitializeFromIni(AHandle, AFilename);
end;

procedure TQuadRender.Polygon(x1, y1, x2, y2, x3, y3, x4, y4: Double;
  Color: Cardinal);
var
  AScreenPosition1: TVectorF;
  AScreenPosition2: TVectorF;
  AScreenPosition3: TVectorF;
  AScreenPosition4: TVectorF;
begin
  AScreenPosition1.Create(x1, y1);
  AScreenPosition2.Create(x2, y2);
  AScreenPosition3.Create(x3, y3);
  AScreenPosition4.Create(x4, y4);
  if Assigned(FEngine.Camera) then
  begin
    AScreenPosition1 := FEngine.Camera.GetScreenPosition(AScreenPosition1);
    AScreenPosition2 := FEngine.Camera.GetScreenPosition(AScreenPosition2);
    AScreenPosition3 := FEngine.Camera.GetScreenPosition(AScreenPosition3);
    AScreenPosition4 := FEngine.Camera.GetScreenPosition(AScreenPosition4);
  end;
  FRender.Polygon(
    AScreenPosition1.X, AScreenPosition1.Y,
    AScreenPosition2.X, AScreenPosition2.Y,
    AScreenPosition3.X, AScreenPosition3.Y,
    AScreenPosition4.X, AScreenPosition4.Y,
    Color);
end;

procedure TQuadRender.Rectangle(x, y, x2, y2: Double; Color: Cardinal);
var
  AScreenPosition1: TVectorF;
  AScreenPosition2: TVectorF;
begin
  AScreenPosition1.Create(x, y);
  AScreenPosition2.Create(x2, y2);
  if Assigned(FEngine.Camera) then
  begin
    AScreenPosition1 := FEngine.Camera.GetScreenPosition(AScreenPosition1);
    AScreenPosition2 := FEngine.Camera.GetScreenPosition(AScreenPosition2);
  end;
  FRender.Rectangle(
    AScreenPosition1.X, AScreenPosition1.Y,
    AScreenPosition2.X, AScreenPosition2.Y,
    Color);
end;

procedure TQuadRender.RectangleEx(x, y, x2, y2: Double;
  Color1, Color2, Color3, Color4: Cardinal);
var
  AScreenPosition1: TVectorF;
  AScreenPosition2: TVectorF;
begin
  AScreenPosition1.Create(x, y);
  AScreenPosition2.Create(x2, y2);
  if Assigned(FEngine.Camera) then
  begin
    AScreenPosition1 := FEngine.Camera.GetScreenPosition(AScreenPosition1);
    AScreenPosition2 := FEngine.Camera.GetScreenPosition(AScreenPosition2);
  end;
  FRender.RectangleEx(
    AScreenPosition1.X, AScreenPosition1.Y,
    AScreenPosition2.X, AScreenPosition2.Y,
    Color1, Color2, Color3, Color4);
end;

procedure TQuadRender.RenderToTexture(AIsRenderToTexture: Boolean;
  AQuadTexture: IQuadTexture; ARegister: Byte = 0;
  AIsCropScreen: Boolean = false);
begin
  FRender.RenderToTexture(
    AIsRenderToTexture, AQuadTexture,
    ARegister, AIsCropScreen);
end;

procedure TQuadRender.SetAutoCalculateTBN(Value: Boolean);
begin
  FRender.SetAutoCalculateTBN(Value);
end;

procedure TQuadRender.SetBlendMode(qbm: TQuadBlendMode);
begin
  FRender.SetBlendMode(qbm);
end;

procedure TQuadRender.SetClipRect(X, Y, X2, Y2: Cardinal);
begin
  FRender.SetClipRect(X, Y, X2, Y2);
end;

procedure TQuadRender.SetTexture(ARegister: Byte; ATexture: IDirect3DTexture9);
begin
  FRender.SetTexture(ARegister, ATexture);
end;

procedure TQuadRender.SetTextureAdressing(ATextureAdressing: TD3DTextureAddress);
begin
  FRender.SetTextureAdressing(ATextureAdressing);
end;

procedure TQuadRender.SetTextureFiltering(ATextureFiltering: TD3DTextureFilterType);
begin
  FRender.SetTextureFiltering(ATextureFiltering);
end;

procedure TQuadRender.SetPointSize(ASize: Cardinal);
begin
  FRender.SetPointSize(ASize);
end;

procedure TQuadRender.SkipClipRect;
begin
  FRender.SkipClipRect;
end;

procedure TQuadRender.ResetDevice;
begin
  FRender.ResetDevice;
end;

function TQuadRender.GetD3DDevice: IDirect3DDevice9;
begin
  Result := FRender.GetD3DDevice;
end;

{$ENDREGION}

end.
