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
      FDefaultResolution: TVectorF;
      FHalfScreen: TVectorF;

      FUseCorrection: Boolean;
      FCorrectionShift: TVectorF;
      FCorrectionScale: TVectorF;

      FPosition: TVectorF;
      FScale: TVectorF;

      function GetRealScale(): TVectorF;

      function GetScreenPosition(const APosition: TVectorF): TVectorF;
      function GetScreenX(X: Single): Single; inline;
      function GetScreenY(Y: Single): Single; inline;

      function GetScreenSize(const ASize: TVectorF): TVectorF;
      function GetScreenWidth(AWidth: Single): Single; inline;
      function GetScreenHeight(AHeight: Single): Single; inline;

      function GetWorldPosition(const APosition: TVectorF): TVectorF;
      function GetWorldX(X: Single): Single; inline;
      function GetWorldY(Y: Single): Single; inline;

      function GetWorldSize(const ASize: TVectorF): TVectorF;
      function GetWorldWidth(AWidth: Single): Single; inline;
      function GetWorldHeight(AHeight: Single): Single; inline;

      function GetPosition(): TVectorF; inline;
      procedure SetPosition(const APosition: TVectorF); inline;

      function GetLeftTopPosition(): TVectorF;
      procedure SetLeftTopPosition(const APosition: TVectorF);

      function GetScale(): TVectorF;  inline;
      procedure SetScale(const AScale: TVectorF); inline;

      function GetCorrection(): TVectorF; inline;

      function GetUseCorrection(): Boolean; inline;
      procedure SetUseCorrection(AUseCorrection: Boolean); inline;

      function GetResolution(): TVectorF;
      function GetDefaultResolution(): TVectorF;

      property RealScale: TVectorF read GetRealScale;
      property HalfScreen: TVectorF read FHalfScreen;
    public
      constructor Create(const ADefaultResolution, ACurrentResolution: TVectorI);

      property Position: TVectorF read GetPosition write SetPosition;
      property LeftTopPosition: TVectorF read GetLeftTopPosition write SetLeftTopPosition;
      property ScreenPosition[const APosition: TVectorF]: TVectorF read GetScreenPosition;
      property ScreenSize[const ASize: TVectorF]: TVectorF read GetScreenSize;
      property WorldPosition[const APosition: TVectorF]: TVectorF read GetWorldPosition;
      property WorldSize[const ASize: TVectorF]: TVectorF read GetWorldSize;
      property Scale: TVectorF read GetScale write SetScale;
      property Correction: TVectorF read GetCorrection;
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
  FHalfScreen := FCurrentResolution * 0.5;

  FCorrectionScale := FCurrentResolution.ComponentwiseDivide(FDefaultResolution);
  if FCorrectionScale.Y < FCorrectionScale.X then
  begin
    FCorrectionScale.Create(FCorrectionScale.Y, FCorrectionScale.Y);
    AValue := 1 - FCorrectionScale.Y;
    FCorrectionShift.Create(AValue * 0.5, 0);
    FCorrectionShift := FCorrectionShift.ComponentwiseMultiply(FCurrentResolution);
  end
  else
  begin
    FCorrectionScale.Create(FCorrectionScale.X, FCorrectionScale.X);
    AValue := 1 - FCorrectionScale.X;
    FCorrectionShift.Create(0, AValue * 0.5);
    FCorrectionShift := FCorrectionShift.ComponentwiseMultiply(FCurrentResolution);
  end;
  FUseCorrection := True;

  FScale.Create(1, 1);
  FPosition := ScreenPosition[HalfScreen];
end;

function TQuadCamera.GetScreenPosition(const APosition: TVectorF): TVectorF;
begin
  Result := HalfScreen + (APosition - FPosition).ComponentwiseMultiply(RealScale);
end;

function TQuadCamera.GetScreenX(X: Single): Single;
begin
  Result := HalfScreen.X + (X - FPosition.X) * RealScale.X;
end;

function TQuadCamera.GetScreenY(Y: Single): Single;
begin
  Result := HalfScreen.Y + (Y - FPosition.Y) * RealScale.Y;
end;

function TQuadCamera.GetScreenSize(const ASize: TVectorF): TVectorF;
begin
  Result := ASize.ComponentwiseMultiply(RealScale);
end;

function TQuadCamera.GetScreenWidth(AWidth: Single): Single;
begin
  Result := AWidth * RealScale.X;
end;

function TQuadCamera.GetScreenHeight(AHeight: Single): Single;
begin
  Result := AHeight * RealScale.Y;
end;

function TQuadCamera.GetWorldPosition(const APosition: TVectorF): TVectorF;
begin
  Result := (APosition - HalfScreen).ComponentwiseDivide(RealScale) + FPosition;
end;

function TQuadCamera.GetWorldX(X: Single): Single;
begin
  Result := (X - HalfScreen.X) / RealScale.X + FPosition.X;
end;

function TQuadCamera.GetWorldY(Y: Single): Single;
begin
  Result := (Y - HalfScreen.Y) / RealScale.Y + FPosition.Y;
end;

function TQuadCamera.GetWorldSize(const ASize: TVectorF): TVectorF;
begin
  Result := ASize.ComponentwiseDivide(RealScale);
end;

function TQuadCamera.GetWorldWidth(AWidth: Single): Single;
begin
  Result := AWidth / RealScale.X;
end;

function TQuadCamera.GetWorldHeight(AHeight: Single): Single;
begin
  Result := AHeight / RealScale.Y;
end;

function TQuadCamera.GetCorrection: TVectorF;
begin
  Result := FCorrectionScale;
end;

function TQuadCamera.GetDefaultResolution: TVectorF;
begin
  Result := FDefaultResolution;
end;

function TQuadCamera.GetLeftTopPosition: TVectorF;
begin
  Result := FPosition - WorldSize[HalfScreen];
end;

function TQuadCamera.GetPosition;
begin
  Result := FPosition;
end;

function TQuadCamera.GetRealScale: TVectorF;
begin
  if FUseCorrection then
    Result := FCorrectionScale
  else
    Result.Create(1, 1);
  Result := Result.ComponentwiseMultiply(FScale);
end;

function TQuadCamera.GetResolution: TVectorF;
begin
  Result := FCurrentResolution;
end;

procedure TQuadCamera.SetLeftTopPosition(const APosition: TVectorF);
begin
  FPosition := APosition + WorldSize[HalfScreen];
end;

procedure TQuadCamera.SetPosition(const APosition: TVectorF);
begin
  FPosition := APosition;
end;

function TQuadCamera.GetScale;
begin
  Result := FScale;
end;

procedure TQuadCamera.SetScale(const AScale: TVectorF);
begin
  FScale.Create(Abs(AScale.X), Abs(AScale.Y));
end;

function TQuadCamera.GetUseCorrection: Boolean;
begin
  Result := FUseCorrection;
end;

procedure TQuadCamera.SetUseCorrection(AUseCorrection: Boolean);
begin
  FUseCorrection := AUseCorrection;
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
