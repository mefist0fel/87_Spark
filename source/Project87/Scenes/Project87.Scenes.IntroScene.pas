unit Project87.Scenes.IntroScene;

interface

uses
  QCore.Types,
  QCore.Input,
  QGame.Scene,
  QEngine.Camera,
  QEngine.Texture,
  Strope.Math;

type
  TIntroScene = class sealed (TScene)
    strict private
      FCamera: IQuadCamera;
      FBalancer: TQuadTexture;
      FGearImages: array [0..2] of TQuadTexture;
      FQuadLogo: TQuadTexture;
      FIgdcLogo: TQuadTexture;

      FBalancerFrame: Integer;
      FBalancerTime: Single;

      FRotationAngle: Single;
      FRotationSpeed: Single;

      procedure DrawQuadLogo;
      procedure DrawIgdcLogo;

      property Camera: IQuadCamera read FCamera;
  private
    procedure LoadImages;
    public
      constructor Create(const AName: string);
      destructor Destroy; override;

      procedure OnInitialize(AParameter: TObject = nil); override;
      procedure OnDraw(const ALayer: Integer); override;
      procedure OnUpdate(const ADelta: Double); override;
      procedure OnDestroy; override;

      function OnKeyDown(AKey: TKeyButton): Boolean; override;
  end;

implementation

uses
  Math,
  SysUtils,
  QuadEngine,
  QApplication.Application,
  QEngine.Core;

{$REGION '  TIntroScene  '}
const
  BALANCER_FRAME_DELTA = 0.02;

constructor TIntroScene.Create(const AName: string);
begin
  inherited Create(AName);
end;

destructor TIntroScene.Destroy;
begin
  inherited;
end;

procedure TIntroScene.DrawQuadLogo;
var
  ALogoSize: TVectorF;
  ABalancerSize: TVectorF;
  ASize: Single;
begin
  TheEngine.Camera := nil;
    TheRender.RectangleEx(0, 0, Camera.Resolution.X, Camera.Resolution.Y,
      $FF000000, $FF000080, $FF000000, $FF000000);

  TheEngine.Camera := Camera;
    ASize := Camera.DefaultResolution.Y * 0.853;
    ALogoSize.Create(ASize, ASize);

    ASize := Camera.DefaultResolution.Y * 0.213;
    ABalancerSize.Create(ASize, ASize);

    FGearImages[2].Draw(Vec2F(181, -83) * 1.28, Vec2F(256, 256) * 1.28 * 0.5,
      -FRotationAngle / 24 - 4, $FF202020);
    FGearImages[1].Draw(Vec2F(181, -167) * 1.28, Vec2F(128, 128) * 1.28 * 0.5,
      FRotationAngle / 14 + 8, $FF202020);
    FGearImages[2].Draw(Vec2F(221, -241) * 1.28, Vec2F(256, 256) * 1.28 * 0.5,
      -FRotationAngle / 24 - 4, $FF202020);
    FGearImages[0].Draw(Vec2F(106, -83) * 1.28, Vec2F(128, 128) * 1.28 * 0.5,
      FRotationAngle / 8 + 10, $FF202020);
    FGearImages[2].Draw(Vec2F(42, -44) * 1.28, Vec2F(256, 256) * 1.28 * 0.5,
      -FRotationAngle / 24, $FF202020);

    FGearImages[0].Draw(Vec2F(-314.88, 106.24), Vec2F(163.84, 163.84),
      FRotationAngle / 8 - 4, $FF888888);
    FGearImages[1].Draw(Vec2F(-245.76, 0), Vec2F(163.84, 163.84),
      -FRotationAngle / 14 + 15, $FF767676);
    FGearImages[1].Draw(Vec2F(-160, 201), Vec2F(163.84, 163.84) * 1.2,
      FRotationAngle / 24, $FF323232);
    FGearImages[2].Draw(Vec2F(6.4, -1), Vec2F(328, 328) * 1.2,
      -FRotationAngle / (288/7) + 2.8, $FF2A2A2A);
    FGearImages[2].Draw(Vec2F(-160, 201), Vec2F(328, 328),
      FRotationAngle / 24, $FF444444);

    TheRender.Rectangle(-164, -307, -156, -40, $FF222233);
    FBalancer.Draw(Vec2F(-160, -126), ABalancerSize, 0, $FF555555, FBalancerFrame);

    FQuadLogo.Draw(ZeroVectorF, ALogoSize, 0, $FFFFFFFF);
end;

procedure TIntroScene.DrawIgdcLogo;
begin

end;

{$REGION '  Base Actions  '}
procedure TIntroScene.OnInitialize(AParameter: TObject = nil);
begin
  FCamera := TheEngine.CreateCamera;
  FCamera.Position := ZeroVectorF;

  LoadImages;

  FBalancerFrame := 0;
  FBalancerTime := 0;

  FRotationAngle := 0;
  FRotationSpeed := 360;
end;

procedure TIntroScene.OnDraw(const ALayer: Integer);
begin
  TheRender.SetBlendMode(qbmSrcAlpha);
  DrawQuadLogo;
end;

procedure TIntroScene.OnUpdate(const ADelta: Double);
begin
  FBalancerTime := FBalancerTime + ADelta;
  if FBalancerTime > BALANCER_FRAME_DELTA then
  begin
    FBalancerTime := 0;
    FBalancerFrame := (FBalancerFrame + 1) mod FBalancer.FramesCount;
  end;

  FRotationAngle := FRotationAngle + FRotationSpeed * ADelta;
end;

procedure TIntroScene.OnDestroy;
begin
  FCamera := nil;
  FreeAndNil(FQuadLogo);
  FreeAndNil(FIgdcLogo);
  FreeAndNil(FBalancer);
  FreeAndNil(FGearImages[0]);
  FreeAndNil(FGearImages[1]);
  FreeAndNil(FGearImages[2]);
end;
{$ENDREGION}

function TIntroScene.OnKeyDown(AKey: Word): Boolean;
begin
  Result := True;
  if AKey = KB_SPACE then
  begin
    TheApplication.Stop;
  end;
end;

procedure TIntroScene.LoadImages;
const
  AGfxDir = '..\data\gfx\logo_elements\';
begin
  FBalancer := TheEngine.CreateTexture;
  FBalancer.LoadFromFile(AGfxDir + 'balancer.png', 0, 128, 128);
  FGearImages[0] := TheEngine.CreateTexture;
  FGearImages[0].LoadFromFile(AGfxDir + 'gear.png', 0);
  FGearImages[1] := TheEngine.CreateTexture;
  FGearImages[1].LoadFromFile(AGfxDir + 'gear_med.png', 0);
  FGearImages[2] := TheEngine.CreateTexture;
  FGearImages[2].LoadFromFile(AGfxDir + 'gear_big.png', 0);
  FQuadLogo := TheEngine.CreateTexture;
  FQuadLogo.LoadFromFile(AGfxDir + 'quad_logo.png', 0);
  FIgdcLogo := TheEngine.CreateTexture;
  FIgdcLogo.LoadFromFile(AGfxDir + 'igdc.png', 0);
end;
{$ENDREGION}

end.
