unit QGame.Resources;

interface

uses
  QuadEngine;

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
      constructor Create(const ATypeName, AName: string;
        AFont: IQuadFont);

      property Font: IQuadFont read FFont;
  end;

  TTextureResource = class sealed (TResource)
    strict private
      FTexture: IQuadTexture;
    public
      constructor Create(const ATypeName, AName: string;
        ATexture: IQuadTexture);

      property Texture: IQuadTexture read FTexture;
  end;

implementation

uses
  SysUtils;

{$REGION '  TResource  '}
constructor TResource.Create(const ATypeName, AName: string);
begin
  FResourceTypeName := AnsiUpperCase(ATypeName);
  FResourceName := AnsiUpperCase(AName);
end;
{$ENDREGION}

{$REGION '  TFontResource  '}
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
{$ENDREGION}

end.
