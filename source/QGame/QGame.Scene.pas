unit QGame.Scene;

interface

uses
  QCore.Types,
  QCore.Input,
  Strope.Math;

type
  TScene = class abstract (TComponent)
    strict private
      FName: string;
    public
      constructor Create(const AName: string);

      procedure OnInitialize(AParameter: TObject = nil); override;
      procedure OnActivate(AIsActivate: Boolean); override;
      procedure OnDraw(const ALayer: Integer); override;
      procedure OnUpdate(const ADelta: Double); override;
      procedure OnDestroy; override;

      function OnMouseMove(const AMousePosition: TVectorF): Boolean; override;
      function OnMouseButtonDown(
        AButton: TMouseButton; const AMousePosition: TVectorF): Boolean; override;
      function OnMouseButtonUp(
        AButton: TMouseButton; const AMousePosition: TVectorF): Boolean; override;
      function OnMouseWheel(ADirection: Integer;
        const AMousePosition: TVectorF): Boolean; override;
      function OnKeyDown(AKey: TKeyButton): Boolean; override;
      function OnKeyUp(AKey: TKeyButton): Boolean; override;

      property Name: string read FName;
  end;

implementation

uses
  SysUtils;

{$REGION '  TScene  '}
constructor TScene.Create(const AName: string);
begin
  FName := AnsiUpperCase(AName);
end;

procedure TScene.OnActivate(AIsActivate: Boolean);
begin
  //nothing to do
end;

procedure TScene.OnDestroy;
begin
  //nothing to do
end;

procedure TScene.OnDraw(const ALayer: Integer);
begin
  //nothing to do
end;

procedure TScene.OnInitialize(AParameter: TObject);
begin
  //nothing to do
end;

function TScene.OnKeyDown(AKey: TKeyButton): Boolean;
begin
  Result := False;
end;

function TScene.OnKeyUp(AKey: TKeyButton): Boolean;
begin
  Result := False;
end;

function TScene.OnMouseButtonDown(AButton: TMouseButton;
  const AMousePosition: TVectorF): Boolean;
begin
  Result := False;
end;

function TScene.OnMouseButtonUp(AButton: TMouseButton;
  const AMousePosition: TVectorF): Boolean;
begin
  Result := False;
end;

function TScene.OnMouseMove(const AMousePosition: TVectorF): Boolean;
begin
  Result := False;
end;

function TScene.OnMouseWheel(ADirection: Integer;
  const AMousePosition: TVectorF): Boolean;
begin
  Result := False;
end;

procedure TScene.OnUpdate(const ADelta: Double);
begin
  //nothing to do
end;
{$ENDREGION}

end.
