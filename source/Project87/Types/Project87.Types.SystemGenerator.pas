unit Project87.Types.SystemGenerator;

interface

uses
  Project87.Hero,
  Project87.Types.StarMap;

type
  TSystemGenerator = class
  private class var FInstance: TSystemGenerator;
  private
    FGenerator: Cardinal;
    constructor Create;
    function GenerateAsteroids(AStarSystem: TStarSystem): Single;
  public
    function PRandom: Integer; overload;
    function PRandom(AMax: Integer): Integer; overload;
    function PRandom(AMin, AMax: Integer): Integer; overload;
    function SRandom: Single;
    class procedure GenerateSystem(AHero: THeroShip; AParameter: TStarSystem);
  end;

implementation

uses
  SysUtils,
  Generics.Collections,
  Strope.Math,
  Project87.Types.GameObject,
  Project87.Asteroid,
  Project87.Fluid;

{$REGION '  Generator const  '}
const
  STABLE_NOISE_COMPONENT = 1;
  NOISE_MULTIPLIER = 22695477;
{$ENDREGION}

{$REGION '  TSystemGenerator  '}
constructor TSystemGenerator.Create;
begin
  FGenerator := 1;
end;

function TSystemGenerator.PRandom: Integer;
begin
  FGenerator := (NOISE_MULTIPLIER * FGenerator + STABLE_NOISE_COMPONENT)
          mod $ffffffff;
  Result := Abs(FGenerator);
end;

function TSystemGenerator.PRandom(AMax: Integer): Integer;
begin
  Result := PRandom mod AMax;
end;

function TSystemGenerator.PRandom(AMin, AMax: Integer): Integer;
begin
  Result := PRandom mod AMax + AMin;
end;

function TSystemGenerator.SRandom: Single;
begin
  Result := PRandom(1000) / 1000;
end;

function TSystemGenerator.GenerateAsteroids(AStarSystem: TStarSystem): Single;
var
  I, J, L, Count: Integer;
  SystemRadius: Single;
  SizeFactor: Single;
  Asteroid: TList<TAsteroid>;
  Resources: TResources;
begin
  SizeFactor := 1;
  Count := -1;
  case AStarSystem.Size of
    ssSmall:
      begin
        SizeFactor := 0.6;
        Count := 90;
      end;
    ssMedium:
      begin
        SizeFactor := 1;
        Count := 180;
      end;
    ssBig:
      begin
        SizeFactor := 1.3;
        Count := 250;
      end;
  end;
  Asteroid := TList<TAsteroid>.Create();
  SystemRadius := 3300 * SizeFactor;
  case AStarSystem.Configuration of
    scDischarged:
    begin
      for I := 0 to Count do
        Asteroid.Add(TAsteroid.CreateAsteroid(
          GetRotatedVector(PRandom(3600) / 10, SystemRadius - SRandom * SRandom * SystemRadius),
          PRandom(360), 20 + PRandom(120),
          TFluidType(I mod (FLUID_TYPE_COUNT))));
    end;
    scCompact:
    begin
      L := Round(4.3 * SizeFactor);
      for I := 1 to L do
        for J := 0 to I * 8 do
        Asteroid.Add(TAsteroid.CreateAsteroid(
          GetRotatedVector(J * (360 / (I * 8)) + SRandom * (360 / I * 8), SystemRadius / L * (I - 0.4) + SRandom * 180 * SizeFactor),
          PRandom(360), 20 + PRandom(120),
          TFluidType((I + J) mod (FLUID_TYPE_COUNT))));
      TObjectManager.GetInstance.SolveCollisions(10);
    end;
    scPlanet: //like a planetar system
    begin
      for I := 0 to count div 2 do
      Asteroid.Add(TAsteroid.CreateAsteroid(
        GetRotatedVector(PRandom(3600) / 10, SystemRadius - SRandom * SystemRadius * 0.05),
        PRandom(360), 20 + PRandom(100),
        TFluidType(I mod (FLUID_TYPE_COUNT))));
      for I := 0 to trunc(4.8 * SizeFactor) do
      Asteroid.Add(TAsteroid.CreateAsteroid(
        GetRotatedVector(PRandom(3600) / 10, PRandom(1000) / 1000 * SystemRadius * 0.35),
        PRandom(360), 100 + PRandom(170) * SizeFactor,
        TFluidType(I mod (FLUID_TYPE_COUNT))));
      for I := 0 to count div 4 do
      Asteroid.Add(TAsteroid.CreateAsteroid(
        GetRotatedVector(PRandom(3600) / 10, PRandom(1000) / 1000 * SystemRadius * 0.8),
        PRandom(360), 20 + PRandom(80),
        TFluidType(I mod (FLUID_TYPE_COUNT))));
      TObjectManager.GetInstance.SolveCollisions(10);
    end;
  end;
  //Resource division
  for J := 0 to FLUID_TYPE_COUNT - 1 do
    Resources[J] := AStarSystem.Resources[J];
  for J := 0 to FLUID_TYPE_COUNT - 1 do
    for I := 0 to Asteroid.Count - 1 do
      if Asteroid[i].FluidType = TFluidType(J) then
      begin
        if Resources[J] >= Asteroid[i].MaxFluids then
        begin
          Asteroid[i].Fluids := PRandom(Asteroid[i].MaxFluids);
          Resources[J] := Resources[J] - Asteroid[i].Fluids;
        end
        else
        begin
          Asteroid[i].Fluids := Resources[J];
          Resources[J] := Resources[J] - Asteroid[i].Fluids;
        end;
        if Resources[J] = 0 then
          Break;
      end;
  TObjectManager.GetInstance.CountObjects(TAsteroid);
  Asteroid.Free;
  Result := SystemRadius;
end;

class procedure TSystemGenerator.GenerateSystem(AHero: THeroShip; AParameter: TStarSystem);
var
  HeroStartDistance, Angle: Single;
begin
  if (FInstance = nil) then
    FInstance := Create();
  if AParameter <> nil then
  with FInstance do
  begin
    FGenerator := AParameter.Seed;
    HeroStartDistance := GenerateAsteroids(AParameter);
    Angle := PRandom(360);
    AHero.FlyInSystem(GetRotatedVector(Angle, -HeroStartDistance * 1.1), Angle);
  end;
{  for I := 0 to 100 do
    TAsteroid.CreateAsteroid(
      Vec2F(Random(5000) - 2500, Random(5000) - 2500),
      Random(360), 20 + Random(100),
      TFluidType(Random(4)));
  UnitSide := TUnitSide(Random(3) + 2);
  for I := 0 to 40 do
    TBaseEnemy.CreateUnit(Vec2F(Random(5000) - 2500, Random(5000) - 2500), Random(360), UnitSide);
  for I := 0 to 10 do
    TBigEnemy.CreateUnit(Vec2F(Random(5000) - 2500, Random(5000) - 2500), Random(360), UnitSide);
  for I := 0 to 20 do
    TSmallEnemy.CreateUnit(Vec2F(Random(5000) - 2500, Random(5000) - 2500), Random(360), UnitSide);  }
end;
{$ENDREGION}

end.
