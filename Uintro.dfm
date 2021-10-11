object Form2: TForm2
  Left = 231
  Top = 136
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Options'
  ClientHeight = 161
  ClientWidth = 329
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 40
    Width = 103
    Height = 16
    Caption = 'Type d'#39'attraction:'
  end
  object Label2: TLabel
    Left = 8
    Top = 72
    Width = 111
    Height = 16
    Caption = 'Nombre de balles:'
  end
  object Label3: TLabel
    Left = 8
    Top = 104
    Width = 88
    Height = 16
    Caption = 'Restitution (%):'
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 8
    Width = 169
    Height = 17
    Caption = 'Rebondir sur les bords'
    Checked = True
    State = cbChecked
    TabOrder = 0
  end
  object Button1: TButton
    Left = 8
    Top = 128
    Width = 313
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = Button1Click
  end
  object ComboBox1: TComboBox
    Left = 144
    Top = 32
    Width = 177
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    ItemIndex = 0
    TabOrder = 2
    Text = 'aucune'
    Items.Strings = (
      'aucune'
      'attraction lineaire'
      'attraction ponctuelle'
      'repulsion ponctuelle')
  end
  object SpinEdit1: TSpinEdit
    Left = 144
    Top = 64
    Width = 97
    Height = 26
    MaxValue = 600
    MinValue = 1
    TabOrder = 3
    Value = 200
  end
  object SpinEdit2: TSpinEdit
    Left = 144
    Top = 96
    Width = 97
    Height = 26
    MaxValue = 105
    MinValue = 1
    TabOrder = 4
    Value = 90
  end
end
