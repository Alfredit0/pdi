//Programa que muestra una imagen
unit uImagen;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, StdCtrls, uVarios, uFiltros, uGamma,uHistograma, Math, uRegional;

type

  { TfrmImagen }

  TfrmImagen = class(TForm)
    btnFilAnt: TButton;
    BtnFilSig: TButton;
    Image1: TImage;
    imgHisto: TImage;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    FiltroMax: TMenuItem;
    FiltroMin: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    mnuRegionGauss: TMenuItem;
    mnuRegionMediana: TMenuItem;
    mnuRegionMedia: TMenuItem;
    mnuRegion: TMenuItem;
    mnuPuntualCos: TMenuItem;
    mnuPuntualSeno: TMenuItem;
    mnuPuntualLog: TMenuItem;
    mnuPuntualGamma: TMenuItem;
    mnuPuntualNegativo: TMenuItem;
    mnuPuntuales: TMenuItem;
    mnuArchivoSalir: TMenuItem;
    mnuArchivoGuardar: TMenuItem;
    mnuArchivoAbrir: TMenuItem;
    mnuArchivo: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    ScrollBox1: TScrollBox;
    txtFilaAct: TEdit;
    txtFilaAct1: TEdit;
    procedure btnFilAntClick(Sender: TObject);
    procedure BtnFilSigClick(Sender: TObject);
    procedure btnLoadImageClick(Sender: TObject);
    procedure FiltroMaxClick(Sender: TObject);
    procedure FiltroMinClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure mnuArchivoGuardarClick(Sender: TObject);
    procedure mnuPuntualCosClick(Sender: TObject);
    procedure mnuPuntualLogClick(Sender: TObject);
    procedure mnuArchivoAbrirClick(Sender: TObject);
    procedure mnuArchivoSalirClick(Sender: TObject);
    procedure MImagen(B: TBitMap);
    procedure mnuPuntualGammaClick(Sender: TObject);
    procedure mnuPuntualNegativoClick(Sender: TObject);
    procedure mnuPuntualSenoClick(Sender: TObject);
    procedure mnuRegionGaussClick(Sender: TObject);
    procedure mnuRegionMediaClick(Sender: TObject);
    procedure mnuRegionMedianaClick(Sender: TObject);
    procedure Shape1ChangeBounds(Sender: TObject);
    procedure PintaHisto();
  private
    { private declarations }
  public
    { public declarations }
    BM: TBitMap;
    Iancho, Ialto: integer;
    MTR, MRES: Mat3D;
    nom: string;
    P: TPoint;
    inSelect: Boolean;
    Han, Hal, nc, nr : integer;
    BH : TBitMap;
    MH : Mat3D;
    HH : ArrInt;
    filaSelec: integer;
  end;

var
  frmImagen: TfrmImagen;

implementation

{$R *.lfm}

{ TfrmImagen }

//Sale del sistema
procedure TfrmImagen.mnuArchivoSalirClick(Sender: TObject);
begin
  Application.Terminate;
end;

//Abre archivo de imagen BMP
procedure TfrmImagen.mnuArchivoAbrirClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    nom := OpenDialog1.FileName;
    BM.LoadFromFile(nom); //Carga la imagen en el BitMap
    MImagen(BM);          //Muestra la imagen

   BA.Assign(BM);

    BH.Assign(BA);  //El contenido de BA se asigna a BH
    nc := BH.Width; //Número de columnas
    nr := BH.Height;//Número de renglones
    BM_MAT(BH,MH);  //Pasa la imagen a un matriz
    filaSelec:=0;
    PintaHisto();   //Pinta el histograma
  end;

end;

procedure TfrmImagen.FormCreate(Sender: TObject);
begin
  BM := TBitmap.Create; //Crea el espacio para la imagen
  BM := TBitmap.Create;
  BA := TBitmap.Create;
  Han := imgHisto.Width;  //Ancho y alto de la ventana donde se
  Hal := imgHisto.Height; //graficara el histograma
  imgHisto.Canvas.Brush.Color := clBlack;
  imgHisto.Canvas.Rectangle(0,0,Han,Hal);  //Dibuja un rectángulo negro
  BH := TBitMap.Create; //Se crea el área de trabajo
