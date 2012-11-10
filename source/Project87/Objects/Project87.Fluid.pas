unit Project87.Fluid;

interface

uses
  QEngine.Camera,
  QEngine.Texture,
  QGame.Scene,
  Strope.Math,
  Project87.Types.GameObject;

type
  TFluid = class (TGameObject)
    private
    public
      constructor CreateFluid(const APosition: TVector2F);
      procedure OnDraw; override;
      procedure OnUpdate(const  ADelta: Double); override;
      procedure OnCollide(OtherObject: TGameObject); override;
  end;

implementation

uses
  Project87.Hero,
  Project87.Resources;

{$REGION '  TAsteroid  '}
constructor TFluid.CreateFluid(const APosition: TVector2F);
begin
  inherited Create;
  FPosition := APosition;
  FRadius := 100;
  FUseCollistion := False;
end;

procedure TFluid.OnDraw;
begin
  TheResources.AsteroidTexture.Draw(FPosition, TVector2F.Create(10, 10), FAngle, $ffffff00);
end;

procedure TFluid.OnUpdate(const  ADelta: Double);
begin
  if Random(100) = 0 then
    FVelocity := Vector2F(Random(100) - 50, Random(100) - 50);
end;

procedure TFluid.OnCollide(OtherObject: TGameObject);
begin
  if (OtherObject is THero) then
    FVelocity := (OtherObject.Position - FPosition) * 5;
end;
{$ENDREGION}

end.
