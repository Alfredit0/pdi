program pImagen;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, uImagen, uVarios, uFiltros, uGamma, uRegional, uHistograma
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TfrmImagen, frmImagen);
  Application.CreateForm(TfrmGamma, frmGamma);
  Application.CreateForm(TfrmHistograma, frmHistograma);
  Application.Run;
end.

