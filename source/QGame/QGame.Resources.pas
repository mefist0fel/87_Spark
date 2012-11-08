unit QGame.Resources;

interface

uses
  QuadEngine,
  QEngine.Font,
  QEngine.Texture;

type
  TResource = class abstract
    strict protected
      FResourceTypeName: string;
      FResourceName: string;
    public
      constructor Create(const ATypeName, AName: string);

      property Name: string read FResourceName;
      property TypeName: string read FResourceTypeName;
  end;

  TFontResource = class sealed (TResource)
    strict private
      FFont: IQuadFont;
    public
      constructor Create(const ATypeName, AName: string); overload;
      constructor Create(const ATypeName, AName: string;
        AFont: IQuadFont); overload;
      constructor CreateAndLoad(const ATypeName, AName, ATextureFile, AUVFile: string);

      property Font: IQuadFont read FFont;
  end;

  TFontExResource = class sealed (TResource)
    strict private
      FFont: TQuadFont;
    public
      constructor Create(const ATypeName, AName: string); overload;
      constructor Create(const ATypeName, AName: string;
        AFont: TQuadFont); overload;
      constructor CreateAndLoad(const ATypeName, AName, ATextureFile, AUVFile: string);

      property Font: TQuadFont read FFont;
  end;

  TTextureResource = class sealed (TResource)
    strict private
      FTexture: IQuadTexture;
    public
      constructor Create(const ATypeName, AName: string); overload;
      constructor Create(const ATypeName, AName: string;
        ATexture: IQuadTexture); overload;
      constructor CreateAndLoad(const ATypeName, AName, AFile: string;
        ARegister: Byte; AFrameWidth: Integer = 0; AFrameHeight: Integer = 0;
        AColorKey: Integer = -1);

      property Texture: IQuadTexture read FTexture;
  end;

  TTextureExResource = class sealed (TResource)
    strict private
      FTexture: TQuadTexture;
    public
      constructor Create(const ATypeName, AName: string); overload;
      constructor Create(const ATypeName, AName: string;
        ATexture: TQuadTexture); overload;
      constructor CreateAndLoad(const ATypeName, AName, AFile: string;
        ARegister: Byte; AFrameWidth: Integer = 0; AFrameHeight: Integer = 0;
        AColorKey: Integer = -1);
      destructor Destroy; override;

      property Texture: TQuadTexture read FTexture;
  end;

implementation

uses
  SysUtils,
  QEngine.Core;

{$REGION '  TResource  '}
constructor TResource.Create(const ATypeName, AName: string);
begin
  FResourceTypeName := AnsiUpperCase(ATypeName);
  FResourceName := AnsiUpperCase(AName);
end;
{$ENDREGION}

{$REGION '  TFontResource  '}
constructor TFontResource.Create(const ATypeName, AName: string);
begin
  inherited Create(ATypeName, AName);
  TheDevice.CreateFont(FFont);
end;

constructor TFontResource.Create(const ATypeName, AName: string;
  AFont: IQuadFont);
begin
  if not Assigned(AFont) then
    raise EArgumentException.Create(
      'Не указан объект шрифта. ' +
      '{4908D643-DF50-4F9B-A2DC-E587C1A5B33B}');

  inherited Create(ATypeName, AName);
  FFont := AFont;
end;

constructor TFontResource.CreateAndLoad(
  const ATypeName, AName, ATextureFile, AUVFile: string);
begin
  if not FileExists(ATextureFile) then
    raise EArgumentException.Create(
      'Файл "' + ATextureFile + '" не существует. ' +
      '{17F7150B-EEC6-4571-9A74-62E475FF970D}');

  if not FileExists(AUVFile) then
    raise EArgumentException.Create(
      'Файл "' + AUVFile + '" не существует. ' +
      '{2EDDEB1F-07A0-464F-A40A-5C9BD2DB98E0}');

  inherited Create(ATypeName, AName);
  TheDevice.CreateAndLoadFont(
    PAnsiChar(AnsiString(ATextureFile)), PAnsiChar(AnsiString(AUVFile)),
    FFont);
end;
{$ENDREGION}

