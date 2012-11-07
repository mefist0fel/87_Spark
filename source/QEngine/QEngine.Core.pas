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
      property QuadRender: IQuadRender read GetRender;
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
      FIsUseCorrection: Boolean;
      FCorrectionScale: TVectorF;
      FPosition: TVectorF;
      FScale: TVectorF;

      function GetScreenPosition(const AWorldPosition: TVectorF): TVectorF;
      function GetScreenX(AWorldX: Single): Single; inline;
      function GetScreenY(AWordlY: Single): Single; inline;

      function GetScreenSize(const AWorldSize: TVectorF): TVectorF;
      function GetScreenWidth(AWorldWidth: Single): Single; inline;
      function GetScreenHeight(AWorldHeight: Single): Single; inline;

      function GetWorldPosition(const AScreenPosition: TVectorF): TVectorF;
      function GetWorldX(AScreenX: Single): Single; inline;
      function GetWorldY(AScreenY: Single): Single; inline;

      function GetWorldSize(const AScreenSize: TVectorF): TVectorF;
      function GetWorldWidth(AScreenWidth: Single): Single; inline;
      function GetWorldHeight(AScreenHeight: Single): Single; inline;

      function GetPosition(): TVectorF; inline;
      procedure SetPosition(const APosition: TVectorF); inline;

      function GetCenterPosition(): TVectorF;
      procedure SetCenterPosition(const APosition: TVectorF);

      function GetScale(): TVectorF;  inline;
      procedure SetScale(const AScale: TVectorF); inline;

      function GetResolutionCorrection(): TVectorF; inline;

      function GetIsUseCorrection(): Boolean; inline;
      procedure SetIsUseCorrection(AIsUseCorrection: Boolean); inline;
    public
      constructor Create(const ADefaultResolution, ACurrentResolution: TVectorI);

      property Position: TVectorF read GetPosition write SetPosition;
      property CenterPosition: TVectorF read GetCenterPosition write SetCenterPosition;
      property Scale: TVectorF read GetScale write SetScale;
      property ResolutionCorrection: TVectorF read GetResolutionCorrection;
      property IsUseCorrection: Boolean read GetIsUseCorrection write SetIsUseCorrection;
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
  AValue := Min(
    ACurrentResolution.X / ADefaultResolution.X,
    ACurrentResolution.Y / ADefaultResolution.Y);
  FCorrectionScale.Create(AValue, AValue);
  FIsUseCorrection := True;
  FPosition.Create(0, 0);
  FScale.Create(1, 1);
end;

function TQuadCamera.GetScreenPosition(const AWorldPosition: TVectorF): TVectorF;
var
  ACorrection: TVectorF;
begin
  if IsUseCorrection then
    ACorrection := ResolutionCorrection
  else
    ACorrection.Create(1, 1);
  Result := (AWorldPosition - Position).ComponentwiseMultiply(
    Scale.ComponentwiseMultiply(ACorrection));
end;

function TQuadCamera.GetScreenX(AWorldX: Single): Single;
var
  ACorrection: Single;
begin
  if IsUseCorrection then
    ACorrection := ResolutionCorrection.X
  else
    ACorrection := 1;
  Result := (AWorldX - Position.X) * Scale.X * ACorrection;
end;

function TQuadCamera.GetScreenY(AWordlY: Single): Single;
var
  ACorrection: Single;
begin
  if IsUseCorrection then
    ACorrection := ResolutionCorrection.Y
  else
    ACorrection := 1;
  Result := (AWordlY - Position.Y) * Scale.Y * ACorrection;
end;

function TQuadCamera.GetScreenSize(const AWorldSize: TVectorF): TVectorF;
var
  ACorrection: TVectorF;
begin
  if IsUseCorrection then
    ACorrection := ResolutionCorrection
  else
    ACorrection.Create(1, 1);
  Result := AWorldSize.ComponentwiseMultiply(
    Scale.ComponentwiseMultiply(ACorrection));
end;