end;



procedure TfrmImagen.Image2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  pic: TPicture;
  bmp: TBitmap;
  img: TImage;
begin
  if inSelect and ( P.X < X )and( P.Y < Y ) then
  begin
    img:= TImage(Sender);
    pic:= TPicture.Create;
    try
      pic.Assign(img.Picture);
      bmp:= TBitmap.Create;
      try
        bmp.Height:= img.Picture.Height;
        bmp.Width := img.Picture.Width;
        bmp.Canvas.Draw(0, 0, Pic.Graphic);
        bmp.Canvas.CopyRect(Rect(0, 0, X-P.X, Y-P.Y),
          bmp.Canvas, Rect(P.X, P.Y, X, Y));
        bmp.Width := Abs(X-P.X);
        bmp.Height:= Abs(Y-P.Y);

      finally
        bmp.Free;
      end;
    finally
      pic.Free;
    end;
  end;
end;

procedure TfrmImagen.FiltroMaxClick(Sender: TObject);
begin
  Iancho := BM.Width; //Obtiene el ancho de la imagen
  Ialto := BM.Height; //Obtiene el alto de la imagen
  BM_MAT(BM, MTR);     //Del bitmap se pasa a la matriz
  FRMediana(MTR, MRES, Iancho, Ialto, 3); //Aplica el filtro de la Mediana a la matriz MTR
  MAT_BM(MRES, BM, Iancho, Ialto);  //La matriz resultado se pasa al bitmap
  MImagen(BM);                   //Muestra la imagen
end;

procedure TfrmImagen.btnLoadImageClick(Sender: TObject);
begin
end;

//filtro minimo
procedure TfrmImagen.FiltroMinClick(Sender: TObject);
begin
  Iancho := BM.Width; //Obtiene el ancho de la imagen
  Ialto := BM.Height; //Obtiene el alto de la imagen
  BM_MAT(BM, MTR);     //Del bitmap se pasa a la matriz
  FRMediana(MTR, MRES, Iancho, Ialto, 2); //Aplica el filtro de la Mediana a la matriz MTR
  MAT_BM(MRES, BM, Iancho, Ialto);  //La matriz resultado se pasa al bitmap
  MImagen(BM);                   //Muestra la imagen
end;

//aplica coseno
procedure TfrmImagen.MenuItem10Click(Sender: TObject);
begin
  Iancho := BM.Width;   //Obtiene el ancho de la imagen
  Ialto := BM.Height;  //Obtiene el alto de la imagen
  BM_Mat(BM, MTr);       //La imagen se coloca en un arreglo
  FPCoseno(MTr, MRes, Iancho, Ialto); //Calcula el negativo de la imagen
  Mat_BM(MRes, BM, Iancho, Ialto); //Se coloca la imagen en un Image
  MImagen(BM);          //Muestra la imagen
end;

procedure TfrmImagen.MenuItem11Click(Sender: TObject);
begin

end;

procedure TfrmImagen.MenuItem12Click(Sender: TObject);
begin
end;


//Aplica el filtro exponecial
procedure TfrmImagen.MenuItem1Click(Sender: TObject);
var
  textoUsuario: string;
var
  alpha: integer;
begin
  textoUsuario := InputBox('Asignación de α por el usuario',
    'Ingrese un valor para α:', '0');
  alpha := StrToInt(textoUsuario);
  if alpha >= 1 then
  begin
    Iancho := BM.Width; //Obtiene el ancho de la imagen
    Ialto := BM.Height; //Obtiene el alto de la imagen
    BM_Mat(BM, MTr);     //Coloca la imagen en una matriz
    FPExpo(MTr, MRes, Iancho, Ialto, alpha); //Aplica log
    Mat_BM(MRes, BM, Iancho, Ialto); //Obtiene el resultado
    MImagen(BM);                  //Muestra el resultado
  end
  else if alpha < 1 then
    ShowMessage('α debe ser mayor a 1!');
end;

procedure TfrmImagen.MenuItem2Click(Sender: TObject);
begin

end;

procedure TfrmImagen.MenuItem3Click(Sender: TObject);
begin

