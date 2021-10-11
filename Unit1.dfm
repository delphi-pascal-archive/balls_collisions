object Form1: TForm1
  Left = 531
  Top = 207
  Width = 666
  Height = 568
  Caption = 'Balls Collisions'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object Image2: TImage
    Left = 0
    Top = 0
    Width = 658
    Height = 540
    Align = alClient
    OnClick = Image2Click
    OnMouseMove = Image2MouseMove
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 10
    OnTimer = Timer1Timer
    Left = 272
    Top = 184
  end
end
