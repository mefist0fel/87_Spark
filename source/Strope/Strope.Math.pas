unit Strope.Math;

interface

type
  TInterpolationType = (
    itLinear = 0,
    itHermit01 = 1,
    itHermit10 = 2,
    itParabolic01 = 3,
    itParabolic10 = 4,
    itSquareRoot01 = 5,
    itSquareRoot10 = 6
  );

  TVector2I = packed record
    public
      constructor Create(X, Y: Integer);

      class operator Negative(const AVector: TVector2I): TVector2I;
      class operator Positive(const AVector: TVector2I): TVector2I;
      class operator Equal(const A, B: TVector2I): Boolean;
      class operator NotEqual(const A, B: TVector2I): Boolean;
      class operator Add(const A, B: TVector2I): TVector2I;
      class operator Subtract(const A, B: TVector2I): TVector2I;
      class operator Multiply(const A, B: TVector2I): TVector2I;
      class operator Multiply(A: Integer; const B: TVector2I): TVector2I;
      class operator Multiply(const A: TVector2I; B: Integer): TVector2I;

      function Length(): Single;
      function LengthSqr(): Single;

      case Byte of
        0: (X, Y: Integer);
        1: (Arr: array [0..1] of Integer);
  end;

  TVector2F = packed record
    public
      constructor Create(X, Y: Single); overload;

      class operator Implicit(const AVector: TVector2I): TVector2F;
      class operator Explicit(const AVector: TVector2I): TVector2F;
      class operator Negative(const AVector: TVector2F): TVector2F;
      class operator Trunc(const AVector: TVector2F): TVector2I;
      class operator Round(const AVector: TVector2F): TVector2I;
      class operator Positive(const AVector: TVector2F): TVector2F;
      class operator Equal(const A, B: TVector2F): Boolean;
      class operator NotEqual(const A, B: TVector2F): Boolean;
      class operator Add(const A, B: TVector2F): TVector2F;
      class operator Subtract(const A, B: TVector2F): TVector2F;
      class operator Multiply(const A, B: TVector2F): Single; overload;
      class operator Multiply(const A: TVector2F; B: Single): TVector2F; overload;
      class operator Multiply(A: Single; const B: TVector2F): TVector2F; overload;

      function ComponentwiseMultiply(const AVector: TVector2F): TVector2F;
      function ComponentwiseDivide(const AVector: TVector2F): TVector2F;

      function Length(): Single;
      function LengthSqr(): Single;

      function Normalized(): TVector2F;
      function Normalize(): TVector2F;

      function Angle(const AVector: TVector2F): Single;

      function InterpolateTo(const AVector: TVector2F; AProgress: Single;
        AInterpolationType: TInterpolationType = itLinear): TVector2F;

      case Byte of
        0: (X, Y: Single);
        1: (U, V: Single);
        2: (Arr: array [0..1] of Single);
  end;

  TVector2IHelper = record helper for TVector2I
    public
      function ComponentwiseMultiply(const AVector: TVector2I): TVector2F;
      function ComponentwiseDivide(const AVector: TVector2I): TVector2F;

      function Normalized(): TVector2F;
      function Angle(const AVector: TVector2F): Single;
      function InterpolateTo(const AVector: TVector2F; AProgress: Single;
        AInterpolationType: TInterpolationType = itLinear): TVector2F;
  end;

  TVectorI = TVector2I;
  TVectorF = TVector2F;

const
  ZeroVectorI: TVectorI = (X: 0; Y: 0);
  ZeroVectorF: TVectorF = (X: 0; Y: 0);

function Vec2I(X, Y: Integer): TVector2I; inline;
function Vec2F(X, Y: Single): TVector2F; inline;

{$REGION '  Clamp Functions  '}
function Clamp(AValue, AMax, AMin: Integer): Integer; overload;
function Clamp(AValue, AMax, AMin: Single): Single; overload;
function Clamp(AValue, AMax, AMin: Double): Double; overload;

function ClampToMax(AValue, AMax: Integer): Integer; overload;
function ClampToMax(AValue, AMax: Single): Single; overload;
function ClampToMax(AValue, AMax: Double): Double; overload;

function ClampToMin(AValue, AMin: Integer): Integer; overload;
function ClampToMin(AValue, AMin: Single): Single; overload;
function ClampToMin(AValue, AMin: Double): Double; overload;
{$ENDREGION}