end;

procedure TfrmImagen.MenuItem4Click(Sender: TObject);
begin

end;

//Aplica escala de grises
procedure TfrmImagen.MenuItem5Click(Sender: TObject);
begin
  Iancho := BM.Width;   //Obtiene el ancho de la imagen
  Ialto := BM.Height;  //Obtiene el alto de la imagen
  BM_Mat(BM, MTr);       //La imagen se coloca en un arreglo
  escaladegrises(MTr, MRes, Iancho, Ialto); //Calcula el negativo de la imagen
  Mat_BM(MRes, BM, Iancho, Ialto); //Se coloca la imagen en un Image
  MImagen(BM);          //Muestra la imagen

end;

procedure TfrmImagen.MenuItem7Click(Sender: TObject);
begin
  frmHistograma.Show;
end;

procedure TfrmImagen.MenuItem8Click(Sender: TObject);
begin

end;

procedure TfrmImagen.MenuItem9Click(Sender: TObject);
begin

end;

procedure TfrmImagen.BtnFilSigClick(Sender: TObject);
begin
  imgHisto.Canvas.Clear;
  imgHisto.Canvas.Brush.Color := clBlack;
  imgHisto.Canvas.Rectangle(0,0,Han,Hal);  //Dibuja un rectángulo negro
  filaSelec:= filaSelec+1;
  if filaSelec<>iAlto then
  begin
    txtFilaAct.Text:=IntToStr(filaSelec);
        txtFilaAct1.Text:=IntToStr(filaSelec);
    PintaHisto();
  end;
end;

procedure TfrmImagen.btnFilAntClick(Sender: TObject);
begin
  imgHisto.Canvas.Clear;
    imgHisto.Canvas.Brush.Color := clBlack;
  imgHisto.Canvas.Rectangle(0,0,Han,Hal);
  if filaSelec<>0 then
  begin
  filaSelec:= filaSelec-1;
  txtFilaAct.Text:=IntToStr(filaSelec);
  PintaHisto();
  end;
end;

//guardar imagen
procedure TfrmImagen.mnuArchivoGuardarClick(Sender: TObject);
begin
  // Give the dialog a title
  saveDialog1.Title := 'Guardar Imagen';

  // Allow only .txt and .doc file types to be saved
  SaveDialog1.Filter := 'Imagen BMP|*.bmp';

  // Set the default extension
  SaveDialog1.DefaultExt := 'bmp';

  // Select text files as the starting filter type
  SaveDialog1.FilterIndex := 1;
  if SaveDialog1.Execute then
  begin
    nom := SaveDialog1.FileName;
    try
      Image1.Picture.SaveToFile(nom);
      ShowMessage('Guardado');
    except
      ShowMessage('Error al guardar');
    end;
  end;
end;

//Aplica el filtro exponencial fuerte
procedure TfrmImagen.mnuPuntualCosClick(Sender: TObject);
var
  textoUsuario: string;
var
  alpha: integer;
begin
  textoUsuario := InputBox('Asignación de α por el usuario',
    'Ingrese un valor para α:',
    '0');
  alpha := StrToInt(textoUsuario);
  if alpha >= 1 then
  begin
    Iancho := BM.Width; //Obtiene el ancho de la imagen
    Ialto := BM.Height; //Obtiene el alto de la imagen
    BM_Mat(BM, MTr);     //Coloca la imagen en una matriz
    FPExpfuerte(MTr, MRes, Iancho, Ialto, alpha); //Aplica log
    Mat_BM(MRes, BM, Iancho, Ialto); //Obtiene el resultado
    MImagen(BM);                  //Muestra el resultado
  end
  else if alpha < 1 then
    ShowMessage('α debe ser mayor a 1!');
end;

//Aplica el filtro Logarítmico a la imagen
procedure TfrmImagen.mnuPuntualLogClick(Sender: TObject);
var
  textoUsuario: string;
var
  alpha: integer;
