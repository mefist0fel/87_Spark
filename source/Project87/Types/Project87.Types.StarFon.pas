unit Project87.Types.StarFon;

interface

uses
  Generics.Collections,
  QCore.Types,
  Strope.Math,
  QEngine.Core,
  QEngine.Texture,
  QEngine.Camera;

type
  TStarFon = class;

  TStar = class sealed
    private
      FPosition: TVectorF;
      FDepth: Single;
      FBrightness: Single;

      function IsOnScreen(): Boolean;
    public
      constructor Create(const APosition: TVectorF; ADepth, ABrightness: Single);

      procedure Draw(AOwner: TStarFon);

      property Position: TVectorF read FPosition write FPosition;
      property Depth: Single read FDepth;
  end;

  TStarFon = class sealed
    strict private
      class var FInstance: TStarFon;
      FStars: TList<TStar>;
      FCamera: IQuadCamera;
      FSprite: TQuadTexture;

      constructor Create;

      procedure Fill;
      function GetSprite(): TQuadTexture;

      class function GetInstance(): TStarFon; static;
    private
      property Sprite: TQuadTexture read GetSprite;
    public
      destructor Destroy; override;

      procedure Draw;
      procedure Shift(const ADelta: TVectorF);

      class property Instance: TStarFon read GetInstance;
  end;

implementation

uses
  direct3d9,
  QGame.Game,
  QGame.Resources;

{$REGION '  TStar  '}
constructor TStar.Create(const APosition: TVectorF;
  ADepth, ABrightness: Single);
begin
  FPosition := APosition;
  FDepth := ADepth;
  FBrightness := ABrightness;
end;

function TStar.IsOnScreen;
var
  ASPosition: TVectorF;
begin
  ASPosition := TheEngine.Camera.GetScreenPos(FPosition);
  if (ASPosition.X > 0 - 2) and (ASPosition.X < TheEngine.Camera.Resolution.X + 2) and
    (ASPosition.Y > 0 - 2) and (ASPosition.Y < TheEngine.Camera.Resolution.Y + 2)
  then
    Exit(True)
  else
    Exit(False);
end;

procedure TStar.Draw(AOwner: TStarFon);
begin
  if not IsOnScreen then
    Exit;

  AOwner.Sprite.Draw(
    FPosition, Vec2F(2, 2),
    0, D3DCOLOR_COLORVALUE(FBrightness, FBrightness, FBrightness, 1));
end;
{$ENDREGION}

{$REGION '  TStarFon  '}
const
  STARS_ON_FON = 12000;
  FON_SIZE = 2048;
  MIN_DEPTH = 1.2;
  MAX_DEPTH = 6;
  MIN_BRIGHTNESS = 0.4;
  MAX_BRIGHTNESS = 1.0;

constructor TStarFon.Create;
begin
  FStars := TList<TStar>.Create;
  FCamera := TheEngine.CreateCamera;
  FSprite :=
    (TheResourceManager.GetResource('Image', 'SystemEnemy') as TTextureExResource).Texture;

  Randomize;
  Fill;
end;

destructor TStarFon.Destroy;
var
  AStar: TStar;
begin
  for AStar in FStars do
    AStar.Free;
  FStars.Free;

  inherited;
end;

class function TStarFon.GetInstance;
begin
  if not Assigned(FInstance) then
    FInstance := TStarFon.Create;
  Result := FInstance;
end;

procedure TStarFon.Fill;
var
  I: Integer;
  AProgress: Single;
  APosition: TVectorF;
  ABrightness, ADepth: Single;
  AStar: TStar;
begin
  for I := 0 to STARS_ON_FON - 1 do
  begin
    AProgress := I / STARS_ON_FON;
    AProgress := Sqrt(AProgress);
    ADepth := MIN_DEPTH + (MAX_DEPTH - MIN_DEPTH) / AProgress;
    ABrightness := MIN_BRIGHTNESS + (MAX_BRIGHTNESS - MIN_BRIGHTNESS) * Random;
    APosition := Vec2F(1 - 2 * Random, 1 - 2 * Random) * FON_SIZE;
    AStar := TStar.Create(APosition, ADepth, ABrightness);
    FStars.Add(AStar);
  end;
end;

function TStarFon.GetSprite;
begin
  Result := FSprite;
end;

procedure TStarFon.Shift(const ADelta: TVector2F);
var
  AStar: TStar;
begin
  for AStar in FStars do
  begin
    AStar.Position := AStar.Position + ADelta * (1 / AStar.Depth);
    if AStar.Position.X > FON_SIZE then
      AStar.Position := Vec2F(AStar.Position.X - 2 * FON_SIZE, AStar.Position.Y);
    if AStar.Position.X < -FON_SIZE then
      AStar.Position := Vec2F(AStar.Position.X + 2 * FON_SIZE, AStar.Position.Y);
    if AStar.Position.Y > FON_SIZE then
      AStar.Position := Vec2F(AStar.Position.X, AStar.Position.Y - 2 * FON_SIZE);
    if AStar.Position.Y < -FON_SIZE then
      AStar.Position := Vec2F(AStar.Position.X, AStar.Position.Y + 2 * FON_SIZE);
  end;
end;

procedure TStarFon.Draw;
var
  I: Integer;
begin
  TheEngine.Camera := FCamera;
  for I := FStars.Count - 1 downto 0 do
    FStars[I].Draw(Self);
end;
{$ENDREGION}

end.
