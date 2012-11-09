unit QEngine.Texture;

interface

uses
  QuadEngine,
  QCore.Types,
  QEngine.Types,
  direct3d9,
  Strope.Math;

type
  TQuadTexture = class sealed (TBaseObject, IQuadTexture)
    strict private
      FEngine: IQuadEngine;
      FTexture: IQuadTexture;

      FTextureSize: TVectorI;
      FSpriteSize: TVectorI;
      FFrameSize: TVectorI;
      FFrameUVSize: TVectorF;
      FFramesCount: Word;

      function GetPatternIndex(Pattern: Word): TVectorI;

      function GetIsLoaded: Boolean; stdcall;
      function GetPatternCount: Integer; stdcall;
      function GetPatternHeight: Word; stdcall;
      function GetPatternWidth: Word; stdcall;
      function GetSpriteHeight: Word; stdcall;
      function GetSpriteWidth: Word; stdcall;
      function GetTexture(i: Byte): IDirect3DTexture9; stdcall;
      function GetTextureHeight: Word; stdcall;
      function GetTextureWidth: Word; stdcall;

      procedure Draw(x, y: Double; Color: Cardinal = $FFFFFFFF); overload; stdcall;
      procedure DrawFrame(x, y: Double; Pattern: Word;
        Color: Cardinal = $FFFFFFFF); stdcall;
      procedure DrawDistort(x1, y1, x2, y2, x3, y3, x4, y4: Double;
        Color: Cardinal = $FFFFFFFF); stdcall;
      procedure DrawMap(x, y, x2, y2, u1, v1, u2, v2: Double; Color:
        Cardinal = $FFFFFFFF); stdcall;
      procedure DrawMapRotAxis(x, y, x2, y2, u1, v1, u2, v2, xA, yA, angle, Scale: Double;
        Color: Cardinal = $FFFFFFFF); stdcall;
      procedure DrawRot(x, y, angle, Scale: Double;
        Color: Cardinal = $FFFFFFFF); stdcall;
      procedure DrawRotFrame(x, y, angle, Scale: Double; Pattern: Word;
        Color: Cardinal = $FFFFFFFF); stdcall;
      procedure DrawRotAxis(x, y, angle, Scale, xA, yA: Double;
        Color: Cardinal = $FFFFFFFF); stdcall;
      procedure DrawRotAxisFrame(x, y, angle, Scale, xA, yA: Double;
        Pattern: Word; Color: Cardinal = $FFFFFFFF); stdcall;

      procedure LoadFromFile(ARegister: Byte; AFilename: PAnsiChar;
        APatternWidth: Integer = 0;
        APatternHeight: Integer = 0;
        AColorKey: Integer = -1); overload; stdcall;
      procedure SetIsLoaded(AWidth, AHeight: Word); stdcall;
    public
      constructor Create(AEngine: IQuadEngine; ATexture: IQuadTexture);

      procedure AddTexture(ARegister: Byte;
        ATexture: IDirect3DTexture9); stdcall;
      procedure LoadFromFile(const AFileName: string; ARegister: Byte;
        APatternWidth: Integer = 0; APatternHeight: Integer = 0;
        AColorKey: Integer = -1); overload;
      procedure LoadFromRAW(ARegister: Byte; AData: Pointer;
        AWidth, AHeight: Integer); stdcall;

      procedure Draw(const APosition: TVectorF;
        AAngle: Single = 0; AColor: Cardinal = $FFFFFFFF; AFrame: Word = 0); overload;
      procedure Draw(const APosition, ASize: TVectorF;
        AAngle: Single = 0; AColor: Cardinal = $FFFFFFFF; AFrame: Word = 0); overload;
      procedure Draw(const APosition, ASize, ARotationCenter: TVectorF;
        AAngle: Single = 0; AColor: Cardinal = $FFFFFFFF; AFrame: Word = 0); overload;

      procedure DrawByLeftTop(const APosition: TVectorF;
        AAngle: Single = 0; AColor: Cardinal = $FFFFFFFF; AFrame: Word = 0); overload;
      procedure DrawByLeftTop(const APosition, ASize: TVectorF;
        AAngle: Single = 0; AColor: Cardinal = $FFFFFFFF; AFrame: Word = 0); overload;
      procedure DrawByLeftTop(const APosition, ASize, ARotationCenter: TVectorF;
        AAngle: Single = 0; AColor: Cardinal = $FFFFFFFF; AFrame: Word = 0); overload;

      property IsLoaded: Boolean read GetIsLoaded;
      property TextureSize: TVectorI read FTextureSize;
      property SpriteSize: TVectorI read FSpriteSize;
      property FrameSize: TVectorI read FFrameSize;
      property FrameUVSize: TVectorF read FFrameUVSize;
      property FramesCount: Word read FFramesCount;
  end;

