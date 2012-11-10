unit Project87.BaseEnemy;

interface

uses
  QGame.Scene,
  Strope.Math,
  Project87.Types.GameObject;

type
  TBaseEnemy = class (TPhysicalObject)
    private
      FTowerAngle: Single;
      FShowShieldTime: Single;
      FMessage: String;
    public
      constructor CreateEnemy(const APosition: TVector2F; AAngle: Single);

      procedure OnDraw; override;
      procedure OnUpdate(const ADelta: Double); override;
      procedure OnCollide(OtherObject: TPhysicalObject); override;
  end;

implementation

uses
  Project87.Resources,
  QEngine.Camera,
  Project87.Asteroid,
  Project87.Hero,
  QEngine.Texture;

{$REGION '  TBaseEnemy  '}
constructor TBaseEnemy.CreateEnemy(const APosition: TVector2F; AAngle: Single);
begin
  inherited Create;
  FPosition := APosition;
  FAngle := AAngle;
  FRadius := 35;
  FUseCollistion := True;
  FMass := 1;
  FMessage := '';
end;

procedure TBaseEnemy.OnDraw;
var
  ShieldAlpha: Byte;
begin
  TheResources.HeroTexture.Draw(FPosition, Vec2F(30, 50), FAngle, $FF00FF00);
  TheResources.HeroTexture.Draw(FPosition, Vec2F(10, 20), FTowerAngle, $FF00FF00);
  ShieldAlpha := Trunc(FShowShieldTime * $52);
  TheResources.AsteroidTexture.Draw(FPosition, Vec2F(70, 70), FTowerAngle, ShieldAlpha * $1000000 + $00FF00);
  TheResources.Font.TextOut(FMessage, FPosition, 2);
end;

procedure TBaseEnemy.OnCollide(OtherObject: TPhysicalObject);
begin
  if (OtherObject is TAsteroid) or (OtherObject is THero) or (OtherObject is TBaseEnemy) then
  begin
    FShowShieldTime := 0.7;
  end;
end;

procedure TBaseEnemy.OnUpdate(const ADelta: Double);
begin
  if (FShowShieldTime > 0) then
  begin
    FShowShieldTime := FShowShieldTime - ADelta;
    if (FShowShieldTime < 0) then
      FShowShieldTime := 0;
  end;

end;
{$ENDREGION}

end.