begin
  textoUsuario := InputBox('Asignación de α por el usuario',
    'Ingrese un valor para α:',
    '0');
  alpha := StrToInt(textoUsuario);
  if alpha >= 1 then
  begin
    Iancho := BM.Width; //Obtiene el ancho de la imagen
    Ialto := BM.Height; //Obtiene el alto de la imagen
    BM_Mat(BM, MTr);     //Coloca la imagen en una matriz
    FPLogarit(MTr, MRes, Iancho, Ialto, alpha); //Aplica log
    Mat_BM(MRes, BM, Iancho, Ialto); //Obtiene el resultado
    MImagen(BM);                  //Muestra el resultado
  end
  else if alpha < 1 then
    ShowMessage('α debe ser mayor a 1!');
end;

//Muestra el contenido del BitMap en el Image
procedure TfrmImagen.MImagen(B: TBitMap);
begin
  Image1.Picture.Assign(B); //Muestra la imagen
end;

//Aplica el filtro Gamma a la imagen
procedure TfrmImagen.mnuPuntualGammaClick(Sender: TObject);
var
  gam: real;
begin
  frmGamma.ShowModal;
  if frmGamma.ModalResult = mrOk then
  begin
    gam := frmGamma.g;
    Iancho := BM.Width;   //Obtiene el ancho de la imagen
    Ialto := BM.Height;   //Obtiene el alto de la imagen
    BM_Mat(BM, MTr);       //La imagen se coloca en un arreglo
    FPGamma(MTr, MRes, Iancho, Ialto, gam); //Aplica el algoritmo
    Mat_BM(MRes, BM, Iancho, Ialto); //Se coloca la imagen en un Image
    MImagen(BM);          //Muestra la imagen
  end;
end;

//Obtiene el negativo de una imagen
procedure TfrmImagen.mnuPuntualNegativoClick(Sender: TObject);
begin
  Iancho := BM.Width;   //Obtiene el ancho de la imagen
  Ialto := BM.Height;  //Obtiene el alto de la imagen
  BM_Mat(BM, MTr);       //La imagen se coloca en un arreglo
  FPNegativo(MTr, MRes, Iancho, Ialto); //Calcula el negativo de la imagen
  Mat_BM(MRes, BM, Iancho, Ialto); //Se coloca la imagen en un Image
  MImagen(BM);          //Muestra la imagen
end;

//Aplica el filtro del seno a una imagen
procedure TfrmImagen.mnuPuntualSenoClick(Sender: TObject);
begin
  Iancho := BM.Width; //Obtiene el ancho de la imagen
  Ialto := BM.Height; //Obtiene el alto de la imagen
  BM_Mat(BM, MTr);     //Coloca la imagen en una matriz
  FPSeno(MTr, MRes, Iancho, Ialto); //Aplica log
  Mat_BM(MRes, BM, Iancho, Ialto); //Obtiene el resultado
  MImagen(BM);                  //Muestra el resultado
end;

//Obtiene el gaussiano de una imagen
procedure TfrmImagen.mnuRegionGaussClick(Sender: TObject);
var
  matc: Matdxd;
  ps: real;
begin
  Iancho := BM.Width; //Obtiene el ancho de la imagen
  Ialto := BM.Height; //Obtiene el alto de la imagen
  BM_Mat(BM, MTr);     //Coloca la imagen en una matriz
  ps := 1 / 16;
  //Obtiene la matriz de convolución en un entorno de vecindad de 3x3
  CopiaVaV(matc, 2);
  FRGausiana(MTR, MRES, Iancho, Ialto, matc, ps); //Aplica el filtro Media
  Mat_BM(MRes, BM, Iancho, Ialto); //Obtiene el resultado
  MImagen(BM);        //Muestra la imagen
end;

//Obtiene la media de una imagen
procedure TfrmImagen.mnuRegionMediaClick(Sender: TObject);
var
  matc: Matdxd;
  ps: real;
begin
  Iancho := BM.Width; //Obtiene el ancho de la imagen
  Ialto := BM.Height; //Obtiene el alto de la imagen
  BM_Mat(BM, MTr);     //Coloca la imagen en una matriz
  ps := 1 / 9;
  //Obtiene la matriz de convolución en un entorno de vecindad de 3x3
  CopiaVaV(matc, 1);
  FRMedia(MTR, MRES, Iancho, Ialto, matc, ps); //Aplica el filtro Media
  Mat_BM(MRes, BM, Iancho, Ialto); //Obtiene el resultado
  MImagen(BM);        //Muestra la imagen
