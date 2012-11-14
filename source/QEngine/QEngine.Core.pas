unit QEngine.Core;

interface

uses
  QuadEngine,
  QCore.Types,
  QEngine.Types,
  QEngine.Device,
  QEngine.Render,
  QEngine.Camera,
  QEngine.Texture,
  QEngine.Font,
  Strope.Math;

type
  TQuadEngine = class sealed (TBaseObject, IQuadEngine)
    strict private
      FDefaultResolution: TVectorI;
      FCurrentResolution: TVectorI;

      FQuadDevice: TQuadDevice;
      FQuadRender: TQuadRender;
      FCamera: IQuadCamera;

      function GetDevice(): IQuadDevice;
      function GetRender(): IQuadRender;

      function GetCamera(): IQuadCamera;
      procedure SetCamera(const ACamera: IQuadCamera);

      function GetDefaultResolution(): TVectorI;
      function GetCurrentResolution(): TVectorI;
    private
      constructor Create(const ADefaultResolution, ACurrentResolution: TVector2I);
    public
      destructor Destroy; override;

      function CreateCamera(): IQuadCamera;
      function CreateTexture(): TQuadTexture;
      function CreateFont(): TQuadFont;

      property QuadDevice: IQuadDevice read GetDevice;
      property QuadDeviceEx: TQuadDevice read FQuadDevice;
      property QuadRender: IQuadRender read GetRender;
      property QyadRenderEx: TQuadRender read FQuadRender;
      ///<summary>Камера, которую учитывает движок при отрисовке.</summary>
      property Camera: IQuadCamera read GetCamera write SetCamera;
      ///<summary>Размер экрана по-умолчанию, к которому корректирует
      /// размеры и позиции текущая камера.</summary>
      property DefaultResolution: TVectorI read GetDefaultResolution;
      ///<summary>Текущий размер экрана.</summary>
      property CurrentResolution: TVectorI read GetCurrentResolution;
  end;

var
  TheEngine: TQuadEngine = nil;
  TheDevice: IQuadDevice = nil;
  TheRender: IQuadRender = nil;

procedure CreateEngine(const ADefaultResolution, ACurrentResolution: TVector2I);

implementation

uses
  SysUtils,
  Math;

type
  TQuadCamera = class sealed (TBaseObject, IQuadCamera)
    strict private
      FCurrentResolution: TVectorF;
      FDefaultResolution: TVectorF;
      FHalfDScreen: TVectorF;
      FHalfCScreen: TVectorF;

      FUseCorrection: Boolean;
      FCorrectionShift: TVectorF;
      FCorrectionScale: TVectorF;

      FPosition: TVectorF;
      FScale: TVectorF;

      function DSP2CSP(const APos: TVectorF): TVectorF;
      function CSP2DSP(const APos: TVectorF): TVectorF;
      function WP2DSP(const APos: TVectorF): TVectorF;
      function DSP2WP(const APos: TVectorF): TVectorF;
      function WP2CSP(const APos: TVectorF): TVectorF;
      function CSP2WP(const APos: TVectorF): TVectorF;

      function DSS2CSS(const ASize: TVectorF): TVectorF;
      function CSS2DSS(const ASize: TVectorF): TVectorF;
      function WS2CSS(const ASize: TVectorF): TVectorF;
      function CSS2WS(const ASize: TVectorF): TVectorF;
      function WS2DSS(const ASize: TVectorF): TVectorF;
      function DSS2WS(const ASize: TVectorF): TVectorF;

      function GetPosition(): TVectorF;
      procedure SetPosition(const APosition: TVectorF);

      function GetScale(): TVectorF;
      procedure SetScale(const AScale: TVectorF);

      function GetUseCorrection(): Boolean;
      procedure SetUseCorrection(AUseCorrection: Boolean);

      function GetResolution(): TVectorF;
      function GetDefaultResolution(): TVectorF;

      function GetScreenPos(const APosition: TVectorF;
        AIsUseCorrection: Boolean = True): TVectorF; overload;
      function GetScreenPos(X, Y: Single;
        AIsUseCorrection: Boolean = True): TVectorF; overload;
      function GetScreenSize(const ASize: TVectorF;
        AIsUseCorrection: Boolean = True): TVectorF; overload;
      function GetScreenSize(Width, Height: Single;
        AIsUseCorrection: Boolean = True): TVectorF; overload;
      function GetWorldPos(const APosition: TVectorF;
        AIsUseCorrection: Boolean = True): TVectorF; overload;
      function GetWorldPos(X, Y: Single;
        AIsUseCorrection: Boolean = True): TVectorF; overload;
      function GetWorldSize(const ASize: TVectorF;
        AIsUseCorrection: Boolean = True): TVectorF; overload;
      function GetWorldSize(Width, Height: Single;
        AIsUseCorrection: Boolean = True): TVectorF; overload;
    public
      constructor Create(const ADefaultResolution, ACurrentResolution: TVectorI);

      property Position: TVectorF read GetPosition write SetPosition;
      property Scale: TVectorF read GetScale write SetScale;
      property UseCorrection: Boolean read GetUseCorrection write SetUseCorrection;
      property Resolution: TVectorF read GetResolution;
      property DefaultResolution: TVectorF read GetDefaultResolution;
  end;

