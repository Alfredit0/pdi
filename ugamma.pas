unit uGamma;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
  StdCtrls, ComCtrls;

type

  { TfrmGamma }

  TfrmGamma = class(TForm)
    bAceptar: TButton;
    bCancelar: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lblPosicion: TLabel;
    TrackBar1: TTrackBar;
    procedure bCancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    g : real;
  end;

var
  frmGamma: TfrmGamma;

implementation

{$R *.lfm}

{ TfrmGamma }

procedure TfrmGamma.FormCreate(Sender: TObject);
begin
  lblPosicion.Caption:= '1.0';
  g := 1.0;
end;

procedure TfrmGamma.bCancelarClick(Sender: TObject);
begin
  close;
end;

procedure TfrmGamma.TrackBar1Change(Sender: TObject);
begin
  g := TrackBar1.Position/20;
  lblPosicion.Caption := FloatToStr(g);
end;

end.

