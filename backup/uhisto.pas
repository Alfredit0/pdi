unit uHisto;

{$mode objfpc}{$H+}

interface

uses
Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
ExtCtrls,uVarios,Math;
type

  { TformHist }

  TformHist = class(TForm)
    bAplicar: TButton;
    bCerrar: TButton;
    chkAzul: TCheckBox;
    chkGris: TCheckBox;
    chkRojo: TCheckBox;
    chkVerde: TCheckBox;
    GroupBox1: TGroupBox;
    imgHisto: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
  private

  public

  end;

var
  formHist: TformHist;

implementation

{$R *.lfm}

end.

