// ����� � ������� ��� �� ������ �����
LetVar('SlotTarget', 'SlotClick');
Run('Battles\HitEntity.pas');
FlagFalse('SlepotaSlot' + GetStr('ActiveCell'));
Run('Battles\SetIni.pas');
Run('Battles\DisplaySlots.pas');





















