unit Project87.BaseEnemy;

interface

uses
  QGame.Scene,
  Strope.Math,
  Project87.BaseUnit,
  Project87.Types.GameObject;

const
  MAX_LIFE = 100;

type
  TBaseEnemy = class (TBaseUnit)
    protected
      FColor: Cardinal;
    public
      constructor CreateUnit(const APosition: TVector2F; AAngle: Single;
        ASide: TUnitSide); override;

      procedure OnDraw; override;
//      procedure OnUpdate(const ADelta: Double); override;
      procedure OnCollide(OtherObject: TPhysicalObject); override;
  end;

implementation

uses
  QEngine.Core,
  Project87.Resources,
  Project87.Asteroid,
  Project87.Hero,
  QEngine.Texture;

{$REGION '  TBaseEnemy  '}
constructor TBaseEnemy.CreateUnit(const APosition: TVector2F; AAngle: Single;
  ASide: TUnitSide);
begin
  inherited;
  FRadius := 35;
  FMass := 1;
  FLife := MAX_LIFE;
  FColor := GetSideColor(ASide);
end;

procedure TBaseEnemy.OnDraw;
var
  ShieldAlpha: Byte;
begin
  if FIsDead then
    Exit;

  TheResources.HeroTexture.Draw(FPosition, Vec2F(30, 50), FAngle, FColor);
  TheResources.HeroTexture.Draw(FPosition, Vec2F(10, 20), FTowerAngle, FColor);
  ShieldAlpha := Trunc(FShowShieldTime * $52);
  if FLife < MAX_LIFE then
    TheRender.Rectangle(
      FPosition.X - 35, FPosition.Y - 43,
      FPosition.X - 35 + FLife / MAX_LIFE * 70, FPosition.Y - 40,
      $FF00FF00);
  TheResources.AsteroidTexture.Draw(
    FPosition, Vec2F(70, 70), FTowerAngle,
    ShieldAlpha * $1000000 + FColor - $FF000000);
end;

procedure TBaseEnemy.OnCollide(OtherObject: TPhysicalObject);
begin
  if FIsDead then
    Exit;

  if (OtherObject is TAsteroid) or
    (OtherObject is THeroShip) or
    (OtherObject is TBaseEnemy)
  then
  begin
    FShowShieldTime := 0.7;
  end;
end;

//procedure TBaseEnemy.OnUpdate(const ADelta: Double);
//begin
//  inherited;
//end;
{$ENDREGION}

end.
