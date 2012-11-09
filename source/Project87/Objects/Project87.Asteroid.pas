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
      FRadius: Single;
    public
      constructor Create(const APosition: TVector2F; AAngle, ARadius: Single);

      procedure OnDraw; override;
      procedure OnUpdate(const  ADelta: Double); override;
  end;

implementation

uses
  Project87.Resources;

{$REGION '  TAsteroid  '}
constructor TAsteroid.Create(const APosition: TVector2F; AAngle, ARadius: Single);
begin
  FPosition := APosition;
  FAngle := AAngle;
  FRadius := ARadius;
  inherited Create;
end;

procedure TAsteroid.OnDraw;
begin
  TheResources.AsteroidTexture.Draw(FPosition, TVector2F.Create(FRadius, FRadius), FAngle, $FFFFFFFF);
end;

procedure TAsteroid.OnUpdate(const  ADelta: Double);
begin

end;
{$ENDREGION}

end.
