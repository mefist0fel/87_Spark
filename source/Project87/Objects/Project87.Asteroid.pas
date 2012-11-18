unit Project87.Asteroid;

interface

uses
  QEngine.Camera,
  QEngine.Texture,
  QGame.Scene,
  Strope.Math,
  Project87.Fluid,
  Project87.Types.GameObject;

const
  MAX_RESOURCES = 100;
  FLUID_POSITION_SCALE = 2;

type
  TScannedResources = record
    Position: array [0..MAX_RESOURCES - 1] of TVectorF;
    Generated: Boolean;
  end;

  TAsteroid = class (TPhysicalObject)
    class var FResources: TScannedResources;
    private
      FMarkerPosition: TVectorF;
      FFluids: Word;
      FMaxFluids: Word;
      FType: TFluidType;
      FShowFluids: Single;
      FAsteroidTexture: Byte;

      procedure GenerateScannedResources;
      procedure ShowFluidsInAsteroid;
    public
      constructor CreateAsteroid(const APosition: TVector2F;
        AAngle, ARadius: Single; AType: TFluidType; ATexture: Byte = 0);

      procedure OnDraw; override;
      procedure OnUpdate(const ADelta: Double); override;
      procedure Scan;
      procedure Hit(AAngle: Single; ANumber: Integer);
      property MaxFluids: Word read FMaxFluids;
      property Fluids: Word read FFluids write FFluids;
      property FluidType: TFluidType read FType;
  end;

implementation

uses
  SysUtils,
  QEngine.Core,
  QApplication.Application,
  Project87.Hero,
  Project87.Resources;

{$REGION '  TAsteroid  '}
constructor TAsteroid.CreateAsteroid(const APosition: TVector2F;
  AAngle, ARadius: Single; AType: TFluidType; ATexture: Byte = 0);
begin
  inherited Create;

  if not FResources.Generated then
    GenerateScannedResources;
  FPosition := APosition;
  FAngle := AAngle;
  FRadius := ARadius;
  FUseCollistion := True;
  FType := AType;
  FMass := 10;
  FAsteroidTexture := ATexture;
  FMaxFluids := Trunc(ARadius / FLUID_POSITION_SCALE);
end;

procedure TAsteroid.GenerateScannedResources;
var
  I: Word;
begin
  FResources.Generated := True;
  for I := 0 to MAX_RESOURCES - 1 do
    FResources.Position[I] := GetRotatedVector(Random(360), I * FLUID_POSITION_SCALE);
end;

procedure TAsteroid.OnDraw;
var
  ScreenSize: TVectorF;
  NeedDrawMarker: Boolean;
begin
  TheResources.AsteroidTexture[FAsteroidTexture].Draw(FPosition, Vec2F(FRadius, FRadius) * 2, FAngle, $FFFFFFFF);

  //TODO - map markers
{  FMarkerPosition := TheEngine.Camera.GetScreenPos(FPosition, false);
  ScreenSize := TheEngine.Camera.Resolution;
  FMarkerPosition := (FPosition - TheEngine.Camera.Position);
  if FMarkerPosition.LengthSqr < RADAR_DISTANCE * RADAR_DISTANCE then
  begin
    NeedDrawMarker := False;
    if Abs(FMarkerPosition.X) - ScreenSize.X * 0.5 > 0 then
    begin
      FMarkerPosition := FMarkerPosition * (ScreenSize.X * 0.5 / Abs(FMarkerPosition.X));
      NeedDrawMarker := True;
    end;
    if Abs(FMarkerPosition.Y) - ScreenSize.Y * 0.5 > 0 then
    begin
      FMarkerPosition := FMarkerPosition * (ScreenSize.Y * 0.5 / Abs(FMarkerPosition.Y));
      NeedDrawMarker := True;
    end;
    if NeedDrawMarker then
        begin
          FMarkerPosition := FMarkerPosition + TheEngine.Camera.Position;
          TheResources.AsteroidTexture.Draw(FMarkerPosition, Vec2F(10, 10), 0, $FFFFFFFF);
        end;
    end;          }
  ShowFluidsInAsteroid;
end;

procedure TAsteroid.OnUpdate(const ADelta: Double);
begin
  if (FShowFluids > 0) then
  begin
    FShowFluids := FShowFluids - ADelta;
    if (FShowFluids < 0) then
      FShowFluids := 0;
  end;
end;

procedure TAsteroid.Scan;
begin
  FShowFluids := FShowFluids + 0.1;
  if (FShowFluids > 1) then
    FShowFluids := 1;
end;

procedure TAsteroid.Hit(AAngle: Single; ANumber: Integer);
var
  I: Integer;
begin
  if FFluids = 0 then
    Exit;
  if (FFluids < ANumber) then
    ANumber := FFluids;
  FFluids := FFluids - ANumber;
  for I := 1 to ANumber do
    TFluid.CreateFluid(
      FPosition + GetRotatedVector(AAngle, FRadius),
      GetRotatedVector(AAngle + Random(10) - 5, Random(200) + 50),
      FType);
end;

procedure TAsteroid.ShowFluidsInAsteroid;
var
  Alpha, I: Word;
  Color: Cardinal;
begin
  if (FShowFluids > 0) and (FFluids > 0) then
  begin
    Alpha := Trunc(FShowFluids * $120);
    if Alpha > $FF then
      Alpha := $FF;
    case FType of
      fYellow: Color := $FFFF00;
      fBlue:   Color := $00FF00;
      fRed:    Color := $FF0000;
      fGreen:  Color := $0000FF;
    else Color := $0000FF;
    end;
    for I := 0 to FFluids - 1 do
      TheResources.FluidTexture.Draw(
        FPosition + FResources.Position[I], Vec2F(8, 8), 0, Alpha * $1000000 + Color);
  end;
end;
{$ENDREGION}

end.