implementation

uses
  SysUtils;

{$REGION '  TQuadTexture  '}
constructor TQuadTexture.Create(AEngine: IQuadEngine; ATexture: IQuadTexture);
begin
  if not Assigned(AEngine) then
    raise EArgumentException.Create(
      'Не указан экземпляр интерфейса IQuadEngine при инициализации объекта класса TQuadTexture. ' +
      '{290DEE7D-6B4B-49F1-A80E-38C80E7C6455}');

  if not Assigned(ATexture) then
    raise EArgumentException.Create(
      'Не указан экземпляр интерфейса IQuadTexture при инициализации объекта класса TQuadTexture. ' +
      '{91564802-EB3A-4321-9C6C-4A51F121E853}');

  FEngine := AEngine;
  FTexture := ATexture;
end;

function TQuadTexture.GetPatternIndex(Pattern: Word): TVectorI;
var
  APatternsCount: TVector2I;
begin
  if FramesCount = 1 then
    Exit(ZeroVectorI);

  Pattern := Pattern mod FramesCount;
  APatternsCount.Create(
    FTexture.GetSpriteWidth div FTexture.GetPatternWidth,
    FTexture.GetSpriteHeight div FTexture.GetPatternHeight);
  Result.Create(
    Pattern mod APatternsCount.X,
    (Pattern div APatternsCount.X) mod APatternsCount.Y);
end;

function TQuadTexture.GetIsLoaded: Boolean;
begin
  Result := FTexture.GetIsLoaded;
end;

function TQuadTexture.GetPatternCount: Integer;
begin
  Result := FTexture.GetPatternCount;
end;

function TQuadTexture.GetPatternHeight: Word;
begin
  Result := FTexture.GetPatternHeight;
end;

function TQuadTexture.GetPatternWidth: Word;
begin
  Result := FTexture.GetPatternWidth;
end;

function TQuadTexture.GetSpriteHeight: Word;
begin
  Result := FTexture.GetSpriteHeight;
end;

function TQuadTexture.GetSpriteWidth: Word;
begin
  Result := FTexture.GetSpriteWidth;
end;

function TQuadTexture.GetTexture(i: Byte): IDirect3DTexture9;
begin
  Result := FTexture.GetTexture(i);
end;

function TQuadTexture.GetTextureHeight: Word;
begin
  Result := FTexture.GetTextureHeight;
end;

function TQuadTexture.GetTextureWidth: Word;
begin
  Result := FTexture.GetTextureWidth;
end;

procedure TQuadTexture.AddTexture(ARegister: Byte;
  ATexture: IDirect3DTexture9);
begin
  FTexture.AddTexture(ARegister, ATexture);
end;

procedure TQuadTexture.Draw(x, y: Double; Color: Cardinal = $FFFFFFFF);
var
  AScreenPosition: TVectorF;
  AScreenSize: TVectorF;
begin
  AScreenPosition.Create(X, Y);
  AScreenSize.Create(FTexture.GetSpriteWidth, FTexture.GetSpriteHeight);
  if Assigned(FEngine.Camera) then
  begin
    AScreenPosition := FEngine.Camera.GetScreenPos(AScreenPosition);
    AScreenSize := FEngine.Camera.GetScreenSize(AScreenSize);
  end;
  FTexture.DrawMap(
    AScreenPosition.X, AScreenPosition.Y,
    AScreenPosition.X + AScreenSize.X, AScreenPosition.Y + AScreenSize.Y,
    0, 0, 1, 1, Color);
