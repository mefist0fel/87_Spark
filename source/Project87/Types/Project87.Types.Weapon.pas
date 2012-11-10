unit Project87.Types.Weapon;

interface

uses
  Strope.Math,
  Project87.Bullet;

type
  TOwner = (OPlayer = 0, OEnemy = 1);

  TCannon = class
  private
    // bullets parameters
    FDamage: Single;
    FReloadTime: Single;
    FReloadTimer: Single;
    FLife: Single;
    FOwner: TOwner;
  public
    constructor Create(AOwner: TOwner; AReloadTime, ADamage: Single);
    procedure OnUpdate(const ADelta: Double);
    procedure Fire(APosition: TVector2F; AAngle: Single);
  end;

implementation

{$REGION '  TCannon  '}
constructor TCannon.Create(AOwner: TOwner; AReloadTime, ADamage: Single);
begin
  FDamage := ADamage;
  FReloadTime := AReloadTime;
  FLife := 1;
  FOwner := AOwner;
end;

procedure TCannon.OnUpdate(const ADelta: Double);
begin
  if (FReloadTimer > 0) then
  begin
    FReloadTimer := FReloadTimer - ADelta;
    if (FReloadTimer < 0) then
      FReloadTimer := 0;
  end;
end;

procedure TCannon.Fire(APosition: TVector2F; AAngle: Single);
begin
  if (FReloadTimer = 0) then
  begin
    FReloadTimer := FReloadTime;
    TBullet.CreateBullet(APosition, ClipAndRotate(AAngle, 1600), AAngle, FLife);
  end;
end;
{$ENDREGION}

end.
