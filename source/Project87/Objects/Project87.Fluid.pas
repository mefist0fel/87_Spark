unit Project87.Fluid;

interface

uses
  Strope.Math,
  Project87.Types.GameObject;

const
  FRICTION = 2.5;
  FLUID_TYPE_COUNT = 3;

type
  TFluidType = (
    fYellow = 0,
    fBlue   = 1,
    fRed    = 2,
    fGreen  = 3
  );

  TFluid = class (TGameObject)
    private
      FType: TFluidType;
    public
      constructor CreateFluid(const APosition: TVector2F; AType: TFluidType = fYellow);

      procedure OnDraw; override;
      procedure OnUpdate(const  ADelta: Double); override;
      procedure OnCollide(OtherObject: TPhysicalObject); override;
    public class procedure EmmitFluids(Count: Byte; APosition: TVector2F; AType: TFluidType = fYellow);
  end;

implementation

uses
  QEngine.Texture,
  Project87.Hero,
  Project87.Resources;

{$REGION '  TFluid  '}
constructor TFluid.CreateFluid(const APosition: TVector2F; AType: TFluidType = fYellow);
begin
  inherited Create;
  FType := AType;
  FPosition := APosition;
end;

procedure TFluid.OnDraw;
begin
  case FType of
    fYellow: TheResources.FluidTexture.Draw(FPosition, TVector2F.Create(8, 8), FAngle, $FFFFFF00);
    fBlue: TheResources.FluidTexture.Draw(FPosition, TVector2F.Create(8, 8), FAngle, $FF00FF00);
    fRed: TheResources.FluidTexture.Draw(FPosition, TVector2F.Create(8, 8), FAngle, $FFFF0000);
    fGreen: TheResources.FluidTexture.Draw(FPosition, TVector2F.Create(8, 8), FAngle, $FF0000FF);
  end;

end;

procedure TFluid.OnUpdate(const  ADelta: Double);
begin
  FVelocity := FVelocity * (1 - ADelta * FRICTION);
end;

procedure TFluid.OnCollide(OtherObject: TPhysicalObject);
begin
  if (OtherObject is THero) then
  begin
    THero(OtherObject).AddFluid(FType);
    FIsDead := True;
  end;
end;

class procedure TFluid.EmmitFluids(Count: Byte; APosition: TVector2F; AType: TFluidType = fYellow);
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
