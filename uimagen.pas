//Programa que muestra una imagen
unit uImagen;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, uVarios, uFiltros, uGamma, uRegional;

type

  { TfrmImagen }

  TfrmImagen = class(TForm)
    Image1: TImage;
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
    procedure FiltroMaxClick(Sender: TObject);
    procedure FiltroMinClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
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
  private
    { private declarations }
  public
    { public declarations }
    BM: TBitMap;
    Iancho, Ialto: integer;
    MTR, MRES: Mat3D;
    nom: string;
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
  end;

end;

procedure TfrmImagen.FormCreate(Sender: TObject);
begin
  BM := TBitmap.Create; //Crea el espacio para la imagen
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
var
  MyRect, MyOther: TRect;
begin
  MyRect := Rect(10, 10, 100, 100);
  MyOther := Rect(10, 111, 100, 201);
   Image1.Canvas.BrushCopy(MyRect, BM, MyRect, clBlack);
     Image1.Canvas.Clear;
  Image1.Canvas.CopyRect(MyOther, BM.Canvas, MyRect);
  BM.Free;
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

procedure TfrmImagen.MenuItem9Click(Sender: TObject);
begin

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
  p: real;
begin
  Iancho := BM.Width; //Obtiene el ancho de la imagen
  Ialto := BM.Height; //Obtiene el alto de la imagen
  BM_Mat(BM, MTr);     //Coloca la imagen en una matriz
  p := 1 / 16;
  //Obtiene la matriz de convolución en un entorno de vecindad de 3x3
  CopiaVaV(matc, 2);
  FRGausiana(MTR, MRES, Iancho, Ialto, matc, p); //Aplica el filtro Media
  Mat_BM(MRes, BM, Iancho, Ialto); //Obtiene el resultado
  MImagen(BM);        //Muestra la imagen
end;

//Obtiene la media de una imagen
procedure TfrmImagen.mnuRegionMediaClick(Sender: TObject);
var
  matc: Matdxd;
  p: real;
begin
  Iancho := BM.Width; //Obtiene el ancho de la imagen
  Ialto := BM.Height; //Obtiene el alto de la imagen
  BM_Mat(BM, MTr);     //Coloca la imagen en una matriz
  p := 1 / 9;
  //Obtiene la matriz de convolución en un entorno de vecindad de 3x3
  CopiaVaV(matc, 1);
  FRMedia(MTR, MRES, Iancho, Ialto, matc, p); //Aplica el filtro Media
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

end.
