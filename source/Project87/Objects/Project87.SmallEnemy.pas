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
  MAX_SMALL_SPEED = 1200;
  FLY_BACK_DISTANCE = 700 * 700;

type
  TSmallEnemy = class(TBaseEnemy)
  protected
    procedure AIAct(const ADelta: Double); override;
  public
    constructor CreateUnit(const APosition: TVector2F; AAngle: Single;
      ASide: TLifeFraction); override;

    procedure OnDraw; override;
    procedure Kill; override;
  end;

implementation

uses
  SysUtils,
  QEngine.Core,
  Project87.Hero,
  Project87.Types.Weapon,
  Project87.Fluid,
  Project87.Resources;

{$REGION '  TBaseEnemy  '}
constructor TSmallEnemy.CreateUnit(const APosition: TVector2F; AAngle: Single;
  ASide: TLifeFraction);
begin
  inherited;
  FRadius := 22;
  FMass := 1;
  FLife := MAX_LIFE * THero.GetInstance.ExpFactor;
  FMaxLife := MAX_LIFE * THero.GetInstance.ExpFactor;
  FreeAndNil(FCannon);
  FCannon := TCannon.CreateMachineGun(oEnemy, 1, 0.1, 1 * THero.GetInstance.ExpFactor, 8);
end;

procedure TSmallEnemy.OnDraw;
var
  ShieldAlpha: Byte;
begin
  ShieldAlpha := Trunc(FShowShieldTime * $52);
  TheResources.FieldTexture.Draw(FPosition, Vec2F(44, 44), FTowerAngle,
    ShieldAlpha * $1000000 + FColor - $FF000000);
  TheResources.SmallEnemyTexture.Draw(FPosition, Vec2F(40, 40), FAngle, FColor);
  if FLife < FMaxLife then
    TheRender.Rectangle(FPosition.X - 10, FPosition.Y - 53,
      FPosition.X - 50 + FLife / FMaxLife * 100, FPosition.Y - 50, $FF00FF00);
end;

procedure TSmallEnemy.AIAct(const ADelta: Double);
begin
  FDistanceToHero := (FPosition - THeroShip.GetInstance.Position).LengthSqr;
  FActionTime := FActionTime - ADelta;
  case FCurrentAction of
    None:
    begin
      FCurrentAction := FlyToHeroAndFire;
    end;
    FlyToHeroAndFire:
    begin
      FAngle := RotateToAngle(FAngle, GetAngle(FPosition, THeroShip.GetInstance.Position), 3);
      FVelocity := FVelocity *  (1 - ADelta) + GetRotatedVector(FAngle, MAX_SMALL_SPEED) * (ADelta);

      if FDistanceToHero < DISTANCE_TO_FIRE then
        FCannon.Fire(FPosition, FAngle);
      if FDistanceToHero < FLY_TO_HERO_DISTANCE then
        SetAction(FlyForward, Random(10) / 10 + 1);
    end;
    FlyForward:
    begin
      FAngle := RotateToAngle(FAngle, GetAngle(THeroShip.GetInstance.Position, FPosition), 3);
      FVelocity := FVelocity *  (1 - ADelta) + GetRotatedVector(FAngle, MAX_SMALL_SPEED) * (ADelta);
      if FDistanceToHero > FLY_BACK_DISTANCE then
        SetAction(FlyToHeroAndFire, Random(10) / 10 + 1);
    end;
  end;
end;

procedure TSmallEnemy.Kill;
begin
  THero.GetInstance.AddExp(1);
  FIsDead := True;
  TFluid.EmmitFluids(1, FPosition, TFluidType(Random(4)));
end;
{$ENDREGION}

end.
