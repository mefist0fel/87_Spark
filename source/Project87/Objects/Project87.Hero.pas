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

    public
      constructor Create( APosition: TVector2F);
      procedure OnDraw; override;
      procedure OnUpdate(const  ADelta: Double); override;
  end;

implementation

uses
  Project87.Resources;

{$REGION '  THero'}
constructor THero.Create( APosition: TVector2F);
begin
  FPosition := APosition;
  inherited Create;
end;

procedure THero.OnDraw;
begin
  TheResources.HeroTexture.Draw(FPosition, 0, 0);
end;

procedure THero.OnUpdate(const  ADelta: Double);
begin

end;

{$ENDREGION}

end.
