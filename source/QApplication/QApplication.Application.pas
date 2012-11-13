unit QApplication.Application;

interface

uses
  Generics.Collections,
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

  ///<summary>Класс приложения, организующий работу окна, игры и игроого таймера.</summary>
  TQApplication = class sealed (TComponent)
    strict private
      FWindow: TWindow;
      FGame: TQGame;
      FControlState: IControlState;
      FIsStoped: Boolean;
      FMainTimer: IQuadTimer;

      FCriticalSection: TCriticalSection;
      FMessages: TList<TEventMessage>;

      FResolution: TVectorI;
      FIsFullscreen: Boolean;

      FIsAltPressed: Boolean;

      procedure SetupWindow;
      procedure SetupTimer(ATimerDelta: Word);

      procedure ProcessMessages;

      function GetFPS(): Single;
    private
      procedure MainTimerUpdate(const ADeltaTime: Double);
    public
      constructor Create;
      destructor Destroy; override;

      ///<summary>Метод вызывается для инициализации приложения.</summary>
      ///<param name="AParameter">Объект-параметр для инициализации.</param>
      procedure OnInitialize(AParameter: TObject = nil); override;

      ///<summary>Метод служит для активации или деактивации приложения.</summary>
      ///<param name="AIsActivate">Значение True служит для активации,
      /// значение False - для деактивации.</param>
      procedure OnActivate(AIsActivate: Boolean); override;

      ///<summary>Метод вызывается для отрисовки игры.</summary>
      ///<param name="ALayer">Слой сцены для отрисовки.</param>
      procedure OnDraw(const ALayer: Integer); override;

      ///<summary>Метод вызывается таймером для обновления состояния приложения.</summary>
      ///<param name="ADelta">Промежуток времены в секундах,
      /// прошедший с предыдущего обновления состояния.</param>
      procedure OnUpdate(const ADelta: Double); override;

      ///<summary>Метод вызываеся для прекращения работы приложения.</summary>
      procedure OnDestroy; override;

      ///<summary>Метод вызывается для реакции на событие "движение мышки"</summary>
      ///<param name="AMousePosition">Текущие координаты мыши,
      /// относительно левого верхнего края рабочего окна.</param>
      ///<returns>Возвращенное логическое значение сигнализирует о том,
      /// было ли событие обработано.</returns>
      function OnMouseMove(const AMousePosition: TVectorF): Boolean; override;

      ///<summary>Метод вызывается для реакции на событие <b><i>нажатие кнопки мыши</i></b></summary>
      ///<param name="AButton">Нажатая кнопка мыши.</param>
      ///<param name="AMousePosition">Координаты мыши в момент нажатие кнопки,
      /// относительно левого верхнего края рабочего окна.</param>
      ///<returns>Возвращенное логическое значение сигнализирует о том,
      ///было ли событие обработано.</returns>
      ///<remarks>Значения перечисления <see creg="QCore.Input|TMouseButton" />
      /// можно узать в модуле QCore.Input.</remarks>
      function OnMouseButtonDown(
        AButton: TMouseButton; const AMousePosition: TVectorF): Boolean; override;

      ///<summary>Метод вызывается для реакции на событие <b><i>отпускание кнопки мыши</i></b></summary>
      ///<param name="AButton">Отпущенная кнопка мыши.</param>
      ///<param name="AMousePosition">Координаты мыши в момент отпускания кнопки,
      /// относительно левого верхнего края рабочего окна.</param>
      ///<returns>Возвращенное логическое значение сигнализирует о том,
      ///было ли событие обработано.</returns>
      ///<remarks>Значения перечисления <see creg="QCore.Input|TMouseButton" />
      /// можно узать в модуле QCore.Input.</remarks>
      function OnMouseButtonUp(
        AButton: TMouseButton; const AMousePosition: TVectorF): Boolean; override;

      ///<summary>Метод вызывается для реакции на событие <b><i>прокрутка колеса мыши вниз</i></b></summary>
      ///<param name="ADirection">Напревление прокрутки колеса.
      /// Значение +1 соответствует прокрутке вверх, -1 - вниз.</param>
      ///<returns>Возвращенное логическое значение сигнализирует о том,
      ///было ли событие обработано.</returns>
      function OnMouseWheel(ADirection: Integer): Boolean; override;

      ///<summary>Метод вызывается для рекции на событие <b><i>нажатие кнопки на клавиатуре</i></b></summary>
      ///<param name="AKey">Нажатая кнопка на клавиатуре.</param>
      ///<returns>Возвращенное логическое значение сигнализирует о том,
      ///было ли событие обработано.</returns>
      ///<remarks>Значения констант TKeyButton можно узать в модуле uInput.</remarks>
      function OnKeyDown(AKey: TKeyButton): Boolean; override;

      ///<summary>Метод вызывается для рекции на событие <b><i>отпускание кнопки на клавиатуре</i></b></summary>
      ///<param name="AKey">Отпущенная кнопка на клавиатуре.</param>
      ///<returns>Возвращенное логическое значение сигнализирует о том,
      ///было ли событие обработано.</returns>
      ///<remarks>Значения констант TKeyButton можно узать в модуле uInput.</remarks>
      function OnKeyUp(AKey: TKeyButton): Boolean; override;

      ///<summary>Метод запускает обработку событий приложением.</summary>
      procedure Loop;
      procedure Stop;

      ///<summary>Экземпляр окна типа <see cref="QApplication.Window|TWindow" />
      /// принадлежащий приложению.</summary>
      property Window: TWindow read FWindow;
      ///<summary>Экземпляр класса игры типа <see cref="QGame.Game|TQGame" />
      /// или производного от него.</summary>
      property Game: TQGame read FGame;
      ///<summary>Интерфейс, позволяющий проверять состояние клавиатуры и мыши.</summary>
      property ControlState: IControlState read FControlState;
      ///<summary>Рабочее разрешение приложение и размер клиентской области окна.</summary>
      property Resolution: TVectorI read FResolution;
      ///<summary>Среднее количество обновлений (и кадров) за последнюю секунду.</summary>
      property FPS: Single read GetFPS;
      property IsFullscreen: Boolean read FIsFullscreen;
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
      'Не указан объект игры. ' +
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

  FIsStoped := True;

  FWindow := TWindow.Create(Self);
  FControlState := TControlState.Create;
  FCriticalSection := TCriticalSection.Create;
  FMessages := TList<TEventMessage>.Create;

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
  FreeAndNil(FMessages);

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