end;

//Obtiene la mediana de una imagen
procedure TfrmImagen.mnuRegionMedianaClick(Sender: TObject);
begin
  Iancho := BM.Width; //Obtiene el ancho de la imagen
  Ialto := BM.Height; //Obtiene el alto de la imagen
  BM_MAT(BM, MTR);     //Del bitmap se pasa a la matriz
  FRMediana(MTR, MRES, Iancho, Ialto, 1); //Aplica el filtro de la Mediana a la matriz MTR
  MAT_BM(MRES, BM, Iancho, Ialto);  //La matriz resultado se pasa al bitmap
  MImagen(BM);                   //Muestra la imagen
end;

procedure TfrmImagen.Shape1ChangeBounds(Sender: TObject);
begin

end;


//Pinta el histograma
procedure TfrmImagen.PintaHisto();
var
  i,j,ind : integer;
  maxi     : array [0..3] of integer;
  fac      : real;
begin
  for i := 0 to 255 do  //limpia la matriz
  begin
     HH[0,i] := 0;
     HH[1,i] := 0;
     HH[2,i] := 0;
     HH[3,i] := 0;
  end;
  j:=filaSelec;
  //obtiene la cantidad de cada color 0..255
  for i:= 0 to nc-1 do
    begin
      ind := MH[i][j][0]; //Rojo
      inc(HH[0,ind]);
      ind := MH[i][j][1]; //Verde
      inc(HH[1,ind]);
      ind := MH[i][j][2]; //Azul
      inc(HH[2,ind]);
      ind :=  (MH[i][j][0] + MH[i][j][1] + MH[i][j][2]) div 3;
      inc(HH[3,ind]);     //Gris
    end;
  // pinta
  maxi[0] := 0;
  maxi[1] := 0;
  maxi[2] := 0;
//  maxi[3] := 0;
  {*if chkRojo.Checked then
  begin*}
    imgHisto.Canvas.Pen.Color := clRed;      //Rojo
    for i := 0 to 255 do
      maxi[0] := Max(HH[0,i], maxi[0]);
    fac := Hal / (maxi[0]+1);
    imgHisto.Canvas.MoveTo(0,Hal-round(fac*HH[0,0]));
    for i := 1 to 255 do

      imgHisto.Canvas.LineTo(round(i * Han/255), Hal-round(fac*HH[0,i]));
  //end;
  {*if chkVerde.Checked then
  begin*}
    imgHisto.Canvas.Pen.Color := clGreen;   //Verde
    for i := 0 to 255 do
      maxi[1] := Max(HH[1,i], maxi[1]);
    fac := Hal / (maxi[1]+1);
    imgHisto.Canvas.MoveTo(0,Hal-round(fac*HH[1,0]));
    for i := 1 to 255 do

      imgHisto.Canvas.LineTo(round(i * Han/255), Hal-round(fac*HH[1,i]));
  {*end;
  if chkAzul.Checked then
  begin*}
    imgHisto.Canvas.Pen.Color := clBlue;    //Azul
    for i := 0 to 255 do
      maxi[2] := Max(HH[2,i], maxi[2]);
    fac := Hal / (maxi[2]+1);
    imgHisto.Canvas.MoveTo(0,Hal-round(fac*HH[2,0]));
    for i := 1 to 255 do

      imgHisto.Canvas.LineTo(round(i * Han/255), Hal-round(fac*HH[2,i]));
{*  end;
  if chkGris.Checked then
  begin*}
    imgHisto.Canvas.Pen.Color := clWhite;    //Gris
    for i := 0 to 255 do
      maxi[3] := Max(HH[3,i], maxi[3]);
    fac := Hal / (maxi[3]+1);
    imgHisto.Canvas.MoveTo(0,Hal-round(fac*HH[3,0]));
    for i := 1 to 255 do

      imgHisto.Canvas.LineTo(round(i * Han/255), Hal-round(fac*HH[3,i]));
  {*end;*}
end;


end.