end;

procedure TQuadTexture.DrawFrame(x, y: Double; Pattern: Word;
  Color: Cardinal = $FFFFFFFF);
var
  AScreenPosition: TVectorF;
  AScreenSize: TVectorF;
  APatternIndex: TVectorI;
  APatternUVSize: TVectorF;
  AUV: TVectorF;
begin
  AScreenPosition.Create(X, Y);
  AScreenSize.Create(FTexture.GetPatternWidth, FTexture.GetPatternHeight);

  APatternIndex := GetPatternIndex(Pattern);
  APatternUVSize := FrameUVSize;
  AUV := APatternUVSize.ComponentwiseMultiply(APatternIndex);

  if Assigned(FEngine.Camera) then
  begin
    AScreenPosition := FEngine.Camera.GetScreenPos(AScreenPosition);
    AScreenSize := FEngine.Camera.GetScreenSize(AScreenSize);
  end;
  FTexture.DrawMap(
    AScreenPosition.X, AScreenPosition.Y,
    AScreenPosition.X + AScreenSize.X, AScreenPosition.Y + AScreenSize.Y,
    AUV.X, AUV.Y, AUV.X + APatternUVSize.X, AUV.Y + APatternUVSize.Y,
    Color);
end;

procedure TQuadTexture.Draw(const APosition, ASize, ARotationCenter: TVectorF;
  AAngle: Single; AColor: Cardinal; AFrame: Word);
var
  ALTPosition, ARBPosition: TVectorF;
  AFrameUV: TVectorF;
begin
  ALTPosition := APosition - ASize * 0.5;
  ARBPosition := ALTPosition + ASize;
  AFrameUV := FrameUVSize.ComponentwiseMultiply(GetPatternIndex(AFrame));
  DrawMapRotAxis(
    ALTPosition.X, ALTPosition.Y,
    ARBPosition.X, ARBPosition.Y,
    AFrameUV.X, AFrameUV.Y, AFrameUV.X + FrameUVSize.X, AFrameUV.Y + FrameUVSize.Y,
    ARotationCenter.X, ARotationCenter.Y,
    AAngle, 1, AColor);
end;

procedure TQuadTexture.Draw(const APosition, ASize: TVectorF; AAngle: Single;
  AColor: Cardinal; AFrame: Word);
var
  ALTPosition, ARBPosition: TVectorF;
  AFrameUV: TVectorF;
begin
  ALTPosition := APosition - ASize * 0.5;
  ARBPosition := ALTPosition + ASize;
  AFrameUV := FrameUVSize.ComponentwiseMultiply(GetPatternIndex(AFrame));
  DrawMapRotAxis(
    ALTPosition.X, ALTPosition.Y,
    ARBPosition.X, ARBPosition.Y,
    AFrameUV.X, AFrameUV.Y, AFrameUV.X + FrameUVSize.X, AFrameUV.Y + FrameUVSize.Y,
    APosition.X, APosition.Y,
    AAngle, 1, AColor);
end;

procedure TQuadTexture.Draw(const APosition: TVectorF; AAngle: Single;
  AColor: Cardinal; AFrame: Word);
var
  ALTPosition, ARBPosition: TVectorF;
  AFrameUV: TVectorF;
begin
  ALTPosition := APosition - TVectorF(FrameSize) * 0.5;
  ARBPosition := ALTPosition + FrameSize;
  AFrameUV := FrameUVSize.ComponentwiseMultiply(GetPatternIndex(AFrame));
  DrawMapRotAxis(
    ALTPosition.X, ALTPosition.Y,
    ARBPosition.X, ARBPosition.Y,
    AFrameUV.X, AFrameUV.Y, AFrameUV.X + FrameUVSize.X, AFrameUV.Y + FrameUVSize.Y,
    APosition.X, APosition.Y,
    AAngle, 1, AColor);
end;

procedure TQuadTexture.DrawByLeftTop(const APosition, ASize, ARotationCenter: TVectorF;
  AAngle: Single; AColor: Cardinal; AFrame: Word);
