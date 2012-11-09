unit Project87.Resources;

interface

uses
  QEngine.Core,
  QEngine.Texture;

type
  TResources = class
    public
      HeroTexture: TQuadTexture;
      AsteroidTexture: TQuadTexture;
      constructor Create;
      destructor Destroy;
  end;

var
  TheResources: TResources = nil;

implementation

{$REGION '  TResources  '}
constructor TResources.Create;
begin
  TheResources := Self;

  HeroTexture := TheEngine.CreateTexture;
  HeroTexture.LoadFromFile('..\data\gfx\quad.png', 0);
  AsteroidTexture := TheEngine.CreateTexture;
  AsteroidTexture.LoadFromFile('..\data\gfx\asteroid.png', 0);

  inherited;
end;

destructor TResources.Destroy;
begin
  HeroTexture.Destroy;
  AsteroidTexture.Destroy;
  inherited;
end;
{$ENDREGION}

end.
