unit Project87.Fluid;

interface

uses
  Strope.Math,
  Project87.Types.GameObject;

const
  FRICTION = 2.5;
  FLUID_TYPE_COUNT = 4;

type
  TFluidType = (
    fYellow = 0,
    fBlue = 1,
    fRed = 2,
    fGreen = 3
  );

  TFluid = class (TGameObject)
    private
      FType: TFluidType;
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
end;

procedure TFluid.OnCollide(OtherObject: TPhysicalObject);
begin
  if (OtherObject is THeroShip) then
  begin
    THeroShip(OtherObject).AddFluid(FType);
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