var
  ARBPosition: TVectorF;
  AFrameUV: TVectorF;
begin
  ARBPosition := APosition + ASize;
  AFrameUV := FrameUVSize.ComponentwiseMultiply(GetPatternIndex(AFrame));
  DrawMapRotAxis(
    APosition.X, APosition.Y,
    ARBPosition.X, ARBPosition.Y,
    AFrameUV.X, AFrameUV.Y, AFrameUV.X + FrameUVSize.X, AFrameUV.Y + FrameUVSize.Y,
    ARotationCenter.X, ARotationCenter.Y,
    AAngle, 1, AColor);
end;

procedure TQuadTexture.DrawByLeftTop(const APosition, ASize: TVectorF;
  AAngle: Single; AColor: Cardinal; AFrame: Word);
var
  ARBPosition: TVectorF;
  ACenter: TVectorF;
  AFrameUV: TVectorF;
begin
  ARBPosition := APosition + ASize;
  ACenter := APosition + ASize * 0.5;
  AFrameUV := FrameUVSize.ComponentwiseMultiply(GetPatternIndex(AFrame));
  DrawMapRotAxis(
    APosition.X, APosition.Y,
    ARBPosition.X, ARBPosition.Y,
    AFrameUV.X, AFrameUV.Y, AFrameUV.X + FrameUVSize.X, AFrameUV.Y + FrameUVSize.Y,
    ACenter.X, ACenter.Y,
    AAngle, 1, AColor);
end;

procedure TQuadTexture.DrawByLeftTop(const APosition: TVectorF; AAngle: Single;
  AColor: Cardinal; AFrame: Word);
var
  ARBPosition: TVectorF;
  ACenter: TVectorF;
  AFrameUV: TVectorF;
begin
  ARBPosition := APosition + FrameSize;
  ACenter := APosition + TVectorF(FrameSize) * 0.5;
  AFrameUV := FrameUVSize.ComponentwiseMultiply(GetPatternIndex(AFrame));
  DrawMapRotAxis(
    APosition.X, APosition.Y,
    ARBPosition.X, ARBPosition.Y,
    AFrameUV.X, AFrameUV.Y, AFrameUV.X + FrameUVSize.X, AFrameUV.Y + FrameUVSize.Y,
    ACenter.X, ACenter.Y,
    AAngle, 1, AColor);
end;

procedure TQuadTexture.DrawDistort(x1, y1, x2, y2, x3, y3, x4, y4: Double;
  Color: Cardinal = $FFFFFFFF);
var
  AScreenPosition1: TVectorF;
  AScreenPosition2: TVectorF;
  AScreenPosition3: TVectorF;
  AScreenPosition4: TVectorF;
begin
  AScreenPosition1.Create(x1, y1);
  AScreenPosition2.Create(x2, y2);
  AScreenPosition3.Create(x3, y3);
  AScreenPosition4.Create(x4, y4);
  if Assigned(FEngine.Camera) then
  begin
    AScreenPosition1 := FEngine.Camera.GetScreenPos(AScreenPosition1);
    AScreenPosition2 := FEngine.Camera.GetScreenPos(AScreenPosition2);
    AScreenPosition3 := FEngine.Camera.GetScreenPos(AScreenPosition3);
    AScreenPosition4 := FEngine.Camera.GetScreenPos(AScreenPosition4);
  end;
  FTexture.DrawDistort(
    AScreenPosition1.X, AScreenPosition1.Y,
    AScreenPosition2.X, AScreenPosition2.Y,
    AScreenPosition3.X, AScreenPosition3.Y,
    AScreenPosition4.X, AScreenPosition4.Y,
    Color);
end;

procedure TQuadTexture.DrawMap(x, y, x2, y2, u1, v1, u2, v2: Double; Color:
  Cardinal = $FFFFFFFF);
var
  AScreenPosition1: TVectorF;
  AScreenPosition2: TVectorF;
