unit Project87.BigEnemy;

interface

uses
  QGame.Scene,
  Strope.Math,
  Project87.BaseUnit,
  Project87.BaseEnemy,
  Project87.Types.Weapon,
  Project87.Types.GameObject,
  Project87.Types.StarMap;

const
  MAX_LIFE = 300;
  MAX_FIRE_DISTANCE = 450 * 450;
  MIN_FIRE_DISTANCE = 300 * 300;
  MAX_BIG_UNIT_SPEED = 400;

type
  TBigEnemy = class (TBaseEnemy)
    protected
      FLauncher: TLauncher;
      procedure AIAct(const ADelta: Double); override;
    public
      constructor CreateUnit(const APosition: TVector2F; AAngle: Single;
        ASide: TLifeFraction); override;

      procedure OnDraw; override;
      procedure OnUpdate(const ADelta: Double); override;
      procedure Kill; override;
  end;

implementation

uses
  QEngine.Core,
  Project87.Hero,
  Project87.Fluid,
  Project87.Resources;

{$REGION '  TBaseEnemy  '}
constructor TBigEnemy.CreateUnit(const APosition: TVector2F; AAngle: Single;
  ASide: TLifeFraction);
begin
  inherited;

  FLauncher := TLauncher.Create(oEnemy, 3, 70, 200);
  FRadius := 85;
  FMass := 3;
  FLife := MAX_LIFE;
end;

procedure TBigEnemy.OnDraw;
var
  ShieldAlpha: Byte;
begin
  ShieldAlpha := Trunc(FShowShieldTime * $52);
  TheResources.FieldTexture.Draw(FPosition, Vec2F(170, 170),
    FTowerAngle, ShieldAlpha * $1000000 + FColor - $FF000000);
  TheResources.BigEnemyTexture.Draw(FPosition, Vec2F(150, 150), FAngle, FColor);
  TheResources.MachineGunTexture.Draw(FPosition, Vec2F(20, 30), FTowerAngle, FColor);
  if FLife < MAX_LIFE then
    TheRender.Rectangle(
      FPosition.X - 50, FPosition.Y - 53,
      FPosition.X - 50 + FLife / MAX_LIFE * 100, FPosition.Y - 50,
      $FF00FF00);
end;

procedure TBigEnemy.AIAct(const ADelta: Double);
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
      //FAngle := RotateToAngle(FAngle, GetAngle(FPosition, THeroShip.GetInstance.Position), 3);
      FVelocity := FVelocity *  (1 - ADelta) + GetRotatedVector(GetAngle(FPosition, THeroShip.GetInstance.Position), MAX_BIG_UNIT_SPEED) * (ADelta);

      if FDistanceToHero < MAX_FIRE_DISTANCE then
        SetAction(StopAndFireToHero, Random(10) / 10 + 1);
    end;
    FlyBack:
    begin
      FVelocity := FVelocity *  (1 - ADelta) + GetRotatedVector(GetAngle(THeroShip.GetInstance.Position, FPosition), MAX_BIG_UNIT_SPEED) * (ADelta);
      if FDistanceToHero > MIN_FIRE_DISTANCE then
        SetAction(StopAndFireToHero, Random(10) / 10 + 1);
    end;
    StopAndFireToHero:
    begin
      FVelocity := FVelocity *  (1 - ADelta);
      if FDistanceToHero < MIN_FIRE_DISTANCE then
        SetAction(FlyBack, Random(10) / 10 + 1);
      if FDistanceToHero > MAX_FIRE_DISTANCE then
        SetAction(FlyToHeroAndFire, Random(10) / 10 + 1);
    end;
  end;
  if FDistanceToHero < DISTANCE_TO_FIRE then
  begin
    FCannon.Fire(FPosition, FTowerAngle);
    FLauncher.Fire(FPosition, THeroShip.GetInstance.Position, FTowerAngle);
  end;
end;

procedure TBigEnemy.OnUpdate(const ADelta: Double);
begin
  inherited;
  FLauncher.OnUpdate(ADelta);
  FAngle := FAngle + 1;
  FTowerAngle := RotateToAngle(FTowerAngle, GetAngle(FPosition, THeroShip.GetInstance.Position), 10);
end;

procedure TBigEnemy.Kill;
begin
  FIsDead := True;
  TFluid.EmmitFluids(6, FPosition, TFluidType(Random(4)));
end;
{$ENDREGION}

end.
