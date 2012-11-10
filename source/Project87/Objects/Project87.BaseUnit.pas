unit Project87.BaseUnit;

interface

uses
  QGame.Scene,
  Strope.Math,
  Project87.Types.GameObject;

type
  TUnitSide = ( //ship races
    usNeutral,
    usHero,
    usRed,
    usGreen,
    usBlue
  );

  TBaseUnit = class (TPhysicalObject)
    protected
      FSide: TUnitSide;
      FTowerAngle: Single;
      FShowShieldTime: Single;
      FLife: Single;
      function GetSideColor(ASide: TUnitSide): Cardinal;
    public
      constructor CreateUnit(const APosition: TVector2F; AAngle: Single; ASide: TUnitSide); virtual;

      procedure OnUpdate(const ADelta: Double); override;
      procedure OnCollide(OtherObject: TPhysicalObject); override;
      procedure Hit(ADamage: Single); virtual;
      procedure Kill; virtual;
  end;

implementation

uses
  Project87.Resources,
  Project87.Asteroid,
  Project87.BaseEnemy,
  Project87.Hero;

{$REGION '  TBaseUnit  '}
constructor TBaseUnit.CreateUnit(const APosition: TVector2F; AAngle: Single; ASide: TUnitSide);
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
  Result := $ffffffff;
  case ASide of
    usNeutral: ;
    usHero: Result := $ffffffff;
    usRed: Result := $ffff2222;
    usGreen: Result := $ff22ff22;
    usBlue: Result := $ff2222ff;
  end;
end;

procedure TBaseUnit.OnCollide(OtherObject: TPhysicalObject);
begin
  if FIsDead then
    Exit;

  if (OtherObject is TAsteroid) or (OtherObject is THero) or (OtherObject is TBaseEnemy) then
  begin
    FShowShieldTime := 0.7;
  end;
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
  //Вообще возможен более сложный сценарий, например установить другой флаг.
  //Такой, что объект уже не колайдится, но на его месте ещё рисуется взрыв.
  FIsDead := True;
end;
{$ENDREGION}

end.
