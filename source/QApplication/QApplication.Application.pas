unit QApplication.Application;

interface

uses
  SyncObjs,
  QuadEngine,
  QCore.Input,
  QCore.Types,
  QApplication.Window,
  QApplication.Input,
  QGame.Game,
  Strope.Math;

type
  TQApplicationParameters = class
    strict private
      FGame: TQGame;
      FTimerDelta: Word;
      FResolution: TVectorI;
      FIsFullscreen: Boolean;
    public
      constructor Create(AGame: TQGame;
        AResolution: TVectorI; AIsFullscreen: Boolean; ATimerDelta: Word = 16);

      property Game: TQGame read FGame;
      property TimerDelta: Word read FTimerDelta;
      property Resolution: TVectorI read FResolution;
      property IsFullscreen: Boolean read FIsFullscreen;
  end;

  ///<summary>����� ����������, ������������ ������ ����, ���� � ������� �������.</summary>
  TQApplication = class sealed (TComponent)
    strict private
      FWindow: TWindow;
      FGame: TQGame;
      FControlState: IControlState;
      FIsRuning: Boolean;
      FIsStoped: Boolean;
      FMainTimer: IQuadTimer;

      FCriticalSection: TCriticalSection;
      FMessageQueue: TMessageQueue;

      FResolution: TVectorI;
      FIsFullscreen: Boolean;

      FIsAltPressed: Boolean;

      procedure SetupWindow;
      procedure SetupTimer(ATimerDelta: Word);

      procedure ProcessMessageQueue;

      function GetFPS(): Single;
    private
      procedure MainTimerUpdate(const ADeltaTime: Double);
    public
      constructor Create;
      destructor Destroy; override;

      ///<summary>����� ���������� ��� ������������� ����������.</summary>
      ///<param name="AParameter">������-�������� ��� �������������.</param>
      procedure OnInitialize(AParameter: TObject = nil); override;

      ///<summary>����� ������ ��� ��������� ��� ����������� ����������.</summary>
      ///<param name="AIsActivate">�������� True ������ ��� ���������,
      /// �������� False - ��� �����������.</param>
      procedure OnActivate(AIsActivate: Boolean); override;

      ///<summary>����� ���������� ��� ��������� ����.</summary>
      ///<param name="ALayer">���� ����� ��� ���������.</param>
      procedure OnDraw(const ALayer: Integer); override;

      ///<summary>����� ���������� �������� ��� ���������� ��������� ����������.</summary>
      ///<param name="ADelta">���������� ������� � ��������,
      /// ��������� � ����������� ���������� ���������.</param>
      procedure OnUpdate(const ADelta: Double); override;

      ///<summary>����� ��������� ��� ����������� ������ ����������.</summary>
      procedure OnDestroy; override;

      ///<summary>����� ���������� ��� ������� �� ������� "�������� �����"</summary>
      ///<param name="AMousePosition">������� ���������� ����,
      /// ������������ ������ �������� ���� �������� ����.</param>
      ///<returns>������������ ���������� �������� ������������� � ���,
      /// ���� �� ������� ����������.</returns>
      function OnMouseMove(const AMousePosition: TVectorF): Boolean; override;

      ///<summary>����� ���������� ��� ������� �� ������� <b><i>������� ������ ����</i></b></summary>
      ///<param name="AButton">������� ������ ����.</param>
      ///<param name="AMousePosition">���������� ���� � ������ ������� ������,
      /// ������������ ������ �������� ���� �������� ����.</param>
      ///<returns>������������ ���������� �������� ������������� � ���,
      ///���� �� ������� ����������.</returns>
      ///<remarks>�������� ������������ <see creg="QCore.Input|TMouseButton" />
      /// ����� ����� � ������ QCore.Input.</remarks>
      function OnMouseButtonDown(
        AButton: TMouseButton; const AMousePosition: TVectorF): Boolean; override;

      ///<summary>����� ���������� ��� ������� �� ������� <b><i>���������� ������ ����</i></b></summary>
      ///<param name="AButton">���������� ������ ����.</param>
      ///<param name="AMousePosition">���������� ���� � ������ ���������� ������,
      /// ������������ ������ �������� ���� �������� ����.</param>
      ///<returns>������������ ���������� �������� ������������� � ���,
      ///���� �� ������� ����������.</returns>
      ///<remarks>�������� ������������ <see creg="QCore.Input|TMouseButton" />
      /// ����� ����� � ������ QCore.Input.</remarks>
      function OnMouseButtonUp(
        AButton: TMouseButton; const AMousePosition: TVectorF): Boolean; override;

      ///<summary>����� ���������� ��� ������� �� ������� <b><i>��������� ������ ���� ����</i></b></summary>
      ///<param name="ADirection">����������� ��������� ������.
      /// �������� +1 ������������� ��������� �����, -1 - ����.</param>
      ///<param name="AMousePosition">���������� ���� � ������ ��������� ������,
      /// ������������ ������ �������� ���� �������� ����.</param>
      ///<returns>������������ ���������� �������� ������������� � ���,
      ///���� �� ������� ����������.</returns>
      function OnMouseWheel(ADirection: Integer;
        const AMousePosition: TVectorF): Boolean; override;

      ///<summary>����� ���������� ��� ������ �� ������� <b><i>������� ������ �� ����������</i></b></summary>
      ///<param name="AKey">������� ������ �� ����������.</param>
      ///<returns>������������ ���������� �������� ������������� � ���,
      ///���� �� ������� ����������.</returns>
      ///<remarks>�������� �������� TKeyButton ����� ����� � ������ uInput.</remarks>
      function OnKeyDown(AKey: TKeyButton): Boolean; override;

      ///<summary>����� ���������� ��� ������ �� ������� <b><i>���������� ������ �� ����������</i></b></summary>
      ///<param name="AKey">���������� ������ �� ����������.</param>
      ///<returns>������������ ���������� �������� ������������� � ���,
      ///���� �� ������� ����������.</returns>
      ///<remarks>�������� �������� TKeyButton ����� ����� � ������ uInput.</remarks>
      function OnKeyUp(AKey: TKeyButton): Boolean; override;

      ///<summary>����� ��������� ��������� ������� �����������.</summary>
      procedure Loop;
      procedure Stop;

      ///<summary>��������� ���� ���� <see cref="QApplication.Window|TWindow" />
      /// ������������� ����������.</summary>
      property Window: TWindow read FWindow;
      ///<summary>��������� ������ ���� ���� <see cref="QGame.Game|TQGame" />
      /// ��� ������������ �� ����.</summary>
      property Game: TQGame read FGame;
      ///<summary>���������, ����������� ��������� ��������� ���������� � ����.</summary>
      property ControlState: IControlState read FControlState;
      ///<summary>������� ���������� ���������� � ������ ���������� ������� ����.</summary>
      property Resolution: TVectorI read FResolution;
      ///<summary>������� ���������� ���������� (� ������) �� ��������� �������.</summary>
      property FPS: Single read GetFPS;
  end;

