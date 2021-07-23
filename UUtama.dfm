object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 346
  ClientWidth = 572
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 0
    Top = 192
    Width = 572
    Height = 154
    Align = alBottom
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object BtnSiap: TButton
    Left = 120
    Top = 64
    Width = 75
    Height = 25
    Caption = 'Siap'
    TabOrder = 1
    OnClick = BtnSiapClick
  end
  object BtnQueryThread: TButton
    Left = 312
    Top = 64
    Width = 89
    Height = 25
    Caption = 'Query Thread'
    TabOrder = 2
    OnClick = BtnQueryThreadClick
  end
  object ADOQuery1: TADOQuery
    Connection = Dm.ADOConnSatu
    Parameters = <>
    Left = 240
    Top = 88
  end
  object DataSource1: TDataSource
    DataSet = ADOQuery1
    Left = 392
    Top = 88
  end
  object ADODataSet1: TADODataSet
    Parameters = <>
    Left = 320
    Top = 128
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 456
    Top = 120
  end
end
