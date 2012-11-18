unit Project87.Types.SystemGenerator;

interface

uses
  Project87.Hero,
  Project87.Types.StarMap;

type
  TSystemGenerator = class
  private class var FInstance: TSystemGenerator;
  private class var FEnemies: TEnemies;
  private
    FGenerator: Cardinal;
    constructor Create;
    function  GenerateAsteroids(AStarSystem: TStarSystem): Single;
    procedure GenerateEnemies(AStarSystem: TStarSystem; SystemSize: Single);
  public
    function PRandom: Integer; overload;
    function PRandom(AMax: Integer): Integer; overload;
    function PRandom(AMin, AMax: Integer): Integer; overload;
    function SRandom: Single;
    class function GetLastEnemies: TEnemies;
    class function  GetRemainingResources: TResources;
    class procedure GenerateSystem(AHero: THeroShip; AParameter: TStarSystem);
  end;

implementation

uses
  SysUtils,
  Generics.Collections,
  Strope.Math,
  QApplication.Application,
  Project87.BigEnemy,
  Project87.BaseEnemy,
  Project87.SmallEnemy,
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
  Asteroid: TList<TAsteroid>;
  SystemRadius: Single;
  SizeFactor: Single;
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
      for I := 0 to count div 4 do
      Asteroid.Add(TAsteroid.CreateAsteroid(
        GetRotatedVector(PRandom(3600) / 10, PRandom(1000) / 1000 * SystemRadius * 0.8),
        PRandom(360), 20 + PRandom(80),
        TFluidType(I mod (FLUID_TYPE_COUNT))));
      TObjectManager.GetInstance.SolveCollisions(10);
      for I := 0 to count div 2 do
      Asteroid.Add(TAsteroid.CreateAsteroid(
        GetRotatedVector(PRandom(3600) / 10, SystemRadius - SRandom * SystemRadius * 0.05),
        PRandom(360), 20 + PRandom(100),
        TFluidType(I mod (FLUID_TYPE_COUNT))));
      for I := 0 to trunc(4.8 * SizeFactor) do
      Asteroid.Add(TAsteroid.CreateAsteroid(
        GetRotatedVector(PRandom(3600) / 10, PRandom(1000) / 1000 * SystemRadius * 0.35),
        PRandom(360), 80 + PRandom(150) * SizeFactor,
        TFluidType(I mod (FLUID_TYPE_COUNT))));
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
          Asteroid[i].Fluids := PRandom(Asteroid[i].MaxFluids div 2) * (PRandom(2) + 1);
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
  Asteroid.Free;
  Result := SystemRadius;
end;

procedure TSystemGenerator.GenerateEnemies(AStarSystem: TStarSystem; SystemSize: Single);
var
  FFraction: TLifeFraction;
  SwarmCount, I, J: Word;
  Count: Single;
  SwarmPosition: TVectorF;
  SwarmType: Byte;
