object ConfirmationForm: TConfirmationForm
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'ConfirmationForm'
  ClientHeight = 383
  ClientWidth = 623
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClick = FormClick
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseMove = FormMouseMove
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 188
    Top = 264
    Width = 105
    Height = 41
    Caption = 'Button1'
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 299
    Top = 264
    Width = 121
    Height = 41
    Caption = 'Button2'
    ModalResult = 2
    TabOrder = 1
  end
end