var
  TheApplication: TQApplication = nil;
  TheControlState: IControlState = nil;
  TheMouseState: IMouseState = nil;
  TheKeyboardState: IKeyboardState = nil;

implementation

uses
  Windows,
  Messages,
  SysUtils,
  Generics.Collections,
  QEngine.Core;

type
  TControlState = class sealed (TBaseObject, IControlState, IMouseState, IKeyboardState)
    strict private
      FMousePosition: TVectorF;
      FButtonsState: array [0..2] of Boolean;
      FKeysState: array [0..KEYBOARD_KEYS] of Boolean;
      FWheelState: TMouseWheelState;

      function GetMouseState(): IMouseState;
      function GetKeyboardState(): IKeyboardState;

      function GetX(): Single;
      function GetY(): Single;
      function GetPosition(): TVectorF;
      function GetIsButtonPressed(AButton: TMouseButton): Boolean;
      function GetWheelState(): TMouseWheelState;

      function GetIsKeyPressed(AKey: TKeyButton): Boolean;
    private
      procedure ClearWheelState;
      procedure SetWheelState(ADirection: Integer);
      procedure SetButtonState(AButton: TMouseButton; AState: Boolean);
      procedure SetMousePosition(const APosition: TVectorF);
      procedure SetKeyState(AKey: TKeyButton; AState: Boolean);
    public
      constructor Create;

      property Mouse: IMouseState read GetMouseState;
      property Keyboard: IKeyboardState read GetKeyboardState;
      property X: Single read GetX;
      property Y: Single read GetY;
      property Position: TVectorF read GetPosition;
      property IsButtonPressed[AButton: TMouseButton]: Boolean read GetIsButtonPressed;
      property WheelState: TMouseWheelState read GetWheelState;
      property IsKeyPressed[AKey: TKeyButton]: Boolean read GetIsKeyPressed;
    end;

