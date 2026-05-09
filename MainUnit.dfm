object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'ELM327 BT YK1021 Configurator 1.0'
  ClientHeight = 401
  ClientWidth = 577
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  ShowHint = True
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 104
    Top = 80
    Width = 100
    Height = 15
    Caption = #1057#1082#1086#1088#1086#1089#1090#1100' '#1086#1073#1084#1077#1085#1072':'
  end
  object Label2: TLabel
    Left = 104
    Top = 112
    Width = 91
    Height = 15
    Caption = #1048#1084#1103' '#1091#1089#1090#1088#1086#1081#1089#1090#1074#1072':'
  end
  object Label3: TLabel
    Left = 104
    Top = 176
    Width = 50
    Height = 15
    Caption = #1055#1080#1085'-'#1082#1086#1076':'
  end
  object Label4: TLabel
    Left = 104
    Top = 208
    Width = 66
    Height = 15
    Caption = 'MAC-'#1072#1076#1088#1077#1089':'
  end
  object DeveloperUrlLabel: TLabel
    Left = 528
    Top = 376
    Width = 33
    Height = 15
    Cursor = crHandPoint
    Hint = 'https://aedev.ru'
    Caption = 'by Lex'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsItalic]
    ParentFont = False
    OnClick = DeveloperUrlLabelClick
    OnMouseEnter = CompanyUrlLabelMouseEnter
    OnMouseLeave = CompanyUrlLabelMouseLeave
  end
  object CompanyUrlLabel: TLabel
    Left = 16
    Top = 376
    Width = 35
    Height = 15
    Cursor = crHandPoint
    Hint = 'https://aedev.ru'
    Caption = 'AEDev'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsItalic]
    ParentFont = False
    OnClick = CompanyUrlLabelClick
    OnMouseEnter = CompanyUrlLabelMouseEnter
    OnMouseLeave = CompanyUrlLabelMouseLeave
  end
  object ChipModelLabel: TLabel
    Left = 240
    Top = 48
    Width = 27
    Height = 15
    Caption = #1048#1052#1057
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 104
    Top = 48
    Width = 74
    Height = 15
    Caption = #1052#1080#1082#1088#1086#1089#1093#1077#1084#1072':'
  end
  object Label6: TLabel
    Left = 104
    Top = 144
    Width = 121
    Height = 15
    Caption = #1048#1084#1103' '#1091#1089#1090#1088#1086#1081#1089#1090#1074#1072' (BLE):'
  end
  object Label7: TLabel
    Left = 104
    Top = 240
    Width = 96
    Height = 15
    Caption = 'MAC-'#1072#1076#1088#1077#1089' (BLE):'
  end
  object SpecialUrlLabel: TLabel
    Left = 216
    Top = 376
    Width = 129
    Height = 15
    Cursor = crHandPoint
    Hint = 'https://4pda.to'
    Caption = #1058#1077#1084#1072' '#1086' ELM327 '#1085#1072' 4PDA'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsItalic]
    ParentFont = False
    OnClick = SpecialUrlLabelClick
    OnMouseEnter = CompanyUrlLabelMouseEnter
    OnMouseLeave = CompanyUrlLabelMouseLeave
  end
  object LogMemo: TMemo
    Left = 16
    Top = 272
    Width = 545
    Height = 97
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object DeviceBTNameEdit: TEdit
    Left = 240
    Top = 112
    Width = 217
    Height = 23
    MaxLength = 24
    TabOrder = 1
  end
  object DeviceBTPasswordEdit: TEdit
    Left = 240
    Top = 176
    Width = 217
    Height = 23
    MaxLength = 15
    TabOrder = 2
  end
  object SaveButton: TButton
    Left = 104
    Top = 8
    Width = 81
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 3
    OnClick = SaveButtonClick
  end
  object OpenButton: TButton
    Left = 16
    Top = 8
    Width = 81
    Height = 25
    Caption = #1054#1090#1082#1088#1099#1090#1100
    TabOrder = 4
    OnClick = OpenButtonClick
  end
  object DeviceBTMACEdit: TEdit
    Left = 240
    Top = 208
    Width = 217
    Height = 23
    TabOrder = 5
  end
  object DeviceBTBaudrateComboBox: TComboBox
    Left = 240
    Top = 80
    Width = 217
    Height = 23
    TabOrder = 6
  end
  object DeviceBTBLENameEdit: TEdit
    Left = 240
    Top = 144
    Width = 217
    Height = 23
    MaxLength = 24
    TabOrder = 7
  end
  object DeviceBTBLEMACEdit: TEdit
    Left = 240
    Top = 240
    Width = 217
    Height = 23
    TabOrder = 8
  end
  object SaveAsButton: TButton
    Left = 192
    Top = 8
    Width = 113
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1082#1072#1082'...'
    TabOrder = 9
    OnClick = SaveAsButtonClick
  end
  object OpenDialog1: TOpenDialog
    Left = 56
    Top = 288
  end
  object SaveDialog1: TSaveDialog
    Left = 128
    Top = 288
  end
end
