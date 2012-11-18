unit Project87.BaseEnemy;

interface

uses
  QGame.Scene,
  Strope.Math,
  Project87.BaseUnit,
  Project87.Types.StarMap,
  Project87.Types.GameObject;

const
  MAX_LIFE = 100;
  FLY_TO_HERO_DISTANCE = 700 * 700;
  MAX_BASE_UNIT_SPEED = 900;

type
  TAIAction = (
    None = 0,
    FlyToHeroAndFire = 1,
    MakeManuver = 2,
    FlyFromHero = 3,
    StopAndFireToHero = 4
  );

  TBaseEnemy = class (TBaseUnit)
    protected
      FColor: Cardinal;
      FLifeFraction: TLifeFraction;
      FDistanceToHero: Single;
      FCurrentAction: TAIAction;
      FActionTime: Single;
      procedure SetAction(ANewAction: TAIAction);
      procedure AIAct(const ADelta: Double);
    public
      constructor CreateUnit(const APosition: TVector2F; AAngle: Single;
        ASide: TLifeFraction); override;

      procedure OnDraw; override;
      procedure OnUpdate(const ADelta: Double); override;
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
  ASide: TLifeFraction);
begin
  inherited;
  FRadius := 33;
  FMass := 1;
  FLife := MAX_LIFE;
  FColor := GetSideColor(ASide);
  FCurrentAction := None;
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

procedure TBaseEnemy.SetAction(ANewAction: TAIAction);
begin
  if FActionTime < 0 then
  begin
    FCurrentAction := ANewAction;
    FActionTime := 2;
  end;
end;

procedure TBaseEnemy.AIAct(const ADelta: Double);
begin
  FActionTime := FActionTime - ADelta;
  case FCurrentAction of
    None:
    begin
      FCurrentAction := FlyToHeroAndFire;
    end;
    FlyToHeroAndFire:
    begin
      FAngle := RotateToAngle(FAngle, GetAngle(FPosition, THeroShip.GetInstance.Position), 10);
      FVelocity := FVelocity *  (1 - ADelta) + GetRotatedVector(FAngle, MAX_BASE_UNIT_SPEED) * (ADelta);
      if FDistanceToHero < FLY_TO_HERO_DISTANCE then
        SetAction(MakeManuver);
    end;
    MakeManuver:
    begin
    //  FVelocity := FVelocity *  (1 - ADelta);
      if FDistanceToHero > FLY_TO_HERO_DISTANCE then
        SetAction(FlyToHeroAndFire);
    end;
    FlyFromHero: ;
    StopAndFireToHero: ;
  end;
end;

procedure TBaseEnemy.OnUpdate(const ADelta: Double);
begin
  inherited;
  if FSeeHero then
  begin
    AIAct(ADelta);
  end;
end;
{$ENDREGION}

end.
