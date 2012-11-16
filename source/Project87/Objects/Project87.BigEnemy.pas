unit Project87.BigEnemy;

interface

uses
  QGame.Scene,
  Strope.Math,
  Project87.BaseUnit,
  Project87.BaseEnemy,
  Project87.Types.GameObject,
  Project87.Types.StarMap;

const
  MAX_LIFE = 300;

type
  TBigEnemy = class (TBaseEnemy)
    private
    public
      constructor CreateUnit(const APosition: TVector2F; AAngle: Single;
        ASide: TLifeFraction); override;

      procedure OnDraw; override;
  end;

implementation

uses
  QEngine.Core,
  Project87.Resources;

{$REGION '  TBaseEnemy  '}
constructor TBigEnemy.CreateUnit(const APosition: TVector2F; AAngle: Single;
  ASide: TLifeFraction);
begin
  inherited;

  FRadius := 85;
  FMass := 3;
  FLife := MAX_LIFE;
end;

procedure TBigEnemy.OnDraw;
var
  ShieldAlpha: Byte;
begin
  TheResources.HeroTexture.Draw(FPosition, Vec2F(90, 150), FAngle, FColor);
  TheResources.HeroTexture.Draw(FPosition, Vec2F(20, 30), FTowerAngle, FColor);
  ShieldAlpha := Trunc(FShowShieldTime * $52);
  if FLife < MAX_LIFE then
    TheRender.Rectangle(
      FPosition.X - 50, FPosition.Y - 53,
      FPosition.X - 50 + FLife / MAX_LIFE * 100, FPosition.Y - 50,
      $FF00FF00);
  TheResources.AsteroidTexture.Draw(FPosition, Vec2F(170, 170),
    FTowerAngle, ShieldAlpha * $1000000 + FColor - $FF000000);
end;
{$ENDREGION}

end.
