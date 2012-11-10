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
    public
      constructor CreateAsteroid(const APosition: TVector2F; AAngle, ARadius: Single);

      procedure OnDraw; override;
      procedure OnUpdate(const ADelta: Double); override;
  end;

implementation

uses
  Project87.Resources;

{$REGION '  TAsteroid  '}
constructor TAsteroid.CreateAsteroid(const APosition: TVector2F; AAngle, ARadius: Single);
begin
  inherited Create;

  FPosition := APosition;
  FAngle := AAngle;
  FRadius := ARadius;
  FUseCollistion := True;
  FMass := 10;
end;

procedure TAsteroid.OnDraw;
begin
  TheResources.AsteroidTexture.Draw(FPosition, Vec2F(FRadius, FRadius) * 2, FAngle, $FFFFFFFF);
//  TheResources.HeroTexture.Draw(FPosition - FCorrection * 0.5, FCorrection, 0, $ffffffff);
end;

procedure TAsteroid.OnUpdate(const ADelta: Double);
begin

end;
{$ENDREGION}

end.
