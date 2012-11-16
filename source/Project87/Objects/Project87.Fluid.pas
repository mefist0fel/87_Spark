unit Project87.Fluid;

interface

uses
  Strope.Math,
  Project87.Types.GameObject;

const
  FRICTION = 2.5;
  FLUID_TYPE_COUNT = 4;
  FLUID_GET_RANGE = 180 * 180;
  FLUID_AUTO_GET_SPEED = 35;

type
  TFluidType = (
    fYellow = 0,
    fGreen = 1,
    fBlue = 2,
    fRed = 3
  );

  TFluid = class (TGameObject)
    private
      FType: TFluidType;
      FCounter: Byte;
      FCanGetByHero: Boolean;
    public
      constructor CreateFluid(const APosition: TVector2F;
        AType: TFluidType = fYellow); overload;
      constructor CreateFluid(const APosition, AVelocity: TVector2F;
        AType: TFluidType = fYellow); overload;

      procedure OnDraw; override;
      procedure OnUpdate(const  ADelta: Double); override;
      procedure OnCollide(OtherObject: TPhysicalObject); override;

      class procedure EmmitFluids(Count: Byte; APosition: TVector2F;
        AType: TFluidType = fYellow);
  end;

implementation

uses
  QEngine.Texture,
  Project87.Hero,
  Project87.Resources;

{$REGION '  TFluid  '}
constructor TFluid.CreateFluid(const APosition: TVector2F;
  AType: TFluidType = fYellow);
begin
  inherited Create;
  FCanGetByHero := False;
  FType := AType;
  FPreviosPosition := APosition;
  FPosition := APosition;
end;

constructor TFluid.CreateFluid(const APosition, AVelocity: TVector2F;
  AType: TFluidType = fYellow);
begin
  inherited Create;

  FType := AType;
  FPosition := APosition;
  FVelocity := AVelocity;
end;

procedure TFluid.OnDraw;
var
  Color: Cardinal;
begin
  Color := $FFFFFFFF;
  case FType of
    fYellow: Color := $FFFFFF00;
    fBlue:   Color := $FF00FF00;
    fRed:    Color := $FFFF0000;
    fGreen:  Color := $FF0000FF;
  end;
  TheResources.FluidTexture.Draw(FPosition, Vec2F(8, 8), FAngle, Color);
end;

procedure TFluid.OnUpdate(const  ADelta: Double);
begin
  FVelocity := FVelocity * (1 - ADelta * FRICTION);
  Inc(FCounter);
  if FCounter > 10 then
  begin
    FCounter := 0;
    if (FPosition - THeroShip.GetInstance.Position).LengthSqr < FLUID_GET_RANGE then
      FCanGetByHero := true;
  end;
  if FCanGetByHero then
    FVelocity := FVelocity + GetRotatedVector(GetAngle(FPosition, THeroShip.GetInstance.Position), FLUID_AUTO_GET_SPEED);
end;

procedure TFluid.OnCollide(OtherObject: TPhysicalObject);
begin
  if (OtherObject is THeroShip) then
  begin
    THero.GetInstance.AddFluid(FType);
    FIsDead := True;
  end;
end;

class procedure TFluid.EmmitFluids(Count: Byte; APosition: TVector2F;
  AType: TFluidType = fYellow);
var
  I: Byte;
  Fluid: TFluid;
begin
  for I := 0 to Count do
  begin
    Fluid := TFluid.CreateFluid(APosition, AType);
    Fluid.FVelocity := Vec2F(Random(200) - 100, Random(200) - 100);
  end;
end;
{$ENDREGION}

end.