{$REGION '  TControlState  '}
constructor TControlState.Create;
var
  I: Integer;
begin
  FMousePosition.Create(0, 0);
  for I := 0 to 2 do
    FButtonsState[I] := False;
  for I := 0 to KEYBOARD_KEYS do
    FKeysState[I] := False;
  FWheelState := mwsNone;
end;

function TControlState.GetIsButtonPressed(AButton: TMouseButton): Boolean;
begin
  Result := FButtonsState[Integer(AButton)];
end;

function TControlState.GetIsKeyPressed(AKey: TKeyButton): Boolean;
begin
  if AKey < KEYBOARD_KEYS then
    Result := FKeysState[AKey]
  else
    Result := False;
end;

function TControlState.GetKeyboardState: IKeyboardState;
begin
  Result := Self;
end;

function TControlState.GetMouseState: IMouseState;
begin
  Result := Self;
end;

function TControlState.GetPosition: TVectorF;
begin
  Result := FMousePosition;
end;

function TControlState.GetWheelState: TMouseWheelState;
begin
  Result := FWheelState;
end;

function TControlState.GetX: Single;
begin
  Result := FMousePosition.X;
end;

function TControlState.GetY: Single;
begin
  Result := FMousePosition.Y;
end;

procedure TControlState.ClearWheelState;
begin
  FWheelState := mwsNone;
end;

procedure TControlState.SetWheelState;
begin
  if ADirection > 0 then
    FWheelState := mwsUp
  else
    FWheelState := mwsDown;
end;

procedure TControlState.SetButtonState;
begin
  FButtonsState[Integer(AButton)] := AState;
end;

procedure TControlState.SetMousePosition;
begin
  FMousePosition := APosition;
end;

procedure TControlState.SetKeyState;
begin
  if (AKey < KEYBOARD_KEYS) then
    FKeysState[AKey] := AState;
end;
{$ENDREGION}

{$REGION '  TQApplicationParameters  '}
constructor TQApplicationParameters.Create(
  AGame: TQGame;
  AResolution: TVector2I;
  AIsFullscreen: Boolean;
  ATimerDelta: Word = 16);
begin
  if not Assigned(AGame) then
    raise EArgumentException.Create(
      '�� ������ ������ ����. ' +
      '{11946C86-12FC-4907-9E74-F3C844A372CD}');

  FGame := AGame;
  FResolution := AResolution;
  FIsFullscreen := AIsFullscreen;
  FTimerDelta := ATimerDelta;
end;
{$ENDREGION}

{$REGION '  TQApplication  '}
procedure MainTimerCallback(var ADelta: Double); stdcall;
begin
  if Assigned(TheApplication) then
    TheApplication.MainTimerUpdate(ADelta);
end;

constructor TQApplication.Create;
begin
  Inc(FRefCount);

  //FIsRuning := False;
  FIsStoped := True;

  FWindow := TWindow.Create(Self);
  FControlState := TControlState.Create;
  FCriticalSection := TCriticalSection.Create;
  FMessageQueue := TMessageQueue.Create;

  TheControlState := ControlState;
  TheMouseState := TheControlState.Mouse;
  TheKeyboardState := TheControlState.Keyboard;
end;