function TQuadCamera.GetScreenWidth(AWorldWidth: Single): Single;
var
  ACorrection: Single;
begin
  if IsUseCorrection then
    ACorrection := ResolutionCorrection.X
  else
    ACorrection := 1;
  Result := AWorldWidth * Scale.X * ACorrection;
end;

function TQuadCamera.GetScreenHeight(AWorldHeight: Single): Single;
var
  ACorrection: Single;
begin
  if IsUseCorrection then
    ACorrection := ResolutionCorrection.Y
  else
    ACorrection := 1;
  Result := AWorldHeight * Scale.Y * ACorrection;
end;

function TQuadCamera.GetWorldPosition(const AScreenPosition: TVectorF): TVectorF;
var
  ACorrection: TVectorF;
begin
  if IsUseCorrection then
    ACorrection := ResolutionCorrection
  else
    ACorrection.Create(1, 1);
  Result := Position + AScreenPosition.ComponentwiseDivide(
    Scale.ComponentwiseMultiply(ACorrection));
end;

function TQuadCamera.GetWorldX(AScreenX: Single): Single;
var
  ACorrection: Single;
begin
  if IsUseCorrection then
    ACorrection := ResolutionCorrection.X
  else
    ACorrection := 1;
  Result := Position.X + AScreenX / (Scale.X * ACorrection);
end;

function TQuadCamera.GetWorldY(AScreenY: Single): Single;
var
  ACorrection: Single;
begin
  if IsUseCorrection then
    ACorrection := ResolutionCorrection.Y
  else
    ACorrection := 1;
  Result := Position.Y + AScreenY / (Scale.Y * ACorrection);
end;

function TQuadCamera.GetWorldSize(const AScreenSize: TVectorF): TVectorF;
var
  ACorrection: TVectorF;
begin
  if IsUseCorrection then
    ACorrection := ResolutionCorrection
  else
    ACorrection.Create(1, 1);
  Result := AScreenSize.ComponentwiseDivide(
    Scale.ComponentwiseMultiply(ACorrection));
end;

function TQuadCamera.GetWorldWidth(AScreenWidth: Single): Single;
var
  ACorrection: Single;
begin
  if IsUseCorrection then
    ACorrection := ResolutionCorrection.X
  else
    ACorrection := 1;
  Result := AScreenWidth / (Scale.X * ACorrection);
end;

function TQuadCamera.GetWorldHeight(AScreenHeight: Single): Single;
var
  ACorrection: Single;
begin
  if IsUseCorrection then
    ACorrection := ResolutionCorrection.Y
  else
    ACorrection := 1;
  Result := AScreenHeight / (Scale.Y * ACorrection);
end;

function TQuadCamera.GetCenterPosition: TVectorF;
begin
  Result := Position + GetWorldSize(FCurrentResolution) * 0.5;
end;

function TQuadCamera.GetIsUseCorrection: Boolean;
begin
  Result := FIsUseCorrection;
end;

function TQuadCamera.GetPosition;
begin
  Exit(FPosition);
end;

function TQuadCamera.GetResolutionCorrection: TVectorF;
begin
  Result := FCorrectionScale;
end;

procedure TQuadCamera.SetCenterPosition(const APosition: TVectorF);
begin
  FPosition := APosition - GetWorldSize(FCurrentResolution) * 0.5;
end;

procedure TQuadCamera.SetIsUseCorrection(AIsUseCorrection: Boolean);
begin
  FIsUseCorrection := AIsUseCorrection;
end;

procedure TQuadCamera.SetPosition(const APosition: TVectorF);
begin
  FPosition := APosition;
end;

function TQuadCamera.GetScale;
begin
  Exit(FScale);
end;

procedure TQuadCamera.SetScale(const AScale: TVectorF);
begin
  FScale.Create(Abs(AScale.X), Abs(AScale.Y));
end;
{$ENDREGION}

{$REGION '  TQuadEngine  '}
constructor TQuadEngine.Create;
var
  ARender: IQuadRender;
begin
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
  FRefCount := -1;

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
