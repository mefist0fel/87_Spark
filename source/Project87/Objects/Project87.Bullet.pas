unit Project87.Bullet;

interface

uses
  Strope.Math,
  Project87.Types.GameObject;

type
  TBullet = class (TGameObject)
    private
      FLife: Single;
    public
      constructor CreateBullet(const APosition, AVelocity: TVector2F; AAngle: Single; ALife: Single);

      procedure OnDraw; override;
      procedure OnUpdate(const  ADelta: Double); override;
  end;

implementation

uses
  QEngine.Texture,
  Project87.Hero,
  Project87.Resources;

{$REGION '  TBullet  '}
constructor TBullet.CreateBullet(const APosition, AVelocity: TVector2F; AAngle: Single; ALife: Single);
begin
  inherited Create;
  FPosition := APosition;
  FVelocity := AVelocity;
  FAngle := AAngle;
  FLife := ALife;
end;

procedure TBullet.OnDraw;
begin
  TheResources.AsteroidTexture.Draw(FPosition, TVector2F.Create(4, 24), FAngle, $FFFFFFFF);
end;

procedure TBullet.OnUpdate(const  ADelta: Double);
begin
  FLife := FLife - ADelta;
  if FLife < 0 then
    Free;
end;
{$ENDREGION}

end.
