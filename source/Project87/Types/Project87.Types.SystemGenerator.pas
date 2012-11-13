unit Project87.Types.SystemGenerator;

interface

const
  MAX_NOISE_VALUES = $FF;

type
  TSystemGenerator = class
  private class var FInstance: TSystemGenerator;
  private
    FGenerator: Cardinal;
    constructor Create;
    procedure GenerateAsteroids(FType: Byte);
  public
    function PRandom: Integer; overload;
    function PRandom(AMax: Integer): Integer; overload;
    function PRandom(AMin, AMax: Integer): Integer; overload;
    class procedure GenerateSystem;
  end;

implementation

uses
  SysUtils,
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

procedure TSystemGenerator.GenerateAsteroids(FType: Byte);
var
  I, J: Integer;
  ASize: Single;
  Position: TVectorF;
begin
  ASize := 500 * 10;
  case FType of
    0:
    begin
      for I := 0 to 50 do
      TAsteroid.CreateAsteroid(
        GetRotatedVector(PRandom(3600) / 10, ASize - PRandom(1000) / 1000 * ASize * 0.05),
        PRandom(360), 20 + PRandom(100),
        TFluidType(PRandom(4)));
      for I := 0 to 4 do
      TAsteroid.CreateAsteroid(
        GetRotatedVector(PRandom(3600) / 10, PRandom(1000) / 1000 * ASize * 0.4),
        PRandom(360), 200 + PRandom(300),
        TFluidType(PRandom(4)));
      for I := 0 to 15 do
      TAsteroid.CreateAsteroid(
        GetRotatedVector(PRandom(3600) / 10, PRandom(1000) / 1000 * ASize * 0.8),
        PRandom(360), 20 + PRandom(200),
        TFluidType(PRandom(4)));
      TObjectManager.GetInstance.SolveCollisions(10);
    end;
    1:
    begin
      for I := 0 to 150 do
      TAsteroid.CreateAsteroid(
        GetRotatedVector(PRandom(3600) / 10, ASize - PRandom(1000) / 1000 * PRandom(1000) / 1000 * ASize),
        PRandom(360), 20 + PRandom(100),
        TFluidType(PRandom(4)));
    end;
    2:
    begin
      for I := -20 to 20 do
        for J := -3 to 3 do
          begin
            Position := Vec2F(I * 300, J * 1400 + Cos(i / 10) * 800) + Vec2F(PRandom(-300, 600), PRandom(-300, 600));
            if Position.Length < ASize then
              TAsteroid.CreateAsteroid(
                Position,
                PRandom(360), 20 + PRandom(100),
                TFluidType(PRandom(4)));
          end;
      {for I := 0 to 150 do
      TAsteroid.CreateAsteroid(
        GetRotatedVector(PRandom(3600) / 10, ASize - PRandom(1000) / 1000 * PRandom(1000) / 1000 * ASize),
        PRandom(360), 20 + PRandom(100),
        TFluidType(PRandom(4)));
      for I := 0 to 4 do
      TAsteroid.CreateAsteroid(
        GetRotatedVector(PRandom(3600) / 10, PRandom(1000) / 1000 * ASize * 0.4),
        PRandom(360), 200 + PRandom(300),
        TFluidType(PRandom(4)));
      for I := 0 to 15 do
      TAsteroid.CreateAsteroid(
        GetRotatedVector(PRandom(3600) / 10, PRandom(1000) / 1000 * ASize * 0.8),
        PRandom(360), 20 + PRandom(200),
        TFluidType(PRandom(4)));                      }
      TObjectManager.GetInstance.SolveCollisions(10);
    end;
  end;
end;

class procedure TSystemGenerator.GenerateSystem;
begin
  if (FInstance = nil) then
    FInstance := Create();
  with FInstance do
  begin
    FGenerator := 1;
    GenerateAsteroids(2);
  end;
end;
{$ENDREGION}

end.
