unit Project87.BaseUnit;

interface

uses
  QGame.Scene,
  Strope.Math,
  Project87.Types.GameObject;

type
  TUnitSide = ( //ship races
    usNeutral = 0,
    usHero    = 1,
    usRed     = 2,
    usGreen   = 3,
    usBlue    = 4
  );

  TBaseUnit = class (TPhysicalObject)
    protected
      FSide: TUnitSide;
      FTowerAngle: Single;
      FShowShieldTime: Single;
      FLife: Single;

      function GetSideColor(ASide: TUnitSide): Cardinal;
    public
      constructor CreateUnit(const APosition: TVector2F; AAngle: Single;
        ASide: TUnitSide); virtual;

      procedure OnUpdate(const ADelta: Double); override;
      procedure OnCollide(OtherObject: TPhysicalObject); override;
      procedure Hit(ADamage: Single); virtual;
      procedure Kill; virtual;

      property Life: Single read FLife;
  end;

implementation

uses
  Project87.Resources,
  Project87.Asteroid,
  Project87.BaseEnemy,
  Project87.Fluid,
  Project87.Hero;

{$REGION '  TBaseUnit  '}
constructor TBaseUnit.CreateUnit(const APosition: TVector2F; AAngle: Single;
  ASide: TUnitSide);
begin
  inherited Create;

  FPosition := APosition;
  FAngle := AAngle;
  FUseCollistion := True;
  FRadius := 35;
  FMass := 1;
  FLife := 100;
end;

function TBaseUnit.GetSideColor(ASide: TUnitSide): Cardinal;
begin
  Result := $FFFFFFFF;
  case ASide of
    usNeutral: ;
    usHero: Result := $FFFFFFFF;
    usRed: Result := $FFFF2222;
    usGreen: Result := $FF22FF22;
    usBlue: Result := $FF2222FF;
  end;
end;

procedure TBaseUnit.OnCollide(OtherObject: TPhysicalObject);
begin
  if FIsDead then
    Exit;

  if (OtherObject is TAsteroid) or
    (OtherObject is THero) or
    (OtherObject is TBaseEnemy)
  then
    FShowShieldTime := 0.7;
end;

procedure TBaseUnit.OnUpdate(const ADelta: Double);
begin
  if FIsDead then
    Exit;

  if (FShowShieldTime > 0) then
  begin
    FShowShieldTime := FShowShieldTime - ADelta;
    if (FShowShieldTime < 0) then
      FShowShieldTime := 0;
  end;
end;

procedure TBaseUnit.Hit(ADamage: Single);
begin
  FShowShieldTime := 0.7;
  FLife := FLife - ADamage;
  if (FLife < 0) then
    Kill;
end;

procedure TBaseUnit.Kill;
begin
  FIsDead := True;
  TFluid.EmmitFluids(Random(10) + 2, FPosition, TFluidType(Random(4)));
end;
{$ENDREGION}

end.
