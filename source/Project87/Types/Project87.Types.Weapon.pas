unit Project87.Types.Weapon;

interface

uses
  Strope.Math,
  Project87.Bullet,
  Project87.Rocket,
  Project87.BaseUnit,
  Project87.ScannerWave;

type
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

  TLauncher = class
    private
      // rocket parameters
      FDamage: Single;
      FDamageRadius: Single;
      FReloadTime: Single;
      FReloadTimer: Single;
      FOwner: TOwner;
      FSide: SmallInt;
    public
      constructor Create(AOwner: TOwner; AReloadTime, ADamage, ADamageRadius: Single);

      procedure OnUpdate(const ADelta: Double);
      procedure Fire(APosition, AAim: TVector2F; AAngle: Single);
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

uses
  Project87.Hero;

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
    TBullet.CreateBullet(APosition, GetRotatedVector(AAngle, 1600), AAngle, FDamage, FLife, FOwner);
  end;
end;
{$ENDREGION}

{$REGION '  TLauncher  '}
constructor TLauncher.Create(AOwner: TOwner; AReloadTime, ADamage, ADamageRadius: Single);
begin
  FDamageRadius := ADamageRadius;
  FDamage := ADamage;
  FReloadTime := AReloadTime;
  FOwner := AOwner;
  FSide := 1;
end;

procedure TLauncher.OnUpdate(const ADelta: Double);
begin
  if (FReloadTimer > 0) then
  begin
    FReloadTimer := FReloadTimer - ADelta;
    if (FReloadTimer < 0) then
      FReloadTimer := 0;
  end;
end;

procedure TLauncher.Fire(APosition, AAim: TVector2F; AAngle: Single);
begin
  if (FReloadTimer = 0) and (THero.GetInstance.Rockets > 0) then
  begin
    FReloadTimer := FReloadTime;
    TRocket.CreateRocket(
      APosition,
      GetRotatedVector(AAngle + 90 * FSide, 120), AAim, AAngle + Random(20) - 10, FDamage, FDamageRadius, oPlayer);
    THero.GetInstance.Rockets := THero.GetInstance.Rockets - 1;
    FSide := FSide * -1;
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
