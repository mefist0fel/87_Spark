unit QApplication.Window;

interface

uses
  Windows,
  Messages,
  QCore.Types,
  Strope.Math;

type
  TWindow = class sealed
    strict private
      FOwner: TComponent;
      FHandle: THandle;
      FCaption: string;
      FCaptionSize, FBorderSizeX, FBorderSizeY: Word;

      procedure SetCaption(ACaption: string);

      class procedure RegisterWindowClass;
    private
      function WndProc(Msg: Cardinal; WParam, LParam: Integer): Boolean;
    public
      class constructor CreateClass;
      class destructor DestroyClass;

      constructor Create(AOwner: TComponent);
      destructor Destroy; override;

      procedure CreateWindow(const AWindowCaption: string;
        AClientWidth, AClientHeight: Word);

      property Handle: THandle read FHandle;
      property Caption: string read FCaption write SetCaption;
  end;

implementation

uses
  SysUtils,
  QCore.Input;

{$REGION '  TWindow  '}
function WindowProcess(
  HWnd: HWND; Msg: Cardinal;
  WParam, LParam: Integer): Integer; stdcall;
var
  AWindow: TWindow;
begin
  AWindow := TWindow(GetWindowLongA(HWnd, GWL_USERDATA));
  if Assigned(AWindow) then
    if AWindow.WndProc(Msg, WParam, LParam) then
      Exit(0);
  Result := DefWindowProcA(HWnd, Msg, WParam, LParam);
end;

class constructor TWindow.CreateClass;
begin
  RegisterWindowClass;
end;

class destructor TWindow.DestroyClass;
begin
  UnregisterClassA(PAnsiChar('QApplication Window'), HInstance);
end;

constructor TWindow.Create(AOwner: TComponent);
begin
  if Assigned(AOwner) then
    FOwner := AOwner
  else
    raise EArgumentException.Create(
      'Не указан владелец окна. ' +
      '{A12D5AE0-0629-40A4-9DFC-5699104EAF75}');
end;

destructor TWindow.Destroy;
begin
  FOwner := nil;
  if FHandle > 0 then
    DestroyWindow(FHandle);

  inherited;
end;

class procedure TWindow.RegisterWindowClass;
var
  AWndClass: WNDCLASSEXA;
begin
  FillChar(AWndClass, SizeOf(AWndClass), 0);
  with AWndClass do
  begin
    cbSize := SizeOf(AWndClass);
    style := CS_HREDRAW or CS_VREDRAW;
    lpfnWndProc := @WindowProcess;
    hCursor := LoadCursorA(0, PAnsiChar(IDC_ARROW));
    hIcon := LoadIconA(0, PAnsiChar(IDI_APPLICATION));
    hbrBackground := HBRUSH(GetStockObject(BLACK_BRUSH));
    lpszClassName := PAnsiChar('QApplication Window');
  end;
  AWndClass.hInstance := HInstance;

  if RegisterClassExA(AWndClass) = 0 then
    raise Exception.Create(
      'Window class register fail. ' +
      '{6393A518-7353-41A1-9468-61B83F854164}');
end;

function TWindow.WndProc(Msg: Cardinal; WParam, LParam: Integer): Boolean;
var
  X, Y: Integer;
