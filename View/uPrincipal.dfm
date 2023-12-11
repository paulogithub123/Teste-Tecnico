object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Controle de Produtos'
  ClientHeight = 217
  ClientWidth = 490
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 345
    Top = 192
    Width = 137
    Height = 25
    Caption = 'Teste de Conex'#227'o'
    TabOrder = 0
    OnClick = Button1Click
  end
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 490
    Height = 27
    UseSystemFont = False
    ActionManager = ActionManager1
    Caption = 'ActionMainMenuBar1'
    Color = clMenuBar
    ColorMap.DisabledFontColor = 10461087
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedFont = clBlack
    ColorMap.UnusedColor = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    Spacing = 0
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    VendorLib = 
      'C:\PauloFN\Projetos Desenvolvimento\Delphi\Delphi x MySQL\Projet' +
      'o 1\Lib\mysql\libmysql41.dll'
    Left = 400
    Top = 8
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Items = <
              item
                Action = Action1
              end>
            Caption = '&Pedido'
          end>
      end
      item
        Items = <
          item
            Items = <
              item
                Action = Action1
              end>
            Caption = '&Vendas'
          end>
        ActionBar = ActionMainMenuBar1
      end>
    Left = 192
    Top = 72
    StyleName = 'Platform Default'
    object Action1: TAction
      Category = '&Vendas'
      Caption = '&Pedido'
      OnExecute = Action1Execute
    end
  end
end
