unit QCore.Input;

interface

uses
  Strope.Math;

const
  KEYBOARD_KEYS = 255;
  KB_BACKSPACE = 8;
  KB_TAB = 9;
  KB_ENTER = 13;
  KB_SHIFT = 16;
  KB_ALT = 18;
  KB_ESC = 27;
  KB_SPACE = 32;
  KB_PAGEUP = 33;
  KB_PAGEDOWN = 34;
  KB_LEFT = 37;
  KB_UP = 38;
  KB_RIGHT = 39;
  KB_DOWN = 40;
  KB_A = 65;
  KB_B = 66;
  KB_C = 67;
  KB_D = 68;
  KB_E = 69;
  KB_F = 70;
  KB_G = 71;
  KB_H = 72;
  KB_L = 76;
  KB_Q = 81;
  KB_S = 83;
  KB_V = 86;
  KB_W = 87;
  KB_PLUS = 107;
  KB_MINUS = 109;
  KB_F4 = 115;

type
  ///<summary>Перечисление определяет коды, соответствующие кнопкам мыши.</summary>
  TMouseButton = (
    mbLeft = 0,
    mbMiddle = 1,
    mbRight = 2
  );

  ///<summary>Перечисление определяет коды, соответствующие действию скролла.</summary>
  TMouseWheelState = (
    mwsNone = 0,
    mwsUp = 1,
    mwsDown = 2
  );

  TKeyButton = Word;

  IMouseState = interface (IUnknown)
    function GetX(): Single;
    function GetY(): Single;
    function GetPosition(): TVectorF;
    function GetIsButtonPressed(AButton: TMouseButton): Boolean;
    function GetWheelState(): TMouseWheelState;

    property X: Single read GetX;
    property Y: Single read GetY;
    property Position: TVectorF read GetPosition;
    property IsButtonPressed[AButton: TMouseButton]: Boolean read GetIsButtonPressed;
    property WheelState: TMouseWheelState read GetWheelState;
  end;

  IKeyboardState = interface (IUnknown)
    function GetIsKeyPressed(AKey: TKeyButton): Boolean;

    {property Tab: Boolean read GetIsKeyPressed(KB_TAB);
    property Enter: Boolean read GetIsKeyPressed(KB_ENTER);
    property Shift: Boolean read GetIsKeyPressed(KB_SHIFT);
    property Alt: Boolean read GetIsKeyPressed(KB_ALT);
    property Esc: Boolean read GetIsKeyPressed(KB_ESC);
    property Space: Boolean read GetIsKeyPressed(KB_SPACE);
    property PageUp: Boolean read GetIsKeyPressed(KB_PAGEUP);
    property PageDown: Boolean read GetIsKeyPressed(KB_PAGEDOWN);
    property Left: Boolean read GetIsKeyPressed(KB_LEFT);
    property Up: Boolean read GetIsKeyPressed(KB_UP);
    property Right: Boolean read GetIsKeyPressed(KB_RIGHT);
    property Down: Boolean read GetIsKeyPressed(KB_DOWN);
    property A: Boolean read GetIsKeyPressed(KB_A);
    property B: Boolean read GetIsKeyPressed(KB_B);
    property C: Boolean read GetIsKeyPressed(KB_C);
    property D: Boolean read GetIsKeyPressed(KB_D);
    property E: Boolean read GetIsKeyPressed(KB_E);
    property F: Boolean read GetIsKeyPressed(KB_F);
    property G: Boolean read GetIsKeyPressed(KB_G);
    property H: Boolean read GetIsKeyPressed(KB_H);
    property L: Boolean read GetIsKeyPressed(KB_L);
    property Q: Boolean read GetIsKeyPressed(KB_Q);
    property S: Boolean read GetIsKeyPressed(KB_S);
    property V: Boolean read GetIsKeyPressed(KB_V);
    property W: Boolean read GetIsKeyPressed(KB_W);
    property Plus: Boolean read GetIsKeyPressed(KB_PLUS);
    property Minus: Boolean read GetIsKeyPressed(KB_MINUS);
    property F4: Boolean read GetIsKeyPressed(KB_F4);}
    property IsKeyPressed[AKey: TKeyButton]: Boolean read GetIsKeyPressed;
  end;

  IControlState = interface (IUnknown)
    function GetMouseState(): IMouseState;
    function GetKeyboardState(): IKeyboardState;

    property Mouse: IMouseState read GetMouseState;
    property Keyboard: IKeyboardState read GetKeyboardState;
  end;

implementation

end.
