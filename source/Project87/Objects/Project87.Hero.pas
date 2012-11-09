unit Project87.Hero;

interface

uses
  QEngine.Camera,
  QEngine.Texture,
  QGame.Scene,
  Strope.Math,
  Project87.Types.GameObject;

type
  THero = class (TGameObject)
    private
      FTowerAngle: Single;
      FNeedCameraPosition: TVector2F;
    public
      constructor Create( APosition: TVector2F);

      procedure OnDraw; override;
      procedure OnUpdate(const  ADelta: Double); override;
  end;

implementation

uses
  QuadEngine,
  QEngine.Core,
  QApplication.Application,
  Project87.Resources;

{$REGION '  THero  '}
constructor THero.Create( APosition: TVector2F);
begin
  FPosition := APosition;
  inherited Create;
end;

procedure THero.OnDraw;
begin
  TheResources.HeroTexture.Draw(FPosition, TVector2F.Create(50, 50), FAngle, $FFFFFFFF);
  TheResources.HeroTexture.Draw(FPosition, TVector2F.Create(50, 50), FTowerAngle, $FFFFFFFF);
end;

procedure THero.OnUpdate(const  ADelta: Double);
var
  MousePosition: TVector2F;
begin
  MousePosition := TheEngine.Camera.GetWorldPos(TheControlState.Mouse.Position);
  FTowerAngle := AngleBetween(FPosition, MousePosition);
  FNeedCameraPosition := MousePosition * 0.5;
  TheEngine.Camera.Position := TheEngine.Camera.Position * (0.9 - ADelta) + FNeedCameraPosition * (0.1 + ADelta);
end;
{$ENDREGION}

end.
