unit Project87.Bullet;

interface

uses
  Strope.Math,
  Project87.BaseUnit,
  Project87.Types.GameObject;

type
  TBullet = class (TGameObject)
    private
      FDamage: Single;
      FLife: Single;
      FOwner: TOwner;
    public
      constructor CreateBullet(const APosition, AVelocity: TVector2F;
        AAngle, ADamage, ALife: Single; AOwner: TOwner);

      procedure OnDraw; override;
      procedure OnUpdate(const  ADelta: Double); override;
      procedure OnCollide(OtherObject: TPhysicalObject); override;
  end;

implementation

uses
  QEngine.Texture,
  Project87.Hero,
  Project87.BaseEnemy,
  Project87.Asteroid,
  Project87.Resources;

{$REGION '  TBullet  '}
constructor TBullet.CreateBullet(const APosition, AVelocity: TVector2F;
  AAngle, ADamage, ALife: Single; AOwner: TOwner);
begin
  inherited Create;

  FDamage := ADamage;
  FPreviosPosition := APosition;
  FPosition := APosition;
  FVelocity := AVelocity;
  FAngle := AAngle;
  FLife := ALife;
  FOwner := AOwner;
end;

procedure TBullet.OnDraw;
begin
  if FIsDead then
    Exit;

  TheResources.BulletTexture.Draw(FPosition, Vec2F(5, 25), FAngle, $FFFFFFFF);
end;

procedure TBullet.OnUpdate(const  ADelta: Double);
begin
  if FIsDead then
    Exit;

  FLife := FLife - ADelta;
  if FLife < 0 then
    FIsDead := True;
end;

procedure TBullet.OnCollide(OtherObject: TPhysicalObject);
var
  CollideVector: TVectorF;
begin
  if FIsDead then
    Exit;

  if (OtherObject is TBaseEnemy) and (FOwner = oPlayer)  then
  begin
    TBaseEnemy(OtherObject).Hit(FDamage);
    FIsDead := True;
  end;
  if (OtherObject is THeroShip) and (FOwner = oEnemy)  then
  begin
    TBaseEnemy(OtherObject).Hit(FDamage);
    FIsDead := True;
  end;
  if (OtherObject is TAsteroid) then
  begin
    CollideVector := (OtherObject.Position - FPosition);
    TAsteroid(OtherObject).Hit(GetAngle(CollideVector), 1);
    FIsDead := True;
  end;
end;
{$ENDREGION}

end.