begin
  AScreenPosition1.Create(x, y);
  AScreenPosition2.Create(x2, y2);
  if Assigned(FEngine.Camera) then
  begin
    AScreenPosition1 := FEngine.Camera.GetScreenPos(AScreenPosition1);
    AScreenPosition2 := FEngine.Camera.GetScreenPos(AScreenPosition2);
  end;
  FTexture.DrawMap(
    AScreenPosition1.X, AScreenPosition1.Y,
    AScreenPosition2.X, AScreenPosition2.Y,
    u1, v1, u2, v2, Color);
end;

procedure TQuadTexture.DrawMapRotAxis(x, y, x2, y2, u1, v1, u2, v2, xA, yA, angle, Scale: Double;
  Color: Cardinal = $FFFFFFFF);
var
  AScreenPosition1, AScreenPosition2: TVectorF;
  ACenter: TVectorF;
begin
  AScreenPosition1.Create(x, y);
  AScreenPosition2.Create(x2, y2);
  ACenter.Create(xA, yA);
  if Assigned(FEngine.Camera) then
  begin
    AScreenPosition1 := FEngine.Camera.GetScreenPos(AScreenPosition1);
    AScreenPosition2 := FEngine.Camera.GetScreenPos(AScreenPosition2);
    ACenter := FEngine.Camera.GetScreenPos(ACenter);
  end;
  FTexture.DrawMapRotAxis(
    AScreenPosition1.X, AScreenPosition1.Y,
    AScreenPosition2.X, AScreenPosition2.Y,
    u1, v1, u2, v2,
    ACenter.X, ACenter.Y,
    angle, Scale, Color);
end;

procedure TQuadTexture.DrawRot(x, y, angle, Scale: Double;
  Color: Cardinal = $FFFFFFFF);
var
  AScreenSize: TVectorF;
  AScreenPosition: TVectorF;
  ACenterPosition: TVectorF;
begin
  ACenterPosition.Create(x, y);
  AScreenSize := SpriteSize;
  if Assigned(FEngine.Camera) then
  begin
    ACenterPosition := FEngine.Camera.GetScreenPos(ACenterPosition);
    AScreenSize := FEngine.Camera.GetScreenSize(AScreenSize);
  end;
  AScreenPosition := ACenterPosition - AScreenSize * 0.5;

  FTexture.DrawMapRotAxis(
    AScreenPosition.X, AScreenPosition.Y,
    AScreenPosition.X + AScreenSize.X, AScreenPosition.Y + AScreenSize.Y,
    0, 0, 1, 1,
    ACenterPosition.X, ACenterPosition.Y,
    angle, Scale, Color);
end;

procedure TQuadTexture.DrawRotFrame(x, y, angle, Scale: Double; Pattern: Word;
  Color: Cardinal = $FFFFFFFF);
var
  AScreenPosition: TVectorF;
  AScreenSize: TVectorF;
  APatternIndex: TVectorI;
  APatternUVSize: TVectorF;
  AUV: TVectorF;
  AOffset: TVectorF;
begin
  AScreenPosition.Create(x, y);
  AScreenSize.Create(FTexture.GetPatternWidth, FTexture.GetPatternHeight);

  APatternIndex := GetPatternIndex(Pattern);
  APatternUVSize := FrameUVSize;
  AUV := APatternUVSize.ComponentwiseMultiply(APatternIndex);

  if Assigned(FEngine.Camera) then
  begin
    AScreenPosition := FEngine.Camera.GetScreenPos(AScreenPosition);
    AScreenSize := FEngine.Camera.GetScreenSize(AScreenSize);
  end;
  AOffset := AScreenPosition;
  AScreenPosition := AScreenPosition - AScreenSize * 0.5;

  FTexture.DrawMapRotAxis(
    AScreenPosition.X, AScreenPosition.Y,
    AScreenPosition.X + AScreenSize.X, AScreenPosition.Y + AScreenSize.Y,
    AUV.X, AUV.Y, AUV.X + APatternUVSize.X, AUV.Y + APatternUVSize.Y,
    AOffset.X, AOffset.Y,
    angle, Scale, Color);
end;

procedure TQuadTexture.DrawRotAxis(x, y, angle, Scale, xA, yA: Double;
  Color: Cardinal = $FFFFFFFF);
var
  AScreenSize: TVectorF;
  AScreenPosition: TVectorF;
  AOffset: TVectorF;
