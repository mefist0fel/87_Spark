unit Project87.BaseUnit;

interface

uses
  QGame.Scene,
  Strope.Math,
  Project87.Types.StarMap,
  Project87.Types.GameObject;

const
  UNIT_VIEW_RANGE = 1200;

type
  TOwner = (oPlayer = 0, oEnemy = 1);

  TBaseUnit = class (TPhysicalObject)
    private
      FCounter: Word;
    protected
      FSide: TLifeFraction;
      FTowerAngle: Single;
      FShowShieldTime: Single;
      FLife: Single;
      FViewRange: Single;
      FSeeHero: Boolean;


      function GetSideColor(ASide: TLifeFraction): Cardinal;
    public
      constructor CreateUnit(const APosition: TVector2F; AAngle: Single;
        ASide: TLifeFraction); virtual;

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
  ASide: TLifeFraction);
begin
  inherited Create;

  FPosition := APosition;
  FAngle := AAngle;
  FUseCollistion := True;
  FRadius := 35;
  FMass := 1;
  FLife := 100;
  FViewRange := UNIT_VIEW_RANGE;
end;

function TBaseUnit.GetSideColor(ASide: TLifeFraction): Cardinal;
begin
  Result := $FFFFFFFF;
  case ASide of
    lfRed: Result := $FFFF2222;
    lfGreen: Result := $FF22FF22;
    lfBlue: Result := $FF2222FF;
  end;
end;

procedure TBaseUnit.OnCollide(OtherObject: TPhysicalObject);
begin
  if (OtherObject is TAsteroid) or
    (OtherObject is THeroShip) or
    (OtherObject is TBaseEnemy)
  then
    FShowShieldTime := 0.7;
end;

procedure TBaseUnit.OnUpdate(const ADelta: Double);
begin

  Inc(FCounter);
  if FCounter > 10 then
  begin
    FCounter := 0;
    if (FPosition - THeroShip.GetInstance.Position).LengthSqr < FLUID_GET_RANGE then
      FSeeHero := true;
  end;

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
