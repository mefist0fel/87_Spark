unit Project87.GameObject;

interface

uses
  QEngine.Camera,
  QEngine.Texture,
  QGame.Scene,
  Strope.Math;

type
  TGameObject = class
    private
      FPosition: TVector2F;
      FVelocity: TVector2F;
    public
      procedure OnDraw; virtual;
      procedure OnUpdate(const  ADelta: Double); virtual;
  end;

implementation

{$REGION '  TGameObject'}
procedure TGameObject.OnDraw;
begin

end;

procedure TGameObject.OnUpdate(const  ADelta: Double);
begin

end;
{$ENDREGION}

end.