begin
  AScreenPosition.Create(x, y);
  AScreenSize := SpriteSize;
  AOffset.Create(xA, yA);
  if Assigned(FEngine.Camera) then
  begin
    AScreenPosition := FEngine.Camera.GetScreenPos(AScreenPosition);
    AScreenSize := FEngine.Camera.GetScreenSize(AScreenSize);
    AOffset := FEngine.Camera.GetScreenPos(AOffset);
  end;
  AScreenPosition := AScreenPosition - AScreenSize * 0.5;

  FTexture.DrawMapRotAxis(
    AScreenPosition.X, AScreenPosition.Y,
    AScreenPosition.X + AScreenSize.X, AScreenPosition.Y + AScreenSize.Y,
    0, 0, 1, 1,
    AOffset.X, AOffset.Y,
    angle, Scale, Color);
end;

procedure TQuadTexture.DrawRotAxisFrame(x, y, angle, Scale, xA, yA: Double;
  Pattern: Word; Color: Cardinal = $FFFFFFFF);
var
  AScreenPosition: TVectorF;
  AScreenSize: TVectorF;
  APatternIndex: TVectorI;
  APatternUVSize: TVectorF;
  AUV: TVectorF;
  AOffset: TVectorF;
begin
  AScreenPosition.Create(x, y);
  AScreenSize.Create(FTexture.GetPatternWidth, FTexture.GetPatternHeight);
  AOffset.Create(xA, yA);

  APatternIndex := GetPatternIndex(Pattern);
  APatternUVSize := FrameUVSize;
  AUV := APatternUVSize.ComponentwiseMultiply(APatternIndex);

  if Assigned(FEngine.Camera) then
  begin
    AScreenPosition := FEngine.Camera.GetScreenPos(AScreenPosition);
    AScreenSize := FEngine.Camera.GetScreenSize(AScreenSize);
    AOffset := FEngine.Camera.GetScreenPos(AOffset);
  end;
  AScreenPosition := AScreenPosition - AScreenSize * 0.5;

  FTexture.DrawMapRotAxis(
    AScreenPosition.X, AScreenPosition.Y,
    AScreenPosition.X + AScreenSize.X, AScreenPosition.Y + AScreenSize.Y,
    AUV.X, AUV.Y, AUV.X + APatternUVSize.X, AUV.Y + APatternUVSize.Y,
    AOffset.X, AOffset.Y,
    angle, Scale, Color);
end;

procedure TQuadTexture.LoadFromFile(ARegister: Byte; AFilename: PAnsiChar;
  APatternWidth: Integer = 0;
  APatternHeight: Integer = 0;
  AColorKey: Integer = -1);
begin
  FTexture.LoadFromFile(ARegister, AFilename,
    APatternWidth, APatternHeight,
    AColorKey);

  FTextureSize := TVectorI.Create(GetTextureWidth, GetTextureHeight);
  FSpriteSize := TVectorI.Create(GetSpriteWidth, GetSpriteHeight);
  FFrameSize := TVectorI.Create(GetPatternWidth, GetPatternHeight);
  FFrameUVSize := TVectorF.Create(
    FTexture.GetPatternWidth / FTexture.GetTextureWidth,
    FTexture.GetPatternHeight / FTexture.GetTextureHeight);
  FFramesCount := GetPatternCount;
end;

procedure TQuadTexture.LoadFromFile(const AFileName: string; ARegister: Byte;
  APatternWidth, APatternHeight, AColorKey: Integer);
begin
  LoadFromFile(ARegister, PAnsiChar(AnsiString(AFileName)),
    APatternWidth, APatternHeight, AColorKey);
end;

procedure TQuadTexture.LoadFromRAW(ARegister: Byte; AData: Pointer;
  AWidth, AHeight: Integer);
begin
  FTexture.LoadFromRAW(ARegister, AData, AWidth, AHeight);
end;

procedure TQuadTexture.SetIsLoaded(AWidth, AHeight: Word);
begin
  FTexture.SetIsLoaded(AWidth, AHeight);
end;
{$ENDREGION}

end.
