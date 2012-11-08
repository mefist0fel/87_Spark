unit QApplication.Input;

interface

uses
  SyncObjs,
  Generics.Collections,
  QCore.Input,
  Strope.Math;

type
  TEventMessageType = (
    emtNone = 0,
    emtActivate = 1,
    emtMouseEvent = 2,
    emtMouseButtonEvent = 3,
    emtWheelEvent = 4,
    emtKeyEvent = 5
  );

  TEventMessage = class abstract
    strict protected
      FMessageType: TEventMessageType;
    public
      property MessageType: TEventMessageType read FMessageType;
  end;

  TMessageQueue = class sealed
    strict private
      FCriticalSection: TCriticalSection;
      FQueue: TList<TEventMessage>;
    public
      constructor Create;
      destructor Destroy; override;

      procedure AddToQueue(AMessage: TEventMessage);
      function GetQueue(): TList<TEventMessage>;
  end;

  TActivateEventMessage = class sealed (TEventMessage)
    strict private
      FIsActive: Boolean;
    public
      constructor Create(AIsActive: Boolean);

      property IsActive: Boolean read FIsActive;
  end;

  TMouseEventMessage =  class sealed (TEventMessage)
    strict private
      FPosition: TVectorF;
    public
      constructor Create(const APosition: TVectorF);

      property Position: TVectorF read FPosition;
  end;

  TMouseButtonEventMessage = class sealed (TEventMessage)
    strict private
      FPosition: TVectorF;
      FButton: TMouseButton;
      FIsPressed: Boolean;
    public
      constructor Create(AButton: TMouseButton; AIsPressed: Boolean;
        const APosition: TVectorF);

      property Button: TMouseButton read FButton;
      property IsPressed: Boolean read FIsPressed;
      property Position: TVectorF read FPosition;
  end;

  TWheelEventMessage = class sealed (TEventMessage)
    strict private
      FPosition: TVectorF;
      FDirection: Integer;
    public
      constructor Create(ADirection: Integer; const APosition: TVectorF);

      property Direction: Integer read FDirection;
      property Position: TVectorF read FPosition;
  end;

  TKeyEventMessage = class sealed (TEventMessage)
    strict private
      FKey: TKeyButton;
      FIsPressed: Boolean;
    public
      constructor Create(AKey: TKeyButton; AIsPressed: Boolean);

      property Key: TKeyButton read FKey;
      property IsPressed: Boolean read FIsPressed;
  end;

implementation

uses
  SysUtils;

{$REGION '  TMessageQueue  '}
constructor TMessageQueue.Create;
begin
  FCriticalSection := TCriticalSection.Create;
  FQueue := TList<TEventMessage>.Create;
end;

destructor TMessageQueue.Destroy;
var
  AMessage: TEventMessage;
begin
  for AMessage in FQueue do
    AMessage.Free;
  FreeAndNil(FQueue);
  FreeAndNil(FCriticalSection);

  inherited;
end;

procedure TMessageQueue.AddToQueue(AMessage: TEventMessage);
begin
  FCriticalSection.Enter;
    if Assigned(AMessage) then
      FQueue.Add(AMessage);
  FCriticalSection.Leave;
end;

function TMessageQueue.GetQueue;
var
  AMessage: TEventMessage;
begin
  FCriticalSection.Enter;
    Result := TList<TEventMessage>.Create;
    for AMessage in FQueue do
      Result.Add(AMessage);
    FQueue.Clear;
  FCriticalSection.Leave;
end;
{$ENDREGION}

{$REGION '  TActivateEventMessage  '}
constructor TActivateEventMessage.Create(AIsActive: Boolean);
begin
  FMessageType := emtActivate;
  FIsActive := AIsActive;
end;
{$ENDREGION}

{$REGION '  TMouseEventMessage  '}
constructor TMouseEventMessage.Create(const APosition: TVector2F);
begin
  FMessageType := emtMouseEvent;
  FPosition := APosition;
end;
{$ENDREGION}

{$REGION '  TMouseButtonEventMessage  '}
constructor TMouseButtonEventMessage.Create(AButton: TMouseButton;
  AIsPressed: Boolean; const APosition: TVector2F);
begin
  FMessageType := emtMouseButtonEvent;
  FButton := AButton;
  FIsPressed := AIsPressed;
  FPosition := APosition;
end;
{$ENDREGION}

{$REGION '  TWheelEventMessage  '}
constructor TWheelEventMessage.Create(ADirection: Integer;
  const APosition: TVector2F);
begin
  FMessageType := emtWheelEvent;
  FDirection := ADirection;
  FPosition := APosition;
end;
{$ENDREGION}

{$REGION '  TKeyEventMessage  '}
constructor TKeyEventMessage.Create(AKey: Word; AIsPressed: Boolean);
begin
  FMessageType := emtKeyEvent;
  FKey := AKey;
  FIsPressed := AIsPressed;
end;
{$ENDREGION}

end.
