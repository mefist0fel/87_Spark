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

  TStar = record
    private
      FPosition: TVectorF;
      FDepth: Single;
      FBrightness: Single;
    public
      constructor Create(const FPosition: TVectorF; FDepth, FBrightness: Single);

      procedure Draw(AOwner: TStarFon);
  end;

  TStarFon = class sealed
    strict private
      FStars: TList<TStar>;
      FCamera: IQuadCamera;
      FStar: TQuadTexture;

      procedure Fill;
    private

    public
      constructor Create;
      destructor Destroy; override;

      procedure Draw;
      procedure Shift(const ADelta: TVectorF);
  end;

implementation

{$REGION '  TStarFon  '}
constructor TStarFon.Create;
begin
  FStars := TList<TStarFon>.Create;

  Randomize;
  Fill;
end;

destructor TStarFon.Destroy;
begin
  FStars.Free;

  inherited;
end;

procedure TStarFon.Fill;
begin

end;

procedure TStarFon.Shift(const ADelta: TVector2F);
begin

end;

procedure TStarFon.Draw;
begin

end;
{$ENDREGION}

end.