begin
  for I := 0 to LIFEFRACTION_COUNT - 1 do
    FEnemies[I] := 0;
  for FFraction in AStarSystem.Fractions do
  begin
    case AStarSystem.Size of
      ssSmall:
        SwarmCount := 1;
      ssMedium:
        SwarmCount := 2;
      ssBig:
        SwarmCount := 4;
    end;
    Count:= AStarSystem.Enemies[Integer(FFraction)];
    for I := 0 to SwarmCount do
    begin
      SwarmType := PRandom(3);
      SwarmPosition := GetRotatedVector(PRandom(360), PRandom(Trunc(SystemSize * 0.9)));
      case SwarmType of
        0:
        for J := 1 to trunc(Count * 10) do
        begin
          FEnemies[Integer(FFraction)] := FEnemies[Integer(FFraction)] + 1;
          TSmallEnemy.CreateUnit(SwarmPosition + Vec2F(Random(300) - 150, Random(300) - 150), Random(360), FFraction);
        end;
        1:
        for J := 1 to trunc(Count * 10) do
        begin
          FEnemies[Integer(FFraction)] := FEnemies[Integer(FFraction)] + 1;
          if J < 2 then
            TBigEnemy.CreateUnit(SwarmPosition + Vec2F(Random(300) - 150, Random(300) - 150), Random(360), FFraction)
          else
            TBaseEnemy.CreateUnit(SwarmPosition + Vec2F(Random(300) - 150, Random(300) - 150), Random(360), FFraction);
        end;
        2:
        for J := 1 to trunc(Count * 10) do
        begin
          FEnemies[Integer(FFraction)] := FEnemies[Integer(FFraction)] + 1;
          if J < 3 then
            TBigEnemy.CreateUnit(SwarmPosition + Vec2F(Random(300) - 150, Random(300) - 150), Random(360), FFraction)
          else
            if J < 6 then
              TBaseEnemy.CreateUnit(SwarmPosition + Vec2F(Random(300) - 150, Random(300) - 150), Random(360), FFraction)
            else
              TSmallEnemy.CreateUnit(SwarmPosition + Vec2F(Random(300) - 150, Random(300) - 150), Random(360), FFraction);
        end;
      end;
    end;
  end;
end;

class function TSystemGenerator.GetLastEnemies: TEnemies;
var
  I: Byte;
  Enemy: TList<TPhysicalObject>;
  Current: TPhysicalObject;
  Enemies: TEnemies;
begin
  for I := 0 to LIFEFRACTION_COUNT - 1 do
    Enemies[I] := 0;
  Enemy := TObjectManager.GetInstance.GetObjects(TBaseEnemy);
  I := 0;
  for Current in Enemy do
    Enemies[Integer(TBaseEnemy(Current).LifeFraction)] := Enemies[Integer(TBaseEnemy(Current).LifeFraction)] + 1;
  for I := 0 to LIFEFRACTION_COUNT - 1 do
    if (FEnemies[I] > 0) then
     Enemies[I] := Enemies[I] / FEnemies[I];
  Enemy.Free;
  Result := Enemies;
end;

class function TSystemGenerator.GetRemainingResources: TResources;
var
  I: Byte;
  Asteroid: TList<TPhysicalObject>;
  Current: TPhysicalObject;
  Resources: TResources;
begin
  for I := 0 to FLUID_TYPE_COUNT - 1 do
    Resources[I] := 0;
  Asteroid := TObjectManager.GetInstance.GetObjects(TAsteroid);
  I := 0;
  for Current in Asteroid do
    Resources[Integer(TAsteroid(Current).FluidType)] := Resources[Integer(TAsteroid(Current).FluidType)] + TAsteroid(Current).Fluids;
  Asteroid.Free;
  Result := Resources;
end;

class procedure TSystemGenerator.GenerateSystem(AHero: THeroShip; AParameter: TStarSystem);
var
  I: Byte;
  SystemSize, Angle: Single;
begin
  if (FInstance = nil) then
    FInstance := Create();
  if AParameter <> nil then
  with FInstance do
  begin
    FGenerator := AParameter.Seed;
    SystemSize := GenerateAsteroids(AParameter);
    Angle := PRandom(360);
    AHero.FlyInSystem(GetRotatedVector(Angle, -SystemSize * 1.1), Angle);
    GenerateEnemies(AParameter, SystemSize);
   { for FFraction in AParameter.Fractions do
    begin
      for I := 0 to 8 do
        TBigEnemy.CreateUnit(Vec2F(Random(5000) - 2500, Random(5000) - 2500), Random(360), FFraction);
      for I := 0 to 30 do
        TBaseEnemy.CreateUnit(Vec2F(Random(5000) - 2500, Random(5000) - 2500), Random(360), FFraction);
      for I := 0 to 20 do
        TSmallEnemy.CreateUnit(Vec2F(Random(5000) - 2500, Random(5000) - 2500), Random(360), FFraction);
    end;                                                                       }
  end;
end;
{$ENDREGION}

end.