destructor TQApplication.Destroy;
begin
  FMainTimer := nil;

  if Assigned(FGame) then
    FGame.OnDestroy;
  FreeAndNil(FGame);

  if Assigned(FWindow) then
    FreeAndNil(FWindow);
  FreeAndNil(FCriticalSection);
  FreeAndNil(FMessageQueue);

  FControlState := nil;
  TheControlState := nil;
  TheMouseState := nil;
  TheKeyboardState := nil;

  FMainTimer := nil;

  inherited;
end;

function TQApplication.GetFPS;
begin
  if Assigned(FMainTimer) then
    Result := FMainTimer.GetFPS
  else
    Result := 0;
end;

procedure TQApplication.SetupWindow;
var
  AWindowCaption: string;
begin
  AWindowCaption := FGame.Name + ' (' + FGame.Version + ')';
  FWindow.CreateWindow(AWindowCaption, Resolution.X, Resolution.Y);
end;

procedure TQApplication.SetupTimer(ATimerDelta: Word);
begin
  TheDevice.CreateTimer(FMainTimer);
  FMainTimer.SetState(False);
  FMainTimer.SetCallBack(@MainTimerCallback);
  FMainTimer.SetInterval(ATimerDelta);
end;

procedure TQApplication.ProcessMessageQueue;
var
  AQueue: TList<QApplication.Input.TEventMessage>;
  AMessage: QApplication.Input.TEventMessage;
  APosition: TVectorF;
  ADirection: Integer;
  AButton: TMouseButton;
  AKey: TKeyButton;
  AState: Boolean;
begin
  AQueue := FMessageQueue.GetQueue;
  for AMessage in AQueue do
  begin
    case AMessage.MessageType of
      emtActivate:
        begin
          if not (AMessage is TActivateEventMessage) then
            Continue;

          AState := (AMessage as TActivateEventMessage).IsActive;
          if Assigned(FGame) then
            FGame.OnActivate(AState);
        end;

      emtMouseEvent:
        begin
          if not (AMessage is TMouseEventMessage) then
            Continue;

          APosition := (AMessage as TMouseEventMessage).Position;
          (FControlState as TControlState).SetMousePosition(APosition);
          if Assigned(FGame) then
            FGame.OnMouseMove(APosition);
        end;

      emtMouseButtonEvent:
        begin
          if not (AMessage is TMouseButtonEventMessage) then
            Continue;

          AState := (AMessage as TMouseButtonEventMessage).IsPressed;
          AButton := (AMessage as TMouseButtonEventMessage).Button;
          APosition := (AMessage as TMouseButtonEventMessage).Position;
          (FControlState as TControlState).SetMousePosition(APosition);
          (FControlState as TControlState).SetButtonState(AButton, AState);
          if AState then
          begin
            if Assigned(FGame) then
              FGame.OnMouseButtonDown(AButton, APosition);
          end
          else
          begin
            if Assigned(FGame) then
              FGame.OnMouseButtonUp(AButton, APosition);
          end;
        end;

      emtWheelEvent:
        begin
          if not (AMessage is TWheelEventMessage) then
            Continue;

          APosition := (AMessage as TWheelEventMessage).Position;
          ADirection := (AMessage as TWheelEventMessage).Direction;
          (FControlState as TControlState).SetWheelState(ADirection);
          (FControlState as TControlState).SetMousePosition(APosition);
          if Assigned(FGame) then
            FGame.OnMouseWheel(ADirection, APosition);
        end;

      emtKeyEvent:
        begin
          if not (AMessage is TKeyEventMessage) then
            Continue;

          AState := (AMessage as TKeyEventMessage).IsPressed;
          AKey := (AMessage as TKeyEventMessage).Key;
          (FControlState as TControlState).SetKeyState(AKey, AState);
          if AState then
          begin
            if Assigned(FGame) then
              FGame.OnKeyDown(AKey);
          end
          else
          begin
            if Assigned(FGame) then
              FGame.OnKeyUp(AKey);
          end;
        end;
    end;
    AMessage.Free;
  end;
  FreeAndNil(AQueue);
end;

