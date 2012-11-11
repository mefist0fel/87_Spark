unit Project87.Types.SimpleGUI;

interface

uses
  QCore.Types,
  QCore.Input,
  Strope.Math;

type
  TGUIAction = procedure of object;

  TWidget = class (TComponent)
    public
  end;

  TGUIManager = class sealed (TComponent)
    public
      constructor Create;
      destructor Destroy; override;
  end;

implementation

{$REGION '  TGUIManager  '}
constructor TGUIManager.Create;
begin

end;

destructor TGUIManager.Destroy;
begin
  inherited;
end;
{$ENDREGION}

end.
