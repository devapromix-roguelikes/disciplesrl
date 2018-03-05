unit DisciplesRL.PathFind;

interface

uses DisciplesRL.Map;

type
  TGetXYVal = function(X, Y: Integer): Boolean; stdcall;

function PathFind(FromX, FromY, ToX, ToY: Integer; Callback: TGetXYVal;
  var TargetX, TargetY: Integer): Boolean;

implementation

uses Math;

const
  MAXLEN = 1000;
  KNORM = 10;
  KDIAG = 12;

type
  TUIntPoint = record
    X, Y: Word;
  end;

type
  TPathFindBlock = record
    CostWay: Integer;
    Parent: TUIntPoint;
  end;

type
  TOpenBlock = record
    Cost, X, Y: Integer;
  end;

  POpenBlock = ^TOpenBlock;

  TPathFindMap = array of TPathFindBlock;

var
  Cells: TPathFindMap;
  FAULT: Integer;
  SavedMapX, SavedMapY: Integer;
  Open: array [0 .. MAXLEN] of POpenBlock;
  OpenRaw: array [0 .. MAXLEN] of TOpenBlock;

procedure InitCrap;
var
  I: Integer;
begin
  for I := 0 to MAXLEN do
    Open[I] := @OpenRaw[I];
end;

function Heuristic(dx, dy: Integer): Integer;
begin
  Result := KNORM * Max(dx, dy) + (KDIAG - KNORM) * Min(dx, dy);
end;

var
  NOpen: Integer = 0;

function PathFind(FromX, FromY, ToX, ToY: Integer; Callback: TGetXYVal;
  var TargetX, TargetY: Integer): Boolean;

  procedure HeapSwap(I, j: Integer);
  var
    tmp: POpenBlock;
  begin
    tmp := Open[I];
    Open[I] := Open[j];
    Open[j] := tmp;
  end;

  procedure HeapAdd;
  var
    I, Parent: Integer;
  begin
    I := NOpen - 1;
    Parent := (I - 1) div 2;
    while (I > 0) and (Open[Parent].Cost > Open[I].Cost) do
    begin
      HeapSwap(I, Parent);
      I := Parent;
      Parent := (I - 1) div 2;
    end;
  end;

  procedure Heapify(I: Integer);
  var
    leftChild, rightChild, largestChild: Integer;
  begin
    repeat
      leftChild := 2 * I + 1;
      if leftChild >= NOpen then
        exit;
      rightChild := leftChild + 1;
      largestChild := I;
      if Open[leftChild].Cost < Open[largestChild].Cost then
        largestChild := leftChild;
      if (rightChild < NOpen) and (Open[rightChild].Cost < Open[largestChild].Cost) then
        largestChild := rightChild;
      if largestChild = I then
        exit;
      HeapSwap(I, largestChild);
      I := largestChild;
    until false;
  end;

  procedure AddToOpen(X, Y, FrX, FrY, NewCost: Integer);
  begin
    if not InRange(X, 0, MapWidth - 1) then
      exit;
    if not InRange(Y, 0, MapHeight - 1) then
      exit;
    with Cells[X * MapHeight + Y] do
    begin
      if CostWay > 0 then // if OpenID > 0 then
      begin
        // if CostWay <= NewCost then
        exit;
      end;
      if not Callback(X, Y) then
        exit;
      if NOpen >= MAXLEN then
        exit;
      Open[NOpen].X := X;
      Open[NOpen].Y := Y;
      // TODO??
      CostWay := NewCost;
      Open[NOpen].Cost := CostWay + Heuristic(abs(X - FromX), abs(Y - FromY));
      Inc(NOpen);
      HeapAdd;
      Parent.X := FrX;
      Parent.Y := FrY;
    end;
  end;

var
  CurX, CurY: Integer;
begin
  Result := false;
  if not InRange(ToX, 0, MapWidth - 1) then
    exit;
  if not InRange(ToY, 0, MapHeight - 1) then
    exit;
  if not Callback(ToX, ToY) then
    exit;
  // if not Callback(FromX, FromY) then exit;
  if (FromX = ToX) and (FromY = ToY) then
  begin
    Result := True;
    TargetX := ToX;
    TargetY := ToY;
    exit;
  end;

  if (SavedMapX <> MapWidth) or (SavedMapY <> MapHeight) then
  begin
    SetLength(Cells, 0);
    SetLength(Cells, MapWidth * MapHeight);
    SavedMapX := MapWidth;
    SavedMapY := MapHeight;
  end
  else
  begin
    FillChar(Pointer(Cells)^, MapWidth * MapHeight * Sizeof(Cells[0]), 0);
  end;
  // exit;

  NOpen := 0;
  // FillChar(Cells, SizeOf(Cells), 0);
  AddToOpen(ToX, ToY, -1, -1, 0);
  repeat
    CurX := Open[0].X;
    CurY := Open[0].Y;
    if (CurX = FromX) and (CurY = FromY) then
    begin
      Result := True;
      // Inc(TOTAL, Open[0].Cost);
      with Cells[CurX * MapHeight + CurY] do
      begin
        TargetX := Parent.X;
        TargetY := Parent.Y;
      end;
      exit;
    end;
    with Cells[CurX * MapHeight + CurY] do
    begin
      // IsClosed := True;
      // inc(CHECKED);
      HeapSwap(0, NOpen - 1);
      // Open[0] := Open[NOpen-1];
      Dec(NOpen);
      Heapify(0);
      AddToOpen(CurX - 1, CurY, CurX, CurY, CostWay + KNORM);
      AddToOpen(CurX, CurY - 1, CurX, CurY, CostWay + KNORM);
      AddToOpen(CurX, CurY + 1, CurX, CurY, CostWay + KNORM);
      AddToOpen(CurX + 1, CurY, CurX, CurY, CostWay + KNORM);
      AddToOpen(CurX - 1, CurY - 1, CurX, CurY, CostWay + KDIAG);
      AddToOpen(CurX - 1, CurY + 1, CurX, CurY, CostWay + KDIAG);
      AddToOpen(CurX + 1, CurY - 1, CurX, CurY, CostWay + KDIAG);
      AddToOpen(CurX + 1, CurY + 1, CurX, CurY, CostWay + KDIAG);
      if NOpen > FAULT then
        FAULT := NOpen;
    end;
  until NOpen <= 0;
  Result := false;
end;

initialization

InitCrap;

end.