procedure TQApplication.Loop;
var
  AMessage: TMsg;
  Result: Boolean;
begin
  FIsStoped := False;
  //FIsRuning := True;
  while GetMessageA(AMessage, FWindow.Handle, 0, 0) do// and FIsRuning do
  begin
    if AMessage.message = 0 then
      Break;

    TranslateMessage(AMessage);
    DispatchMessageA(AMessage);

    if FIsStoped then
      DestroyWindow(FWindow.Handle);
  end;
end;

procedure TQApplication.Stop;
begin
  FIsStoped := True;
end;

procedure TQApplication.MainTimerUpdate(const ADeltaTime: Double);
begin
  FCriticalSection.Enter;
    //if FIsRuning then
    //begin
    ProcessMessageQueue;
    OnUpdate(ADeltaTime);
    OnDraw(0);
    (FControlState as TControlState).ClearWheelState;
    //end;

    if FIsStoped then
      FMainTimer.SetState(False);
  FCriticalSection.Leave;
end;

procedure TQApplication.OnInitialize(AParameter: TObject = nil);
var
  AOptions: TQApplicationParameters;
begin
  if not Assigned(AParameter) then
    raise EArgumentException.Create(
      '�� ������� ��������� ��� ������������� ����������. ' +
      '{4B5CB812-602E-4713-8581-B59B35576786}');

  if not (AParameter is TQApplicationParameters) then
    raise EArgumentException.Create(
      '������������ ������ ���������� �������������. ' +
      '{DDAF7AF1-9673-4344-93F9-D61D2DA43133}');

  AOptions := AParameter as TQApplicationParameters;
  FGame := AOptions.Game;
  FResolution := AOptions.Resolution;
  FIsFullscreen := AOptions.IsFullscreen;

  SetupWindow;
  SetupTimer(AOptions.TimerDelta);
  TheRender.Initialize(Window.Handle, Resolution.X, Resolution.Y, FIsFullscreen);

  FreeAndNil(AOptions);
  FGame.OnInitialize;
end;

procedure TQApplication.OnActivate(AIsActivate: Boolean);
begin
  if Assigned(FMainTimer) then
  begin
    FMainTimer.SetState(AIsActivate);
    FMessageQueue.AddToQueue(TActivateEventMessage.Create(AIsActivate));
  end;
end;

procedure TQApplication.OnDraw(const ALayer: Integer);
begin
  if Assigned(FGame) then
  begin
    TheRender.BeginRender;
      FGame.OnDraw(0);
    TheRender.EndRender;
  end;
end;

procedure TQApplication.OnUpdate(const ADelta: Double);
begin
  if Assigned(FGame) then
    FGame.OnUpdate(ADelta);
end;

procedure TQApplication.OnDestroy;
begin
  FMainTimer.SetState(False);
end;

function TQApplication.OnMouseMove;
begin
  Result := True;
  FMessageQueue.AddToQueue(TMouseEventMessage.Create(AMousePosition));
end;

function TQApplication.OnMouseButtonDown;
begin
  Result := True;
  FMessageQueue.AddToQueue(TMouseButtonEventMessage.Create(AButton, True, AMousePosition));
end;

function TQApplication.OnMouseButtonUp;
begin
  Result := True;
  FMessageQueue.AddToQueue(TMouseButtonEventMessage.Create(AButton, False, AMousePosition));
end;

function TQApplication.OnMouseWheel;
begin
  Result := True;
  FMessageQueue.AddToQueue(TWheelEventMessage.Create(ADirection, AMousePosition));
end;

function TQApplication.OnKeyDown;
begin
  Result := True;
  FMessageQueue.AddToQueue(TKeyEventMessage.Create(AKey, True));

  if AKey = KB_ALT then
    FIsAltPressed := True;
  if (AKey = KB_F4) and FIsAltPressed then
    Stop;
end;

function TQApplication.OnKeyUp;
begin
  Result := True;
  FMessageQueue.AddToQueue(TKeyEventMessage.Create(AKey, False));

  if AKey = KB_ALT then
    FIsAltPressed := False;
end;
{$ENDREGION}

end.