procedure TQApplication.ProcessMessages;
var
  AMessage: TEventMessage;
begin
  for AMessage in FMessages do
  begin
    case AMessage.MessageType of
      emtMouseEvent:
        if Assigned(FGame) then
          FGame.OnMouseMove(AMessage.MousePosition);

      emtMouseButtonEvent:
        if AMessage.IsMouseButtonPressed then
        begin
          if Assigned(FGame) then
            FGame.OnMouseButtonDown(AMessage.MouseButton, AMessage.MousePosition);
        end
        else
        begin
          if Assigned(FGame) then
            FGame.OnMouseButtonUp(AMessage.MouseButton, AMessage.MousePosition);
        end;

      emtMouseWheelEvent:
        if Assigned(FGame) then
          FGame.OnMouseWheel(AMessage.MouseWheelDirection);

      emtKeyEvent:
        if AMessage.IsKeyPressed then
        begin
          if Assigned(FGame) then
            FGame.OnKeyDown(AMessage.KeyButton);
        end
        else
        begin
          if Assigned(FGame) then
            FGame.OnKeyUp(AMessage.KeyButton);
        end;

    end;
  end;

  FMessages.Clear;
end;

procedure TQApplication.Loop;
var
  AMessage: TMsg;
begin
  FIsStoped := False;
  while GetMessageA(AMessage, FWindow.Handle, 0, 0) do// and FIsRuning do
  begin
    if AMessage.message = 0 then
      Break;

    TranslateMessage(AMessage);
    DispatchMessageA(AMessage);

    if FIsStoped then
      DestroyWindow(FWindow.Handle);
  end;

  FCriticalSection.Enter;
  FCriticalSection.Leave;
end;

procedure TQApplication.Stop;
begin
  FIsStoped := True;
end;

procedure TQApplication.MainTimerUpdate(const ADeltaTime: Double);
begin
  FCriticalSection.Enter;
    ProcessMessages;
    OnUpdate(ADeltaTime);
    OnDraw(0);
    (FControlState as TControlState).ClearWheelState;

    if FIsStoped then
      FMainTimer.SetState(False);

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
      'Не указаны параметры для инициализации приложения. ' +
      '{4B5CB812-602E-4713-8581-B59B35576786}');

  if not (AParameter is TQApplicationParameters) then
    raise EArgumentException.Create(
      'Неправильный формат параметров инициализации. ' +
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
    FMainTimer.SetState(AIsActivate);
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
  FCriticalSection.Enter;
    (FControlState as TControlState).SetMousePosition(AMousePosition);
    FMessages.Add(TEventMessage.CreateAsMouseEvent(AMousePosition));
  FCriticalSection.Leave;
end;

function TQApplication.OnMouseButtonDown;
begin
  Result := True;
  FCriticalSection.Enter;
    (FControlState as TControlState).SetMousePosition(AMousePosition);
    (FControlState as TControlState).SetButtonState(AButton, True);
    FMessages.Add(
      TEventMessage.CreateAsMouseButtonEvent(AMousePosition, AButton, True));
  FCriticalSection.Leave;
end;

function TQApplication.OnMouseButtonUp;
begin
  Result := True;
  FCriticalSection.Enter;
    (FControlState as TControlState).SetMousePosition(AMousePosition);
    (FControlState as TControlState).SetButtonState(AButton, False);
    FMessages.Add(
      TEventMessage.CreateAsMouseButtonEvent(AMousePosition, AButton, False));
  FCriticalSection.Leave;
end;

function TQApplication.OnMouseWheel;
begin
  Result := True;
    FCriticalSection.Enter;
    (FControlState as TControlState).SetWheelState(ADirection);
    FMessages.Add(
      TEventMessage.CreateAsMouseWheelEvent(ADirection));
  FCriticalSection.Leave;
end;

function TQApplication.OnKeyDown;
begin
  Result := True;
  FCriticalSection.Enter;
    (FControlState as TControlState).SetKeyState(AKey, True);
    FMessages.Add(
      TEventMessage.CreateAsKeyEvent(AKey, True));
  FCriticalSection.Leave;

  if AKey = KB_ALT then
    FIsAltPressed := True;
  if (AKey = KB_F4) and FIsAltPressed then
    Stop;
end;

function TQApplication.OnKeyUp;
begin
  Result := True;
  FCriticalSection.Enter;
    (FControlState as TControlState).SetKeyState(AKey, False);
    FMessages.Add(
      TEventMessage.CreateAsKeyEvent(AKey, False));
  FCriticalSection.Leave;

  if AKey = KB_ALT then
    FIsAltPressed := False;
end;
{$ENDREGION}

end.

