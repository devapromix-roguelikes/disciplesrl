// MsgBox(GetStr('Slot' + GetStr('SlotClick') + 'HP'));
// ���� ���� �� ������
//MsgBox(GetStr('Slot' + GetStr('SlotClick') + 'Type'));//Debug
if (GetInt('Slot' + GetStr('SlotClick') + 'HP') > 0) then
begin
  // �������� ���� � ����� �������
  if (GetInt('ActiveCell') <= 6) then
    // ��������� �� �������
    case GetInt('Slot' + GetStr('ActiveCell') + 'Class') of
      1: // ���� ������� ������ ���������� �����
        begin
          if (GetInt('SlotClick') > 6) then
          begin
            { // � ����� ���� �������� ���� � ���� �� ��� � �������� �������
              if (GetInt('ActiveCell') <= 3) then
              begin
              U := ((GetInt('Slot4HP') > 0) or (GetInt('Slot5HP') > 0) or (GetInt('Slot6HP') > 0));
              if U then
              begin
              FlagFalse('SlepotaSlot' + GetStr('ActiveCell'));
              Run('Battles\SetIni.pas');
              Run('Battles\DisplaySlots.pas');
              Exit;
              end;
              end; }
            // ���� �� ������� ��� � �����������?
            U := ((GetInt('Slot7HP') > 0) or (GetInt('Slot8HP') > 0) or
              (GetInt('Slot9HP') > 0));
            if (U and (GetInt('SlotClick') >= 7) and (GetInt('SlotClick') <= 9))
              or (not U and (GetInt('SlotClick') >= 10) and
              (GetInt('SlotClick') <= 12)) then
              Run('Battles\HitUnit.pas');
          end;
        end;
      2: // ���� ������� ��� ������
        begin
          if (GetInt('SlotClick') > 6) then
            Run('Battles\HitUnits.pas');
        end;
      3: // �������� �����
        begin
          if (GetInt('SlotClick') <= 6) then
            Run('Battles\HealUnit.pas');
        end;
      4: // ������� ������� ������ ������ ����� �� ������
        begin
          if (GetInt('SlotClick') > 6) then
            Run('Battles\HitUnit.pas');
        end;
      5: // �������� ��� ������
        begin
          if (GetInt('SlotClick') <= 6) then
            Run('Battles\HealUnits.pas');
        end;
      6: // ������ ��� ������� ������ ������ ����� �� ������
        begin
          if (GetInt('SlotClick') > 6) then
            Run('Battles\HitUnit.pas');
        end;

      8: // ������� �� ������ ������ ����� �� ������
        begin
          if (GetInt('SlotClick') > 6) then
            Run('Battles\SlepotaUnit.pas');
        end;
      9: // ������� �� ���� ������ ������
        begin
          if (GetInt('SlotClick') > 6) then
            Run('Battles\SlepotaUnits.pas');
        end;

    end
  else // ������ � ������ �������
    case GetInt('Slot' + GetStr('ActiveCell') + 'Class') of
      1: // ���� ������� ������ ���������� �����
        begin
          if (GetInt('SlotClick') <= 6) then
          begin
            // ���� �� ������� ��� � �����������?
            U := ((GetInt('Slot4HP') > 0) or (GetInt('Slot5HP') > 0) or
              (GetInt('Slot6HP') > 0));
            if (U and (GetInt('SlotClick') >= 4) and (GetInt('SlotClick') <= 6))
              or (not U and (GetInt('SlotClick') >= 1) and
              (GetInt('SlotClick') <= 3)) then
              Run('Battles\HitUnit.pas');
          end;
        end;
      2: // ���� ������� ��� ������
        begin
          if (GetInt('SlotClick') <= 6) then
            Run('Battles\HitUnits.pas');
        end;
      3: // �������� �����
        begin
          if (GetInt('SlotClick') > 6) then
            Run('Battles\HealUnit.pas');
        end;
      4: // ������� ������� ������ ������ ����� �� ������
        begin
          if (GetInt('SlotClick') <= 6) then
            Run('Battles\HitUnit.pas');
        end;
      5: // �������� ��� ������
        begin
          if (GetInt('SlotClick') > 6) then
            Run('Battles\HealUnits.pas');
        end;
      6: // ������ ��� ������� ������ ������ ����� �� ������
        begin
          if (GetInt('SlotClick') <= 6) then
            Run('Battles\HitUnit.pas');
        end;

      8: // ������� �� ������ ������ ����� �� ������
        begin
          if (GetInt('SlotClick') <= 6) then
            Run('Battles\SlepotaUnit.pas');
        end;
      9: // ������� �� ���� ������ ������
        begin
          if (GetInt('SlotClick') <= 6) then
            Run('Battles\SlepotaUnits.pas');
        end;

    end;
  Refresh;
  Render;
end;
