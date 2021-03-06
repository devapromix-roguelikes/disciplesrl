﻿unit DisciplesRL.Scene.Hire;

interface

uses
{$IFDEF FPC}
  Controls,
{$ELSE}
  Vcl.Controls,
{$ENDIF}
  Classes,
  DisciplesRL.Saga,
  DisciplesRL.Creatures,
  DisciplesRL.Scenes,
  DisciplesRL.Resources,
  DisciplesRL.Party;

type
  THireSubSceneEnum = (stCharacter, stLeader, stRace, stScenario, stJournal,
    stVictory, stDefeat, stHighScores2, stLoot, stStoneTab, stSpy, stWar,
    stDifficulty);

type

  { TSceneHire }

  TSceneHire = class(TScene)
  private const
    H = 25;
  private
  var
    T, L: Integer;
  strict private
    function ThiefPoisonDamage: Integer;
    function ThiefChanceOfSuccess(V: TLeaderThiefSpyVar): Integer;
    function WarriorChanceOfSuccess(V: TLeaderWarriorActVar): Integer;
    procedure RenderButtons;
    procedure Ok;
    procedure Back;
    procedure RenderDifficultyInfo;
    procedure RenderScenarioInfo;
    procedure RenderSpyInfo;
    procedure RenderWarInfo;
    procedure RenderRace(const Race: TRaceEnum; const AX, AY: Integer);
    procedure RenderSpy(const N: TLeaderThiefSpyVar; const AX, AY: Integer);
    procedure RenderWar(const N: TLeaderWarriorActVar; const AX, AY: Integer);
    procedure RenderDifficulty(const Difficulty: TSaga.TDifficultyEnum;
      const AX, AY: Integer);
    procedure RenderScenario(const AScenario: TScenario.TScenarioEnum;
      const AX, AY: Integer);
    procedure Add; overload;
    procedure Add(S: string; F: Boolean = False); overload;
    procedure Add(S, V: string); overload;
    procedure Add(S: string; V, M: Integer); overload;
    procedure Add(S: string; V: Integer; R: string = ''); overload;
    procedure Add2(S: string; V: Integer); overload;
    procedure RenderRaceInfo;
    procedure RenderHighScores;
    procedure RenderFinalInfo;
  public
  class var
    MPX: Integer;
    MPY: Integer;
    constructor Create;
    destructor Destroy; override;
    procedure Render; override;
    procedure Update(var Key: Word); override;
    procedure Timer; override;
    procedure MouseDown(AButton: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure DrawItem(ItemRes: array of TResEnum);
    class function HireIndex: Integer; static;
    procedure RenderCharacterInfo(C: TCreatureEnum; const F: Boolean = True);
    class procedure Show(const ASubScene: THireSubSceneEnum); overload;
    class procedure Show(const Party: TParty; const Position: Integer);
      overload;
    class procedure Show(const ASubScene: THireSubSceneEnum;
      const ABackScene: TSceneEnum; const ALootRes: TResEnum); overload;
    class procedure Show(const ASubScene: THireSubSceneEnum;
      const ABackScene: TSceneEnum); overload;
  end;

implementation

uses
  Math,
  SysUtils,
  DisciplesRL.Map,
  DisciplesRL.Button,
  DisciplesRL.Scene.Party,
  DisciplesRL.Scene.Battle2,
  DisciplesRL.Scene.Settlement;

type
  TButtonEnum = (btOk, btClose);

const
  ButtonText: array [THireSubSceneEnum] of array [TButtonEnum] of TResEnum = (
    // Character
    (reTextHire, reTextClose),
    // Leader
    (reTextContinue, reTextCancel),
    // Race
    (reTextContinue, reTextCancel),
    // Scenario
    (reTextContinue, reTextCancel),
    // Journal
    (reTextClose, reTextClose),
    // Victory
    (reTextClose, reTextClose),
    // Defeat
    (reTextClose, reTextClose),
    // Scores
    (reTextClose, reTextClose),
    // Loot
    (reTextClose, reTextClose),
    // StoneTab
    (reTextClose, reTextClose),
    // Spy
    (reTextContinue, reTextCancel),
    // War
    (reTextContinue, reTextCancel),
    // Difficulty
    (reTextContinue, reTextCancel));

const
  AddButtonScene = [stLoot, stStoneTab];
  CloseButtonScene = [stJournal, stVictory, stDefeat, stHighScores2] +
    AddButtonScene;
  MainButtonsScene = [stCharacter, stLeader, stRace, stScenario, stHighScores2,
    stDifficulty, stSpy, stWar];
  WideButtonScene = [stCharacter, stLeader];

var
  HireParty: TParty = nil;
  HirePosition: Integer = 0;
  SubScene: THireSubSceneEnum = stCharacter;
  BackScene: TSceneEnum = scMenu;
  Button: array [THireSubSceneEnum] of array [TButtonEnum] of TButton;
  CurrentIndex: Integer = 0;
  Lf, Lk: Integer;
  GC, MC: Integer;
  LootRes: TResEnum;

class procedure TSceneHire.Show(const ASubScene: THireSubSceneEnum);
begin
  case ASubScene of
    stJournal:
      CurrentIndex := Ord(Game.Scenario.CurrentScenario);
  else
    CurrentIndex := 0;
  end;
  SubScene := ASubScene;
  Game.Show(scHire);
  if ASubScene = stVictory then
    Game.MediaPlayer.PlayMusic(mmVictory);
end;

class procedure TSceneHire.Show(const Party: TParty; const Position: Integer);
begin
  HireParty := Party;
  HirePosition := Position;
  Show(stCharacter);
end;

class procedure TSceneHire.Show(const ASubScene: THireSubSceneEnum;
  const ABackScene: TSceneEnum);
begin
  SubScene := ASubScene;
  BackScene := ABackScene;
  Game.Show(scHire);
end;

class procedure TSceneHire.Show(const ASubScene: THireSubSceneEnum;
  const ABackScene: TSceneEnum; const ALootRes: TResEnum);
begin
  TSceneHire.Show(ASubScene, ABackScene);
  case SubScene of
    stLoot, stStoneTab:
      Game.MediaPlayer.Play(mmLoot);
  end;
  LootRes := ALootRes;
  GC := RandomRange(0, 3);
  MC := RandomRange(0, 3);
end;

class function TSceneHire.HireIndex: Integer;
begin
  Result := CurrentIndex;
end;

procedure TSceneHire.DrawItem(ItemRes: array of TResEnum);
var
  I, X: Integer;
begin
  DrawImage(ScrWidth - 59 - 120, 295, reSmallFrame);
  DrawImage(ScrWidth - 59, 295, reSmallFrame);
  DrawImage(ScrWidth - 59 + 120, 295, reSmallFrame);
  case Length(ItemRes) of
    1:
      if ItemRes[0] <> reNone then
        DrawImage(ScrWidth - 32, 300, ItemRes[0]);
    2, 3:
      begin
        X := -120;
        for I := 0 to Length(ItemRes) - 1 do
        begin
          if ItemRes[I] <> reNone then
            DrawImage(ScrWidth - 32 + X, 300, ItemRes[I]);
          Inc(X, 120);
        end;
      end;
  end;
end;

procedure TSceneHire.Back;
begin
  Game.MediaPlayer.Play(mmClick);
  case SubScene of
    stCharacter:
      Game.Show(scSettlement);
    stDifficulty:
      TSceneHire.Show(stScenario);
    stLeader:
      TSceneHire.Show(stRace);
    stRace:
      TSceneHire.Show(stDifficulty);
    stScenario:
      Game.Show(scMenu);
    stJournal, stSpy, stWar:
      Game.Show(scMap);
    stDefeat:
      begin
        TSaga.IsGame := False;
        TSceneHire.Show(stHighScores2);
      end;
    stVictory:
      begin
        TSaga.IsGame := False;
        TSceneHire.Show(stHighScores2);
      end;
    stHighScores2:
      begin
        Game.Show(scMenu);
      end;
  end;
end;

function TSceneHire.ThiefChanceOfSuccess(V: TLeaderThiefSpyVar): Integer;
const
  S: array [TLeaderThiefSpyVar] of Byte = (95, 80, 65);
begin
  Result := S[V] - (20 - EnsureRange(TLeaderParty.Leader.Level * 2, 0, 20));
end;

function TSceneHire.WarriorChanceOfSuccess(V: TLeaderWarriorActVar): Integer;
const
  S: array [TLeaderWarriorActVar] of Byte = (100, 80, 60);
begin
  Result := S[V];
end;

function TSceneHire.ThiefPoisonDamage: Integer;
begin
  Result := TSaga.LeaderThiefPoisonDamageAllInPartyPerLevel;
end;

procedure TSceneHire.Ok;
var
  F: Boolean;
  I: Integer;

  procedure NoSpy;
  begin
    InformDialog('Вы использовали все попытки!');
  end;

  function TrySpy(V: TLeaderThiefSpyVar): Boolean;
  begin
    Result := (RandomRange(0, 100) <= ThiefChanceOfSuccess(V)) or Game.Wizard;
    if not Result then
    begin
      InformDialog('Вы потерпели неудачу и вступаете в схватку!');
      TLeaderParty.Leader.PutAt(MPX, MPY);
    end;
  end;

  function TryWar(V: TLeaderWarriorActVar): Boolean;
  begin
    Result := (RandomRange(0, 100) <= WarriorChanceOfSuccess(V)) or Game.Wizard;
    if not Result then
    begin
      InformDialog('Вы потерпели неудачу и вступаете в схватку!');
      TLeaderParty.Leader.PutAt(MPX, MPY);
    end;
  end;

begin
  Game.MediaPlayer.Play(mmClick);
  case SubScene of
    stRace:
      begin
        TSaga.LeaderRace := TRaceEnum(CurrentIndex + 1);
        TSceneHire.Show(stLeader);
      end;
    stLeader:
      begin
        TSaga.Clear;
        Party[TLeaderParty.LeaderPartyIndex].Owner := TSaga.LeaderRace;
        Game.MediaPlayer.PlayMusic(mmGame);
        Game.MediaPlayer.Play(mmExit);
        TSceneSettlement.Show(stCapital);
      end;
    stDifficulty:
      begin
        TSaga.Difficulty := TSaga.TDifficultyEnum(CurrentIndex);
        TSceneHire.Show(stRace);
      end;
    stCharacter:
      begin
        if HireParty.Hire(Characters[Party[TLeaderParty.LeaderPartyIndex].Owner]
          [cgCharacters][TRaceCharKind(CurrentIndex)], HirePosition) then
        begin
          Game.MediaPlayer.Play(mmGold);
          Game.Show(scSettlement);
        end
        else
          InformDialog('Не хватает денег!');
      end;
    stScenario:
      begin
        Game.Scenario.CurrentScenario := TScenario.TScenarioEnum(CurrentIndex);
        TSceneHire.Show(stDifficulty);
      end;
    stJournal:
      Game.Show(scMap);
    stDefeat:
      begin
        TSaga.IsGame := False;
        TSceneHire.Show(stHighScores2);
        Game.MediaPlayer.PlayMusic(mmMenu);
      end;
    stVictory:
      begin
        TSaga.IsGame := False;
        TSceneHire.Show(stHighScores2);
        Game.MediaPlayer.PlayMusic(mmMenu);
      end;
    stHighScores2:
      begin
        Game.Show(scMenu);
      end;
    stStoneTab:
      begin
        if (Game.Scenario.CurrentScenario = sgAncientKnowledge) then
          if Game.Scenario.StoneTab >= TScenario.ScenarioStoneTabMax then
          begin
            TSceneHire.Show(stVictory);
            Exit;
          end
          else
          begin
            F := True;
            Game.Show(scMap);
            Exit;
          end;
      end;
    stSpy:
      begin
        case TLeaderThiefSpyVar(CurrentIndex) of
          svIntroduceSpy:
            begin
              if TLeaderParty.Leader.Spy > 0 then
              begin
                TLeaderParty.Leader.Spy := TLeaderParty.Leader.Spy - 1;
                if TrySpy(svIntroduceSpy) then
                begin
                  TLeaderParty.Leader.PutAt(MPX, MPY, True);
                end;
              end
              else
                NoSpy;
            end;
          svDuel:
            begin
              if TLeaderParty.Leader.Spy > 0 then
              begin
                TLeaderParty.Leader.Spy := TLeaderParty.Leader.Spy - 1;
                if TrySpy(svDuel) then
                begin
                  InformDialog('Вы вызвали противника на дуэль!');
                  TSceneBattle2.IsDuel := True;
                  TLeaderParty.Leader.PutAt(MPX, MPY);
                end;
              end
              else
                NoSpy;
            end;
          svPoison:
            begin
              if TLeaderParty.Leader.Spy > 0 then
              begin
                TLeaderParty.Leader.Spy := TLeaderParty.Leader.Spy - 1;
                if TrySpy(svPoison) then
                begin
                  I := TSaga.GetPartyIndex(MPX, MPY);
                  Party[I].TakeDamageAll(ThiefPoisonDamage);
                  InformDialog('Вы отравили все колодцы в округе!');
                end;
              end
              else
                NoSpy;
            end
        else
          Game.Show(scMap);
        end;
      end;
    stWar:
      begin
        case TLeaderWarriorActVar(CurrentIndex) of
          avRest:
            begin
              if TLeaderParty.Leader.Spy > 0 then
              begin
                TLeaderParty.Leader.Spy := TLeaderParty.Leader.Spy - 1;
                if TryWar(avRest) then
                begin
                  // TLeaderParty.Leader.PutAt(MPX, MPY, True);
                end;
              end
              else
                NoSpy;
            end;
          avRitual:
            begin
              if TLeaderParty.Leader.Spy > 0 then
              begin
                TLeaderParty.Leader.Spy := TLeaderParty.Leader.Spy - 1;
                if TryWar(avRitual) then
                begin
                  // InformDialog('Вы вызвали противника на дуэль!');
                  // TSceneBattle2.IsDuel := True;
                  // TLeaderParty.Leader.PutAt(MPX, MPY);
                end;
              end
              else
                NoSpy;
            end;
          avWar3:
            begin
              if TLeaderParty.Leader.Spy > 0 then
              begin
                TLeaderParty.Leader.Spy := TLeaderParty.Leader.Spy - 1;
                if TryWar(avWar3) then
                begin
                  // I := TSaga.GetPartyIndex(MPX, MPY);
                  // Party[I].TakeDamageAll(ThiefPoisonDamage);
                  // InformDialog('Вы отравили все колодцы в округе!');
                end;
              end
              else
                NoSpy;
            end
        else
          Game.Show(scMap);
        end;
      end;
    stLoot:
      begin
        Game.MediaPlayer.Play(mmLoot);
        F := True;
        Game.Show(scMap);
        begin
          if (Game.Scenario.CurrentScenario = sgDarkTower) then
          begin
            case Game.Map.LeaderTile of
              reTower:
                begin
                  TSceneHire.Show(stVictory);
                  Exit;
                end;
            end;
          end;
          if Game.Map.LeaderTile = reNeutralCity then
          begin
            Game.MediaPlayer.PlayMusic(mmGame);
            Game.MediaPlayer.Play(mmSettlement);
            TSceneSettlement.Show(stCity);
            Exit;
          end;
          if F then
            Game.NewDay;
        end;
      end;
  end;
end;

procedure TSceneHire.RenderCharacterInfo(C: TCreatureEnum; const F: Boolean);
var
  J: Integer;
begin
  T := Top + 6;
  L := Lf + ResImage[reActFrame].Width + 12;
  with TCreature.Character(C) do
  begin
    Add(Name[0], True);
    Add;
    if TSaga.IsGame and F then
      Add2('Побед', Game.Statistics.GetValue(stBattlesWon));
    Add('Уровень', Level);
    if TSaga.IsGame and F then
      Add2('Убито', Game.Statistics.GetValue(stKilledCreatures));
    Add('Точность', ChancesToHit, '%');
    if TSaga.IsGame and F then
      Add2('Очки', Game.Statistics.GetValue(stScore));
    Add('Инициатива', Initiative);
    Add('Здоровье', HitPoints, HitPoints);
    Add('Урон', Damage);
    Add('Броня', Armor);
    Add('Источник', SourceName[SourceEnum]);
    case ReachEnum of
      reAny:
        begin
          Add('Дистанция', 'Все поле боя');
          Add('Цели', 1);
        end;
      reAdj:
        begin
          Add('Дистанция', 'Ближайшие цели');
          Add('Цели', 1);
        end;
      reAll:
        begin
          Add('Дистанция', 'Все поле боя');
          Add('Цели', 6);
        end;
    end;
    for J := 0 to 2 do
      Add(Description[J]);
  end;
end;

procedure TSceneHire.RenderRace(const Race: TRaceEnum; const AX, AY: Integer);
begin
  case Race of
    reTheEmpire:
      DrawImage(AX + 7, AY + 7, reTheEmpireLogo);
    reUndeadHordes:
      DrawImage(AX + 7, AY + 7, reUndeadHordesLogo);
    reLegionsOfTheDamned:
      DrawImage(AX + 7, AY + 7, reLegionsOfTheDamnedLogo);
  end;
end;

procedure TSceneHire.RenderSpy(const N: TLeaderThiefSpyVar;
  const AX, AY: Integer);
begin
  case N of
    svIntroduceSpy:
      DrawImage(AX + 7, AY + 7, reThiefDuel);
    svDuel:
      DrawImage(AX + 7, AY + 7, reThiefDuel);
    svPoison:
      DrawImage(AX + 7, AY + 7, reThiefDuel);
  end;
end;

procedure TSceneHire.RenderWar(const N: TLeaderWarriorActVar;
  const AX, AY: Integer);
begin
  case N of
    avRest:
      DrawImage(AX + 7, AY + 7, reTheEmpireLogo);
    avRitual:
      DrawImage(AX + 7, AY + 7, reUndeadHordesLogo);
    avWar3:
      DrawImage(AX + 7, AY + 7, reLegionsOfTheDamnedLogo);
  end;
end;

procedure TSceneHire.RenderDifficulty(const Difficulty: TSaga.TDifficultyEnum;
  const AX, AY: Integer);
begin
  case Difficulty of
    dfEasy:
      DrawImage(AX + 7, AY + 7, reDifficultyEasyLogo);
    dfNormal:
      DrawImage(AX + 7, AY + 7, reDifficultyNormalLogo);
    dfHard:
      DrawImage(AX + 7, AY + 7, reDifficultyHardLogo);
  end;
end;

procedure TSceneHire.RenderScenario(const AScenario: TScenario.TScenarioEnum;
  const AX, AY: Integer);
begin
  case AScenario of
    sgDarkTower:
      DrawImage(AX + 7, AY + 7, reScenarioDarkTower);
    sgOverlord:
      DrawImage(AX + 7, AY + 7, reScenarioOverlord);
    sgAncientKnowledge:
      DrawImage(AX + 7, AY + 7, reScenarioAncientKnowledge);
  end;
end;

procedure TSceneHire.Add;
begin
  Inc(T, H);
end;

procedure TSceneHire.Add(S: string; F: Boolean = False);
begin
  DrawText(L, T, S, F);
  Inc(T, H);
end;

procedure TSceneHire.Add(S, V: string);
begin
  DrawText(L, T, Format('%s: %s', [S, V]));
  Inc(T, H);
end;

procedure TSceneHire.Add(S: string; V: Integer; R: string = '');
begin
  DrawText(L, T, Format('%s: %d%s', [S, V, R]));
  Inc(T, H);
end;

procedure TSceneHire.Add2(S: string; V: Integer);
begin
  DrawText(L + 200, T, Format('%s: %d', [S, V]));
end;

procedure TSceneHire.Add(S: string; V, M: Integer);
begin
  DrawText(L, T, Format('%s: %d/%d', [S, V, M]));
  Inc(T, H);
end;

procedure TSceneHire.RenderRaceInfo;
var
  R: TRaceEnum;
  J: Integer;
begin
  T := Top + 6;
  L := Lf + ResImage[reActFrame].Width + 12;
  R := TRaceEnum(CurrentIndex + 1);
  Add(RaceName[R], True);
  Add;
  for J := 0 to 10 do
    Add(RaceDescription[R][J]);
end;

procedure TSceneHire.RenderDifficultyInfo;
var
  D: TSaga.TDifficultyEnum;
  J: Integer;
begin
  T := Top + 6;
  L := Lf + ResImage[reActFrame].Width + 12;
  D := TSaga.TDifficultyEnum(CurrentIndex);
  Add(TSaga.DifficultyName[D], True);
  Add;
  for J := 0 to 11 do
    Add(TSaga.DifficultyDescription[D][J]);
end;

procedure TSceneHire.RenderScenarioInfo;
var
  S: TScenario.TScenarioEnum;
  J: Integer;
begin
  T := Top + 6;
  L := Lf + ResImage[reActFrame].Width + 12;
  S := TScenario.TScenarioEnum(CurrentIndex);
  Add(TScenario.ScenarioName[S], True);
  Add;
  for J := 0 to 10 do
    Add(TScenario.ScenarioDescription[S][J]);
  if TSaga.IsGame then
    case Game.Scenario.CurrentScenario of
      sgOverlord:
        Add(Game.Scenario.ScenarioOverlordState);
      sgAncientKnowledge:
        Add(Game.Scenario.ScenarioAncientKnowledgeState);
    end;
end;

procedure TSceneHire.RenderFinalInfo;
begin
  T := Top + 6;
  L := Lf + ResImage[reActFrame].Width + 12;
  Add('Статистика', True);
  Add;
  Add('Выиграно боев', Game.Statistics.GetValue(stBattlesWon));
  Add('Убито врагов', Game.Statistics.GetValue(stKilledCreatures));
  Add('Очки', Game.Statistics.GetValue(stScore));
end;

procedure TSceneHire.RenderHighScores;
begin

end;

procedure TSceneHire.RenderSpyInfo;
var
  J: Integer;
  S: TLeaderThiefSpyVar;
begin
  T := Top + 6;
  L := Lf + ResImage[reActFrame].Width + 12;
  S := TLeaderThiefSpyVar(CurrentIndex);
  Add(TSaga.SpyName[S], True);
  Add;
  for J := 0 to 4 do
    Add(TSaga.SpyDescription[S][J]);
  Add;
  Add;
  Add;
  Add;
  Add(Format('Попыток на день: %d/%d', [TLeaderParty.Leader.Spy,
    TLeaderParty.Leader.GetMaxSpy]));
  Add(Format('Вероятность успеха: %d %', [ThiefChanceOfSuccess(S)]));
  case S of
    svPoison:
      Add(Format('Сила ядов: %d', [ThiefPoisonDamage]));
  end;
end;

procedure TSceneHire.RenderWarInfo;
var
  J: Integer;
  S: TLeaderWarriorActVar;
begin
  T := Top + 6;
  L := Lf + ResImage[reActFrame].Width + 12;
  S := TLeaderWarriorActVar(CurrentIndex);
  Add(TSaga.WarName[S], True);
  Add;
  for J := 0 to 4 do
    Add(TSaga.WarDescription[S][J]);
  Add;
  Add;
  Add;
  Add;
  Add(Format('Попыток на день: %d/%d', [TLeaderParty.Leader.Spy,
    TLeaderParty.Leader.GetMaxSpy]));
  Add(Format('Вероятность успеха: %d %', [WarriorChanceOfSuccess(S)]));
end;

procedure TSceneHire.RenderButtons;
var
  I: TButtonEnum;
begin
  if (SubScene in CloseButtonScene) then
    Button[SubScene][btOk].Render
  else
    for I := Low(TButtonEnum) to High(TButtonEnum) do
      Button[SubScene][I].Render;
end;

{ Malavien's Camp	My mercenaries will join your army ... for a price.
  Guther's Camp	My soldiers are the finest in the region.
  Turion's Camp	My soldiers are the most formidable in the land.
  Uther's Camp	Are you in need of recruits?
  Dennar's Camp	We will join your army, for a price.
  Purthen's Camp	My mercenaries will join your army ... for a price.
  Luther's Camp	My soldiers are the finest in the region.
  Richard's Camp	My soldiers are the most formidable in the land.
  Ebbon's Camp	Are you in need of recruits?
  Righon's Camp	We will join your army, for a price.
  Kigger's Camp	My mercenaries will join your army ... for a price.
  Luggen's Camp	My soldiers are the finest in the region.
  Werric's Camp	My soldiers are the most formidable in the land.
  Xennon's Camp	Are you in need of recruits? }

{ TSceneHire }

constructor TSceneHire.Create;
var
  I: TButtonEnum;
  J: THireSubSceneEnum;
  Lc, W: Integer;
begin
  inherited;
  MPX := 0;
  MPY := 0;
  for J := Low(THireSubSceneEnum) to High(THireSubSceneEnum) do
  begin
    W := ResImage[reButtonDef].Width + 4;
    if (J in CloseButtonScene) then
      Lc := ScrWidth - (ResImage[reButtonDef].Width div 2)
    else
      Lc := ScrWidth - ((W * (Ord(High(TButtonEnum)) + 1)) div 2);
    for I := Low(TButtonEnum) to High(TButtonEnum) do
    begin
      Button[J][I] := TButton.Create(Lc, 600, ButtonText[J][I]);
      if not(J in CloseButtonScene) then
        Inc(Lc, W);
      if (I = btOk) then
        Button[J][I].Sellected := True;
    end;
  end;
  Lf := ScrWidth - (ResImage[reFrame].Width) - 2;
  Lk := ScrWidth - (((ResImage[reFrame].Width) * 2) + 2);
end;

destructor TSceneHire.Destroy;
var
  J: THireSubSceneEnum;
  I: TButtonEnum;
begin
  for J := Low(THireSubSceneEnum) to High(THireSubSceneEnum) do
    for I := Low(TButtonEnum) to High(TButtonEnum) do
      FreeAndNil(Button[J][I]);
  inherited;
end;

procedure TSceneHire.MouseDown(AButton: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  case AButton of
    mbLeft:
      begin
        if (SubScene in WideButtonScene) then
        begin
          if MouseOver(Lk, Top, X, Y) then
          begin
            Game.MediaPlayer.Play(mmClick);
            CurrentIndex := 0;
          end;
          if MouseOver(Lk, Top + 120, X, Y) then
          begin
            Game.MediaPlayer.Play(mmClick);
            CurrentIndex := 1;
          end;
          if MouseOver(Lk, Top + 240, X, Y) then
          begin
            Game.MediaPlayer.Play(mmClick);
            CurrentIndex := 2;
          end;
        end;
        if not(SubScene in CloseButtonScene) then
        begin
          if MouseOver(Lf, Top, X, Y) then
          begin
            Game.MediaPlayer.Play(mmClick);
            CurrentIndex := IfThen(SubScene in WideButtonScene, 3, 0);
          end;
          if MouseOver(Lf, Top + 120, X, Y) then
          begin
            Game.MediaPlayer.Play(mmClick);
            CurrentIndex := IfThen(SubScene in WideButtonScene, 4, 1);
          end;
          if MouseOver(Lf, Top + 240, X, Y) then
          begin
            Game.MediaPlayer.Play(mmClick);
            CurrentIndex := IfThen(SubScene in WideButtonScene, 5, 2);
          end;
        end;

        if SubScene in MainButtonsScene then
          if Button[SubScene][btOk].MouseDown then
            Ok
          else if Button[SubScene][btClose].MouseDown then
            Back;

        if (SubScene in CloseButtonScene) then
        begin
          if Button[SubScene][btOk].MouseDown then
            Ok;
        end;

      end;
  end;
end;

procedure TSceneHire.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  I: TButtonEnum;
begin
  inherited;
  if (SubScene in CloseButtonScene) then
    Button[SubScene][btOk].MouseMove(X, Y)
  else
    for I := Low(TButtonEnum) to High(TButtonEnum) do
      Button[SubScene][I].MouseMove(X, Y);
  Render;
end;

procedure TSceneHire.Render;
var
  Left, X, Y: Integer;
  R: TRaceEnum;
  K: TRaceCharKind;
  S: TScenario.TScenarioEnum;
  D: TSaga.TDifficultyEnum;
  Z: TLeaderThiefSpyVar;
  N: TLeaderWarriorActVar;
  ItemRes: TResEnum;
  It1, It2, It3: TResEnum;
  C: TCreatureEnum;

  procedure DrawGold;
  begin
    case GC of
      0:
        DrawItem([reItemGold]);
      1:
        DrawItem([reItemGold, reItemGold]);
      2:
        DrawItem([reItemGold, reItemGold, reItemGold]);
    end;
  end;

  procedure DrawMana;
  begin
    case MC of
      0:
        DrawItem([reItemMana]);
      1:
        DrawItem([reItemMana, reItemMana]);
      2:
        DrawItem([reItemMana, reItemMana, reItemMana]);
    end;
  end;

begin
  inherited;
  Y := 0;
  X := 0;
  It1 := reNone;
  It2 := reNone;
  It3 := reNone;
  case SubScene of
    stCharacter:
      begin
        DrawImage(reWallpaperSettlement);
        DrawTitle(reTitleHire);
        for K := Low(TRaceCharKind) to High(TRaceCharKind) do
        begin
          Left := IfThen(Ord(K) > 2, Lk, Lk - 2);
          if K = TRaceCharKind(CurrentIndex) then
            DrawImage(Left + X, Top + Y, reActFrame)
          else
            DrawImage(Left + X, Top + Y, reFrame);
          with TCreature.Character
            (Characters[Party[TLeaderParty.LeaderPartyIndex].Owner]
            [cgCharacters][K]) do
            if HitPoints > 0 then
            begin
              DrawUnit(ResEnum, Left + X, Top + Y, bsCharacter);
              TSceneParty(Game.GetScene(scParty)).DrawUnitInfo(Left + X,
                Top + Y, Characters[Party[TLeaderParty.LeaderPartyIndex].Owner]
                [cgCharacters][K], False);
            end;
          Inc(Y, 120);
          if Y > 240 then
          begin
            Y := 0;
            Inc(X, 320);
          end;
        end;
      end;
    stLeader:
      begin
        DrawImage(reWallpaperLeader);
        DrawTitle(reTitleLeader);
        for K := Low(TRaceCharKind) to High(TRaceCharKind) do
        begin
          Left := IfThen(Ord(K) > 2, Lk, Lk - 2);
          if K = TRaceCharKind(CurrentIndex) then
            DrawImage(Left + X, Top + Y, reActFrame)
          else
            DrawImage(Left + X, Top + Y, reFrame);
          with TCreature.Character(Characters[TSaga.LeaderRace]
            [cgLeaders][K]) do
            if HitPoints > 0 then
            begin
              DrawUnit(ResEnum, Left + X, Top + Y, bsCharacter);
              TSceneParty(Game.GetScene(scParty)).DrawUnitInfo(Left + X,
                Top + Y, Characters[TSaga.LeaderRace][cgLeaders][K], False);
            end;
          Inc(Y, 120);
          if Y > 240 then
          begin
            Y := 0;
            Inc(X, 320);
          end;
        end;
      end;
    stDifficulty:
      begin
        DrawImage(reWallpaperDifficulty);
        DrawTitle(reTitleDifficulty);
        for D := dfEasy to dfHard do
        begin
          if Ord(D) = CurrentIndex then
            DrawImage(Lf, Top + Y, reActFrame)
          else
            DrawImage(Lf, Top + Y, reFrame);
          RenderDifficulty(D, Lf, Top + Y);
          Inc(Y, 120);
        end;
      end;
    stRace:
      begin
        DrawImage(reWallpaperDifficulty);
        DrawTitle(reTitleRace);
        for R := reTheEmpire to reLegionsOfTheDamned do
        begin
          if Ord(R) - 1 = CurrentIndex then
            DrawImage(Lf, Top + Y, reActFrame)
          else
            DrawImage(Lf, Top + Y, reFrame);
          RenderRace(R, Lf, Top + Y);
          Inc(Y, 120);
        end;
      end;
    stSpy:
      begin
        DrawImage(reWallpaperDifficulty);
        DrawTitle(reTitleThief);
        for Z := svIntroduceSpy to svPoison do
        begin
          if Ord(Z) = CurrentIndex then
            DrawImage(Lf, Top + Y, reActFrame)
          else
            DrawImage(Lf, Top + Y, reFrame);
          RenderSpy(Z, Lf, Top + Y);
          Inc(Y, 120);
        end;
      end;
    stWar:
      begin
        DrawImage(reWallpaperDifficulty);
        DrawTitle(reTitleThief);
        for N := avRest to avWar3 do
        begin
          if Ord(N) = CurrentIndex then
            DrawImage(Lf, Top + Y, reActFrame)
          else
            DrawImage(Lf, Top + Y, reFrame);
          RenderWar(N, Lf, Top + Y);
          Inc(Y, 120);
        end;
      end;
    stScenario, stJournal:
      begin
        DrawImage(reWallpaperScenario);
        DrawTitle(reTitleScenario);
        for S := Low(TScenario.TScenarioEnum)
          to High(TScenario.TScenarioEnum) do
        begin
          if Ord(S) = CurrentIndex then
            DrawImage(Lf, Top + Y, reActFrame)
          else
            DrawImage(Lf, Top + Y, reFrame);
          RenderScenario(S, Lf, Top + Y);
          Inc(Y, 120);
        end;
      end;
    stVictory:
      begin
        DrawImage(reWallpaperDefeat);
        DrawTitle(reTitleVictory);
      end;
    stDefeat:
      begin
        DrawImage(reWallpaperDefeat);
        DrawTitle(reTitleDefeat);
      end;
    stHighScores2:
      begin
        DrawImage(reWallpaperDefeat);
        DrawTitle(reTitleHighScores);
      end;
    stStoneTab:
      begin
        DrawImage(reWallpaperLoot);
        DrawTitle(reTitleLoot);
        DrawItem([reItemStoneTable]);
        DrawText(450, 'КАМЕННАЯ ТАБЛИЧКА');
        DrawText(470, Game.Scenario.ScenarioAncientKnowledgeState);
      end;
    stLoot:
      begin
        DrawImage(reWallpaperLoot);
        DrawTitle(reTitleLoot);
        case LootRes of
          reGold:
            begin
              DrawGold;
              DrawText(450, 'СОКРОВИЩЕ');
              DrawText(470, 'ЗОЛОТО +' + IntToStr(Game.Gold.NewValue));
            end;
          reMana:
            begin
              DrawMana;
              DrawText(450, 'СОКРОВИЩЕ');
              DrawText(470, 'МАНА +' + IntToStr(Game.Mana.NewValue));
            end;
          reBag:
            begin
              Y := 470;
              DrawText(450, 'СОКРОВИЩЕ');
              if Game.Gold.NewValue > 0 then
              begin
                It1 := reItemGold;
                DrawText(Y, 'ЗОЛОТО +' + IntToStr(Game.Gold.NewValue));
                Inc(Y, 20);
              end;
              if Game.Mana.NewValue > 0 then
              begin
                if It1 = reNone then
                  It1 := reItemMana
                else
                  It2 := reItemMana;
                DrawText(Y, 'МАНА +' + IntToStr(Game.Mana.NewValue));
                Inc(Y, 20);
              end;
              if TSaga.NewItem > 0 then
              begin
                ItemRes := reAcolyte;
                if It1 = reNone then
                  It1 := ItemRes
                else if It2 = reNone then
                  It2 := ItemRes
                else
                  It3 := ItemRes;
                DrawText(Y, 'АРТЕФАКТ ' + IntToStr(TSaga.NewItem));
                Inc(Y, 20);
              end;
              DrawItem([It1, It2, It3]);
            end;
        end;
      end;
  end;
  if SubScene in MainButtonsScene + CloseButtonScene - AddButtonScene then
    DrawImage(Lf + ResImage[reActFrame].Width + 2, Top, reInfoFrame);
  case SubScene of
    stCharacter, stLeader:
      begin
        K := TRaceCharKind(CurrentIndex);
        case SubScene of
          stCharacter:
            C := Characters[TSaga.LeaderRace][cgCharacters][K];
          stLeader:
            C := Characters[TSaga.LeaderRace][cgLeaders][K];
        end;
        if C <> crNone then
          RenderCharacterInfo(C, False);
        case SubScene of
          stCharacter:
            begin
              DrawResources;
              DrawImage(Lf + (ResImage[reActFrame].Width * 2) - 70,
                Top, reGold);
              DrawText(Lf + (ResImage[reActFrame].Width * 2) - 40, Top + 12,
                TCreature.Character(C).Gold);
            end;
          stLeader:
            begin
              { DrawImage(Lf + (ResImage[reActFrame].Width + 2) * 2, Top,
                reInfoFrame);
                T := Top + 6;
                L := Lf + (ResImage[reActFrame].Width * 2) + 14;
                Add('Умения', True);
                Add; }
            end;
        end;
      end;
    stRace:
      RenderRaceInfo;
    stDifficulty:
      RenderDifficultyInfo;
    stScenario, stJournal:
      RenderScenarioInfo;
    stVictory, stDefeat:
      RenderFinalInfo;
    stHighScores2:
      RenderHighScores;
    stSpy:
      RenderSpyInfo;
    stWar:
      RenderWarInfo;
  end;
  RenderButtons;
end;

procedure TSceneHire.Timer;

begin
  inherited;

end;

procedure TSceneHire.Update(var Key: Word);
var
  FF: Boolean;

  procedure Upd(const MaxValue: Integer);
  begin
    case Key of
      K_ESCAPE:
        Back;
      K_ENTER:
        Ok;
      K_UP:
        begin
          Game.MediaPlayer.Play(mmClick);
          CurrentIndex := EnsureRange(CurrentIndex - 1, 0, MaxValue);
        end;
      K_DOWN:
        begin
          Game.MediaPlayer.Play(mmClick);
          CurrentIndex := EnsureRange(CurrentIndex + 1, 0, MaxValue);
        end;
    end;
  end;

begin
  inherited;
  case SubScene of
    stLeader, stCharacter:
      begin
        FF := CurrentIndex in [0 .. 4];
        case Key of
          K_ESCAPE:
            Back;
          K_ENTER:
            if FF then
              Ok;
          K_UP:
            begin
              Game.MediaPlayer.Play(mmClick);
              case CurrentIndex of
                1, 2, 4, 5:
                  Dec(CurrentIndex);
              end;
            end;
          K_DOWN:
            begin
              Game.MediaPlayer.Play(mmClick);
              case CurrentIndex of
                0, 1, 3, 4:
                  Inc(CurrentIndex);
              end;
            end;
          K_LEFT:
            begin
              Game.MediaPlayer.Play(mmClick);
              case CurrentIndex of
                3 .. 5:
                  Dec(CurrentIndex, 3);
              end;
            end;
          K_RIGHT:
            begin
              Game.MediaPlayer.Play(mmClick);
              case CurrentIndex of
                0 .. 2:
                  Inc(CurrentIndex, 3);
              end;
            end;
        end;
      end;
    stSpy:
      Upd(Ord(High(TLeaderThiefSpyVar)));
    stWar:
      Upd(Ord(High(TLeaderWarriorActVar)));
    stRace:
      Upd(Ord(High(TRaceCharKind)));
    stDifficulty:
      Upd(Ord(High(TSaga.TDifficultyEnum)));
    stVictory, stDefeat, stScenario, stHighScores2:
      Upd(Ord(High(TScenario.TScenarioEnum)));
  end;
  if (SubScene in CloseButtonScene) then
    case Key of
      K_ESCAPE, K_ENTER:
        Ok;
    end;
end;

end.