procedure CreateEngine(const ADefaultResolution, ACurrentResolution: TVector2I);
begin
  if not Assigned(TheEngine) then
    TheEngine :=  TQuadEngine.Create(ADefaultResolution, ACurrentResolution);
end;

{$REGION '  TQuadCamera  '}
constructor TQuadCamera.Create(const ADefaultResolution, ACurrentResolution: TVector2I);
var
  AValue: Single;
begin
  FCurrentResolution := ACurrentResolution;
  FDefaultResolution := ADefaultResolution;
  FHalfDScreen := FDefaultResolution * 0.5;
  FHalfCScreen := FCurrentResolution * 0.5;

  FCorrectionScale := FCurrentResolution.ComponentwiseDivide(FDefaultResolution);
  if FCorrectionScale.X > FCorrectionScale.Y then
  begin
    FCorrectionScale.Create(FCorrectionScale.Y, FCorrectionScale.Y);
    AValue := (FCurrentResolution.X - FDefaultResolution.X * FCorrectionScale.X) * 0.5;
    FCorrectionShift.Create(AValue, 0);
  end
  else
  begin
    FCorrectionScale.Create(FCorrectionScale.X, FCorrectionScale.X);
    AValue := (FCurrentResolution.Y - FDefaultResolution.Y * FCorrectionScale.Y) * 0.5;
    FCorrectionShift.Create(0, AValue);
  end;
  FUseCorrection := True;

  FScale.Create(1, 1);
  FPosition := ZeroVectorF;
end;

function TQuadCamera.DSP2CSP(const APos: TVectorF): TVectorF;
begin
  Result := FCorrectionShift + APos.ComponentwiseMultiply(FCorrectionScale);
end;

function TQuadCamera.CSP2DSP(const APos: TVectorF): TVectorF;
begin
  Result := (APos - FCorrectionShift).ComponentwiseDivide(FCorrectionScale);
end;

function TQuadCamera.WP2CSP(const APos: TVectorF): TVectorF;
begin
  Result := (APos - FPosition).ComponentwiseMultiply(FScale) + FHalfCScreen;
end;

function TQuadCamera.CSP2WP(const APos: TVectorF): TVectorF;
begin
  Result := (APos - FHalfCScreen).ComponentwiseDivide(FScale) + FPosition;
end;

function TQuadCamera.WP2DSP(const APos: TVectorF): TVectorF;
begin
  Result := (APos - FPosition).ComponentwiseMultiply(FScale) + FHalfDScreen;
end;

function TQuadCamera.DSP2WP(const APos: TVectorF): TVectorF;
begin
  Result := (APos - FHalfDScreen).ComponentwiseDivide(FScale) + FPosition;
end;

function TQuadCamera.DSS2CSS(const ASize: TVectorF): TVectorF;
begin
  Result := ASize.ComponentwiseMultiply(FCorrectionScale);
end;

function TQuadCamera.CSS2DSS(const ASize: TVectorF): TVectorF;
begin
  Result := ASize.ComponentwiseDivide(FCorrectionScale);
end;

function TQuadCamera.WS2CSS(const ASize: TVectorF): TVectorF;
begin
  Result := ASize.ComponentwiseDivide(FScale);
end;

function TQuadCamera.CSS2WS(const ASize: TVectorF): TVectorF;
begin
  Result := ASize.ComponentwiseMultiply(FScale);
end;

function TQuadCamera.WS2DSS(const ASize: TVectorF): TVectorF;
begin
  Result := ASize.ComponentwiseDivide(FScale);
end;

function TQuadCamera.DSS2WS(const ASize: TVectorF): TVectorF;
begin
  Result := ASize.ComponentwiseMultiply(FScale);
end;

function TQuadCamera.GetDefaultResolution: TVectorF;
begin
  Result := FDefaultResolution;
end;

function TQuadCamera.GetPosition: TVectorF;
begin
  Result := FPosition;
end;

function TQuadCamera.GetResolution: TVectorF;
begin
  Result := FCurrentResolution;
end;

function TQuadCamera.GetScale: TVectorF;
begin
  Result := FScale;
end;

function TQuadCamera.GetScreenPos(const APosition: TVectorF;
  AIsUseCorrection: Boolean): TVectorF;
