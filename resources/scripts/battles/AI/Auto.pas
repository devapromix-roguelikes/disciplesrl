// ����� �� ������ ����������: � ����������� �� ������ ������ ��������� ������ � ��� (������� AI)
case GetInt('Slot' + GetStr('ActiveCell') + 'Class') of

  1: // ���� �� ���������� ������ ���������� �� ������
    for I := 6 downto 1 do
      if (GetInt('Slot' + IntToStr(I) + 'HP') > 0) then
      begin
        SetInt('SlotClick', I);
        Run('Battles\SlotClick.pas');
        Break;
      end;

  2: // ���� �� ���� ����������� �� ������
    for I := 1 to 6 do
      if (GetInt('Slot' + IntToStr(I) + 'HP') > 0) then
      begin
        SetInt('SlotClick', I);
        Run('Battles\SlotClick.pas');
        Break;
      end;

  3: // ��������� ������ �������������� �����
    begin
      A := 0;
      B := 0;
      for I := 12 downto 7 do
        if (GetInt('Slot' + IntToStr(I) + 'HP') > 0) then
        begin
          // ���� ����� ������ ����
          C := GetInt('Slot' + IntToStr(I) + 'MHP') - GetInt('Slot' + IntToStr(I) + 'HP');
          if (C >= A) then
          begin
            A := C;
            B := I;
          end;
        end;
      if (B > 0) then
      begin
        SetInt('SlotClick', B);
        Run('Battles\SlotClick.pas');
      end;
    end;

  4, 6: // ���� �� ������ ������ ����� �� ��������� ������
    begin
      A := 10000;
      B := 0;
      for I := 6 downto 1 do
        if (GetInt('Slot' + IntToStr(I) + 'HP') > 0) then
        begin
          // ����� ������ ���� ����� ������ ����
          if (GetInt('Slot' + IntToStr(I) + 'HP') < A) then
          begin
            A := GetInt('Slot' + IntToStr(I) + 'HP');
            B := I;
          end;
        end;
      if (B > 0) then
      begin
        SetInt('SlotClick', B);
        Run('Battles\SlotClick.pas');
      end;
    end;

  5: // ��������� ���� ��������� ����� ������
    begin
      LetVar('SlotClick', 'ActiveCell');
      Run('Battles\SlotClick.pas');
    end;

  8: // ���������� ������ ����� �� ��������� ������
    begin
      A := 0;
      B := 0;
      for I := 6 downto 1 do
        if (GetInt('Slot' + IntToStr(I) + 'HP') > 0) then
        begin
          // ���� ����� ������� ����
          if (GetInt('Slot' + IntToStr(I) + 'HP') > A) and not(Flag('SlepotaSlot' + IntToStr(I))) then
          begin
            A := GetInt('Slot' + IntToStr(I) + 'HP');
            B := I;
          end;
        end;
      if (B > 0) then
      begin
        SetInt('SlotClick', B);
        Run('Battles\SlotClick.pas');
      end
      else
      begin
        // ��� ���� (����), ����������� ���������� ��������
        for I := 6 downto 1 do
          if (GetInt('Slot' + IntToStr(I) + 'HP') > 0) then
          begin
            SetInt('SlotClick', I);
            Run('Battles\SlotClick.pas');
          end;
      end;
    end;

  9: // ���������� ���� ������ �� ��������� ������
    for I := 1 to 6 do
      if (GetInt('Slot' + IntToStr(I) + 'HP') > 0) then
      begin
        SetInt('SlotClick', I);
        Run('Battles\SlotClick.pas');
        Break;
      end;

end;
