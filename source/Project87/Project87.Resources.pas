unit Project87.Resources;

interface

uses
  QEngine.Core,
  QEngine.Texture,
  QEngine.Font;

type
  TResources = class
    public
      HeroTexture: TQuadTexture;
      AsteroidTexture: TQuadTexture;
      Font: TQuadFont;

      constructor Create;
      destructor Destroy; override;
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

  Font := TheEngine.CreateFont;
  Font.LoadFromFile('..\data\fnt\droid_sans_bold_28.png', '..\data\fnt\droid_sans_bold_28.qef');
end;

destructor TResources.Destroy;
begin
  HeroTexture.Free;
  AsteroidTexture.Free;
  Font.Free;

  TheResources := nil;

  inherited;
end;
{$ENDREGION}

end.
