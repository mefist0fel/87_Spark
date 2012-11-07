unit Project87.Resources;

interface

uses
  QEngine.Core,
  QEngine.Texture;

type
  TResources = class
    public
      HeroTexture: TQuadTexture;
      constructor Create;
      destructor Destroy;
  end;

var
  TheResources: TResources;

implementation

{$REGION '  TResources'}
constructor TResources.Create;
begin
  TheResources := Self;
  HeroTexture := TheEngine.CreateTexture;
  HeroTexture.LoadFromFile('..\data\gfx\miku.png', 0, 128, 128);
  inherited;
end;

destructor TResources.Destroy;
begin
  HeroTexture := nil;
  inherited;
end;
{$ENDREGION}

end.
