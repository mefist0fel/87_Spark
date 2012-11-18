unit Project87.BaseEnemy;

interface

uses
  QGame.Scene,
  Strope.Math,
  Project87.BaseUnit,
  Project87.Types.StarMap,
  Project87.Types.Weapon,
  Project87.Types.GameObject;

const
  MAX_LIFE = 100;
  FLY_TO_HERO_DISTANCE = 250 * 250;
  DISTANCE_TO_FIRE = 450 * 450;
  MAX_BASE_UNIT_SPEED = 850;
  DEFAULT_ACTION_TIME = 2;

type
  TAIAction = (
    None = 0,
    FlyToHeroAndFire = 1,
    MakeLeftManuver = 2,
    MakeRightManuver = 3,
    FlyForward = 4,
    FlyBack = 5,
    StopAndFireToHero = 6
  );

  TBaseEnemy = class (TBaseUnit)
    protected
      FColor: Cardinal;
      FLifeFraction: TLifeFraction;
      FDistanceToHero: Single;
      FCurrentAction: TAIAction;
      FActionTime: Single;
      FCannon: TCannon;
      procedure SetAction(ANewAction: TAIAction; AActionTime: Single = DEFAULT_ACTION_TIME);
      procedure AIAct(const ADelta: Double); virtual;
      procedure SetRandomDirection;
    public
      constructor CreateUnit(const APosition: TVector2F; AAngle: Single;
        ASide: TLifeFraction); override;

      procedure OnDraw; override;
      procedure OnUpdate(const ADelta: Double); override;
      procedure OnCollide(OtherObject: TPhysicalObject); override;
      procedure Kill; override;
      property LifeFraction: TLifeFraction read FLifeFraction;
  end;

implementation

uses
  SysUtils,
  QEngine.Core,
  Project87.Resources,
  Project87.Asteroid,
  Project87.Hero,
  Project87.Fluid,
  QEngine.Texture;

{$REGION '  TBaseEnemy  '}
constructor TBaseEnemy.CreateUnit(const APosition: TVector2F; AAngle: Single;
  ASide: TLifeFraction);
begin
  inherited;
  FRadius := 33;
  FMass := 1;
  FLife := MAX_LIFE;
  FColor := GetSideColor(ASide);
  FCurrentAction := None;
  FCannon := TCannon.CreateMachineGun(oEnemy, 1, 0.1, 1, 5);
end;

procedure TBaseEnemy.OnDraw;
var
  ShieldAlpha: Byte;
begin
  ShieldAlpha := Trunc(FShowShieldTime * $52);
  TheResources.FieldTexture.Draw(
    FPosition, Vec2F(70, 70), FTowerAngle,
    ShieldAlpha * $1000000 + FColor - $FF000000);
  TheResources.MeduimEnemyTexture.Draw(FPosition, Vec2F(66, 66), FAngle, FColor);
  TheResources.MachineGunTexture.Draw(FPosition, Vec2F(19, 51), FTowerAngle, FColor);
  if FLife < MAX_LIFE then
    TheRender.Rectangle(
      FPosition.X - 35, FPosition.Y - 43,
      FPosition.X - 35 + FLife / MAX_LIFE * 70, FPosition.Y - 40,
      $FF00FF00);
//  TheResources.Font.TextOut(IntToStr(Integer(FCurrentAction)), FPosition, 1);
end;

procedure TBaseEnemy.OnCollide(OtherObject: TPhysicalObject);
begin
  if (OtherObject is TAsteroid) or
    (OtherObject is THeroShip) or
    (OtherObject is TBaseEnemy)
  then
  begin
    FShowShieldTime := 0.7;
  end;
end;

procedure TBaseEnemy.SetAction(ANewAction: TAIAction; AActionTime: Single = DEFAULT_ACTION_TIME);
begin
  if FActionTime < 0 then
  begin
    FCurrentAction := ANewAction;
    FActionTime := AActionTime;
  end;
end;

procedure TBaseEnemy.SetRandomDirection;
begin
  case Random(4) of
    0:SetAction(FlyForward, Random(10) / 10);
    1:SetAction(MakeRightManuver, Random(10) / 10);
    2:SetAction(MakeLeftManuver, Random(10) / 10);
  end;
end;

procedure TBaseEnemy.AIAct(const ADelta: Double);
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
      FVelocity := FVelocity *  (1 - ADelta) + GetRotatedVector(FAngle, MAX_BASE_UNIT_SPEED) * (ADelta);
      if FDistanceToHero < FLY_TO_HERO_DISTANCE then
        if Random(2) = 0 then
          SetAction(MakeLeftManuver, Random(10) / 10 + 1)
        else
          SetAction(MakeRightManuver, Random(10) / 10 + 1);
    end;
    MakeLeftManuver:
    begin
      FAngle := RoundAngle(FAngle + 3);
      FVelocity := FVelocity *  (1 - ADelta) + GetRotatedVector(FAngle, MAX_BASE_UNIT_SPEED) * (ADelta);
      if FDistanceToHero > FLY_TO_HERO_DISTANCE then
        FCurrentAction := FlyToHeroAndFire;
      SetRandomDirection;
    end;
    MakeRightManuver:
    begin
      FAngle := RoundAngle(FAngle - 3);
      FVelocity := FVelocity *  (1 - ADelta) + GetRotatedVector(FAngle, MAX_BASE_UNIT_SPEED) * (ADelta);
      if FDistanceToHero > FLY_TO_HERO_DISTANCE then
        FCurrentAction := FlyToHeroAndFire;
      SetRandomDirection;
    end;
    FlyForward:
    begin
      FVelocity := FVelocity *  (1 - ADelta) + GetRotatedVector(FAngle, MAX_BASE_UNIT_SPEED) * (ADelta);
      if FDistanceToHero > FLY_TO_HERO_DISTANCE then
        FCurrentAction := FlyToHeroAndFire;
      SetRandomDirection;
    end;
    StopAndFireToHero: ;
  end;
  if FDistanceToHero < DISTANCE_TO_FIRE then
    FCannon.Fire(FPosition, GetAngle(FPosition, THeroShip.GetInstance.Position));
end;

procedure TBaseEnemy.OnUpdate(const ADelta: Double);
begin
  inherited;
  FCannon.OnUpdate(ADelta);
  if FSeeHero then
  begin
    AIAct(ADelta);
  end;
end;

procedure TBaseEnemy.Kill;
begin
  THero.GetInstance.AddExp(3);
  FIsDead := True;
  TFluid.EmmitFluids(3, FPosition, TFluidType(Random(4)));
end;
{$ENDREGION}

end.