{$REGION '  TFontExResource  '}
constructor TFontExResource.Create(const ATypeName, AName: string);
begin
  inherited Create(ATypeName, AName);
  FFont := TheEngine.CreateFont;
end;

constructor TFontExResource.Create(const ATypeName, AName: string;
  AFont: TQuadFont);
begin
  if not Assigned(AFont) then
    raise EArgumentException.Create(
      'Не указан объект шрифта. ' +
      '{4908D643-DF50-4F9B-A2DC-E587C1A5B33B}');

  inherited Create(ATypeName, AName);
  FFont := AFont;
end;

constructor TFontExResource.CreateAndLoad(
  const ATypeName, AName, ATextureFile, AUVFile: string);
begin
  if not FileExists(ATextureFile) then
    raise EArgumentException.Create(
      'Файл "' + ATextureFile + '" не существует. ' +
      '{17F7150B-EEC6-4571-9A74-62E475FF970D}');

  if not FileExists(AUVFile) then
    raise EArgumentException.Create(
      'Файл "' + AUVFile + '" не существует. ' +
      '{2EDDEB1F-07A0-464F-A40A-5C9BD2DB98E0}');

  inherited Create(ATypeName, AName);
  FFont := TheEngine.CreateFont;
  FFont.LoadFromFile(ATextureFile, AUVFile);
end;
{$ENDREGION}

{$REGION '  TTextureResource  '}
constructor TTextureResource.Create(const ATypeName, AName: string;
  ATexture: IQuadTexture);
begin
  if not Assigned(ATexture) then
    raise EArgumentException.Create(
      'Не указан объект текстуры. ' +
      '{03E418E1-76B3-4B52-AD15-44F15765807B}');

  inherited Create(ATypeName, AName);
  FTexture := ATexture;
end;

constructor TTextureResource.Create(const ATypeName, AName: string);
begin
  inherited Create(ATypeName, AName);
  TheDevice.CreateTexture(FTexture);
end;

constructor TTextureResource.CreateAndLoad(const ATypeName, AName, AFile: string;
  ARegister: Byte; AFrameWidth: Integer = 0; AFrameHeight: Integer = 0;
  AColorKey: Integer = -1);
begin
  if not FileExists(AFile) then
    raise EArgumentException.Create(
      'Файл "' + AFile + '" не существует. ' +
      '{68BCDF44-93B4-4A18-8969-87BCD0C95BD9}');

  inherited Create(ATypeName, AName);
  TheDevice.CreateAndLoadTexture(ARegister, PAnsiChar(AnsiString(AFile)),
    FTexture, AFrameWidth, AFrameHeight, AColorKey);
end;
{$ENDREGION}

{$REGION '  TTextureExResource  '}
constructor TTextureExResource.Create(const ATypeName, AName: string;
  ATexture: TQuadTexture);
begin
  if not Assigned(ATexture) then
    raise EArgumentException.Create(
      'Не указан объект текстуры. ' +
      '{03E418E1-76B3-4B52-AD15-44F15765807B}');

  inherited Create(ATypeName, AName);
  FTexture := ATexture;
end;

constructor TTextureExResource.Create(const ATypeName, AName: string);
begin
  inherited Create(ATypeName, AName);
  FTexture := TheEngine.CreateTexture;
end;

constructor TTextureExResource.CreateAndLoad(const ATypeName, AName, AFile: string;
  ARegister: Byte; AFrameWidth: Integer = 0; AFrameHeight: Integer = 0;
  AColorKey: Integer = -1);
begin
  if not FileExists(AFile) then
    raise EArgumentException.Create(
      'Файл "' + AFile + '" не существует. ' +
      '{68BCDF44-93B4-4A18-8969-87BCD0C95BD9}');

  inherited Create(ATypeName, AName);
  FTexture := TheEngine.CreateTexture;
  FTexture.LoadFromFile(AFile, ARegister, AFrameWidth, AFrameHeight, AColorKey);
end;

destructor TTextureExResource.Destroy;
begin
  FreeAndNil(FTexture);

  inherited;
end;
{$ENDREGION}

end.
