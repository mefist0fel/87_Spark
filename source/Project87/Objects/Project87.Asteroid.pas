unit Project87.Asteroid;

interface

uses
  QEngine.Camera,
  QEngine.Texture,
  QGame.Scene,
  Strope.Math,
  Project87.Types.GameObject;

type
  TAsteroid = class (TGameObject)
    private
    public
      constructor CreateAsteroid(const APosition: TVector2F; AAngle, ARadius: Single);
      procedure OnDraw; override;
      procedure OnUpdate(const  ADelta: Double); override;
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
  TheResources.AsteroidTexture.Draw(FPosition, TVector2F.Create(FRadius * 2, FRadius * 2), FAngle, $ffffffff);
//  TheResources.HeroTexture.Draw(FPosition - FCorrection * 0.5, FCorrection, 0, $ffffffff);
end;

procedure TAsteroid.OnUpdate(const  ADelta: Double);
begin

end;
{$ENDREGION}

end.
