unit Project87.Asteroid;

interface

uses
  QEngine.Camera,
  QEngine.Texture,
  QGame.Scene,
  Strope.Math,
  Project87.Types.GameObject;

type
  TAsteroid = class (TPhysicalObject)
    private
      FFluids: Word;
      FShowFluids: Single;
    public
      constructor CreateAsteroid(const APosition: TVector2F; AAngle, ARadius: Single);

      procedure OnDraw; override;
      procedure OnUpdate(const ADelta: Double); override;
      procedure Scan;
  end;

implementation

uses
  SysUtils,
  Project87.Resources;

{$REGION '  TAsteroid  '}
constructor TAsteroid.CreateAsteroid(const APosition: TVector2F; AAngle, ARadius: Single);
begin
  inherited Create;
  FFluids := Random(50) * Random(2) * Random(2);
  FPosition := APosition;
  FAngle := AAngle;
  FRadius := ARadius;
  FUseCollistion := True;
  FMass := 10;
end;

procedure TAsteroid.OnDraw;
var
  FluidsString: String;
  Alpha: Word;
begin
  TheResources.AsteroidTexture.Draw(FPosition, Vec2F(FRadius, FRadius) * 2, FAngle, $FFFFFFFF);
  FluidsString := IntToStr(FFluids);
  Alpha := Trunc(FShowFluids * $120);
  if Alpha > $ff then
    Alpha := $ff;
  TheResources.Font.TextOut(FluidsString, FPosition, 1, Alpha * $1000000 + $ffffff);
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
{$ENDREGION}

end.