{$REGION '  Interpolate Functions  '}
function InterpolateValue(AFrom, ATo, AProgress: Single;
  AInterpolationType: TInterpolationType = itLinear): Single;
function LinearInterpolate(AFrom, ATo, AProgress: Single): Single;
function Ermit01Interpolate(AFrom, ATo, AProgress: Single): Single;
function Ermit10Interpoalte(AFrom, ATo, AProgress: Single): Single;
function Parabolic01Interpolate(AFrom, ATo, AProgress: Single): Single;
function Parabolic10Interpolate(AFrom, ATo, AProgress: Single): Single;
function SquareRoot01Interpolate(AFrom, ATo, AProgress: Single): Single;
function SquareRoot10Interpolate(AFrom, ATo, AProgress: Single): Single;
{$ENDREGION}

{$REGION '  Angle work Functions  '}
function RoundAngle(Angle: Single): Single;
function AngleBetween(A, B: TVector2F): Single;
{$ENDREGION}

{$REGION '  TVector2F additional Functions  '}
function Distance(A, B: TVector2F): Single;
{$ENDREGION}

implementation

uses
  Math;

{$REGION '  Clamp Functions  '}
function Clamp(AValue, AMax, AMin: Integer): Integer;
begin
  Exit(Max(Min(AValue, AMax), AMin));
end;

function ClampToMax(AValue, AMax: Integer): Integer;
begin
  Exit(Min(AValue, AMax));
end;

function ClampToMin(AValue, AMin: Integer): Integer;
begin
  Exit(Max(AValue, AMin));
end;

function Clamp(AValue, AMax, AMin: Single): Single;
begin
  Exit(Max(Min(AValue, AMax), AMin));
end;

function ClampToMax(AValue, AMax: Single): Single;
begin
  Exit(Min(AValue, AMax));
end;

function ClampToMin(AValue, AMin: Single): Single;
begin
  Exit(Max(AValue, AMin));
end;

function Clamp(AValue, AMax, AMin: Double): Double;
begin
  Exit(Max(Min(AValue, AMax), AMin));
end;

function ClampToMax(AValue, AMax: Double): Double;
begin
  Exit(Min(AValue, AMax));
end;

function ClampToMin(AValue, AMin: Double): Double;
begin
  Exit(Max(AValue, AMin));
end;
{$ENDREGION}

{$REGION '  Interpolate Functions  '}
function InterpolateValue(AFrom, ATo, AProgress: Single;
  AInterpolationType: TInterpolationType = itLinear): Single;
begin
  Result := AFrom;
  case AInterpolationType of
    itLinear: Result := LinearInterpolate(AFrom, ATo, AProgress);
    itHermit01: Result := Ermit01Interpolate(AFrom, ATo, AProgress);
    itHermit10: Result := Ermit10Interpoalte(AFrom, ATo, AProgress);
    itParabolic01: Result := Parabolic01Interpolate(AFrom, ATo, AProgress);
    itParabolic10: Result := Parabolic10Interpolate(AFrom, ATo, AProgress);
    itSquareRoot01: Result := SquareRoot01Interpolate(AFrom, ATo, AProgress);
    itSquareRoot10: Result := SquareRoot10Interpolate(AFrom, ATo, AProgress);
  end;
end;

function LinearInterpolate(AFrom, ATo, AProgress: Single): Single;
begin
  Result := (ATo - AFrom) * Clamp(AProgress, 1, 0);
end;

function Ermit01Interpolate(AFrom, ATo, AProgress: Single): Single;
begin
  AProgress := Clamp(AProgress, 1, 0);
  Result := (ATo - AFrom) * (Sqr(AProgress) * (3 - 2 * AProgress));
end;

function Ermit10Interpoalte(AFrom, ATo, AProgress: Single): Single;
begin
  AProgress := Clamp(AProgress, 1, 0);
  Result := (ATo - AFrom) * (Sqr(1 - AProgress) * (1 + 2 * AProgress));
end;

function Parabolic01Interpolate(AFrom, ATo, AProgress: Single): Single;
begin
  Result := (ATo - AFrom) * Sqr(AProgress);
end;

function Parabolic10Interpolate(AFrom, ATo, AProgress: Single): Single;
begin
  Result := (ATo - AFrom) * (1 - Sqr(AProgress));
end;

