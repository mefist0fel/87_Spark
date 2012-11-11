unit Project87.Types.SystemGenerator;

interface

const
  MAX_NOISE_VALUES = $ff;
  STABLE_NOISE_COMPONENT = 8023;
  NOISE_MULTIPLIER = 317;
  BIG_SIMPLE_NUMBER = 54789;
  SEED = 5330;

type
  TNoise = record
    Values: array [0..MAX_NOISE_VALUES] of Byte;
  end;

  TSystemGenerator = class
    private class var FInstance: TSystemGenerator;
    private
      FNoise: TNoise;
      procedure GenerateNoise;
      constructor Create();
    public
      class procedure GenerateSystem();
  end;

implementation

{$REGION '  TSystemGenerator  '}
procedure TSystemGenerator.GenerateNoise;
var
  I, J: Word;
  Generator: Integer;
  Number, Temp: Byte;
begin
  for I := 0 to MAX_NOISE_VALUES do
    FNoise.Values[I] := I;
  Generator := SEED;
  for J := 0 to MAX_NOISE_VALUES do
    for I := 0 to MAX_NOISE_VALUES do
    begin
      Generator := (NOISE_MULTIPLIER * Generator + STABLE_NOISE_COMPONENT) mod BIG_SIMPLE_NUMBER;
      Number := Generator mod $100;
      Temp := FNoise.Values[Number];
      FNoise.Values[Number] := FNoise.Values[I];
      FNoise.Values[I] := Temp;
    end;
end;

constructor TSystemGenerator.Create();
begin
  GenerateNoise;
end;

class procedure TSystemGenerator.GenerateSystem();
begin
  if (FInstance = nil) then
    FInstance := Create();
end;
{$ENDREGION}

end.
