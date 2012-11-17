unit Project87.Types.HeroInterface;

interface

Uses
  QEngine.Camera,
  QEngine.Core,
  QEngine.Font,
  Project87.Hero;

type
  THeroInterface = class
    private
      FVisibility: Single;
      FHero: THero;
      FGUICamera: IQuadCamera;
      FFont: TQuadFont;
    public
      constructor Create(AHero: THero);
      procedure OnDraw;
  end;

implementation

uses
  SysUtils,
  Strope.Math,
  QGame.Game,
  QGame.Resources;

{$REGION '  THeroInterface  '}
constructor THeroInterface.Create(AHero: THero);
begin
  FHero := AHero;
  FGUICamera := TheEngine.CreateCamera;
  FFont := (TheResourceManager.GetResource('Font', 'Quad_24') as TFontExResource).Font;
end;

procedure THeroInterface.OnDraw;
var
  LineAPosition,
  LineBPosition: TVectorF;
begin
  TheEngine.Camera := FGUICamera;
  LineAPosition := FGUICamera.GetWorldPos(Vec2F(24, 10));
  LineBPosition := FGUICamera.GetWorldPos(Vec2F(24 + FHero.Life * 3, 20));
  TheRender.Rectangle(LineAPosition.X, LineAPosition.Y, LineBPosition.X, LineBPosition.Y, $5000FF00);
  LineAPosition := FGUICamera.GetWorldPos(Vec2F(20, 24));
  LineBPosition := FGUICamera.GetWorldPos(Vec2F(20 + FHero.Energy * 300, 34));
  TheRender.Rectangle(LineAPosition.X, LineAPosition.Y, LineBPosition.X, LineBPosition.Y, $500000FF);
  FFont.TextOut(IntToStr(FHero.Fluid[0]), FGUICamera.GetWorldPos(Vec2F(16, 38)),
    1, $FFFFFF00);
  FFont.TextOut(IntToStr(FHero.Fluid[1]), FGUICamera.GetWorldPos(Vec2F(14, 63)),
    1, $FF0000FF);
  FFont.TextOut(IntToStr(FHero.Fluid[3]), FGUICamera.GetWorldPos(Vec2F(12, 88)),
    1, $FFFF0000);
  FFont.TextOut(IntToStr(FHero.Fluid[2]), FGUICamera.GetWorldPos(Vec2F(10, 113)),
    1, $FF00FF00);
  FFont.TextOut(IntToStr(FHero.Rockets), FGUICamera.GetWorldPos(Vec2F(9, 138)),
    1, $FFFFFFFF);
end;
{$ENDREGION}

end.