function SquareRoot01Interpolate(AFrom, ATo, AProgress: Single): Single;
begin
  Result := (ATo - AFrom) * Sqrt(AProgress);
end;

function SquareRoot10Interpolate(AFrom, ATo, AProgress: Single): Single;
begin
  Result := (ATo - AFrom) * Sqrt(1 - AProgress);
end;
{$ENDREGION}

{$REGION '  Angle work Functions  '}
function RoundAngle(Angle: Single): Single;
begin
  Repeat
    If Angle < 0 then
      Angle := Angle + 360;
    If Angle >= 360 then
      Angle := Angle - 360;
  Until (Angle >= 0) and (Angle<360);
  Result:= Angle;
end;

function AngleBetween(A, B: TVector2F): Single;
var
  S, C: Single;
begin
  C := (B.Y - A.Y) / Distance(A, B);
  If C > 1 then
    C := 1;
  If C < -1 then
    C := -1;
  S := (arccos(C)) * 180 / PI;
  If (A.X - B.X) > 0 then
     S := RoundAngle(360 - S);
  S := RoundAngle(180 - S);
  Result:= S;
end;
{$ENDREGION}

{$REGION '  TVector2F additional Functions  '}
function Distance(A, B: TVector2F): Single;
begin
  Result:= Sqrt(Sqr(A.X - B.X) + Sqr(A.Y - B.Y));
end;
{$ENDREGION}

{$REGION '  TVector2I  '}
function Vec2I(X, Y: Integer): TVector2I;
begin
  Result.Create(X, Y);
end;

constructor TVector2I.Create(X, Y: Integer);
begin
  Self.X := X;
  Self.Y := Y;
end;

class operator TVector2I.Negative(const AVector: TVector2I): TVector2I;
begin
  Result.X := -AVector.X;
  Result.Y := -AVector.Y;
  Exit(Result);
end;

class operator TVector2I.Positive(const AVector: TVector2I): TVector2I;
begin
  Exit(AVector);
end;

class operator TVector2I.Equal(const A, B: TVector2I): Boolean;
begin
  Exit((A.X = B.X) and (A.Y = B.Y));
end;

class operator TVector2I.NotEqual(const A, B: TVector2I): Boolean;
begin
  Exit((A.X <> B.X) and (A.Y <> B.Y));
end;

class operator TVector2I.Add(const A, B: TVector2I): TVector2I;
begin
  Result.Create(A.X + B.X, A.Y + B.Y);
end;

class operator TVector2I.Subtract(const A, B: TVector2I): TVector2I;
begin
  Result.Create(A.X - B.X, A.Y - B.Y);
end;

class operator TVector2I.Multiply(const A, B: TVector2I): TVector2I;
begin
  Result.Create(A.X * B.X, A.Y * B.Y);
end;

class operator TVector2I.Multiply(A: Integer; const B: TVector2I): TVector2I;
begin
  Result.Create(A * B.X, A * B.Y);
end;

class operator TVector2I.Multiply(const A: TVector2I; B: Integer): TVector2I;
begin
  Result.Create(A.X * B, A.Y * B);
end;

function TVector2I.Length(): Single;
begin
  Result := Sqrt(Sqr(Self.X) + Sqr(Self.Y));
end;

function TVector2I.LengthSqr(): Single;
begin
  Result := Sqr(Self.X) + Sqr(Self.Y);
end;
{$ENDREGION}

{$REGION '  TVector2F  '}
function Vec2F(X, Y: Single): TVector2F;
begin
  Result.Create(X, Y);
end;

constructor TVector2F.Create(X, Y: Single);
begin
  Self.X := X;
  Self.Y := Y;
end;

class operator TVector2F.Implicit(const AVector: TVector2I): TVector2F;
begin
  Result.Create(AVector.X, AVector.Y);
end;

class operator TVector2F.Explicit(const AVector: TVector2I): TVector2F;
begin
  Result.Create(AVector.X, AVector.Y);
end;

class operator TVector2F.Negative(const AVector: TVector2F): TVector2F;
begin
  Result.X := -Result.X;
  Result.Y := -Result.Y;
  Exit(Result);
end;

class operator TVector2F.Trunc(const AVector: TVector2F): TVector2I;
begin
  Result.Create(Trunc(AVector.X), Trunc(AVector.Y));
end;

