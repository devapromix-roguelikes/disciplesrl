﻿unit DisciplesRL.Scene.Menu2;

interface

uses
{$IFDEF FPC}
  Controls,
{$ELSE}
  Vcl.Controls,
{$ENDIF}
  Classes,
  DisciplesRL.Button,
  DisciplesRL.Resources,
  DisciplesRL.Scenes;

type

  { TSceneMenu }

  { TSceneMenu2 }

  TSceneMenu2 = class(TScene)
  private type
  TButtonEnum = (btPlay, btContinue);
  TIconEnum = (itHighScores, itQuit);
  private const
    ButtonText: array [TButtonEnum] of TResEnum = (reTextPlay, reTextContinue);
    IconDef: array [TIconEnum] of TResEnum = (reIconScores, reIconClosedGates);
    IconOver: array [TIconEnum] of TResEnum = (reIconScoresOver, reIconOpenedGates);
  private
    CursorPos: TButtonEnum;
    Button: array [TButtonEnum] of TButton;
    Icons: array [TIconEnum] of TIcon;
    procedure Next;
    procedure Quit;
    procedure ConfirmQuit;
    procedure PlayGame;
    procedure ContinueGame;
    procedure HighScores;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Render; override;
    procedure Update(var Key: Word); override;
    procedure Timer; override;
    procedure MouseDown(AButton: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
  end;

implementation

uses
  Math,
  SysUtils,
  DisciplesRL.MainForm,
  DisciplesRL.Saga,
  DisciplesRL.Scene.Hire;

procedure TSceneMenu2.Next;
begin
  MediaPlayer.Play(mmClick);
  case CursorPos of
    btPlay:
      PlayGame;
    btContinue:
      ContinueGame;
  end;
end;

procedure TSceneMenu2.Quit;
begin
  DisciplesRL.MainForm.MainForm.Close;
end;

procedure TSceneMenu2.ConfirmQuit;
begin
  ConfirmDialog('Завершить игру?', {$IFDEF FPC}@{$ENDIF}Quit);
end;

procedure TSceneMenu2.PlayGame;
begin
  TSaga.IsGame := False;
  TSceneHire.Show(stScenario);
end;

procedure TSceneMenu2.ContinueGame;
begin
  if TSaga.IsGame then
  begin
    MediaPlayer.PlayMusic(mmMap);
    Scenes.Show(scMap);
  end;
end;

procedure TSceneMenu2.HighScores;
begin
  TSceneHire.Show(stHighScores2);
end;

{ TSceneMenu }

constructor TSceneMenu2.Create;
var
  L, T, H: Integer;
  I: TButtonEnum;
  J: TIconEnum;
begin
  inherited;
  L := ScrWidth - (ResImage[reButtonDef].Width div 2);
  H := ResImage[reButtonDef].Height + 10;
  T := (Surface.Height div 3 * 2) - ((H * (Ord(High(TButtonEnum)) + 1)) div 2);
  for I := Low(TButtonEnum) to High(TButtonEnum) do
  begin
    Button[I] := TButton.Create(L, T, ButtonText[I]);
    if (I = btPlay) then
      Button[I].Sellected := True;
    Inc(T, H);
  end;
  L := 20;
  T := 500;
  for J := Low(TIconEnum) to High(TIconEnum) do
  begin
    Icons[J] := TIcon.Create(L, T, IconDef[J], IconOver[J]);
    Inc(T, 84);
  end;
end;

destructor TSceneMenu2.Destroy;
var
  I: TButtonEnum;
  J: TIconEnum;
begin
  for I := Low(TButtonEnum) to High(TButtonEnum) do
    FreeAndNil(Button[I]);
  for J := Low(TIconEnum) to High(TIconEnum) do
    FreeAndNil(Icons[J]);
  inherited;
end;

procedure TSceneMenu2.MouseDown(AButton: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  I: TButtonEnum;
begin
  inherited;
  case AButton of
    mbLeft:
      begin
        for I := Low(TButtonEnum) to High(TButtonEnum) do
          if Button[I].MouseDown then
          begin
            CursorPos := I;
            Next;
          end;
        if Icons[itHighScores].MouseDown then
          HighScores;
        if Icons[itQuit].MouseDown then
          ConfirmQuit;
    end;
  end;
end;

procedure TSceneMenu2.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  I: TButtonEnum;
  J: TIconEnum;
begin
  inherited;
  for I := Low(TButtonEnum) to High(TButtonEnum) do
    Button[I].MouseMove(X, Y);
  for J := Low(TIconEnum) to High(TIconEnum) do
    Icons[J].MouseMove(X, Y);
  Scenes.Render;
end;

procedure TSceneMenu2.Render;

  procedure RenderButtons;
  var
    I: TButtonEnum;
  begin
    for I := Low(TButtonEnum) to High(TButtonEnum) do
    begin
      Button[I].Sellected := (I = CursorPos);
      Button[I].Render;
    end;
  end;

  procedure RenderIcons;
  var
    J: TIconEnum;
  begin
    for J := Low(TIconEnum) to High(TIconEnum) do
      Icons[J].Render;
  end;

begin
  inherited;
  DrawImage(reWallpaperMenu);
  DrawTitle(reTitleLogo);
  RenderButtons;
  RenderIcons;
  DrawText(Surface.Height - 50, '2018-2021 by Apromix');
end;

procedure TSceneMenu2.Timer;
begin
  inherited;

end;

procedure TSceneMenu2.Update(var Key: Word);
begin
  inherited;
  case Key of
    K_ENTER:
      Next;
    K_ESCAPE:
      ConfirmQuit;
    K_S:
      HighScores;
    K_UP:
      CursorPos := TButtonEnum(EnsureRange(Ord(CursorPos) - 1, 0,
        Ord(High(TButtonEnum))));
    K_DOWN:
      CursorPos := TButtonEnum(EnsureRange(Ord(CursorPos) + 1, 0,
        Ord(High(TButtonEnum))));
  end;
end;

end.