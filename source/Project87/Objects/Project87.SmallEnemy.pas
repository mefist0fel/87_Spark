unit Project87.SmallEnemy;

interface

uses
  QGame.Scene,
  Strope.Math,
  Project87.BaseUnit,
  Project87.BaseEnemy,
  Project87.Types.StarMap,
  Project87.Types.GameObject;

const
  MAX_LIFE = 60;

type
  TSmallEnemy = class (TBaseEnemy)
    private
    public
      constructor CreateUnit(const APosition: TVector2F; AAngle: Single; ASide: TLifeFraction); override;

      procedure OnDraw; override;
  end;

implementation

uses
  QEngine.Core,
  Project87.Resources;

{$REGION '  TBaseEnemy  '}
constructor TSmallEnemy.CreateUnit(const APosition: TVector2F; AAngle: Single; ASide: TLifeFraction);
begin
  inherited;
  FRadius := 15;
  FMass := 1;
  FLife := MAX_LIFE;
end;

procedure TSmallEnemy.OnDraw;
var
  ShieldAlpha: Byte;
begin
  TheResources.SmallEnemyTexture.Draw(FPosition, Vec2F(20, 20), FAngle, FColor);
  ShieldAlpha := Trunc(FShowShieldTime * $52);
  if FLife < MAX_LIFE then
    TheRender.Rectangle(
      FPosition.X - 10, FPosition.Y - 53,
      FPosition.X - 50 + FLife / MAX_LIFE * 100, FPosition.Y - 50,
      $FF00FF00);
  TheResources.AsteroidTexture.Draw(FPosition, Vec2F(30, 30),
    FTowerAngle, ShieldAlpha * $1000000 + FColor - $FF000000);
end;
{$ENDREGION}

end.
