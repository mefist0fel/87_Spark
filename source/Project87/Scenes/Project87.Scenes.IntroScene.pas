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
      FGearImages: array [0..4] of TQuadTexture;
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
  ACenter: TVectorF;
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

    //RotationAngle:= RotationAngle + RotationSpeed;
    //GiantAngle:= RotationAngle / 213.9 - Trunc((RotationAngle / 213.9) / (20.2)) * (20.2);
    //Задние темные шестерни
    {BigGear.DrawRot(CenterX + 181, CenterY - 83 , -RotationAngle / 24  -  4, 0.5, $ff202020);
    MedGear.DrawRot(CenterX + 181, CenterY - 167,  RotationAngle / 14   + 8, 0.5, $ff202020);
    BigGear.DrawRot(CenterX + 221, CenterY - 241, -RotationAngle / 24  -  4, 0.5, $ff202020);
    Gear.DrawRot   (CenterX + 106, CenterY - 83 ,  RotationAngle / 8   + 10, 0.5, $ff202020);
    BigGear.DrawRot(CenterX + 42 , CenterY - 44 , -RotationAngle / 24  -  0, 0.5, $ff202020);
    //Основные шестерни
    Gear.DrawRot   (CenterX - 246, CenterY -  83,  RotationAngle / 8  -  4 , 1  , $ff888888);
    MedGear.DrawRot(CenterX - 192, CenterY      , -RotationAngle / 14 + 15 , 1  , $ff767676);
    MedGear.DrawRot(CenterX - 125, CenterY + 157,  RotationAngle / 24      , 1.2, $ff323232);
    BigGear.DrawRot(CenterX +   5, CenterY - 02,  -RotationAngle /(288/7)+2, 1.2, $ff2a2a2a);
    BigGear.DrawRot(CenterX - 125, CenterY + 157,  RotationAngle / 24      , 1  , $ff444444);
    //Большая шестерня справа
    GiantGear.DrawRot(CenterX - 1300, CenterY, -GiantAngle + 10.6, 1, $ff555555);
    //Ось балансира
    Quad.Rectangle(CenterX - 129, CenterY - 240, CenterX - 121, CenterY - 32, $ff222233);
    //Логотип
    Logo.Draw(CenterX - Logo.GetSpriteWidth / 2, CenterY - Logo.GetSpriteHeight / 2);
    //Балансир
    Balance.DrawFrame(CenterX - 189, CenterY - 160, Trunc(RotationAngle / RotationSpeed / 2) mod 16, $ff555555);}
    FBalancer.Draw(TVectorF.Create(-160, -126), ABalancerSize,
      0, FBalancerFrame, $FF555555);
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
  FRotationSpeed := 0;
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
  if FRotationAngle > 360 then
    FRotationAngle := FRotationAngle - 360;
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
  FreeAndNil(FGearImages[3]);
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
  FGearImages[3] := TheEngine.CreateTexture;
  FGearImages[3].LoadFromFile(AGfxDir + 'gear_giant.png', 0);
  FQuadLogo := TheEngine.CreateTexture;
  FQuadLogo.LoadFromFile(AGfxDir + 'quad_logo.png', 0);
  FIgdcLogo := TheEngine.CreateTexture;
  FIgdcLogo.LoadFromFile(AGfxDir + 'igdc.png', 0);
end;
{$ENDREGION}

end.
