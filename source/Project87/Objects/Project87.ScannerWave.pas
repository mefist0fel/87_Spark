unit Project87.ScannerWave;

interface

uses
  Strope.Math,
  Project87.Types.GameObject;

type
  TScannerWave = class (TGameObject)
    private
      FLife: Single;
      FMaxLife: Single;
    public
      constructor CreateWave(const APosition, AVelocity: TVector2F; AAngle, ALife: Single);

      procedure OnDraw; override;
      procedure OnUpdate(const  ADelta: Double); override;
      procedure OnCollide(OtherObject: TPhysicalObject); override;
  end;

implementation

uses
  QEngine.Texture,
  Project87.Hero,
  Project87.BaseEnemy,
  Project87.Asteroid,
  Project87.Resources;

{$REGION '  TScannerWave  '}
constructor TScannerWave.CreateWave(const APosition, AVelocity: TVector2F; AAngle, ALife: Single);
begin
  inherited Create;
  FPreviosPosition := APosition;
  FPosition := APosition;
  FVelocity := AVelocity;
  FAngle := AAngle;
  FLife := ALife;
  FMaxLife := ALife;
end;

procedure TScannerWave.OnDraw;
var
  Size: Single;
begin
  Size := 2.2 - FLife / FMaxLife * 2;
  TheResources.WaveTexture.Draw(FPosition, TVector2F.Create(40 * Size, 10 * Size), FAngle, $FFFFFFFF);
end;

procedure TScannerWave.OnUpdate(const  ADelta: Double);
begin
  FLife := FLife - ADelta;
  if FLife < 0 then
    FIsDead := True;
end;

procedure TScannerWave.OnCollide(OtherObject: TPhysicalObject);
begin
  if (OtherObject is TAsteroid) then
  begin
    FIsDead := True;
    TAsteroid(OtherObject).Scan;
  end;
end;
{$ENDREGION}

end.
