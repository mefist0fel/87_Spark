unit Project87.Types.SimpleGUI;

interface

uses
  QCore.Types,
  QCore.Input,
  Strope.Math,
  QEngine.Font;

type
  TEventAction = procedure of object;

  TWidget = class abstract (TComponent)
    strict protected
      FPosition: TVectorF;
      FSize: TVectorF;
      FCaption: string;
      FColor: Cardinal;
      FFont: TQuadFont;

      FIsFocused: Boolean;
      FIsEnabled: Boolean;

      FOnMouseMove: TEventAction;
      FOnClick: TEventAction;

      procedure SetSize(const ASize: TVectorF); virtual;
      procedure SetCaption(const ACaption: string); virtual;
    public
      constructor Create;

      function OnMouseMove(const AMousePosition: TVectorF): Boolean; override;
      function OnMouseButtonUp(AButton: TMouseButton;
        const AMousePosition: TVectorF): Boolean; override;

      property Position: TVectorF read FPosition write FPosition;
      property Size: TVectorF read FSize write SetSize;
      property Caption: string read FCaption write SetCaption;
      property Color: Cardinal read FColor write FColor;
      property Font: TQuadFont read FFont write FFont;
      property IsEnabled: Boolean read FIsEnabled write FIsEnabled;

      property OnMouseMoveEvent: TEventAction read FOnMouseMove write FOnMouseMove;
      property OnClickEvent: TEventAction read FOnClick write FOnClick;
  end;

  TSimpleButton = class (TWidget)
    strict protected
    public
  end;

  TGUIManager = class sealed (TComponent)
    public
      constructor Create;
      destructor Destroy; override;
  end;

implementation

{$REGION '  TWidget  '}
constructor TWidget.Create;
begin

end;

procedure TWidget.SetSize(const ASize: TVector2F);
begin

end;

procedure TWidget.SetCaption(const ACaption: string);
begin

end;

function TWidget.OnMouseMove(const AMousePosition: TVector2F): Boolean;
begin

end;

function TWidget.OnMouseButtonUp(AButton: TMouseButton;
  const AMousePosition: TVectorF): Boolean;
begin

end;
{$ENDREGION}

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
