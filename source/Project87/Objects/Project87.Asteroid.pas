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

type
  TScannedResources = record
    Position: array [0..MAX_RESOURCES - 1] of TVectorF;
    Generated: Boolean;
  end;

  TAsteroid = class (TPhysicalObject)
    private
      class var FResources: TScannedResources;

      FFluids: Word;
      FType: TFluidType;
      FShowFluids: Single;

      procedure GenerateScannedResources;
    public
      constructor CreateAsteroid(const APosition: TVector2F;
        AAngle, ARadius: Single; AType: TFluidType);

      procedure OnDraw; override;
      procedure OnUpdate(const ADelta: Double); override;
      procedure Scan;
      procedure Hit(AAngle: Single; ANumber: Integer);
  end;

implementation

uses
  SysUtils,
  Project87.Resources;

{$REGION '  TAsteroid  '}
constructor TAsteroid.CreateAsteroid(const APosition: TVector2F;
  AAngle, ARadius: Single; AType: TFluidType);
begin
  inherited Create;

  if not FResources.Generated then
    GenerateScannedResources;
  //“ы же в курсе, раземеетс€, что Random(n) возвращает числа от 0 до n - 1
  FFluids := Random(MAX_RESOURCES) * Random(2) * Random(2);
  FPosition := APosition;
  FAngle := AAngle;
  FRadius := ARadius;
  FUseCollistion := True;
  FType := AType;
  FMass := 10;
end;

procedure TAsteroid.GenerateScannedResources;
var
  I: Word;
begin
  FResources.Generated := True;
  for I := 0 to MAX_RESOURCES - 1 do
    FResources.Position[I] := GetRotatedVector(Random(360), I * 2);
end;

procedure TAsteroid.OnDraw;
var
  Alpha, I: Word;
  Color: Cardinal;
begin
  TheResources.AsteroidTexture.Draw(FPosition, Vec2F(FRadius, FRadius) * 2, FAngle, $FFFFFFFF);
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
{$ENDREGION}

end.
