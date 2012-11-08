unit QGame.ResourceManager;

interface

uses
  Generics.Collections,
  QGame.Resources;

type
  TResourceManager = class sealed
    strict private
      FResources: TDictionary<string, TDictionary<string, TResource>>;
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
  FResources := TDictionary<string, TDictionary<string, TResource>>.Create;
end;

destructor TResourceManager.Destroy;
begin
  DeleteAllResources;
  FreeAndNil(FResources);

  inherited;
end;

procedure TResourceManager.AddResource(AResource: TResource);
begin
  if Assigned(AResource) then
  begin
    if FResources.ContainsKey(AResource.TypeName) then
      FResources[AResource.TypeName].Add(AResource.Name, AResource)
    else
    begin
      FResources.Add(AResource.TypeName, TDictionary<string, TResource>.Create);
      FResources[AResource.TypeName].Add(AResource.Name, AResource);
    end;
  end;
end;

function TResourceManager.GetResource(const ATypeName, AName: string): TResource;
var
  AResources: TDictionary<string, TResource>;
begin
  Result := nil;
  AResources := nil;
  FResources.TryGetValue(AnsiUpperCase(ATypeName), AResources);
  if Assigned(AResources) then
    AResources.TryGetValue(AnsiUpperCase(AName), Result);
end;

procedure TResourceManager.DeleteResource(const ATypeName, AName: string);
var
  AResources: TDictionary<string, TResource>;
  AResource: TResource;
begin
  AResources := nil;
  AResource := nil;
  FResources.TryGetValue(AnsiUpperCase(ATypeName), AResources);
  if Assigned(AResources) then
  begin
    AResources.TryGetValue(AnsiUpperCase(AName), AResource);
    if Assigned(AResource) then
      AResource.Free;
  end;
end;

procedure TResourceManager.DeleteAllResources;
var
  AResources: TDictionary<string, TResource>;
  AResource: TResource;
begin
  for AResources in FResources.Values do
  begin
    for AResource in AResources.Values do
      AResource.Free;
    AResources.Clear;
  end;
  FResources.Clear;
end;
{$ENDREGION}

end.
