unit QGame.ResourceManager;

interface

uses
  Generics.Collections,
  QGame.Resources;

type
  TResourceManager = class sealed
    strict private
      FList: TList<TResource>;
    public
      constructor Create;
      destructor Destroy; override;

      procedure AddResource(AResource: TResource);
      function GetResource(const ATypeName, AName: string): TResource;
      procedure DeleteResource(const ATypeName, AName: string);
      procedure DeleteAllResources;
  end;

implementation

uses
  SysUtils;

{$REGION '  TResourceManager  '}
constructor TResourceManager.Create;
begin
  FList := TList<TResource>.Create;
end;

destructor TResourceManager.Destroy;
var
  AResource: TResource;
begin
  DeleteAllResources;
  FreeAndNil(FList);

  inherited;
end;

procedure TResourceManager.AddResource(AResource: TResource);
begin
  if Assigned(AResource) then
    FList.Add(AResource);
end;

function TResourceManager.GetResource(const ATypeName, AName: string): TResource;
var
  AResource: TResource;
  Str1, Str2: string;
begin
  Result := nil;
  Str1 := AnsiUpperCase(ATypeName);
  Str2 := AnsiUpperCase(AName);
  for AResource in FList do
    if (AnsiCompareStr(Str1, AResource.TypeName) = 0) and
      (AnsiCompareStr(Str2, AResource.Name) = 0)
    then
      Exit(AResource);
end;

procedure TResourceManager.DeleteResource(const ATypeName, AName: string);
var
  AResource: TResource;
  Str1, Str2: string;
begin
  Str1 := AnsiUpperCase(ATypeName);
  Str2 := AnsiUpperCase(AName);
  for AResource in FList do
    if (AnsiCompareStr(Str1, AResource.TypeName) = 0) and
      (AnsiCompareStr(Str2, AResource.Name) = 0)
    then
    begin
      FList.Remove(AResource);
      AResource.Free;
      Exit;
    end;
end;

procedure TResourceManager.DeleteAllResources;
var
  AResource: TResource;
begin
  for AResource in FList do
    AResource.Free;
  FList.Clear;
end;
{$ENDREGION}

end.
