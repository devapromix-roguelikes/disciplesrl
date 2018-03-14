// ���� ������
for I := 1 to 12 do
begin
  S := 'Slot' + IntToStr(I);
  // ������� ������ ������� �� ���� ������
  FlagFalse('Slepota' + S);
  // ������� ��� �������
  FlagFalse('Miss' + S);
  //
  if (GetInt(S + 'HP') > 0) then
  case GetInt(S + 'Type') of
  // ��������� �������
   1: begin // ������ (����)
        SetStr(S + 'Name',  '������');
        SetInt(S + 'MHP',   100);
        SetInt(S + 'INI',   50);
        SetInt(S + 'Use',   25);
        SetInt(S + 'TCH',   80);
        SetInt(S + 'Class', 1);
      end;
   2: begin // ������ (������)
        SetStr(S + 'Name',  '������');
        SetInt(S + 'MHP',   35);
        SetInt(S + 'INI',   40);
        SetInt(S + 'Use',   15);
        SetInt(S + 'TCH',   80);
        SetInt(S + 'Class', 2);
      end;
   3: begin // ���������� (����� ������ �����)
        SetStr(S + 'Name',  '����������');
        SetInt(S + 'MHP',   50);
        SetInt(S + 'INI',   20);
        SetInt(S + 'Use',   25);
        SetInt(S + 'TCH',   100);
        SetInt(S + 'Class', 3);
      end;
   4: begin // ������
        SetStr('Slot' + IntToStr(I) + 'Name',  '������');
        SetInt('Slot' + IntToStr(I) + 'MHP',   55);
        SetInt('Slot' + IntToStr(I) + 'INI',   60);
        SetInt('Slot' + IntToStr(I) + 'Use',   15);
        SetInt('Slot' + IntToStr(I) + 'TCH',   80);
        SetInt('Slot' + IntToStr(I) + 'Class', 4);
      end;
   5: begin // �������� (����� ������)
        SetStr('Slot' + IntToStr(I) + 'Name',  '��������');
        SetInt('Slot' + IntToStr(I) + 'MHP',   60);
        SetInt('Slot' + IntToStr(I) + 'INI',   15);
        SetInt('Slot' + IntToStr(I) + 'Use',   15);
        SetInt('Slot' + IntToStr(I) + 'TCH',   100);
        SetInt('Slot' + IntToStr(I) + 'Class', 5);
      end;
   6: begin // �������� (������ ���)
        SetStr('Slot' + IntToStr(I) + 'Name',  '��������');
        SetInt('Slot' + IntToStr(I) + 'MHP',   60);
        SetInt('Slot' + IntToStr(I) + 'INI',   55);
        SetInt('Slot' + IntToStr(I) + 'Use',   25);
        SetInt('Slot' + IntToStr(I) + 'TCH',   75);
        SetInt('Slot' + IntToStr(I) + 'Class', 6);
      end;

  // ���� ������
  21: begin // ���� �����
        SetStr('Slot' + IntToStr(I) + 'Name',  '���� �����');
        SetInt('Slot' + IntToStr(I) + 'MHP',   120);
        SetInt('Slot' + IntToStr(I) + 'INI',   50);
        SetInt('Slot' + IntToStr(I) + 'Use',   25);
        SetInt('Slot' + IntToStr(I) + 'TCH',   80);
        SetInt('Slot' + IntToStr(I) + 'Class', 1);
      end;
  22: begin // ����� (������)
        SetStr('Slot' + IntToStr(I) + 'Name',  '�����');
        SetInt('Slot' + IntToStr(I) + 'MHP',   45);
        SetInt('Slot' + IntToStr(I) + 'INI',   40);
        SetInt('Slot' + IntToStr(I) + 'Use',   15);
        SetInt('Slot' + IntToStr(I) + 'TCH',   80);
        SetInt('Slot' + IntToStr(I) + 'Class', 2);
      end;
  23: begin // ���������� (����������� ���������� "�������" �� ������ ����������)
        SetStr('Slot' + IntToStr(I) + 'Name',  '����������');
        SetInt('Slot' + IntToStr(I) + 'MHP',   45);
        SetInt('Slot' + IntToStr(I) + 'INI',   80);
        SetInt('Slot' + IntToStr(I) + 'Use',   0);
        SetInt('Slot' + IntToStr(I) + 'TCH',   65);
        SetInt('Slot' + IntToStr(I) + 'Class', 8);
      end;
  26: begin // ������������� ��� (������ ���)
        SetStr('Slot' + IntToStr(I) + 'Name',  '������������� ���');
        SetInt('Slot' + IntToStr(I) + 'MHP',   60);
        SetInt('Slot' + IntToStr(I) + 'INI',   55);
        SetInt('Slot' + IntToStr(I) + 'Use',   25);
        SetInt('Slot' + IntToStr(I) + 'TCH',   75);
        SetInt('Slot' + IntToStr(I) + 'Class', 6);
      end;

  // ������� ���������
  42: begin // ������� (������)
        SetStr('Slot' + IntToStr(I) + 'Name',  '�������');
        SetInt('Slot' + IntToStr(I) + 'MHP',   45);
        SetInt('Slot' + IntToStr(I) + 'INI',   40);
        SetInt('Slot' + IntToStr(I) + 'Use',   15);
        SetInt('Slot' + IntToStr(I) + 'TCH',   80);
        SetInt('Slot' + IntToStr(I) + 'Class', 2);
      end;

  // ����������� ��������
  101: begin // ������ ����
        SetStr('Slot' + IntToStr(I) + 'Name',  '������ ����');
        SetInt('Slot' + IntToStr(I) + 'MHP',   140);
        SetInt('Slot' + IntToStr(I) + 'INI',   45);
        SetInt('Slot' + IntToStr(I) + 'Use',   30);
        SetInt('Slot' + IntToStr(I) + 'TCH',   80);
        SetInt('Slot' + IntToStr(I) + 'Class', 1);
       end;
  102: begin // ����-�������
        SetStr('Slot' + IntToStr(I) + 'Name',  '����-�������');
        SetInt('Slot' + IntToStr(I) + 'MHP',   180);
        SetInt('Slot' + IntToStr(I) + 'INI',   40);
        SetInt('Slot' + IntToStr(I) + 'Use',   45);
        SetInt('Slot' + IntToStr(I) + 'TCH',   80);
        SetInt('Slot' + IntToStr(I) + 'Class', 1);
       end;

  end;
end;
