// ��������� ������� ��������
Run('Battles\Finish.pas');

for I := 1 to 12 do
if (GetInt('Slot' + IntToStr(I) + 'HP') > 0) then
begin
  if (GetInt('Slot' + IntToStr(I) + 'HP') > GetInt('Slot' + IntToStr(I) + 'MHP'))
    then LetVar('Slot' + IntToStr(I) + 'HP', 'Slot' + IntToStr(I) + 'MHP');
  // ��������� � ���������
  if (GetInt('FinishExp') > 0) then
  begin
    // ����
    DisplayMsg(I, 14, '+' + GetStr('FinishExp'));
    Continue;
  end;
  if (GetInt('DisplayHealSlot' + IntToStr(I)) > 0) then
  begin
    // ���������
    DisplayMsg(I, 12, '+' + GetStr('DisplayHealSlot' + IntToStr(I)));
    SetInt('DisplayHealSlot' + IntToStr(I), 0);
  end else
  if (GetInt('DisplayDamageSlot' + IntToStr(I)) > 0) then
  begin
    // ����
    DisplayMsg(I, 4, '-' + GetStr('DisplayDamageSlot' + IntToStr(I)));
    SetInt('DisplayDamageSlot' + IntToStr(I), 0);
  end else                         
//  if Flag('SlepotaSlot' + IntToStr(I)) then DisplayMsg(I, 14, '�������') else
  if Flag('MissSlot' + IntToStr(I)) then
  begin
    DisplayMsg(I, 14, '������');
    FlagFalse('MissSlot' + IntToStr(I));
  end;
end;

Render;







