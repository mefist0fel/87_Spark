unit Project87.Bullet;

interface

uses
  Strope.Math,
  Project87.Types.GameObject;

type
  TBullet = class (TGameObject)
    private
      FDamage: Single;
      FLife: Single;
    public
      constructor CreateBullet(const APosition, AVelocity: TVector2F; AAngle, ADamage, ALife: Single);

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
constructor TBullet.CreateBullet(const APosition, AVelocity: TVector2F; AAngle, ADamage, ALife: Single);
begin
  inherited Create;
  FDamage := ADamage;
  FPosition := APosition;
  FVelocity := AVelocity;
  FAngle := AAngle;
  FLife := ALife;
end;

procedure TBullet.OnDraw;
begin
  if FIsDead then
    Exit;

  TheResources.AsteroidTexture.Draw(FPosition, TVector2F.Create(4, 24), FAngle, $FFFFFFFF);
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
begin
  if FIsDead then
    Exit;

  if (OtherObject is TBaseEnemy) then
  begin
    TBaseEnemy(OtherObject).Hit(FDamage);
    FIsDead := True;
  end;
  if (OtherObject is TAsteroid) then
    FIsDead := True;
end;
{$ENDREGION}

end.