begin
  Result := False;
  case Msg of
    {$REGION '  Focus  '}
    WM_SETFOCUS:
      begin
        FOwner.OnActivate(True);
        Exit(True);
      end;
    WM_KILLFOCUS:
      begin
        FOwner.OnActivate(False);
        Exit(True);
      end;
    {$ENDREGION}

    {$REGION '  Keyboard input  '}
    WM_KEYDOWN:
      begin
        FOwner.OnKeyDown(WParam);
        Exit(True);
      end;
    WM_KEYUP:
      begin
        FOwner.OnKeyUp(WParam);
        Exit(True);
      end;
    WM_SYSKEYDOWN:
      begin
        FOwner.OnKeyDown(WParam);
        Exit(True);
      end;
    WM_SYSKEYUP:
      begin
        FOwner.OnKeyUp(WParam);
        Exit(True);
      end;
    {$ENDREGION}

    {$REGION '  Mouse input  '}
    WM_MOUSEMOVE:
      begin
        X := LParam and $0000FFFF;
        Y := (LParam and $FFFF0000) shr 16;
        FOwner.OnMouseMove(TVectorF.Create(X, Y));
        Exit(True);
      end;
    WM_LBUTTONDOWN:
      begin
        X := LParam and $0000FFFF;
        Y := (LParam and $FFFF0000) shr 16;
        FOwner.OnMouseButtonDown(mbLeft, TVectorF.Create(X, Y));
        Exit(True);
      end;
    WM_LBUTTONUP:
      begin
        X := LParam and $0000FFFF;
        Y := (LParam and $FFFF0000) shr 16;
        FOwner.OnMouseButtonUp(mbLeft, TVectorF.Create(X, Y));
        Exit(True);
      end;
    WM_RBUTTONDOWN:
      begin
        X := LParam and $0000FFFF;
        Y := (LParam and $FFFF0000) shr 16;
        FOwner.OnMouseButtonDown(mbRight, TVectorF.Create(X, Y));
        Exit(True);
      end;
    WM_RBUTTONUP:
      begin
        X := LParam and $0000FFFF;
        Y := (LParam and $FFFF0000) shr 16;
        FOwner.OnMouseButtonUp(mbRight, TVectorF.Create(X, Y));
        Exit(True);
      end;
    WM_MBUTTONDOWN:
      begin
        X := LParam and $0000FFFF;
        Y := (LParam and $FFFF0000) shr 16;
        FOwner.OnMouseButtonDown(mbMiddle, TVectorF.Create(X, Y));
        Exit(True);
      end;
    WM_MBUTTONUP:
      begin
        X := LParam and $0000FFFF;
        Y := (LParam and $FFFF0000) shr 16;
        FOwner.OnMouseButtonUp(mbMiddle, TVectorF.Create(X, Y));
        Exit(True);
      end;
    WM_MOUSEWHEEL:
      begin
        X := LParam and $0000FFFF;
        Y := (LParam and $FFFF0000) shr 16;
        if WParam > 0 then
          FOwner.OnMouseWheel(1, TVectorF.Create(X, Y))
        else
          FOwner.OnMouseWheel(-1, TVectorF.Create(X, Y));
        Exit(True);
      end;
    {$ENDREGION}

    WM_CLOSE:
      begin
        FOwner.OnDestroy;
        PostQuitMessage(0);
      end;
  end;
end;

procedure TWindow.SetCaption(ACaption: string);
begin
  FCaption := ACaption;
  SetWindowText(FHandle, ACaption);
end;

procedure TWindow.CreateWindow(
  const AWindowCaption: string;
  AClientWidth, AClientHeight: Word);
var
  AWindowWidth, AWindowHeight: Word;
begin
  if FHandle <> 0 then
    raise Exception.Create(
      'Window already created! ' +
      '{7C6D90CE-6214-4650-B210-23463687980E}');

  FCaptionSize := GetSystemMetrics(SM_CYCAPTION );
  FBorderSizeX := GetSystemMetrics(SM_CXDLGFRAME);
  FBorderSizeY := GetSystemMetrics(SM_CYDLGFRAME);
  AWindowWidth := AClientWidth + 2 * FBorderSizeX;
  AWindowHeight := AClientHeight + 2 * FBorderSizeY + FCaptionSize;

  FHandle := CreateWindowExA(
    WS_EX_APPWINDOW or WS_EX_WINDOWEDGE,
    PAnsiChar('QApplication Window'),
    PAnsiChar(AnsiString(AWindowCaption)),
		WS_CAPTION or WS_BORDER or WS_SYSMENU or WS_MINIMIZEBOX,
    Round((GetSystemMetrics(SM_CXSCREEN) - AWindowWidth) * 0.5),
    Round((GetSystemMetrics(SM_CYSCREEN) - AWindowHeight) * 0.5),
    AWindowWidth, AWindowHeight,
    0, 0, HInstance, nil);

  if FHandle = 0 then
    raise Exception.Create(
    'Window create fail. ' +
      '{4B351846-BBAA-4D0C-A572-D52D09F8B14D}');
  FCaption := AWindowCaption;

  ShowCursor(True);
  SetForegroundWindow(FHandle);
  ShowWindow(FHandle, SW_SHOW);
  SetFocus(FHandle);
  UpdateWindow(FHandle);
  SetWindowLongA(FHandle, GWL_USERDATA, Cardinal(Self));
end;
{$ENDREGION}

end.

