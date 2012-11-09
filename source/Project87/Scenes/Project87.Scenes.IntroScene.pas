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
  TIntroSceneState = (
    issNone = 0,
    issFirstWait = 1,
    issShowUp = 2,
    issWait = 3,
    issShowDown = 4,
    issChange = 5
  );

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

      FState: TIntroSceneState;
      FLogo: Integer;
      FAlpha: Single;
      FTime: Single;
      FIsToMenu: Boolean;

      procedure LoadImages;
      procedure DrawQuadLogo;
      procedure DrawIgdcLogo;

      property Camera: IQuadCamera read FCamera;
    public
      constructor Create(const AName: string);
      
      procedure OnInitialize(AParameter: TObject = nil); override;
      procedure OnDraw(const ALayer: Integer); override;
      procedure OnUpdate(const ADelta: Double); override;
      procedure OnDestroy; override;

      function OnKeyDown(AKey: TKeyButton): Boolean; override;
  end;

implementation

uses
  SysUtils,
  QuadEngine,
  direct3d9,
  QEngine.Core,
  QGame.Game;

{$REGION '  TIntroScene  '}
const
  BALANCER_FRAME_DELTA = 0.02;
  TIME_FIRST_WAIT = 1.2;
  TIME_SHOWUP = 1.3;
  TIME_WAIT = 3.5;
  TIME_SHOWDOWN = 1.3;
  TIME_CHANGE = 0.25;

constructor TIntroScene.Create(const AName: string);
begin
  inherited Create(AName);

  FAlpha := 1;
end;

procedure TIntroScene.DrawQuadLogo;
var
  ALogoSize: TVectorF;
  ABalancerSize: TVectorF;
  ASize: Single;
begin
  TheEngine.Camera := nil;
  TheRender.RectangleEx(0, 0, Camera.Resolution.X, Camera.Resolution.Y,
    $FF000000, $FF000060, $FF000000, $FF000000);

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
  TheEngine.Camera := nil;
  TheRender.Rectangle(0, 0, Camera.Resolution.X, Camera.Resolution.Y, $FF000000);

  TheEngine.Camera := Camera;
  FIgdcLogo.Draw(ZeroVectorF, Vec2F(720, 720), 0, $FFFFFFFF);
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

  FAlpha := 1;
  FState := issFirstWait;
  FTime := 0;
end;

procedure TIntroScene.OnDraw(const ALayer: Integer);
begin
  TheRender.SetBlendMode(qbmSrcAlpha);

  case FLogo of
    0: DrawQuadLogo;
    1: DrawIgdcLogo;
  end;

  TheEngine.Camera := nil;
  TheRender.Rectangle(0, 0, Camera.Resolution.X, Camera.Resolution.Y,
    D3DCOLOR_COLORVALUE(0, 0, 0, FAlpha));
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

  FTime := FTime + ADelta;
  case FState of
    issFirstWait:
      if FTime > TIME_FIRST_WAIT then
      begin
        FState := issShowUp;
        FTime := 0;
      end;

    issShowUp:
      begin
        FAlpha := InterpolateValue(1, 0, FTime / TIME_SHOWUP, itHermit01);
        if FTime > TIME_SHOWUP then
        begin
          FState := issWait;
          FTime := 0;
          FAlpha := 0;
        end;
      end;

    issWait:
      if FTime > TIME_WAIT then
      begin
        FState := issShowDown;
        FTime := 0;
      end;

    issShowDown:
      begin
        FAlpha := InterpolateValue(0, 1, FTime / TIME_SHOWDOWN, itHermit01);
        if FTime > TIME_SHOWDOWN then
        begin
          FState := issChange;
          FTime := 0;
          FAlpha := 1;
        end;
      end;

    issChange:
      begin
        if FIsToMenu then
        begin
          TheGame.SceneManager.MakeCurrent('Spark');
          TheGame.SceneManager.OnInitialize;
          Exit;
        end;

        if FTime > TIME_CHANGE then
        begin
          FState := issShowUp;
          Inc(FLogo);
          if FLogo = 2 then
          begin
            TheGame.SceneManager.MakeCurrent('Spark');
            TheGame.SceneManager.OnInitialize;
          end;
        end;
      end;
  end;
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
  if AKey in [KB_SPACE, KB_ENTER] then
  begin
    case FState of
      issFirstWait:
        begin
          FState := issChange;
          FTime := 0;
        end;

      issShowUp:
        begin
          FState := issShowDown;
          FTime := (1 - FTime / TIME_SHOWUP) * TIME_SHOWDOWN;
        end;

      issWait:
        begin
          FState := issShowDown;
          FTime := 0;
        end;

      issChange: FTime := 0;
    end;
    FIsToMenu := True;
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
  FIgdcLogo.LoadFromFile(AGfxDir + 'igdc.jpg', 0);
end;
{$ENDREGION}

end.
