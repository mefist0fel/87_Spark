unit QEngine.Font;

interface

uses
  QuadEngine,
  QCore.Types,
  QEngine.Types,
  Strope.Math;

type
  TQuadFont = class sealed (TBaseObject, IQuadFont)
    strict private
      FEngine: IQuadEngine;
      FFont: IQuadFont;

      procedure LoadFromFile(ATextureFilename, AUVFilename: PAnsiChar); overload; stdcall;

      function TextHeight(AText: PAnsiChar; AScale: Single = 1.0): Single; overload; stdcall;
      function TextWidth(AText: PAnsiChar; AScale: Single = 1.0): Single; overload; stdcall;

      procedure TextOut(x, y, scale: Single; AText: PAnsiChar;
        Color: Cardinal = $FFFFFFFF); overload; stdcall;
      procedure TextOutAligned(x, y, scale: Single; AText: PAnsiChar;
        Color: Cardinal = $FFFFFFFF; Align: TqfAlign = qfaLeft); overload; stdcall;
      procedure TextOutCentered(x, y, scale: Single; AText: PAnsiChar;
        Color: Cardinal = $FFFFFFFF); overload; stdcall;

      function GetIsLoaded: Boolean; stdcall;
      function GetKerning: Single; stdcall;
      procedure SetKerning(AValue: Single); stdcall;
    public
      constructor Create(AEngine: IQuadEngine; AFont: IQuadFont);

      procedure LoadFromFile(const ATextureFileName, AUVFileName: string); overload;
      procedure SetSmartColor(AColorChar: AnsiChar; AColor: Cardinal); stdcall;
      procedure SetIsSmartColoring(Value: Boolean); stdcall;

      function TextHeight(const AText: string; AScale: Single = 1): Single; overload;
      function TextWidth(const AText: string; AScale: Single = 1): Single; overload;

      procedure TextOut(const AText: string;
        const APosition: TVectorF; AScale: Single; Color: Cardinal = $FFFFFFFF); overload;
      procedure TextOutAligned(const AText: string;
        const APosition: TVectorF; AScale: Single;
        Color: Cardinal = $FFFFFFFF; Align: TqfAlign = qfaLeft); overload;
      procedure TextOutCentered(const AText: string;
        const APosition: TVectorF; AScale: Single; Color: Cardinal = $FFFFFFFF); overload;

      property IsLoaded: Boolean read GetIsLoaded;
      property Kerning: Single read GetKerning write SetKerning;
  end;

implementation

uses
  SysUtils,
  Math;

{$REGION '  TQuadFont  '}
constructor TQuadFont.Create(AEngine: IQuadEngine; AFont: IQuadFont);
begin
  if not Assigned(AEngine) then
    raise EArgumentException.Create(
      'Не указан экземпляр интерфейса IQuadEngine при инициализации объекта класса TQuadFont. ' +
      '{947BEB10-B749-4ED2-925E-BC26B94A0E3E}');

  if not Assigned(AFont) then
    raise EArgumentException.Create(
      'Не указан экземпляр интерфейса IQuadFont при инициализации объекта класса TQuadFont. ' +
      '{17A10AC2-7565-46E4-BEA5-813A7ED02501}');

  FEngine := AEngine;
  FFont := AFont;
end;

function TQuadFont.GetIsLoaded: Boolean;
begin
  Result := FFont.GetIsLoaded;
end;

function TQuadFont.GetKerning: Single;
begin
  Result := FFont.GetKerning;
end;

procedure TQuadFont.LoadFromFile(ATextureFilename, AUVFilename : PAnsiChar);
begin
  FFont.LoadFromFile(ATextureFilename, AUVFilename);
end;

procedure TQuadFont.LoadFromFile(const ATextureFileName, AUVFileName: string);
begin
  LoadFromFile(PAnsiChar(AnsiString(ATextureFileName)),
    PAnsiChar(AnsiString(AUVFileName)));
end;

procedure TQuadFont.SetSmartColor(AColorChar: AnsiChar; AColor: Cardinal);
begin
  FFont.SetSmartColor(AColorChar, AColor);
