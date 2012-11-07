{==============================================================================

  Quad engine 0.4.0 header file for CodeGear™ Delphi®

     ╔═══════════╦═╗
     ║           ║ ║
     ║           ║ ║
     ║ ╔╗ ║║ ╔╗ ╔╣ ║
     ║ ╚╣ ╚╝ ╚╩ ╚╝ ║
     ║  ║ engine   ║
     ║  ║          ║
     ╚══╩══════════╝

  For further information please visit:
  http://quad-engine.com

==============================================================================}

unit QuadEngine;

interface

uses
  Windows, Direct3D9;

const
  LibraryName: PChar = 'qei.dll';
  CreateQuadDeviceProcName: PChar = 'CreateQuadDevice';
  CreateQuadWindowProcName: PChar = 'CreateQuadWindow';
  SecretMagicFunctionProcName: PChar = 'SecretMagicFunction';

type
  // Blending mode types
  TQuadBlendMode = (qbmNone           = 0,     { Without blending }
                    qbmAdd            = 1,     { Add source to dest }
                    qbmSrcAlpha       = 2,     { Blend dest with alpha to source }
                    qbmSrcAlphaAdd    = 3,     { Add source with alpha to dest }
                    qbmSrcAlphaMul    = 4,     { Multiply source alpha with dest }
                    qbmMul            = 5,     { Multiply Source with dest }
                    qbmSrcColor       = 6,     { Blend source with color weight to dest }
                    qbmSrcColorAdd    = 7,     { Blend source with color weight and alpha to dest }
                    qbmInvertSrcColor = 8);

  // Vector record declaration
  TVector = packed record
    x: Single;
    y: Single;
    z: Single;
  end;

  // vertex record declaration
  TVertex = packed record
    x, y, z : Single;         { X, Y of vertex. Z not used }
    normal  : TVector;        { Normal vector }
    color   : Cardinal;       { Color }
    u, v    : Single;         { Texture UV coord }
    tangent : TVector;        { Tangent vector }
    binormal: TVector;        { Binormal vector }
  end;

  // forward interfaces declaration
  IQuadDevice  = interface;
  IQuadRender  = interface;
  IQuadTexture = interface;
  IQuadShader  = interface;
  IQuadFont    = interface;
  IQuadLog     = interface;
  IQuadTimer   = interface;
  IQuadWindow  = interface;

  { Quad Render }

  // OnError routine. Calls whenever error occurs
  TOnErrorFunction = procedure(Errorstring: PAnsiChar); stdcall;

  IQuadDevice = interface(IUnknown)
    ['{E28626FF-738F-43B0-924C-1AFC7DEC26C7}']
    function CreateAndLoadFont(AFontTextureFilename, AUVFilename: PAnsiChar; out pQuadFont: IQuadFont): HResult; stdcall;
    function CreateAndLoadTexture(ARegister: Byte; AFilename: PAnsiChar; out pQuadTexture: IQuadTexture;
      APatternWidth: Integer = 0; APatternHeight: Integer = 0; AColorKey : Integer = -1): HResult; stdcall;
    function CreateFont(out pQuadFont: IQuadFont): HResult; stdcall;
    function CreateShader(out pQuadShader: IQuadShader): HResult; stdcall;
    function CreateTexture(out pQuadTexture: IQuadTexture): HResult; stdcall;
    function CreateTimer(out pQuadTimer: IQuadTimer): HResult; stdcall;
    function CreateRender(out pQuadRender: IQuadRender): HResult; stdcall;    
    function GetIsResolutionSupported(AWidth, AHeight: Word): Boolean; stdcall;
    function GetLastError: PAnsiChar; stdcall;
    function GetMonitorsCount: Byte; stdcall;
    procedure GetSupportedScreenResolution(index: Integer; out Resolution: TCoord); stdcall;
    procedure SetActiveMonitor(AMonitorIndex: Byte); stdcall;
    procedure SetOnErrorCallBack(Proc: TOnErrorFunction); stdcall;
  end;

  IQuadRender = interface(IUnknown)
    ['{D9E9C42B-E737-4CF9-A92F-F0AE483BA39B}']
    procedure CreateRenderTexture(AWidth, AHeight: Word; var AQuadTexture: IQuadTexture; ARegister: Byte); stdcall;
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
    procedure AddTrianglesToBuffer(const AVertexes: array of TVertex; ACount: Cardinal); stdcall;
    procedure BeginRender; stdcall;
    procedure ChangeResolution(AWidth, AHeight : Word); stdcall;
    procedure Clear(AColor: Cardinal); stdcall;
    procedure CreateOrthoMatrix; stdcall;
    procedure DrawDistort(x1, y1, x2, y2, x3, y3, x4, y4: Double; u1, v1, u2, v2: Double; Color: Cardinal); stdcall;
    procedure DrawRect(x, y, x2, y2: Double; u1, v1, u2, v2: Double; Color: Cardinal); stdcall;
    procedure DrawRectRot(x, y, x2, y2, ang, Scale: Double; u1, v1, u2, v2: Double; Color: Cardinal); stdcall;
    procedure DrawRectRotAxis(x, y, x2, y2, ang, Scale, xA, yA : Double; u1, v1, u2, v2: Double; Color: Cardinal); stdcall;
    procedure DrawLine(x, y, x2, y2 : Single; Color: Cardinal); stdcall;
    procedure DrawPoint(x, y : Single; Color : Cardinal); stdcall;
    procedure EndRender; stdcall;
    procedure Finalize; stdcall;
    procedure FlushBuffer; stdcall;
    procedure Initialize(AHandle: THandle; AWidth, AHeight: Integer;
      AIsFullscreen: Boolean; AIsCreateLog: Boolean = True); stdcall;
    procedure InitializeFromIni(AHandle: THandle; AFilename: PAnsiChar); stdcall;
    procedure Polygon(x1, y1, x2, y2, x3, y3, x4, y4: Double; Color: Cardinal); stdcall;
    procedure Rectangle(x, y, x2, y2: Double; Color: Cardinal); stdcall;
    procedure RectangleEx(x, y, x2, y2: Double; Color1, Color2, Color3, Color4: Cardinal); stdcall;
    procedure RenderToTexture(AIsRenderToTexture: Boolean; AQuadTexture: IQuadTexture; ARegister: Byte = 0; AIsCropScreen: Boolean = false); stdcall;
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

  { Quad Texture }

  IQuadTexture = interface(IUnknown)
    ['{9A617F86-2CEC-4701-BF33-7F4989031BBA}']
    function GetIsLoaded: Boolean; stdcall;
    function GetPatternCount: Integer; stdcall;
    function GetPatternHeight: Word; stdcall;
    function GetPatternWidth: Word; stdcall;
    function GetSpriteHeight: Word; stdcall;
    function GetSpriteWidth: Word; stdcall;
    function GetTexture(i: Byte): IDirect3DTexture9; stdcall;
    function GetTextureHeight: Word; stdcall;
    function GetTextureWidth: Word; stdcall;
    procedure AddTexture(ARegister: Byte; ATexture: IDirect3DTexture9); stdcall;
    procedure Draw(x, y: Double; Color: Cardinal = $FFFFFFFF); stdcall;
    procedure DrawFrame(x, y: Double; Pattern: Word; Color: Cardinal = $FFFFFFFF); stdcall;
    procedure DrawDistort(x1, y1, x2, y2, x3, y3, x4, y4: Double; Color: Cardinal = $FFFFFFFF); stdcall;
    procedure DrawMap(x, y, x2, y2, u1, v1, u2, v2: Double; Color: Cardinal = $FFFFFFFF); stdcall;
    procedure DrawMapRotAxis(x, y, x2, y2, u1, v1, u2, v2, xA, yA, angle, Scale: Double; Color: Cardinal = $FFFFFFFF); stdcall;
    procedure DrawRot(x, y, angle, Scale: Double; Color: Cardinal = $FFFFFFFF); stdcall;
    procedure DrawRotFrame(x, y, angle, Scale: Double; Pattern: Word; Color: Cardinal = $FFFFFFFF); stdcall;
    procedure DrawRotAxis(x, y, angle, Scale, xA, yA: Double; Color: Cardinal = $FFFFFFFF); stdcall;
    procedure DrawRotAxisFrame(x, y, angle, Scale, xA, yA: Double; Pattern: Word; Color: Cardinal = $FFFFFFFF); stdcall;
    procedure LoadFromFile(ARegister: Byte; AFilename: PAnsiChar; APatternWidth: Integer = 0;
      APatternHeight: Integer = 0; AColorKey: Integer = -1); stdcall;
    procedure LoadFromRAW(ARegister: Byte; AData: Pointer; AWidth, AHeight: Integer); stdcall;
    procedure SetIsLoaded(AWidth, AHeight: Word); stdcall;
  end;

  { Quad Shader }

  IQuadShader = interface(IUnknown)
    ['{7B7F4B1C-7F05-4BC2-8C11-A99696946073}']
    procedure BindVariableToVS(ARegister: Byte; AVariable: Pointer; ASize: Byte); stdcall;
    procedure BindVariableToPS(ARegister: Byte; AVariable: Pointer; ASize: Byte); stdcall;
    function GetVertexShader(out Shader: IDirect3DVertexShader9): HResult; stdcall;
    function GetPixelShader(out Shader: IDirect3DPixelShader9): HResult; stdcall;
    procedure LoadVertexShader(AVertexShaderFilename: PAnsiChar); stdcall;
    procedure LoadPixelShader(APixelShaderFilename: PAnsiChar); stdcall;
    procedure LoadComplexShader(AVertexShaderFilename, APixelShaderFilename: PAnsiChar); stdcall;
    procedure SetShaderState(AIsEnabled: Boolean); stdcall;
  end;

  { Quad Font }


  { Predefined colors for SmartColoring:
      W - white
      Z - black (zero)
      R - red
      L - lime
      B - blue
      M - maroon
      G - green
      N - Navy
      Y - yellow
      F - fuchsia
      A - aqua
      O - olive
      P - purple
      T - teal
      D - gray (dark)
      S - silver

      ! - default DrawText color
    ** Do not override "!" char **  }

  // font alignments
  TqfAlign = (qfaLeft    = 0,      { Align by left }
              qfaRight   = 1,      { Align by right }
              qfaCenter  = 2,      { Align by center }
              qfaJustify = 3);     { Align by both sides}

  IQuadFont = interface(IUnknown)
    ['{A47417BA-27C2-4DE0-97A9-CAE546FABFBA}']
    function GetIsLoaded: Boolean; stdcall;
    function GetKerning: Single; stdcall;
    procedure LoadFromFile(ATextureFilename, AUVFilename : PAnsiChar); stdcall;
    procedure SetSmartColor(AColorChar: AnsiChar; AColor: Cardinal); stdcall;
    procedure SetIsSmartColoring(Value: Boolean); stdcall;
    procedure SetKerning(AValue: Single); stdcall;
    function TextHeight(AText: PAnsiChar; AScale: Single = 1.0): Single; stdcall;
    function TextWidth(AText: PAnsiChar; AScale: Single = 1.0): Single; stdcall;
    procedure TextOut(x, y, scale: Single; AText: PAnsiChar; Color: Cardinal = $FFFFFFFF); stdcall;
    procedure TextOutAligned(x, y, scale: Single; AText: PAnsiChar; Color: Cardinal = $FFFFFFFF; Align: TqfAlign = qfaLeft); stdcall;
    procedure TextOutCentered(x, y, scale: Single; AText: PAnsiChar; Color: Cardinal = $FFFFFFFF); stdcall;
  end;

  {Quad Log}

  IQuadLog = interface(IUnknown)
    ['{7A4CE319-C7AF-4BF3-9218-C2A744F915E6}']
    procedure Write(const aString: string); stdcall;
  end;

  {Quad Timer}

  TTimerProcedure = procedure(out delta: Double); stdcall;
  { template:
    procedure OnTimer(out delta: Double); stdcall;
    begin

    end;
  }
  IQuadTimer = interface(IUnknown)
    ['{EA3BD116-01BF-4E12-B504-07D5E3F3AD35}']
    function GetCPUload: Single; stdcall;
    function GetDelta: Double; stdcall;
    function GetFPS: Single; stdcall;
    function GetWholeTime: Double; stdcall;
    procedure ResetWholeTimeCounter; stdcall;
    procedure SetCallBack(AProc: TTimerProcedure); stdcall;
    procedure SetInterval(AInterval: Word); stdcall;
    procedure SetState(AIsEnabled: Boolean); stdcall;
  end;

  {Quad Sprite}     {not implemented yet. do not use}

  IQuadSprite = interface(IUnknown)
  ['{3E6AF547-AB0B-42ED-A40E-8DC10FC6C45F}']
    procedure Draw; stdcall;
    procedure SetPosition(X, Y: Double); stdcall;
    procedure SetVelocity(X, Y: Double); stdcall;
  end;

  {Quad Window}     {not implemented yet. do not use}
  IQuadWindow = interface(IUnknown)
  ['{E8691EB1-4C5D-4565-8B78-3FC7C620DFFB}']
    function GetHandle: Cardinal; stdcall;
    procedure SetPosition(ATop, ALeft: Integer); stdcall;
    procedure SetDimentions(AWidth, AHeight: Integer); stdcall;
    procedure CreateWindow; stdcall;
  end;

  TCreateQuadDevice    = function(out QuadDevice: IQuadDevice): HResult; stdcall;
  TCreateQuadWindow    = function(out QuadWindow: IQuadWindow): HResult; stdcall;
  TSecretMagicFunction = function: PAnsiChar;

  function CreateQuadDevice: IQuadDevice;
  function CreateWindow: IQuadWindow;

implementation

// Creating of main Quad interface object
function CreateQuadDevice: IQuadDevice;
var
  h: THandle;
  Creator: TCreateQuadDevice;
begin
  h := LoadLibrary(LibraryName);
  Creator := GetProcAddress(h, CreateQuadDeviceProcName);
  if Assigned(Creator) then
    Creator(Result);
end;

// Creating of Quad window interface object
function CreateWindow: IQuadWindow;
var
  h: THandle;
  Creator: TCreateQuadWindow;
begin
  h := LoadLibrary(LibraryName);
  Creator := GetProcAddress(h, CreateQuadWindowProcName);
  if Assigned(Creator) then
    Creator(Result);
end;

end.
