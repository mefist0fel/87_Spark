unit Project87.Scenes.TestScene;

interface

uses
  QCore.Input,
  QEngine.Camera,
  QEngine.Texture,
  QGame.Scene,
  Strope.Math;

type
  TTestScene = class sealed (TScene)
    strict private
      FTestCamera: IQuadCamera;
      FImage: TQuadTexture;
    public
      constructor Create(const AName: string);
      destructor Destroy; override;

      procedure OnInitialize(AParameter: TObject = nil); override;
      procedure OnDraw(const ALayer: Integer); override;
  end;

implementation

uses
  QuadEngine,
  QEngine.Core;

{$REGION '  TTestScene  '}
constructor TTestScene.Create(const AName: string);
begin
  inherited Create(AName);
end;

destructor TTestScene.Destroy;
begin
  inherited;
end;

procedure TTestScene.OnInitialize(AParameter: TObject);
begin
  FTestCamera := TheEngine.CreateCamera;
  FImage := TheEngine.CreateTexture;
  FImage.LoadFromFile('..\data\gfx\miku.png', 0, 128, 128);
end;

procedure TTestScene.OnDraw(const ALayer: Integer);
begin
  TheRender.Clear($FF000000);
  TheRender.SetBlendMode(qbmSrcAlpha);
  TheEngine.Camera := FTestCamera;
  FTestCamera.CenterPosition := TVectorF.Create(0, 0);
  FImage.Draw(TVectorF.Create(0, 0), 0.0, $FFFFFFFF);
end;
{$ENDREGION}

end.
