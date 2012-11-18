unit Project87.Rocket;

interface

uses
  Strope.Math,
  Project87.BaseUnit,
  Project87.Types.GameObject;

const
  ROCKET_SPEED = 80;
  ROCKET_LIFE_TIME = 4;
  ROCKET_PRECIZION = 35 * 35;
  START_DELAY = 0.35;
  FRICTION = 2.5;
  EXPLODE_TIME = 0.2;

type
  TRocket = class (TGameObject)
    private
      FDamageRadius: Single;
      FDamage: Single;
      FOwner: TOwner;
      FLifetime: Single;
      FDirection: TVectorF;
      FAim: TVectorF;
      FStartDelay: Single;
      FExplosionAnimation: Single;
      FExplosion: Boolean;
      procedure Explode;
      procedure HitNearestShips;
    public
      constructor CreateRocket(const APosition, AVelocity, AAim: TVector2F;
        AAngle, ADamage, ADamageRadius: Single; AOwner: TOwner);

      procedure OnDraw; override;
      procedure OnUpdate(const  ADelta: Double); override;
      procedure OnCollide(OtherObject: TPhysicalObject); override;
  end;

implementation

uses
  SysUtils,
  QApplication.Application,
  QEngine.Texture,
  Generics.Collections,
  Project87.Hero,
  Project87.BaseEnemy,
  Project87.Asteroid,
  Project87.Resources;

{$REGION '  TRocket  '}
constructor TRocket.CreateRocket(const APosition, AVelocity, AAim: TVector2F;
        AAngle, ADamage, ADamageRadius: Single; AOwner: TOwner);
begin
  inherited Create;

  FAim := AAim;
  FLifetime := ROCKET_LIFE_TIME;
  FDamage := ADamage;
  FDamageRadius := ADamageRadius;
  FPreviosPosition := APosition;
  FPosition := APosition;
  FVelocity := AVelocity;
  FAngle := AAngle;
  FOwner := AOwner;
  FStartDelay := START_DELAY;
end;

procedure TRocket.OnDraw;
var
  BlowSize: Single;
begin
  if not (FExplosion) then
    TheResources.RocketTexture.Draw(FPosition, Vec2F(64, 8), FAngle - 90, $FFFFFFFF, 1)
  else
  begin
    BlowSize := (1 - Abs(FExplosionAnimation / EXPLODE_TIME * 2 - 1)) * FDamageRadius * 0.5;
    TheResources.FieldTexture.Draw(FPosition, Vec2F(BlowSize, BlowSize), FAngle, $FFFFFFFF)
  end;
end;

procedure TRocket.OnUpdate(const  ADelta: Double);
begin
  if (FStartDelay < 0) then
  begin
    FLifetime := FLifetime - ADelta;
    if FLifetime < 0 then
      Explode;

    FVelocity := FVelocity + FDirection * ROCKET_SPEED;
  end
  else
  begin
    FAngle := RotateToAngle(FAngle, GetAngle(FPosition, FAim), 8);
    FStartDelay := FStartDelay - ADelta;
    FVelocity := FVelocity * (1 - ADelta * FRICTION);
    if FStartDelay < 0 then
    begin
      FDirection := (FAim - FPosition).Normalize;
      FAngle := GetAngle(FPosition, FAim);
    end;
  end;

  if FExplosion then
  begin
    if FExplosionAnimation > 0 then
      FExplosionAnimation := FExplosionAnimation - ADelta
    else
    begin
      FIsDead := True;
    end;
  end;
end;

procedure TRocket.HitNearestShips;
var
  Ships: TList<TPhysicalObject>;
  Current: TPhysicalObject;
  Distance: Single;
begin
  Ships := TObjectManager.GetInstance.GetObjects(TBaseUnit);
  for Current in Ships do
    if not Current.IsDead then
    begin
      if (Current is TBaseEnemy) and (FOwner = oPlayer) then
        if (Current.Position - FPosition).LengthSqr < FDamageRadius * FDamageRadius then
        begin
          Distance := 1 - (Current.Position - FPosition).Length / FDamageRadius;
          TBaseEnemy(Current).Hit(Distance * FDamage);
        end;
      if (Current is THeroShip) and (FOwner = oEnemy) then
        if (Current.Position - FPosition).LengthSqr < FDamageRadius * FDamageRadius then
        begin
          Distance := 1 - (Current.Position - FPosition).Length / FDamageRadius;
          THeroShip(Current).Hit(Distance * FDamage);
        end;
    end;
  Ships.Free;
end;

procedure TRocket.Explode;
begin
  if not FExplosion then
  begin
    HitNearestShips;
    FExplosionAnimation := EXPLODE_TIME;
    FStartDelay := 1;
    FVelocity := ZeroVectorF;
    FExplosion := True;
  end;
end;

procedure TRocket.OnCollide(OtherObject: TPhysicalObject);
var
  I: Word;
  CollideVector: TVectorF;
begin
  if (OtherObject is TBaseEnemy) and (FOwner = oPlayer) then
  begin
    Explode();
  end;
  if (OtherObject is TAsteroid) and not FExplosion then
  begin
    Explode();
    for i := 0 to 3 + Random(10) do
      TAsteroid(OtherObject).Hit(GetAngle(OtherObject.Position, FPosition) + Random(30) - 15, 1);
  end;
  if (OtherObject is THeroShip) and (FOwner = oEnemy) then
  begin
    Explode();
  end;
end;
{$ENDREGION}

end.
