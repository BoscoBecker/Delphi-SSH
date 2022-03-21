object MainConexao: TMainConexao
  Left = 0
  Top = 0
  Caption = 'SSH delphi'
  ClientHeight = 532
  ClientWidth = 682
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    682
    532)
  PixelsPerInch = 96
  TextHeight = 13
  object info: TLabel
    Left = 14
    Top = 167
    Width = 660
    Height = 51
    Anchors = [akLeft, akTop, akBottom]
    AutoSize = False
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    WordWrap = True
  end
  object log: TMemo
    Left = 8
    Top = 224
    Width = 666
    Height = 300
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 666
    Height = 73
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Configura'#231#227'o da conex'#227'o '
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Top = 35
      Width = 22
      Height = 13
      Caption = 'Host'
    end
    object Label2: TLabel
      Left = 149
      Top = 35
      Width = 20
      Height = 13
      Caption = 'Port'
    end
    object lblusuario: TLabel
      Left = 241
      Top = 35
      Width = 36
      Height = 13
      Caption = 'Usu'#225'rio'
    end
    object Label4: TLabel
      Left = 371
      Top = 35
      Width = 30
      Height = 13
      Caption = 'Senha'
    end
    object btnIniciar: TButton
      Left = 509
      Top = 30
      Width = 93
      Height = 25
      Caption = 'Inciar Sess'#227'o'
      TabOrder = 4
      OnClick = btnIniciarClick
    end
    object edthost: TEdit
      Left = 44
      Top = 32
      Width = 97
      Height = 21
      TabOrder = 0
      TextHint = '192.168.0.1'
    end
    object edtPort: TEdit
      Left = 175
      Top = 32
      Width = 45
      Height = 21
      Enabled = False
      TabOrder = 1
      Text = '22'
    end
    object loading: TActivityIndicator
      Left = 622
      Top = 23
    end
    object edtusuario: TEdit
      Left = 279
      Top = 32
      Width = 80
      Height = 21
      TabOrder = 2
    end
    object edtSenha: TEdit
      Left = 407
      Top = 32
      Width = 80
      Height = 21
      PasswordChar = '*'
      TabOrder = 3
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 89
    Width = 666
    Height = 77
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Comandos para sess'#227'o'
    TabOrder = 2
    object Label3: TLabel
      Left = 45
      Top = 35
      Width = 50
      Height = 13
      Caption = 'Comandos'
    end
    object listComandos: TEdit
      Left = 101
      Top = 32
      Width = 300
      Height = 21
      Enabled = False
      TabOrder = 0
      TextHint = 'ls'
    end
    object btnComandos: TButton
      Left = 407
      Top = 28
      Width = 108
      Height = 25
      Caption = 'Executar Comandos'
      Enabled = False
      TabOrder = 1
      OnClick = btnComandosClick
    end
  end
end