end;

procedure TQuadFont.SetIsSmartColoring(Value: Boolean);
begin
  FFont.SetIsSmartColoring(Value);
end;

procedure TQuadFont.SetKerning(AValue: Single);
begin
  FFont.SetKerning(AValue);
end;

function TQuadFont.TextHeight(AText: PAnsiChar; AScale: Single = 1.0): Single;
begin
  Result := FFont.TextHeight(AText, AScale);
end;

function TQuadFont.TextWidth(AText: PAnsiChar; AScale: Single = 1.0): Single;
begin
  Result := FFont.TextWidth(AText, AScale);
end;

procedure TQuadFont.TextOut(x, y, scale: Single; AText: PAnsiChar;
  Color: Cardinal = $FFFFFFFF);
var
  AScreenPosition: TVectorF;
  AScale: Single;
begin
  AScreenPosition.Create(x, y);
  AScale := 1;
  if Assigned(FEngine.Camera) then
  begin
    AScreenPosition := FEngine.Camera.GetScreenPosition(AScreenPosition);
    AScale := Min(FEngine.Camera.Scale.X, FEngine.Camera.Scale.Y);
  end;
  FFont.TextOut(AScreenPosition.X, AScreenPosition.Y,  AScale * scale,
    AText, Color);
end;

procedure TQuadFont.TextOutAligned(x, y, scale: Single; AText: PAnsiChar;
  Color: Cardinal = $FFFFFFFF; Align: TqfAlign = qfaLeft);
var
  AScreenPosition: TVectorF;
  AScale: Single;
begin
  AScreenPosition.Create(x, y);
  AScale := 1;
  if Assigned(FEngine.Camera) then
  begin
    AScreenPosition := FEngine.Camera.GetScreenPosition(AScreenPosition);
    AScale := Min(FEngine.Camera.Scale.X, FEngine.Camera.Scale.Y);
  end;
  FFont.TextOutAligned(AScreenPosition.X, AScreenPosition.Y,  AScale * scale,
    AText, Color, Align);
end;

procedure TQuadFont.TextOutCentered(x, y, scale: Single; AText: PAnsiChar;
  Color: Cardinal = $FFFFFFFF);
var
  AScreenPosition: TVectorF;
  AScale: Single;
begin
  AScreenPosition.Create(x, y);
  AScale := 1;
  if Assigned(FEngine.Camera) then
  begin
    AScreenPosition := FEngine.Camera.GetScreenPosition(AScreenPosition);
    AScale := Min(FEngine.Camera.Scale.X, FEngine.Camera.Scale.Y);
  end;
  FFont.TextOutCentered(AScreenPosition.X, AScreenPosition.Y,  AScale * scale,
    AText, Color);
end;

function TQuadFont.TextHeight(const AText: string; AScale: Single = 1): Single;
begin
  Result := FFont.TextHeight(PAnsiChar(AnsiString(AText)), AScale);
end;

function TQuadFont.TextWidth(const AText: string; AScale: Single = 1): Single;
begin
  Result := FFont.TextWidth(PAnsiChar(AnsiString(AText)), AScale);
end;

procedure TQuadFont.TextOut(const AText: string; const APosition: TVector2F;
  AScale: Single; Color: Cardinal = $FFFFFFFF);
begin
  TextOut(APosition.X, APosition.Y, AScale, PAnsiChar(AnsiString(AText)), Color);
end;

procedure TQuadFont.TextOutAligned(const AText: string; const APosition: TVector2F;
  AScale: Single; Color: Cardinal = $FFFFFFFF; Align: TqfAlign = qfaLeft);
begin
  TextOutAligned(APosition.X, APosition.Y, AScale,
    PAnsiChar(AnsiString(AText)), Color, Align);
end;

procedure TQuadFont.TextOutCentered(const AText: string; const APosition: TVector2F;
  AScale: Single; Color: Cardinal = $FFFFFFFF);
begin
  TextOutCentered(APosition.X, APosition.Y, AScale,
    PAnsiChar(AnsiString(AText)), Color);
end;
{$ENDREGION}

end.
