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
    emtMouseEvent = 1,
    emtMouseButtonEvent = 2,
    emtMouseWheelEvent = 3,
    emtKeyEvent = 4
  );

  TEventMessage = record
    strict private
      FMessageType: TEventMessageType;

      FMousePosition: TVectorF;
      FMouseButton: TMouseButton;
      FIsMouseButtonPressed: Boolean;
      FMouseWheelDirection: Integer;

      FKeyButton: TKeyButton;
      FIsKeyPressed: Boolean;
    public
      constructor CreateAsMouseEvent(const APosition: TVectorF);
      constructor CreateAsMouseButtonEvent(const APosition: TVectorF;
        AButton: TMouseButton; AIsPressed: Boolean);
      constructor CreateAsMouseWheelEvent(const APostion: TVectorF; ADirection: Integer);
      constructor CreateAsKeyEvent(AKey: TKeyButton; AIsPressed: Boolean);

      property MessageType: TEventMessageType read FMessageType;
      property MousePosition: TVectorF read FMousePosition;
      property MouseButton: TMouseButton read FMouseButton;
      property IsMouseButtonPressed: Boolean read FIsMouseButtonPressed;
      property MouseWheelDirection: Integer read FMouseWheelDirection;
      property KeyButton: TKeyButton read FKeyButton;
      property IsKeyPressed: Boolean read FIsKeyPressed;
  end;

implementation

uses
  SysUtils;

{$REGION '  TEventMessage  '}
constructor TEventMessage.CreateAsKeyEvent(AKey: TKeyButton;
  AIsPressed: Boolean);
begin
  FMessageType := emtKeyEvent;
  FKeyButton := AKey;
  FIsKeyPressed := AIsPressed;
end;

constructor TEventMessage.CreateAsMouseButtonEvent(const APosition: TVectorF;
  AButton: TMouseButton; AIsPressed: Boolean);
begin
  FMessageType := emtMouseButtonEvent;
  FMousePosition := APosition;
  FMouseButton := AButton;
  FIsMouseButtonPressed := AIsPressed;
end;

constructor TEventMessage.CreateAsMouseEvent(const APosition: TVectorF);
begin
  FMessageType := emtMouseEvent;
  FMousePosition := APosition;
end;

constructor TEventMessage.CreateAsMouseWheelEvent(const APostion: TVectorF;
  ADirection: Integer);
begin
  FMessageType := emtMouseWheelEvent;
  FMousePosition := APostion;
  FMouseWheelDirection := ADirection;
end;
{$ENDREGION}

end.
