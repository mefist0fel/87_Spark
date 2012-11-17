unit Project87.Resources;

interface

uses
  QEngine.Core,
  QEngine.Texture,
  QEngine.Font;

type
  TGameResources = class
    public
      HeroTexture: TQuadTexture;
      SmallEnemyTexture: TQuadTexture;
      MeduimEnemyTexture: TQuadTexture;
      BigEnemyTexture: TQuadTexture;
      RocketTexture: TQuadTexture;
      AsteroidTexture: TQuadTexture;
      FluidTexture: TQuadTexture;
      Font: TQuadFont;

      constructor Create;
      destructor Destroy; override;
  end;

var
  TheResources: TGameResources = nil;

implementation

{$REGION '  TResources  '}
constructor TGameResources.Create;
begin
  TheResources := Self;

  HeroTexture := TheEngine.CreateTexture;
  HeroTexture.LoadFromFile('..\data\gfx\game_elements\ship.png', 0);

  AsteroidTexture := TheEngine.CreateTexture;
  AsteroidTexture.LoadFromFile('..\data\gfx\asteroid.png', 0);

  FluidTexture := TheEngine.CreateTexture;
  FluidTexture.LoadFromFile('..\data\gfx\fluid.png', 0);

  SmallEnemyTexture := TheEngine.CreateTexture;
  SmallEnemyTexture.LoadFromFile('..\data\gfx\game_elements\enemy_small.png', 0);

  MeduimEnemyTexture := TheEngine.CreateTexture;
  MeduimEnemyTexture.LoadFromFile('..\data\gfx\game_elements\enemy_medium.png', 0);

  BigEnemyTexture := TheEngine.CreateTexture;
  BigEnemyTexture.LoadFromFile('..\data\gfx\game_elements\enemy_big.png', 0);

  RocketTexture := TheEngine.CreateTexture;
  RocketTexture.LoadFromFile('..\data\gfx\game_elements\rockets.png', 0, 512, 64);

  Font := TheEngine.CreateFont;
  Font.LoadFromFile('..\data\fnt\droid_sans_bold_28.png', '..\data\fnt\droid_sans_bold_28.qef');
end;

destructor TGameResources.Destroy;
begin
  HeroTexture.Free;
  AsteroidTexture.Free;
  FluidTexture.Free;
  Font.Free;

  TheResources := nil;

  inherited;
end;
{$ENDREGION}

end.