class operator TVector2F.Round(const AVector: TVector2F): TVector2I;
begin
  Result.Create(Round(AVector.X), Round(AVector.Y));
end;

class operator TVector2F.Positive(const AVector: TVector2F): TVector2F;
begin
  Exit(AVector);
end;

class operator TVector2F.Equal(const A, B: TVector2F): Boolean;
begin
  Exit((A.X = B.X) and (A.Y = B.Y));
end;

class operator TVector2F.NotEqual(const A, B: TVector2F): Boolean;
begin
  Exit((A.X <> B.X) and (A.Y <> B.Y));
end;

class operator TVector2F.Add(const A, B: TVector2F): TVector2F;
begin
  Result.Create(A.X + B.X, A.Y + B.Y);
end;

class operator TVector2F.Subtract(const A, B: TVector2F): TVector2F;
begin
  Result.Create(A.X - B.X, A.Y - B.Y);
end;

class operator TVector2F.Multiply(const A, B: TVector2F): Single;
begin
  Result := A.X * B.X + A.Y * B.Y;
end;

class operator TVector2F.Multiply(const A: TVector2F; B: Single): TVector2F;
begin
  Result.Create(A.X * B, A.Y * B);
end;

class operator TVector2F.Multiply(A: Single; const B: TVector2F): TVector2F;
begin
  Result.Create(A * B.X, A * B.Y);
end;

function TVector2F.ComponentwiseMultiply(const AVector: TVector2F): TVector2F;
begin
  Result.Create(Self.X * AVector.X, Self.Y * AVector.Y);
end;

function TVector2F.ComponentwiseDivide(const AVector: TVector2F): TVector2F;
begin
  Result.Create(Self.X / AVector.X, Self.Y / AVector.Y);
end;

function TVector2F.Length(): Single;
begin
  Result := Sqrt(Sqr(X) + Sqr(Y));
end;

function TVector2F.LengthSqr(): Single;
begin
  Result := Sqr(X) + Sqr(Y);
end;

function TVector2F.Normalized(): TVector2F;
var
  ALength: Single;
begin
  ALength := Self.Length;
  Result.Create(Self.X / ALength, Self.Y / ALength);
end;

function TVector2F.Normalize(): TVector2F;
var
  ALength: Single;
begin
  ALength := Self.Length;
  Result.Create(Self.X / ALength, Self.Y / ALength);
  Self := Result;
end;

function TVector2F.Angle(const AVector: TVector2F): Single;
const
  Zero: TVector2F = (X: 0; Y: 0);
begin
  if (Zero = AVector) or (Zero = Self) then
    Exit(0);

  Result := ArcCos(Self * AVector / (Self.Length * AVector.Length));
end;

function TVector2F.InterpolateTo(const AVector: TVector2F; AProgress: Single;
  AInterpolationType: TInterpolationType = itLinear): TVector2F;
begin
  Result.Create(
    InterpolateValue(Self.X, AVector.X, AProgress, AInterpolationType),
    InterpolateValue(Self.Y, AVector.Y, AProgress, AInterpolationType));
end;
{$ENDREGION}

{$REGION '  TVector2IHelper  '}
function TVector2IHelper.ComponentwiseMultiply(const AVector: TVector2I): TVector2F;
begin
  Result.Create(Self.X * AVector.X, Self.Y * AVector.Y);
end;

function TVector2IHelper.ComponentwiseDivide(const AVector: TVector2I): TVector2F;
begin
  Result.Create(Self.X / AVector.X, Self.Y / AVector.Y);
end;

function TVector2IHelper.Normalized(): TVector2F;
var
  ALength: Single;
begin
  ALength := Self.Length;
  Result.Create(Self.X / ALength, Self.Y / ALength);
end;

function TVector2IHelper.Angle(const AVector: TVector2F): Single;
begin
  if (ZeroVectorF = AVector) or (ZeroVectorI = Self) then
    Exit(0);

  Result := ArcCos(Self * AVector / (Self.Length * AVector.Length));
end;

function TVector2IHelper.InterpolateTo(const AVector: TVector2F; AProgress: Single;
  AInterpolationType: TInterpolationType = itLinear): TVector2F;
begin
  Result.Create(
    InterpolateValue(Self.X, AVector.X, AProgress, AInterpolationType),
    InterpolateValue(Self.Y, AVector.Y, AProgress, AInterpolationType));
end;
{$ENDREGION}

end.
