unit Project87.Fluid;

interface

uses
  Strope.Math,
  Project87.Types.GameObject;

type
  TFluid = class (TGameObject)
    private
    public
      constructor CreateFluid(const APosition: TVector2F);

      procedure OnDraw; override;
      procedure OnUpdate(const  ADelta: Double); override;
  end;

implementation

uses
  QEngine.Texture,
  Project87.Hero,
  Project87.Resources;

{$REGION '  TFluid  '}
constructor TFluid.CreateFluid(const APosition: TVector2F);
begin
  inherited Create;
  FPosition := APosition;
end;

procedure TFluid.OnDraw;
begin
  TheResources.AsteroidTexture.Draw(FPosition, TVector2F.Create(10, 10), FAngle, $FFFFFF00);
end;

procedure TFluid.OnUpdate(const  ADelta: Double);
begin

end;
{
procedure TFluid.OnCollide(OtherObject: TPhysicalObject);
begin
  if (OtherObject is THero) then
    FVelocity := (OtherObject.Position - FPosition) * 5;
end;      }
{$ENDREGION}

end.