begin
  if FUseCorrection and AIsUseCorrection then
  begin
    Result := WP2DSP(APosition);
    Result := DSP2CSP(Result);
  end
  else
    Result := WP2CSP(APosition);
end;

function TQuadCamera.GetScreenSize(const ASize: TVectorF;
  AIsUseCorrection: Boolean): TVectorF;
begin
  if FUseCorrection and AIsUseCorrection then
  begin
    Result := WS2DSS(ASize);
    Result := DSS2CSS(Result);
  end
  else
    Result := WS2CSS(ASize);
end;

function TQuadCamera.GetUseCorrection: Boolean;
begin
  Result := FUseCorrection;
end;

function TQuadCamera.GetWorldPos(const APosition: TVectorF;
  AIsUseCorrection: Boolean): TVectorF;
begin
  if FUseCorrection and AIsUseCorrection then
  begin
    Result := CSP2DSP(APosition);
    Result := DSP2WP(Result);
  end
  else
    Result := CSP2WP(APosition);
end;

function TQuadCamera.GetWorldSize(const ASize: TVectorF;
  AIsUseCorrection: Boolean): TVectorF;
begin
  if FUseCorrection and AIsUseCorrection then
  begin
    Result := CSS2DSS(ASize);
    Result := DSS2WS(Result);
  end
  else
    Result := CSS2WS(ASize);
end;

procedure TQuadCamera.SetPosition(const APosition: TVectorF);
begin
  FPosition := APosition;
end;

procedure TQuadCamera.SetScale(const AScale: TVectorF);
begin
  FScale := AScale;
end;

procedure TQuadCamera.SetUseCorrection(AUseCorrection: Boolean);
begin
  FUseCorrection := AUseCorrection;
end;

function TQuadCamera.GetScreenPos(X, Y: Single;
  AIsUseCorrection: Boolean): TVectorF;
begin
  GetScreenPos(Vec2F(X, Y), AIsUseCorrection);
end;

function TQuadCamera.GetScreenSize(Width, Height: Single;
  AIsUseCorrection: Boolean): TVectorF;
begin
  GetScreenSize(Vec2F(Width, Height), AIsUseCorrection);
end;

function TQuadCamera.GetWorldPos(X, Y: Single;
  AIsUseCorrection: Boolean): TVectorF;
begin
  GetWorldPos(Vec2F(X, Y), AIsUseCorrection);
end;

function TQuadCamera.GetWorldSize(Width, Height: Single;
  AIsUseCorrection: Boolean): TVectorF;
begin
  GetWorldSize(Vec2F(Width, Height), AIsUseCorrection);
end;
{$ENDREGION}

{$REGION '  TQuadEngine  '}
constructor TQuadEngine.Create;
var
  ARender: IQuadRender;
begin
  Inc(FRefCount);

  FDefaultResolution := ADefaultResolution;
  FCurrentResolution := ACurrentResolution;

  FQuadDevice := TQuadDevice.Create(Self);

  FQuadDevice.Device.CreateRender(ARender);
  FQuadRender := TQuadRender.Create(Self, ARender);

  TheDevice := QuadDevice;
  TheRender := QuadRender;
end;

destructor TQuadEngine.Destroy;
begin
  TheRender.Finalize;

  FreeAndNil(FQuadDevice);
  FreeAndNil(FQuadRender);

  TheDevice := nil;
  TheRender := nil;

  inherited;
end;

function TQuadEngine.GetDevice;
begin
  Result := FQuadDevice;
end;

function TQuadEngine.GetRender;
begin
  Result := FQuadRender;
end;

function TQuadEngine.GetCamera;
begin
  Result := FCamera;
end;

procedure TQuadEngine.SetCamera(const ACamera: IQuadCamera);
begin
  FCamera := ACamera;
end;

function TQuadEngine.GetDefaultResolution: TVectorI;
begin
  Result := FDefaultResolution;
end;

function TQuadEngine.GetCurrentResolution: TVectorI;
begin
  Result := FCurrentResolution;
end;

function TQuadEngine.CreateCamera;
begin
  Result := TQuadCamera.Create(DefaultResolution, CurrentResolution);
end;

function TQuadEngine.CreateTexture: TQuadTexture;
var
  ATexture: IQuadTexture;
begin
  FQuadDevice.Device.CreateTexture(ATexture);
  Result := TQuadTexture.Create(Self, ATexture);
  ATexture := nil;
end;

function TQuadEngine.CreateFont: TQuadFont;
var
  AFont: IQuadFont;
begin
  FQuadDevice.Device.CreateFont(AFont);
  Result := TQuadFont.Create(Self, AFont);
end;
{$ENDREGION}

end.
