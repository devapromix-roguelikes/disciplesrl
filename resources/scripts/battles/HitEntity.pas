// A������ ��������
if (Flag('SlepotaSlot' + GetStr('ActiveCell')) and (Rand(0, 100) <= 75)) then
begin
  FlagTrue('MissSlot' + GetStr('SlotTarget'));
  SetStr('Log', GetStr('Slot' + GetStr('SlotTarget') + 'Name') + ' ����������.');
end
else if (GetInt('Slot' + GetStr('SlotTarget') + 'HP') > 0) then
begin
  if (Rand(0, 100) <= GetInt('Slot' + GetStr('ActiveCell') + 'TCH')) then
  begin
    DecInt('Slot' + GetStr('SlotTarget') + 'HP',
      GetInt('Slot' + GetStr('ActiveCell') + 'Use'));
    SetInt('DisplayDamageSlot' + GetStr('SlotTarget'),
      GetInt('Slot' + GetStr('ActiveCell') + 'Use'));
	SetStr('Log', GetStr('Slot' + GetStr('SlotTarget') + 'Name') + ' �������� ���� ' + GetStr('Slot' + GetStr('ActiveCell') + 'Use'));
  end
  else
  begin
    FlagTrue('MissSlot' + GetStr('SlotTarget'));
    SetStr('Log', GetStr('Slot' + GetStr('SlotTarget') + 'Name') + ' ����������.');
  end;	
  if (GetInt('Slot' + GetStr('SlotTarget') + 'HP') < 0) then
	SetInt('Slot' + GetStr('SlotTarget') + 'HP', 0);
end;

if (GetInt('Slot' + GetStr('SlotTarget') + 'HP') = 0) then
  SetStr('Log', GetStr('Log') + ' ' + GetStr('Slot' + GetStr('SlotTarget') + 'Name') + ' ��������.');
Log(GetStr('Slot' + GetStr('ActiveCell') + 'Name') + ' �������� ��������� ' + GetStr('Slot' + GetStr('SlotTarget') + 'Name') + '... ' + GetStr('Log'));

