object FrmPrincipal: TFrmPrincipal
  Left = 238
  Top = 121
  Anchors = [akLeft, akTop, akRight, akBottom]
  Caption = 'Controle de Contas Pagar'
  ClientHeight = 631
  ClientWidth = 1180
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu1
  Position = poDesigned
  WindowState = wsMaximized
  TextHeight = 15
  object StatusBar1: TStatusBar
    Left = 0
    Top = 612
    Width = 1180
    Height = 19
    Panels = <
      item
        Text = 'Desenv. Eduardo Moraes'
        Width = 250
      end
      item
        Text = 'Periodo de consulta'
        Width = 50
      end
      item
        Text = 'Vers'#227'o do produto'
        Width = 250
      end
      item
        Text = 'Informa'#231#245'es do Banco Dados'
        Width = 250
      end>
  end
  object CategoryPanelGroup1: TCategoryPanelGroup
    Left = 0
    Top = 0
    Width = 350
    Height = 612
    VertScrollBar.Tracking = True
    Constraints.MaxWidth = 500
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -12
    HeaderFont.Name = 'Segoe UI'
    HeaderFont.Style = []
    TabOrder = 1
    object CategoryPanel4: TCategoryPanel
      Top = 459
      Caption = 'Filtros de Pesquisa:'
      TabOrder = 0
      ExplicitTop = 475
    end
    object CategoryPanel3: TCategoryPanel
      Top = 251
      Height = 208
      Caption = 'Per'#237'odo de pagamento:'
      TabOrder = 1
      ExplicitTop = 267
    end
    object CategoryPanel2: TCategoryPanel
      Top = 65
      Height = 186
      Caption = 'Per'#237'odo de vencimento:'
      TabOrder = 2
      ExplicitTop = 81
    end
    object CategoryPanel1: TCategoryPanel
      Top = 0
      Height = 65
      Caption = 'Tipo de pesquisa nos registros'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
  end
  object ComboBox1: TComboBox
    AlignWithMargins = True
    Left = 8
    Top = 35
    Width = 317
    Height = 23
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 2
    Text = 'Todas'
    Items.Strings = (
      'Todas'
      'Contas a pagar'
      'Contas pagas'
      'Contas Vencidas')
  end
  object MainMenu1: TMainMenu
    Left = 800
    Top = 544
    object Configurao1: TMenuItem
      Caption = 'Configura'#231#227'o'
      object ValidarConexoBancoDados1: TMenuItem
        Caption = 'Validar Conex'#227'o Banco Dados'
      end
      object ConfiguraoBancoDados1: TMenuItem
        Caption = 'Configura'#231#227'o Banco Dados'
      end
      object BackupBancoDados1: TMenuItem
        Caption = 'Backup Banco Dados'
      end
    end
  end
end
