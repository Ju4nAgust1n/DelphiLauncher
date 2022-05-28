object Form1: TForm1
  Left = 231
  Top = 97
  AlphaBlend = True
  AlphaBlendValue = 1
  AutoSize = True
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Form1'
  ClientHeight = 600
  ClientWidth = 600
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image2: TImage
    Left = 0
    Top = 0
    Width = 600
    Height = 600
    AutoSize = True
    Center = True
  end
  object Image1: TImage
    Left = 200
    Top = 168
    Width = 193
    Height = 97
    OnClick = Image1Click
  end
  object Image3: TImage
    Left = 528
    Top = 24
    Width = 57
    Height = 41
    OnClick = Image3Click
  end
  object Label1: TLabel
    Left = 192
    Top = 360
    Width = 45
    Height = 13
    Caption = 'Label1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Transparent = True
    Visible = False
  end
  object Timer1: TTimer
    Interval = 1
    OnTimer = Timer1Timer
    Left = 8
    Top = 8
  end
end
