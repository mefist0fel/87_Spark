unit Project87.Types.Weapon;

interface

uses
  Strope.Math,
  Project87.Bullet,
  Project87.ScannerWave;

type
  TOwner = (oPlayer = 0, oEnemy = 1);

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

  TScanner = class
    private
      FReloadTime: Single;
      FReloadTimer: Single;
    public
      constructor Create();

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
    TBullet.CreateBullet(APosition, GetRotatedVector(AAngle, 1600), AAngle, FDamage, FLife);
  end;
end;
{$ENDREGION}

{$REGION '  TScanner  '}
constructor TScanner.Create;
begin
  FReloadTime := 0.05;
end;

procedure TScanner.OnUpdate(const ADelta: Double);
begin
  if (FReloadTimer > 0) then
  begin
    FReloadTimer := FReloadTimer - ADelta;
    if (FReloadTimer < 0) then
      FReloadTimer := 0;
  end;
end;

procedure TScanner.Fire(APosition: TVector2F; AAngle: Single);
begin
  if (FReloadTimer = 0) then
  begin
    FReloadTimer := FReloadTime;
    TScannerWave.CreateWave(APosition, GetRotatedVector(AAngle, 1600), AAngle, 0.5);
  end;
end;
{$ENDREGION}

end.
